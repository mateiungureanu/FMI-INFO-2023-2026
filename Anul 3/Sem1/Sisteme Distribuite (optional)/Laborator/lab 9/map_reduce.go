//Cerinta: Sa se afiseze media verbelor si substantivelor dintrun text anume
//Rezolutie: vom avea nevoie de o functie mapper si reducer care sa se ocupe de medie

package main

import "fmt"
import "sync"

//** pasul 1 - implementarea functiei mapper, care primeste ca input un canal de siruri de caractere si numara aparitiile fiecarui cuvant unic din canalul respectiv
func mapper(intrare <-chan string, iesire chan<- map[string]int) {
	//contor
	contorizare := map[string]int{}

	//parcurgem fiecare cuvant in parte din datele de intrare
	for cuvant := range intrare {
		contorizare[cuvant] = contorizare[cuvant] + 1
	}

	iesire <- contorizare
	close(iesire)
}

//** pasul 2 - implementarea functiei reducer, care primeste un canal de nr intregi si face operatia de adunare pana cand canalul respectiv este inchis
//** va realiza impartirea intre valoare nr intregi (trimisa ca date de intrare) si adunarea respectiva pentru a calcula media corespunzatoare
func reducer(intrare <-chan int, iesire chan<- float32) {
	suma, contor := 0, 0

	for n := range intrare {
		suma += n
		contor++
	}

	iesire <- float32(suma) / float32(contor)
	close(iesire)
}

//** pasul 3 - functia citire input (a datelor de intrare) o sa primeasca trei canale de iesire, fiecare canal de iesire va avea "niste" date
func citireInput(iesire [3]chan<- string) {
	//** "citim" ceva date de intrare
	intrare := [][]string{
		{"substantiv", "verb", "verb", "substantiv", "substantiv"}, //1
		{"substantiv", "substantiv", "verb", "substantiv", "verb", "verb", "substantiv", "substantiv", "verb", "substantiv", "verb", "verb", "substantiv", "substantiv", "verb", "substantiv", "verb", "verb"}, //2
		{"verb", "substantiv", "verb"}, //3
	}

	for i := range iesire {
		go func(caracter chan<- string, cuvinte []string) {
			for _, c := range cuvinte {
				caracter <- c
			}
			close(caracter)
		}(iesire[i], intrare[i])
	}
}

//** pasul 4 - functia "amesteca" primeste o lista cu canalele de intrare cu perechile de cheie/valoare (substantiv: 5 etc.)
//** valorile sunt trimise catre iesire[0] si pentru fiecare cheie "verb" la iesire[1].
func genereazaAmestecare(intrare []<-chan map[string]int, iesire [2]chan<- int) {
	//procesul de sincronizare
	var sincronizare sync.WaitGroup

	sincronizare.Add(len(intrare))

	for _, caracter := range intrare {
		go func(c <-chan map[string]int) {
			for i := range c {
				contor_substantive, ok := i["substantiv"]
				if ok {
					iesire[0] <- contor_substantive
				}

				contor_verbe, ok := i["verb"]
				if ok {
					iesire[1] <- contor_verbe
				}
			}
			sincronizare.Done()
		}(caracter)
	}
	go func() {
		sincronizare.Wait()
		close(iesire[0])
		close(iesire[1])
	}()
}

//** pasul 5  - calculam media verbelor substantivelor
func scrieMedie(intrare []<-chan float32) {
	var sincronizare sync.WaitGroup
	sincronizare.Add(len(intrare))

	//Nota (Atentie!): iesire[0] contine (reprezinta) substantivele si iesire[1] reprezinta verbele
	eticheta := []string{"substantiv", "verb"}

	for i := 0; i < len(intrare); i++ {
		go func(pozitieComponent int, caracter <-chan float32) {
			for medie := range caracter {
				fmt.Printf("Media %selor pentru fiecare text (component intrare) -> %f\n", eticheta[pozitieComponent], medie)
			}
			sincronizare.Done()
		}(i, intrare[i])
	}
	sincronizare.Wait()
}

//** pasul 6 - implementarea functiei main
func main() {
	//** legatura cu input-ul din linia 40
	dimensiune := 12

	//** initializarea componentelor
	componentaText1 := make(chan string, dimensiune)
	componentaText2 := make(chan string, dimensiune)
	componentaText3 := make(chan string, dimensiune)

	componentaMap1 := make(chan map[string]int, dimensiune)
	componentaMap2 := make(chan map[string]int, dimensiune)
	componentaMap3 := make(chan map[string]int, dimensiune)

	componentReduce1 := make(chan int, dimensiune)
	componentReduce2 := make(chan int, dimensiune)

	componentaMedie1 := make(chan float32, dimensiune)
	componentaMedie2 := make(chan float32, dimensiune)

	//** pornirea job-urilor
	go citireInput([3]chan<- string{componentaText1, componentaText2, componentaText3})

	go mapper(componentaText1, componentaMap1)
	go mapper(componentaText2, componentaMap2)
	go mapper(componentaText3, componentaMap3)

	go genereazaAmestecare([]<-chan map[string]int{componentaMap1, componentaMap2, componentaMap3}, [2]chan<- int{componentReduce1, componentReduce2})

	go reducer(componentReduce1, componentaMedie1) //substantive
	go reducer(componentReduce2, componentaMedie2) //verbe

	scrieMedie([]<-chan float32{componentaMedie1, componentaMedie2})
}
