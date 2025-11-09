package main

import (
	"encoding/json"
	"fmt"
	"log"
	"sort"
)

func main() {
	// Continutul JSON sub forma de string
	jsonData := `{
		"mere": 20.2,
		"pere": 64.6,
		"piersici": 32.3,
		"capsuni": 87.9
	}`

	// Map pentru stocarea datelor
	fructe := make(map[string]float64)

	// Decodam JSON-ul în map
	err := json.Unmarshal([]byte(jsonData), &fructe)
	if err != nil {
		log.Fatalf("Eroare la decodarea JSON: %v", err)
	}

	// Extragem cheile (numele fructelor)
	var chei []string
	for fruct := range fructe {
		chei = append(chei, fruct)
	}

	// Sortam alfabetic
	sort.Strings(chei)

	// Afisam fructele în ordine alfabetica
	for _, fruct := range chei {
		fmt.Printf("%s: %.2f\n", fruct, fructe[fruct])
	}
}
