package main

import (
	"fmt"
	"sync"
	"time"
)

// Writer writes to the shared resource
// We pass *sync.RWMutex instead of two separate mutexes
func Writer(rw *sync.RWMutex, id int, wg *sync.WaitGroup) {
	defer wg.Done()

	for {
		// Lock() requests exclusive access (for writing)
		// It will block until ALL active readers have finished.
		rw.Lock()

		fmt.Printf("Writer %d writes...\n", id)
		time.Sleep(2 * time.Second)

		rw.Unlock()

		// Sleep to give readers a chance to jump in
		time.Sleep(1 * time.Second)
	}
}

// Reader reads from the shared resource
func Reader(rw *sync.RWMutex, id int, wg *sync.WaitGroup) {
	defer wg.Done()

	for {
		// RLock() requests shared access (for reading)
		// It will NOT block other readers.
		// It ONLY blocks if a Writer currently holds the Lock().
		rw.RLock()

		fmt.Printf("Reader %d reads...\n", id)
		time.Sleep(1 * time.Second)

		rw.RUnlock()

		// Sleep between reads
		time.Sleep(1 * time.Second)
	}
}

func main() {
	// sync.RWMutex handles the complexity of the reader counter internally
	var rw sync.RWMutex
	var wg sync.WaitGroup

	// Start 2 writers
	wg.Add(2)
	for i := 1; i <= 2; i++ {
		go Writer(&rw, i, &wg)
	}

	// Start 6 readers
	wg.Add(6)
	for i := 1; i <= 6; i++ {
		go Reader(&rw, i, &wg)
	}

	wg.Wait()
	fmt.Println("All readers and writers completed")
}
