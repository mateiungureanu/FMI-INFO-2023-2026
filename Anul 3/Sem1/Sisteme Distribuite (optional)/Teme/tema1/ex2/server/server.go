package main

import (
	"encoding/json"
	"fmt"
	"math"
	"net"
	"os"
	"strconv"
	"unicode"
)

type Config struct {
	Port string `json:"port"`
}
type Request struct {
	Strings []string `json:"strings"`
}
type Response struct {
	Result int `json:"result"`
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
	fmt.Println("Server Ex2 Pornit.")

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

	count := 0
	for _, s := range req.Strings {
		digits := ""
		for _, r := range s {
			if unicode.IsDigit(r) {
				digits += string(r)
			}
		}
		if digits != "" {
			num, err := strconv.Atoi(digits)
			check(err)
			sqrt := math.Sqrt(float64(num))
			if sqrt == float64(int64(sqrt)) {
				count++
			}
		}
	}

	resp := Response{Result: count}
	fmt.Printf("Server trimite %d catre client.\n", resp.Result)
	json.NewEncoder(conn).Encode(resp)
}
