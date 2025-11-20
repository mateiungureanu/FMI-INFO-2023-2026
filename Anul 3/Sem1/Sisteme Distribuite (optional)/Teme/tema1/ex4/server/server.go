package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
)

type Config struct {
	Port string `json:"port"`
}

type Request struct {
	Data []int `json:"data"`
}
type Response struct {
	Media float64 `json:"media"`
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	file, err := os.Open("../config.json")
	check(err)
	var cfg Config
	json.NewDecoder(file).Decode(&cfg)
	file.Close()

	ln, err := net.Listen("tcp", cfg.Port)
	check(err)
	defer ln.Close()
	fmt.Println("Server Ex4 Pornit.")

	for {
		conn, err := ln.Accept()
		check(err)
		go handle(conn)
	}
}

func handle(conn net.Conn) {
	defer conn.Close()
	var req Request
	json.NewDecoder(conn).Decode(&req)
	fmt.Println("Server a primit requestul.")

	if len(req.Data) < 3 {
		return
	}

	a := req.Data[0]
	b := req.Data[1]
	numbers := req.Data[2:]

	sum := 0
	count := 0

	for _, n := range numbers {
		temp := n
		digitSum := 0
		for temp > 0 {
			digitSum += temp % 10
			temp /= 10
		}

		if digitSum >= a && digitSum <= b {
			sum += n
			count++
		}
	}

	media := 0.0
	if count > 0 {
		media = float64(sum) / float64(count)
	}

	resp := Response{Media: media}
	fmt.Printf("Server trimite %.2f catre client.\n", resp.Media)
	json.NewEncoder(conn).Encode(resp)
}
