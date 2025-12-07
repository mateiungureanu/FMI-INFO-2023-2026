package main

import (
	"fmt"
	"strings"
	"sync"
)

func isValidWord(word string) bool {
	vowels := "aeiouAEIOU"
	v := 0
	c := 0

	for _, r := range word {
		if strings.ContainsRune(vowels, r) {
			v++
		} else {
			c++
		}
	}

	return (v%2 == 0) && (c%3 == 0)
}

func mapper(in <-chan []string, out chan<- int) {
	for batch := range in {
		count := 0
		for _, word := range batch {
			if isValidWord(word) {
				count++
			}
		}
		out <- count
	}
}

func reducer(in <-chan int, out chan<- int) {
	sum := 0
	for n := range in {
		sum += n
	}
	out <- sum
	close(out)
}

func main() {
	input := [][]string{
		{"aabbb", "ebep", "blablablaa", "hijk", "wsww"},
		{"abba", "eeeppp", "cocor", "ppppppaa", "qwerty", "acasq"},
		{"lalala", "lalal", "papapa", "papap"},
	}

	tasks := make(chan []string, len(input))
	mapped := make(chan int, len(input))
	result := make(chan int)

	go reducer(mapped, result)

	var wg sync.WaitGroup
	numWorkers := 3

	for range numWorkers {
		wg.Go(func() {
			mapper(tasks, mapped)
		})
	}

	for _, line := range input {
		tasks <- line
	}
	close(tasks)

	wg.Wait()
	close(mapped)

	totalSum := <-result

	avg := float64(totalSum) / float64(len(input))
	fmt.Printf("Media: %.2f\n", avg)
}
