package main

import (
	"encoding/json"
	"fmt"
	"net"
	"os"
	"sync"
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

	var wg sync.WaitGroup
	wg.Add(2)
	go runClient(1, "input1.json", cfg, &wg)
	go runClient(2, "input2.json", cfg, &wg)
	wg.Wait()
}

func runClient(clientID int, filename string, cfg Config, wg *sync.WaitGroup) {
	defer wg.Done()

	file, err := os.Open(filename)
	check(err)
	var req Request
	json.NewDecoder(file).Decode(&req)
	file.Close()

	conn, err := net.Dial("tcp", cfg.Port)
	check(err)
	defer conn.Close()

	fmt.Printf("Client %d Conectat.\n", clientID)
	fmt.Printf("Client %d a facut request cu datele: %v\n", clientID, req.Strings)

	json.NewEncoder(conn).Encode(req)
	var resp Response
	json.NewDecoder(conn).Decode(&resp)

	fmt.Printf("Client %d a primit raspunsul: %d patrate perfecte\n", clientID, resp.Result)
}
