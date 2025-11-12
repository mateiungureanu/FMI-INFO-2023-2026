package main

import (
	"bufio"
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"
)

// setari cli: adresa/port si timeout optional pe citire
var (
	addr        = flag.String("addr", "127.0.0.1:9000", "adresa:port pe care asculta serverul")
	readTimeout = flag.Duration("read-timeout", 0, "timeout pentru citire per client (ex: 30s). 0 = fara")
)

func main() {
	flag.Parse()

	// pornim listenerul
	ln, err := net.Listen("tcp", *addr)
	if err != nil {
		log.Fatalf("nu pot asculta pe %s: %v", *addr, err)
	}
	log.Printf("Server pornit. Ascult pe %s ...", *addr)

	// context de inchidere gratioasa (Ctrl+C / SIGTERM)
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	var wg sync.WaitGroup

	// accept loop intr-un goroutine ca sa putem opri gratios
	acceptErr := make(chan error, 1)
	go func() {
		for {
			conn, err := ln.Accept()
			if err != nil {
				// daca listenerul e inchis pentru shut down, iesim
				if ctx.Err() != nil {
					acceptErr <- nil
					return
				}
				acceptErr <- fmt.Errorf("eroare la Accept: %w", err)
				return
			}
			wg.Add(1)
			go func(c net.Conn) {
				defer wg.Done()
				handleConn(c, *readTimeout)
			}(conn)
		}
	}()

	// asteptam semnalul de inchidere
	select {
	case <-ctx.Done():
		log.Println("Semnal primit. Oprire cu succes...")
		_ = ln.Close() // opreste Accept-ul
	case err := <-acceptErr:
		if err != nil {
			log.Printf("Bucla de accept s-a incheiat cu eroare: %v", err)
		}
	}

	// asteptam sa termine toate conexiunile active
	wg.Wait()
	log.Println("Server oprit. La revedere!")
}

func handleConn(conn net.Conn, perReadTimeout time.Duration) {
	defer conn.Close()
	remote := conn.RemoteAddr().String()
	log.Printf("Conexiune deschisa de la %s", remote)

	writer := bufio.NewWriter(conn)
	sc := bufio.NewScanner(conn)
	// marim bufferul implicit al scanner-ului daca vrei linii mai mari
	buf := make([]byte, 0, 64*1024)
	sc.Buffer(buf, 1024*1024)

	for {
		if perReadTimeout > 0 {
			_ = conn.SetReadDeadline(time.Now().Add(perReadTimeout))
		}
		if !sc.Scan() {
			if err := sc.Err(); err != nil {
				// deadline depasit, conexiune inchisa de client, etc.
				log.Printf("Conexiune %s inchisa cu eroare: %v", remote, err)
			} else {
				log.Printf("Conexiune %s inchisa de client", remote)
			}
			return
		}
		line := sc.Text()

		// logheaza linia primita
		log.Printf("[%s] <- %q", remote, line)

		// raspuns simplu „OK: <mesaj>”
		reply := fmt.Sprintf("OK: %s\n", line)
		if _, err := writer.WriteString(reply); err != nil {
			log.Printf("Eroare la scriere catre %s: %v", remote, err)
			return
		}
		if err := writer.Flush(); err != nil {
			log.Printf("Eroare la flush catre %s: %v", remote, err)
			return
		}
	}
}
