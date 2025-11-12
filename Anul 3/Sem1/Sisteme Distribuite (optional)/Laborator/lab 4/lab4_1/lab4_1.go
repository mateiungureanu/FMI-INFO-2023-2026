package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"log"
	"os"
	"time"
)

// Address și Person modelează un obiect cu tag-uri JSON și câmpuri opționale
// Folosim `omitempty` pentru a ascunde câmpurile zero în output.
type Address struct {
	Street string `json:"street"`
	City   string `json:"city"`
	Zip    string `json:"zip,omitempty"`
}

type Person struct {
	ID        int       `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email,omitempty"`
	Active    bool      `json:"active"`
	Tags      []string  `json:"tags,omitempty"`
	Address   Address   `json:"address"`
	CreatedAt time.Time `json:"created_at"` // time.Time se codifică implicit RFC3339
}

// Un exemplu de tip personalizat cu (de)serializare proprie
// Afișăm o monedă ca string (ex: "12.34 RON")
type MoneyRON int64 // valori în bani (1 RON = 100 bani)

func (m MoneyRON) MarshalJSON() ([]byte, error) {
	value := fmt.Sprintf("\"%.2f RON\"", float64(m)/100)
	return []byte(value), nil
}

func (m *MoneyRON) UnmarshalJSON(data []byte) error {
	// Acceptăm forma "12.34 RON"
	var s string
	if err := json.Unmarshal(data, &s); err != nil {
		return err
	}
	var amount float64
	var unit string
	if _, err := fmt.Sscanf(s, "%f %s", &amount, &unit); err != nil {
		return err
	}
	if unit != "RON" {
		return errors.New("unitate monetară neacceptată (doar RON)")
	}
	*m = MoneyRON(amount * 100)
	return nil
}

// Order combină tipuri diferite, inclusiv MoneyRON
// pentru a demonstra (de)codarea de colecții și compoziție

type Order struct {
	OrderID string            `json:"order_id"`
	Buyer   Person            `json:"buyer"`
	Items   []string          `json:"items"`
	Meta    map[string]any    `json:"meta,omitempty"`
	Total   MoneyRON          `json:"total"`
	Flags   map[string]bool   `json:"flags,omitempty"`
}

func encodeExamples() error {
	p := Person{
		ID:     1,
		Name:   "Ana Pop",
		Email:  "ana.pop@example.com",
		Active: true,
		Tags:   []string{"admin", "beta"},
		Address: Address{
			Street: "Str. Lalelelor 10",
			City:   "Cluj-Napoca",
			Zip:    "400123",
		},
		CreatedAt: time.Date(2025, 10, 30, 9, 0, 0, 0, time.FixedZone("EET", 2*3600)),
	}

	// 1) Codare simplă într-un []byte
	b, err := json.MarshalIndent(p, "", "  ")
	if err != nil {
		return err
	}
	fmt.Println("=== JSON pentru Person ===")
	fmt.Println(string(b))

	// 2) Codare pentru colecții: slice + map
	collection := map[string]any{
		"people": []Person{p, {ID: 2, Name: "Dan Ionescu", Active: false, Address: Address{Street: "Calea Dorobanți 1", City: "București"}, CreatedAt: time.Now()}},
		"count":  2,
	}
	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "  ")
	fmt.Println("\n=== JSON pentru colecție (map + slice) ===")
	if err := enc.Encode(collection); err != nil {
		return err
	}

	// 3) Codare unui obiect cu tip personalizat (MoneyRON)
	order := Order{
		OrderID: "ORD-1001",
		Buyer:   p,
		Items:   []string{"carte", "pix"},
		Meta:    map[string]any{"source": "web", "coupon": nil},
		Total:   MoneyRON(2599), // 25.99 RON
		Flags:   map[string]bool{"paid": true, "shipped": false},
	}
	fmt.Println("\n=== JSON pentru Order (cu MoneyRON) ===")
	if err := enc.Encode(order); err != nil {
		return err
	}

	return nil
}

func decodeExamples() error {
	// 1) Decodare într-o structură cunoscută
	jsonPerson := `{
	  "id": 3,
	  "name": "Ioana Matei",
	  "active": true,
	  "address": {"street": "Bd. Unirii 5", "city": "Iași"},
	  "created_at": "2025-10-30T08:30:00+02:00"
	}`
	var p Person
	if err := json.Unmarshal([]byte(jsonPerson), &p); err != nil {
		return err
	}
	fmt.Println("\n>>> Decodat Person din JSON:", p.Name, p.Address.City, p.CreatedAt.Format(time.RFC3339))

	// 2) Decodare cu validare: DisallowUnknownFields
	jsonStrict := `{"order_id":"ORD-2002","buyer": {"id": 4, "name": "Radu" , "active": false, "address": {"street":"", "city":"București"}, "created_at":"2025-10-30T10:00:00+02:00"}, "items":["mouse"], "total":"99.99 RON", "extra":"ignore"}`
	dec := json.NewDecoder(bytes.NewBufferString(jsonStrict))
	dec.DisallowUnknownFields() // va greși pentru câmpul "extra"
	var o Order
	if err := dec.Decode(&o); err != nil {
		fmt.Println("(așteptat) Eroare la decodare strictă:", err)
	}

	// 3) Decodare tolerantă (fără DisallowUnknownFields)
	dec2 := json.NewDecoder(bytes.NewBufferString(jsonStrict))
	if err := dec2.Decode(&o); err != nil {
		return err
	}
	fmt.Println(
		"\n>>> Decodat Order tolerant:",
		o.OrderID,
		"total:", o.Total,
	)

	return nil
}

func main() {
	log.SetFlags(0)
	if err := encodeExamples(); err != nil {
		log.Fatal("encodeExamples:", err)
	}
	if err := decodeExamples(); err != nil {
		log.Fatal("decodeExamples:", err)
	}
}
