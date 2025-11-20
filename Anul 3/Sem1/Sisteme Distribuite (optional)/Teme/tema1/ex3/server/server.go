package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"strconv"
)

type Config struct {
	Port string `json:"port"`
}

type Request struct {
	Numbers []int `json:"numbers"`
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
	fmt.Println("Server Ex3 Pornit.")

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

	sum := 0
	for _, n := range req.Numbers {
		s := strconv.Itoa(n)
		revS := ""
		for _, v := range s {
			revS = string(v) + revS
		}
		revN, err := strconv.Atoi(revS)
		check(err)
		sum += revN
	}

	resp := Response{Result: sum}
	fmt.Printf("Server trimite %d catre client.\n", resp.Result)
	json.NewEncoder(conn).Encode(resp)
}
