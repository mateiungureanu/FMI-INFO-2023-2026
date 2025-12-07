//Sa se implementeze algoritmul AES folosind limbajul GOLANG

package main

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"encoding/pem" // PEM stands for Privacy Enhanced Mail
	"fmt"
	"io/ioutil"
	"log"
)

const (
	fisierCheie   = "aes.key" //continutul fisierului este reprezentat de cheia
	fisierCriptat = "aes.enc" //continutul fisierului reprezinta criptarea mesajului
)

// var IV
var vector_initializare = []byte("1234567812345678")

func citesteCheie(numefisier string) ([]byte, error) {
	cheie, err := ioutil.ReadFile(numefisier)
	if err != nil {
		return cheie, err
	}
	block, _ := pem.Decode(cheie)
	return block.Bytes, nil
}

func generareCheie() []byte {
	cheie_noua := make([]byte, 16)
	_, err := rand.Read(cheie_noua)
	if err != nil {
		log.Fatalf("Am esuat sa citesc noua cheie -> %s", err)
	}
	return cheie_noua
}

func salveazaCheie(numefisier string, cheie []byte) {
	block := &pem.Block{
		Type:  "AES KEY",
		Bytes: cheie,
	}
	err := ioutil.WriteFile(numefisier, pem.EncodeToMemory(block), 0644)
	if err != nil {
		log.Fatalf("Am esuat in salvarea cheii la locatia %s -> %s", numefisier, err)
	}
}

func cheieAES() []byte {
	fisier := fmt.Sprintf(fisierCheie)
	cheie, err := citesteCheie(fisier)
	if err != nil {
		log.Println("Crearea unei noi chei tip AES")
		cheie = generareCheie()
		salveazaCheie(fisier, cheie)
	}
	return cheie
}

func generareAlgoritm() cipher.Block {
	c, err := aes.NewCipher(cheieAES())
	if err != nil {
		log.Fatalf("Am esuat la generarea algoritmului AES: %s", err)
	}
	return c
}

func criptare(plaintext string) {
	reprezentareBytes := []byte(plaintext)
	blockCipher := generareAlgoritm()
	flux := cipher.NewCTR(blockCipher, vector_initializare)
	flux.XORKeyStream(reprezentareBytes, reprezentareBytes)
	err := ioutil.WriteFile(fmt.Sprintf(fisierCriptat), reprezentareBytes, 0644)
	if err != nil {
		log.Fatalf("Scrierea fisierului criptat -> %s", err)
	} else {
		fmt.Printf("Mesajul a fost criptat in fisierul: %s\n\n", fisierCriptat)
	}
}

func decriptare() []byte {
	reprezentareBytes, err := ioutil.ReadFile(fmt.Sprintf(fisierCriptat))
	if err != nil {
		log.Fatalf("Citirea fisierului criptat -> %s", err)
	}
	blockCipher := generareAlgoritm()
	flux := cipher.NewCTR(blockCipher, vector_initializare)
	flux.XORKeyStream(reprezentareBytes, reprezentareBytes)
	return reprezentareBytes
}

func main() {
	var mesaj = "Astazi sunt la laborator la disciplina Sisteme Distribuite"
	criptare(mesaj)

	fmt.Printf("Decriptarea mesajului -> %s", decriptare())
}
