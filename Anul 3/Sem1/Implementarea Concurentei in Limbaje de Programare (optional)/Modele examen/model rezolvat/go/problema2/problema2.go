package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// --- Shared Resources ---

// Simulated Database
type Database struct {
	mu   sync.RWMutex
	Data []string
}

func NewDatabase(size int) *Database {
	d := &Database{
		Data: make([]string, size),
	}
	for i := 0; i < size; i++ {
		d.Data[i] = fmt.Sprintf("Line %d", i)
	}
	return d
}

// Monitor to track the best result
type Monitor struct {
	mu           sync.Mutex
	BestIndex    int
	BestResult   int // Assuming result is an int score
	ResultCount  int
	TotalActions int
}

func (m *Monitor) UpdateIfBetter(index int, result int) {
	m.mu.Lock()
	defer m.mu.Unlock()

	// "retine mereu doar perechea corespunzatoare celui mai mare scor obtinut"
	if result > m.BestResult {
		m.BestResult = result
		m.BestIndex = index
	}
	m.ResultCount++
}

func (m *Monitor) PrintBest() {
	m.mu.Lock()
	defer m.mu.Unlock()
	fmt.Printf("Monitor: Best Action Index %d with Score %d\n", m.BestIndex, m.BestResult)
}

// --- Logic ---

// computeResult function (random as per observation)
func computeResult(lines []string) int {
	// Simulate work
	time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)
	return rand.Intn(100) // Returns a score 0-99
}

// Action represents the "Reader" part then "Writer" update
func Action(index int, db *Database, monitor *Monitor, N, M int, wg *sync.WaitGroup) {
	defer wg.Done()

	// 1. Reader Role: Read lines between N and M
	db.mu.RLock()
	// Simulate reading time
	time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)

	// Validate boundaries
	start, end := N, M
	if start < 0 {
		start = 0
	}
	if end > len(db.Data) {
		end = len(db.Data)
	}

	var readLines []string
	if start < end {
		// Copy data to work on it
		readLines = make([]string, end-start)
		copy(readLines, db.Data[start:end])
	}
	db.mu.RUnlock()

	fmt.Printf("Action %d executed (Read %d lines)\n", index, len(readLines))

	// 2. Compute Result (Local processing)
	score := computeResult(readLines)

	// 3. Writer Role: Update source, labeling lines with batch score
	// "thread-urile Writer se updateaza sursa de date, etichetand fiecare linie cu scor-ul batch-ului"
	// NOTE: Problem says "Cu ajutorul thread-urilor Writer...".
	// It implies the Action spawns a Writer or becomes a Writer.
	// "Fiecare actiune executa un Reader... Dupa ce au citit... se updateaza... In acelasi timp... monitor"

	// We will treat the current goroutine as transitioning to Writer role for the update.
	db.mu.Lock()
	// Simulate writing time
	time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)

	if start < end {
		for i := start; i < end; i++ {
			db.Data[i] = fmt.Sprintf("%s [Batch %d Score %d]", db.Data[i], index, score)
		}
	}
	db.mu.Unlock()

	// 4. Send result to Monitor
	monitor.UpdateIfBetter(index, score)
}

func main() {
	// Configuration
	NumActions := 5
	DBSize := 100

	db := NewDatabase(DBSize)
	monitor := &Monitor{BestResult: -1} // Init with low value
	monitor.TotalActions = NumActions

	var wg sync.WaitGroup

	fmt.Printf("Starting %d actions...\n", NumActions)

	// "implementati un array de actiuni care sa se execute asincron"
	for i := 0; i < NumActions; i++ {
		wg.Add(1)

		// Limits N and M - random for simulation
		N := i * 10
		M := N + 10 // Guaranteed N < M

		go Action(i, db, monitor, N, M, &wg)
	}

	wg.Wait()
	monitor.PrintBest()
}
