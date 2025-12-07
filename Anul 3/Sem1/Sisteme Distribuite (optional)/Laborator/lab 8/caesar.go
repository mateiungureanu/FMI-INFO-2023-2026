//Curs disponibil online: https://cacr.uwaterloo.ca/hac/
//Sa se implementeze algoritmul CAESAR folosind limbajul GOLANG

package main

import (
	"fmt"
	"unicode"
)

// Pasul 1 - Declaram o interfata pentru cele doua operatii (criptare, decriptare)
type CaesarAlgoritm interface {
	Enc(string) string
	Dec(string) string
}

// Pasul 2 - Cheia utilizata la operatiile de criptare si decriptare
type algoritm []int

// Pasul 3 - procesul de shifting
func (ch algoritm) AlgoritmCaesar(litere string, shift func(int, int) int) string {
	//alfabet shiftat
	textShiftat := ""
	for _, litera := range litere {
		if !unicode.IsLetter(litera) {
			continue
		}
		shifting := ch[len(textShiftat)%len(ch)]
		//shiftarea propriu-zisa
		s := shift(int(unicode.ToLower(litera)), shifting)
		//realizam o verificare pentru cazul in care s-ul respectiv (shiftarea) este mai mica decat valoarea ascii a caracterului 'a'
		switch {
		case s < 'a':
			s += 'z' - 'a' + 1
		case 'z' < s:
			s -= 'z' - 'a' + 1
		}
		textShiftat += string(s)
	}
	return textShiftat
}

// Pasul 3 - Criptarea mesajului
func (ch *algoritm) Enc(plaintext string) string {
	return ch.AlgoritmCaesar(plaintext, func(a, b int) int { return a + b })
}

// Pasul 4 - Decriptarea mesajului
func (ch *algoritm) Dec(ciphertext string) string {
	return ch.AlgoritmCaesar(ciphertext, func(a, b int) int { return a - b })
}

// Pasul 5 - generam procesul de shiftare pentru algoritmul caesar
func Caesar(key int) CaesarAlgoritm {
	return ShiftingOp(key)
}

func ShiftingOp(shift int) CaesarAlgoritm {
	if shift < -25 || 25 < shift || shift == 0 {
		return nil
	}
	ch := algoritm([]int{shift})
	return &ch
}

func main() {
	//Exemplul 1
	ch := Caesar(1)
	fmt.Println("Criptare folosind K=1 pentru salut ->", ch.Enc("salut"))
	fmt.Println("Decriptare folosind K=1 pentru tbmvu ->", ch.Dec("tbmvu"))

	//Exemplul 2
	ch = Caesar(20)
	fmt.Println("Criptare folosind K=20 pentru salut ->", ch.Enc("salut"))
	fmt.Println("Decriptare folosind K=20 pentru mufon ->", ch.Dec("mufon"))

}
