package main

import "fmt"

type linux struct {
	imprimanta imprimanta
}

// pentru tiparirea la imprimanta
func (li *linux) tiparire() {
	fmt.Println("Cererea de tiparire de pe LINUX a fost generata.")
	li.imprimanta.tiparireFisier()
}

// penntru configurarea imprimantei
func (li *linux) configurareImprimanta(im imprimanta) {
	li.imprimanta = im
}
