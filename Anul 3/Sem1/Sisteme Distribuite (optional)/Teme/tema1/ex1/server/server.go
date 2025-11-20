package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
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

	listener, err := net.Listen("tcp", cfg.Port)
	check(err)
	defer listener.Close()
	fmt.Println("Server pornit pe", cfg.Port)

	for {
		conn, err := listener.Accept()
		check(err)
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()
	var req Request
	json.NewDecoder(conn).Decode(&req)

	fmt.Println("Server a primit requestul.")
	fmt.Println("Server proceseaza datele.")

	var out []string
	if len(req.Strings) > 0 {
		for i := range len(req.Strings[0]) {
			word := ""
			for _, s := range req.Strings {
				if i < len(s) {
					word += string(s[i])
				}
			}
			out = append(out, word)
		}
	}

	finalStr := strings.Join(out, ", ")

	resp := Response{Result: finalStr}
	fmt.Printf("Server trimite %s catre client.\n", resp.Result)
	json.NewEncoder(conn).Encode(resp)
}
