package main

import (
	"encoding/json"
	"fmt"
)

type Person struct {
	Name string
	Age  int
}

func main() {
	p1 := Person{
		Name: "Alex",
		Age:  20,
	}

	jsonData, err := json.Marshal(p1)
	if err != nil {
		panic(err)
	}

	fmt.Println(string(jsonData))
}
