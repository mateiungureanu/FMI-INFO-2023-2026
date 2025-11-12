package main

import (
	"fmt"
	"regexp"
)

func main() {
	var s string
	fmt.Scan(&s)
	match, _ := regexp.MatchString("p([a-z]+)ch", s)
	fmt.Println(match)
}
