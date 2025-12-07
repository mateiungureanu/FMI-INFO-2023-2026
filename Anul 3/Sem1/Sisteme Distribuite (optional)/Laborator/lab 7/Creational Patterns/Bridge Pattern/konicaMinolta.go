package main

import "fmt"

type konicaMinolta struct {
}

func (km *konicaMinolta) tiparireFisier() {
	fmt.Println("Tiparire la imprimanta Konica Minolta")
}
