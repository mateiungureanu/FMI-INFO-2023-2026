package main

import (
	"encoding/json"
	"fmt"
	"log"
	"os"
)

func main() {
	// Numele fisierului JSON
	filename := "cantitati_fructe.json"

	// Deschidem fisierul
	file, err := os.Open(filename)
	if err != nil {
		log.Fatalf("Eroare la deschiderea fisierului: %v", err)
	}
	defer file.Close()

	// Cream o variabila map pentru a stoca datele
	fructe := make(map[string]float64)

	// Decodam continutul JSON în map
	decoder := json.NewDecoder(file)
	if err := decoder.Decode(&fructe); err != nil {
		log.Fatalf("Eroare la decodarea JSON: %v", err)
	}

	// Afisam fiecare fruct si cantitatea sa
	for fruct, cantitate := range fructe {
		fmt.Printf("%s: %.2f\n", fruct, cantitate)
	}
}
