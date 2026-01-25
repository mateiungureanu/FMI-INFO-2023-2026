package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Producer sends messages to the channel
// ch: The channel for passing data
// id: ID for logging
// wg: WaitGroup to signal when this specific producer is done
func Producer(ch chan<- string, id int, wg *sync.WaitGroup) {
	defer wg.Done() // 3. Notify WaitGroup when this function exits

	messages := []string{"i", "want", "to", "send", "a", "message"}

	for _, msg := range messages {
		fmt.Printf("Producer %d produced %s\n", id, msg)

		// 1. Send to channel.
		// Because the channel is unbuffered, this line BLOCKS
		// untill a consumer is ready to take it.
		ch <- msg

		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	}
}

// Consumer receives messages from the channel
func Consumer(ch <-chan string, id int, wg *sync.WaitGroup) {
	defer wg.Done()

	// 2. Range Loop
	// This loop automatically:
	// - Blocks when channel is empty
	// - Runs when data arrives
	// - Exits immediately when the channel is closed
	for message := range ch {
		fmt.Printf("Consumer %d received %s\n", id, message)
		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	}
	fmt.Printf("Consumer %d shutting down\n", id)
}

func main() {
	// We create an unbuffered channel. This mimics the "Single Item Buffer"
	// from your Java code. Use make(chan string, 10) if you wanted a buffer.
	drop := make(chan string)

	var producerWg sync.WaitGroup
	var consumerWg sync.WaitGroup

	// Start Producer
	producerWg.Add(1)
	go Producer(drop, 1, &producerWg)

	// Start Consumer
	consumerWg.Add(1)
	go Consumer(drop, 1, &consumerWg)

	// 4. Coordinator Goroutine
	// We need a background routine to close the channel once producers are done.
	go func() {
		producerWg.Wait() // Wait for all producers to finish
		close(drop)       // Close channel to signal consumers to stop
	}()

	// 5. Main Block
	// Wait for consumers to finish processing the closed channel data
	consumerWg.Wait()

	fmt.Println("All processing complete.")
}
