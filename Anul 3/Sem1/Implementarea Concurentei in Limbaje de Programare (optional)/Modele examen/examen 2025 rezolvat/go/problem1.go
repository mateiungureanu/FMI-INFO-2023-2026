package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Item represents the object with a type
type Item struct {
	Type  int
	Value string
}

// Buffer manages the fixed-size constraint and separate queues for types
type Buffer struct {
	ch0  chan Item
	ch1  chan Item
	sem  chan struct{} // limits total items in buffer
	size int
}

func NewBuffer(size int) *Buffer {
	return &Buffer{
		ch0:  make(chan Item, size), // technically can hold 'size' items of type 0
		ch1:  make(chan Item, size), // technically can hold 'size' items of type 1
		sem:  make(chan struct{}, size),
		size: size,
	}
}

func (b *Buffer) Put(item Item) {
	// Block if buffer is full (global size constraint)
	b.sem <- struct{}{}

	if item.Type == 0 {
		b.ch0 <- item
	} else {
		b.ch1 <- item
	}
}

func (b *Buffer) Get(reqType int) Item {
	var item Item
	if reqType == 0 {
		item = <-b.ch0
	} else {
		item = <-b.ch1
	}

	// Release space in buffer
	<-b.sem
	return item
}

// Producer sends messages to the buffer
func Producer(buf *Buffer, id int, wg *sync.WaitGroup) {
	defer wg.Done()

	messages := []string{"i", "want", "to", "send", "a", "message"}

	for i := 0; i < 10; i++ {
		// Toggle type to ensure balance: Type 0 then Type 1 ...
		msgType := i % 2
		msg := messages[i%len(messages)]
		item := Item{Type: msgType, Value: msg}

		fmt.Printf("Producer %d produced Type %d: %s\n", id, msgType, msg)

		// Send to buffer
		buf.Put(item)

		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	}
}

// Consumer receives messages from the buffer
func Consumer(buf *Buffer, id int, typeToConsume int, wg *sync.WaitGroup) {
	defer wg.Done()
	for i := 0; i < 10; i++ {
		item := buf.Get(typeToConsume)
		fmt.Printf("Consumer %d (Type %d) received Type %d: %s\n", id, typeToConsume, item.Type, item.Value)
		time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)
	}
	fmt.Printf("Consumer %d shutting down\n", id)
}

func main() {
	// a. Buffer of fixed size specified at creation
	buffer := NewBuffer(5)

	var producerWg sync.WaitGroup
	var consumerWg sync.WaitGroup

	// Start Producers
	producerWg.Add(1)
	go Producer(buffer, 1, &producerWg)
	producerWg.Add(1)
	go Producer(buffer, 2, &producerWg)

	// Start Consumers (Type 0 and Type 1)
	consumerWg.Add(1)
	go Consumer(buffer, 1, 0, &consumerWg) // Consumer 1 takes Type 0
	consumerWg.Add(1)
	go Consumer(buffer, 2, 1, &consumerWg) // Consumer 2 takes Type 1

	// Coordinator to wait for producers (optional for exam but good practice)
	// Since consumers are fixed loop, we just wait for everyone
	producerWg.Wait()
	consumerWg.Wait()

	fmt.Println("All processing complete.")
}
