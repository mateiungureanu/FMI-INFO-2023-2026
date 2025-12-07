package main

import (
	"fmt"
	"sync"
)

//** excluziune mutuala
var lock = &sync.Mutex{}

type singleton struct {
}

var instanta *singleton

func obtineInstanta() *singleton {
	if instanta == nil {
		lock.Lock()
		defer lock.Unlock()
		if instanta == nil {
			fmt.Println("Initializarea unei instante")
			instanta = &singleton{}
		} else {
			fmt.Println("Instanta deja exista.")
		}
	} else {
		fmt.Println("Instanta deja exista.")
	}
	return instanta
}
