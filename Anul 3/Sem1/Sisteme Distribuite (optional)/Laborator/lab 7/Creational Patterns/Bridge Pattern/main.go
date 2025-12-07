package main

import (
	"fmt"
)

func main() {
	imprimantaBrother := &brother{}
	imprimantaKonicaMinolta := &konicaMinolta{}

	laptopLINUX := &linux{}

	laptopLINUX.configurareImprimanta(imprimantaBrother)
	laptopLINUX.tiparire()
	fmt.Println("***************************")

	laptopLINUX.configurareImprimanta(imprimantaKonicaMinolta)
	laptopLINUX.tiparire()
	fmt.Println("***************************")

	laptopWINDOWS := &windows{}

	laptopWINDOWS.configurareImprimanta(imprimantaBrother)
	laptopWINDOWS.tiparire()
	fmt.Println("***************************")

	laptopWINDOWS.configurareImprimanta(imprimantaKonicaMinolta)
	laptopWINDOWS.tiparire()
	fmt.Println("***************************")

}
