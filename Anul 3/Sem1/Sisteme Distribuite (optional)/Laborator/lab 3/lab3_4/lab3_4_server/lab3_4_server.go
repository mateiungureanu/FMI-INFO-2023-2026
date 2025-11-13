package main

import (
	"fmt"
	"net/http"
)

func welcome(w http.ResponseWriter, req *http.Request) {
	fmt.Fprintf(w, "Welcome to the home page!\n")
}

func hello(w http.ResponseWriter, req *http.Request) {

	fmt.Fprintf(w, "hello\n")
}

func headers(w http.ResponseWriter, req *http.Request) {

	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

func main() {

	http.HandleFunc("/hello", hello)
	http.HandleFunc("/headers", headers)
	http.HandleFunc("/", welcome)

	http.ListenAndServe(":8090", nil)
}
