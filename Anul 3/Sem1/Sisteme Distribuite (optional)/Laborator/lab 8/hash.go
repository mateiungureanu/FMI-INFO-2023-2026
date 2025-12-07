//Sa se implementeze algoritmul SHA-1 folosind limbajul GOLANG

package main

import (
	"crypto/md5"
	"crypto/sha512"
	"fmt"
)

func main() {
	fmt.Println("Calcularea functiilor hash (MD5, SHA512, SHA256, SHA1)\n")
	mesaj := []byte("Astazi sunt la laborator Sisteme Distribuite")

	fmt.Printf("Valoarea MD5 -> %x\n\n", md5.Sum(mesaj))
	fmt.Printf("Valoarea SHA512 -> %x\n\n", sha512.Sum512(mesaj))
}
