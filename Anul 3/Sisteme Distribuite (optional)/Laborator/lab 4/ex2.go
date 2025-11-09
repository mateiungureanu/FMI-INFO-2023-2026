package main

import (
	"encoding/xml"
	"fmt"
	"os"
	"time"
)

// Inventory reprezintă documentul rădăcină
// Exemplu structură XML:
// <coffeeInventory generatedAt="2025-10-30T09:00:00+02:00">
//   <roaster>...</roaster>
//   <coffee id="...">...</coffee>
// </coffeeInventory>

type Inventory struct {
	XMLName     xml.Name `xml:"coffeeInventory"`
	XMLNS       string   `xml:"xmlns,attr,omitempty"`
	GeneratedAt string   `xml:"generatedAt,attr"`
	Roaster     Roaster  `xml:"roaster"`
	Coffees     []Coffee `xml:"coffee"`
}

type Roaster struct {
	Name     string `xml:"name"`
	Location string `xml:"location"`
	Website  string `xml:"website,omitempty"`
}

type Coffee struct {
	ID         string   `xml:"id,attr"`
	Name       string   `xml:"name"`
	Origin     Origin   `xml:"origin"`
	Process    string   `xml:"process,omitempty"`      // washed, natural, honey, anaerobic etc.
	Variety    []string `xml:"variety>name,omitempty"` // generează <variety><name>...</name>...</variety>
	RoastLevel string   `xml:"roastLevel"`             // light/medium/dark
	Notes      []string `xml:"notes>note,omitempty"`
	PriceCents int      `xml:"priceCents"`
	InStock    bool     `xml:"inStock"`
}

type Origin struct {
	Country        string `xml:"country,attr"`
	Region         string `xml:"region,omitempty"`
	AltitudeMeters int    `xml:"altitudeMeters,omitempty"`
	Farms          []Farm `xml:"farm"`
}

type Farm struct {
	Name           string   `xml:"name,attr"`
	Producer       string   `xml:"producer,omitempty"`
	Certifications []string `xml:"certifications>cert,omitempty"`
}

func buildSampleInventory() Inventory {
	inv := Inventory{
		XMLNS:       "https://example.com/coffee/inventory",
		GeneratedAt: time.Now().Format(time.RFC3339),
		Roaster: Roaster{
			Name:     "BrewCraft Roastery",
			Location: "Cluj-Napoca, RO",
			Website:  "https://brewcraft.example.com",
		},
		Coffees: []Coffee{
			{
				ID:         "C-ETH-001",
				Name:       "Ethiopia Yirgacheffe",
				Process:    "washed",
				Variety:    []string{"Heirloom"},
				RoastLevel: "light",
				Notes:      []string{"jasmine", "citrus", "bergamot"},
				PriceCents: 4990,
				InStock:    true,
				Origin: Origin{
					Country:        "Ethiopia",
					Region:         "Yirgacheffe",
					AltitudeMeters: 1950,
					Farms: []Farm{
						{Name: "Kochere", Producer: "Yirgacheffe Co-op", Certifications: []string{"Organic"}},
					},
				},
			},
			{
				ID:         "C-COL-002",
				Name:       "Colombia Huila",
				Process:    "honey",
				Variety:    []string{"Caturra", "Castillo"},
				RoastLevel: "medium",
				Notes:      []string{"caramel", "red apple", "almond"},
				PriceCents: 4290,
				InStock:    false,
				Origin: Origin{
					Country:        "Colombia",
					Region:         "Huila",
					AltitudeMeters: 1750,
					Farms: []Farm{
						{Name: "El Paraiso", Producer: "Diego Bermudez", Certifications: []string{"Rainforest Alliance"}},
						{Name: "La Esperanza"},
					},
				},
			},
		},
	}
	return inv
}

func writeXMLToFile(filename string, inv Inventory) error {
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer f.Close()

	enc := xml.NewEncoder(f)
	enc.Indent("", "  ")

	// Scriem header-ul XML standard
	if _, err := f.WriteString(xml.Header); err != nil {
		return err
	}
	return enc.Encode(inv)
}

func main() {
	inv := buildSampleInventory()

	// 1) Serializare indentată în stdout (pentru vizualizare rapidă)
	fmt.Println("=== XML generat (previzualizare) ===")
	buf, err := xml.MarshalIndent(inv, "", "  ")
	if err != nil {
		fmt.Println("eroare marshal:", err)
		os.Exit(1)
	}
	fmt.Println(xml.Header + string(buf))

	// 2) Salvare în fișier
	outFile := "coffee_inventory.xml"
	if err := writeXMLToFile(outFile, inv); err != nil {
		fmt.Println("eroare scriere fișier:", err)
		os.Exit(1)
	}
	fmt.Println("\nFișier generat:", outFile)
}
