package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	_, err := os.Stat("text.txt")
	if err != nil {
		if os.IsNotExist(err) {
			fmt.Print("file does not exist")
		} else {
			panic(err)
		}
	} else {
		fmt.Print("file exists\n\n")
	}

	dat, err := os.ReadFile("text.txt")
	data := string(dat)

	lines := strings.Split(data, "\n")
	for i, line := range lines {
		fmt.Printf("Line %d: %s\n", i, line)
	}

	f, err := os.Create("text2.txt")
	if err != nil {
		panic(err)
	}
	// defer f.Close()

	_, err = f.WriteString(data)
	if err != nil {
		panic(err)
	}
	f.Sync()
	f.Close()

	err = os.Rename("text2.txt", "text_clone.txt")
	if err != nil {
		panic(err)
	}
}
