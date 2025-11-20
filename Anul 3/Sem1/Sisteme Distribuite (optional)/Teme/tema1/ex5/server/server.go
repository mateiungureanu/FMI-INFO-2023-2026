package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"strconv"
	"strings"
)

type Config struct {
	Port string `json:"port"`
}
type Request struct {
	Strings []string `json:"strings"`
}
type Response struct {
	Result string `json:"result"`
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
	fmt.Println("Server Ex5 Pornit.")

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

	var converted []string
	for _, s := range req.Strings {
		val, err := strconv.ParseInt(s, 2, 64)
		if err == nil {
			converted = append(converted, fmt.Sprintf("%d", val))
		}
	}

	finalStr := strings.Join(converted, ", ")

	resp := Response{Result: finalStr}
	fmt.Printf("Server trimite %s catre client.\n", resp.Result)
	json.NewEncoder(conn).Encode(resp)
}
