package main

import "fmt"

type windows struct {
	imprimanta imprimanta
}

// pentru tiparirea la imprimanta
func (win *windows) tiparire() {
	fmt.Println("Cererea de tiparire de pe WINDOWS a fost generata.")
	win.imprimanta.tiparireFisier()
}

// penntru configurarea imprimantei
func (win *windows) configurareImprimanta(im imprimanta) {
	win.imprimanta = im
}
