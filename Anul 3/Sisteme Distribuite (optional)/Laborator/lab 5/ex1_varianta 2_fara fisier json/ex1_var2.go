package main

import (
	"encoding/json"
	"fmt"
	"log"
)

func main() {
	// Continutul JSON direct intr-un string
	jsonData := `{
		"mere": 20.2,
		"pere": 64.6,
		"piersici": 32.3,
		"capsuni": 87.9
	}`

	// Map pentru stocarea datelor
	fructe := make(map[string]float64)

	// Decodam JSON-ul din string
	err := json.Unmarshal([]byte(jsonData), &fructe)
	if err != nil {
		log.Fatalf("Eroare la decodarea JSON: %v", err)
	}

	// Afisam rezultatele
	for fruct, cantitate := range fructe {
		fmt.Printf("%s: %.2f\n", fruct, cantitate)
	}
}
