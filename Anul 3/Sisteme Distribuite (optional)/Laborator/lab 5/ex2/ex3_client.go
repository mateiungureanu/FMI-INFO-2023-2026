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
	"strings"
	"syscall"
	"time"
)

var (
	addr        = flag.String("addr", "127.0.0.1:9000", "adresa:port a serverului")
	msg         = flag.String("msg", "", "daca e setat, trimite acest mesaj si iese; altfel intra in mod interactiv")
	timeout     = flag.Duration("timeout", 5*time.Second, "timeout de conectare")
	readTimeout = flag.Duration("read-timeout", 0, "timeout de citire raspuns pe fiecare linie (0 = fara)")
)

func main() {
	flag.Parse()

	// Ctrl+C handling
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	dialer := net.Dialer{Timeout: *timeout}
	conn, err := dialer.DialContext(ctx, "tcp", *addr)
	if err != nil {
		log.Fatalf("nu ma pot conecta la %s: %v", *addr, err)
	}
	defer conn.Close()
	log.Printf("Conectat la %s", *addr)

	if *msg != "" {
		if err := sendAndPrint(conn, *msg, *readTimeout); err != nil {
			log.Fatalf("eroare: %v", err)
		}
		return
	}

	// Mod interactiv
	in := bufio.NewScanner(os.Stdin)
	fmt.Println("Mod interactiv. Tasteaza o linie si apasa Enter. Ctrl+C pentru iesire.")
	for {
		fmt.Print("> ")
		if !in.Scan() {
			// EOF sau eroare stdin
			if err := in.Err(); err != nil {
				log.Printf("eroare la citirea din stdin: %v", err)
			}
			return
		}
		line := in.Text()
		if strings.TrimSpace(line) == "" {
			continue
		}
		if err := sendAndPrint(conn, line, *readTimeout); err != nil {
			log.Fatalf("eroare: %v", err)
		}
	}
}

func sendAndPrint(conn net.Conn, line string, perReadTimeout time.Duration) error {
	// trimitem linia + newline
	if _, err := fmt.Fprintf(conn, "%s\n", line); err != nil {
		return fmt.Errorf("scriere catre server: %w", err)
	}

	// citim raspuns o linie
	if perReadTimeout > 0 {
		_ = conn.SetReadDeadline(time.Now().Add(perReadTimeout))
	}
	respReader := bufio.NewReader(conn)
	resp, err := respReader.ReadString('\n')
	if ne, ok := err.(net.Error); ok && ne.Timeout() {
		return fmt.Errorf("timeout la citire raspuns")
	}
	if err != nil {
		return fmt.Errorf("citire raspuns: %w", err)
	}
	fmt.Printf("< %s", resp)
	return nil
}
