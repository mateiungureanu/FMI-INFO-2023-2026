package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"sync"
	"time"
)

// --- Priority Reader-Writer Monitor ---
type PriorityRWMonitor struct {
	mu              sync.Mutex
	cond            *sync.Cond
	activeReaders   int
	activeWriters   int
	waitingWriters  int
	messagesWritten int // To track "guarantee at least one message"
}

func NewPriorityRWMonitor() *PriorityRWMonitor {
	m := &PriorityRWMonitor{}
	m.cond = sync.NewCond(&m.mu)
	return m
}

func (m *PriorityRWMonitor) StartRead() {
	m.mu.Lock()
	defer m.mu.Unlock()

	// Wait if:
	// 1. A writer is currently writing (activeWriters > 0)
	// 2. A writer is WAITING (priority rule) (waitingWriters > 0)
	// 3. No messages have been written yet (messagesWritten == 0)
	for m.activeWriters > 0 || m.waitingWriters > 0 || m.messagesWritten == 0 {
		m.cond.Wait()
	}
	m.activeReaders++
}

func (m *PriorityRWMonitor) EndRead() {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.activeReaders--
	if m.activeReaders == 0 {
		m.cond.Broadcast() // Wake up writers
	}
}

func (m *PriorityRWMonitor) StartWrite() {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.waitingWriters++

	// Wait if:
	// 1. A writer is active
	// 2. A reader is active
	// Note: We do NOT wait for other waiting writers (we just compete with them when woken)
	for m.activeWriters > 0 || m.activeReaders > 0 {
		m.cond.Wait()
	}

	m.waitingWriters--
	m.activeWriters++
}

func (m *PriorityRWMonitor) EndWrite() {
	m.mu.Lock()
	defer m.mu.Unlock()

	m.activeWriters--
	m.messagesWritten++

	m.cond.Broadcast() // Wake up readers or other writers
}

// --- Logic ---

func Producer(ch chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()
	defer close(ch)

	reader := bufio.NewReader(os.Stdin)
	fmt.Println("Producer: Enter messages (type 'exit' to stop):")

	for {
		// Read from STDIN
		text, _ := reader.ReadString('\n')
		text = strings.TrimSpace(text)

		if text == "exit" {
			break
		}

		fmt.Printf("[Producer] Produced: %s\n", text)
		ch <- text
	}
	fmt.Println("[Producer] Stopped.")
}

func ConsumerWriter(id int, ch <-chan string, monitor *PriorityRWMonitor, filename string, wg *sync.WaitGroup) {
	defer wg.Done()

	for msg := range ch {
		// Writer Logic
		monitor.StartWrite()

		// WRITE to file
		// Append mode
		f, err := os.OpenFile(filename, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			fmt.Println("Error opening file:", err)
			monitor.EndWrite()
			continue
		}

		content := fmt.Sprintf("[Writer %d] %s\n", id, msg)
		if _, err := f.WriteString(content); err != nil {
			fmt.Println("Error writing to file:", err)
		}
		f.Close()

		fmt.Printf("[Writer %d] Wrote to critical section: %s\n", id, msg)

		monitor.EndWrite()

		// Simulate some processing time
		time.Sleep(500 * time.Millisecond)
	}
}

func Reader(id int, monitor *PriorityRWMonitor, filename string, wg *sync.WaitGroup, stopChan <-chan bool) {
	defer wg.Done()

	for {
		select {
		case <-stopChan:
			return
		default:
			// Reader Logic
			monitor.StartRead()

			// Critical Section: READ file and print to STDOUT
			data, err := os.ReadFile(filename)
			if err == nil {
				fmt.Printf("\n[Reader %d] Content of %s:\n%s\n", id, filename, string(data))
			} else {
				fmt.Println("[Reader] Error reading file (or empty):", err)
			}

			monitor.EndRead()

			// Sleep before next read to avoid spamming console
			time.Sleep(2 * time.Second)
		}
	}
}

func main() {
	// Setup
	msgChan := make(chan string, 10)
	filename := "sub1.txt"
	monitor := NewPriorityRWMonitor()

	// Create/Clear the file initially?
	// The problem implies "appending" or writing to checking messages.
	// Let's truncate start.
	os.WriteFile(filename, []byte(""), 0644)

	var prodWg sync.WaitGroup
	var consWg sync.WaitGroup
	var readerWg sync.WaitGroup

	// 1 Producer
	prodWg.Add(1)
	go Producer(msgChan, &prodWg)

	// 3 Writers (Consumers)
	NumWriters := 3
	for i := 1; i <= NumWriters; i++ {
		consWg.Add(1)
		go ConsumerWriter(i, msgChan, monitor, filename, &consWg)
	}

	// 3 Readers
	NumReaders := 3
	stopReaders := make(chan bool)
	for i := 1; i <= NumReaders; i++ {
		readerWg.Add(1)
		go Reader(i, monitor, filename, &readerWg, stopReaders)
	}

	// Wait for Producer to finish (user types exit)
	prodWg.Wait()

	// Wait for Consumers to finish processing channel
	consWg.Wait()

	// Stop Readers
	close(stopReaders)
	readerWg.Wait()

	fmt.Println("Simulation finished.")
}
