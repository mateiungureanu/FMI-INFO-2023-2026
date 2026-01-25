package main

import (
	"fmt"
	"sync"
)

const ITERATIONS = 1_000_000

func main() {
	counter := 0
	var lock sync.Mutex
	var wg sync.WaitGroup

	// Start a goroutine
	wg.Add(1)
	go func() {
		defer wg.Done()
		for range ITERATIONS {
			lock.Lock()
			counter++
			lock.Unlock()
		}
	}()

	// Main goroutine also increments
	for range ITERATIONS {
		lock.Lock()
		counter++
		lock.Unlock()
	}

	wg.Wait()
	fmt.Printf("Final counter value: %d (expected: %d)\n", counter, 2*ITERATIONS)
}
