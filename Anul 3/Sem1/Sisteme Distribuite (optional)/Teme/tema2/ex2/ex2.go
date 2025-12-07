package main

import (
	"fmt"
	"sync"
)

func isPalindrome(word string) bool {
	for i := 0; i < len(word)/2; i++ {
		if word[i] != word[len(word)-i-1] {
			return false
		}
	}
	return true
}

func mapper(in <-chan []string, out chan<- int) {
	for batch := range in {
		count := 0
		for _, word := range batch {
			if isPalindrome(word) {
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
		{"a1551a", "parc", "ana", "minim", "1pcl3"},
		{"calabalac", "tivit", "leu", "zece10", "ploaie", "9ana9"},
		{"lalalal", "tema", "papa", "ger"},
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
