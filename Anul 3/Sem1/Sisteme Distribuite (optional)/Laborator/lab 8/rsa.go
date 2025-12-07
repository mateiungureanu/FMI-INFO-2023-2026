package main

import (
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/pem"
	"flag"
	"fmt"
)

//** cheie publica si cheie privata
func ExportCheiePublicaCaSirPem(pub_key *rsa.PublicKey) string {
	pub_key_pem := string(pem.EncodeToMemory(&pem.Block{Type: "RSA PUBLIC KEY", Bytes: x509.MarshalPKCS1PublicKey(pub_key)}))
	return pub_key_pem
}

func ExportCheiePrivataCaSirPem(prv_key *rsa.PrivateKey) string {
	prv_key_pem := string(pem.EncodeToMemory(&pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(prv_key)}))
	return prv_key_pem
}

func ExportMesajStdPem(mesaj []byte) string {
	mesaj_pem := string(pem.EncodeToMemory(&pem.Block{Type: "MESSAGE", Bytes: mesaj}))
	return mesaj_pem
}

func main() {
	bits := 1024 //dimensiunea cheii
	flag.Parse()
	args := flag.Args()

	mesaj := args[0]

	costelCheiePrivata, _ := rsa.GenerateKey(rand.Reader, bits)
	costelCheiePublica := &costelCheiePrivata.PublicKey

	fmt.Printf("Cheie privata -> %s\n", ExportCheiePrivataCaSirPem(costelCheiePrivata))
	fmt.Printf("Cheie publica -> %s\n", ExportCheiePublicaCaSirPem(costelCheiePublica))

	mesajCostel := []byte(mesaj)
	eticheta := []byte("")
	hash := sha256.New()

	mesajCriptat, _ := rsa.EncryptOAEP(hash, rand.Reader, costelCheiePublica, mesajCostel, eticheta)

	fmt.Printf("Mesaj PEM -> %s\n", ExportMesajStdPem(mesajCriptat))

	plaintext, _ := rsa.DecryptOAEP(hash, rand.Reader, costelCheiePrivata, mesajCriptat, eticheta)

	fmt.Printf("Decriptarea folosind RSA -> %s", plaintext)
}
