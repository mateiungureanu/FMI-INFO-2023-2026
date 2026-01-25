package main

import (
	"bufio"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"sync"
)

// Logger Monitor
type Monitor struct {
	mu sync.Mutex
}

func (m *Monitor) Log(msg string) {
	m.mu.Lock()
	defer m.mu.Unlock()
	fmt.Println(msg)
}

var monitor = &Monitor{}

// Shared State for coordination
type Context struct {
	ProcessedFilesCount int
	mu                  sync.Mutex
	cond                *sync.Cond
}

func NewContext() *Context {
	ctx := &Context{}
	ctx.cond = sync.NewCond(&ctx.mu)
	return ctx
}

func (c *Context) IncFilesProcessed() {
	c.mu.Lock()
	c.ProcessedFilesCount++
	// Broadcast to all waiting consumers that state changed
	c.cond.Broadcast()
	c.mu.Unlock()
}

func (c *Context) WaitForMinFiles(min int) {
	c.mu.Lock()
	defer c.mu.Unlock()
	for c.ProcessedFilesCount < min {
		c.cond.Wait()
	}
}

// Data packet aimed for Consumer
type FileContent struct {
	Path    string
	Content string
}

func Producer(id int, filePaths <-chan string, dataChan chan<- FileContent, ctx *Context, wg *sync.WaitGroup) {
	defer wg.Done()

	for path := range filePaths {
		monitor.Log(fmt.Sprintf("Thread Id %d is currently working on file {%s}", id, path))

		// Read file
		content, err := os.ReadFile(path)
		if err != nil {
			// Skip error handling for simplicity or log?
			continue
		}

		// Push to data channel
		dataChan <- FileContent{Path: path, Content: string(content)}

		// Signal that one file has been processed
		ctx.IncFilesProcessed()
	}
}

func Consumer(id int, dataChan <-chan FileContent, ctx *Context, wg *sync.WaitGroup, minWait int) {
	defer wg.Done()

	// "scrie la STDOUT sa fie efectuata dupa prelucrarea a cel putin 2 fisiere text"
	// Check condition *once* before starting to write?
	// Or check periodically? The requirement implies the *mechanism* enables writing
	// only when condition is met.
	// Let's block here until global count >= 2.

	// Wait for condition
	ctx.WaitForMinFiles(minWait)

	// Regex for alphanumeric
	re := regexp.MustCompile("[^a-zA-Z0-9]+")

	for item := range dataChan {
		monitor.Log(fmt.Sprintf("Thread Id %d is currently writing at standard output", id))

		// Clean content
		clean := re.ReplaceAllString(item.Content, "")

		fmt.Printf("[Writer %d] Content of %s:\n%s\n\n", id, item.Path, clean)
	}
}

func main() {
	// Standard Input: Path, N, M
	// For simulation/skeleton, we can hardcode or read.
	// Let's read from Stdin as requested.
	reader := bufio.NewReader(os.Stdin)

	fmt.Print("Enter absolute path: ")
	pathStr, _ := reader.ReadString('\n')
	pathStr = filepath.Clean(pathStr[:len(pathStr)-1]) // TRIM newline usually windows sends \r\n
	// Remove potential \r on windows
	if len(pathStr) > 0 && pathStr[len(pathStr)-1] == '\r' {
		pathStr = pathStr[:len(pathStr)-1]
	}

	var N, M int
	fmt.Print("Enter N (Threads Reader): ")
	fmt.Scan(&N)
	fmt.Print("Enter M (Threads Writer): ")
	fmt.Scan(&M)

	// Validate inputs
	if N < 1 {
		N = 1
	}
	if M < 1 {
		M = 1
	}

	// Find all text files first
	var files []string
	// Check if path exists first
	fi, err := os.Stat(pathStr)
	if err != nil {
		fmt.Println("Error accessing path:", err)
		return
	}

	if !fi.IsDir() {
		// If it's a file, just add it if txt
		if filepath.Ext(pathStr) == ".txt" {
			files = append(files, pathStr)
		}
	} else {
		err = filepath.Walk(pathStr, func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if !info.IsDir() && filepath.Ext(path) == ".txt" {
				files = append(files, path)
			}
			return nil
		})
	}

	if err != nil {
		fmt.Println("Error walking path:", err)
		return
	}

	fmt.Printf("Found %d text files.\n", len(files))

	minFilesToWait := 2
	if len(files) < 2 {
		fmt.Println("Warning: Fewer than 2 files found. Adjusting wait condition to avoid deadlock.")
		minFilesToWait = len(files)
	}

	// Setup Channels and Context
	filesChan := make(chan string, len(files))
	dataChan := make(chan FileContent, len(files)) // Buffered to avoid blocking producers too much

	ctx := NewContext()
	var producerWg sync.WaitGroup
	var consumerWg sync.WaitGroup

	// Start Producers
	for i := 1; i <= N; i++ {
		producerWg.Add(1)
		go Producer(i, filesChan, dataChan, ctx, &producerWg)
	}

	// Start Consumers
	for i := 1; i <= M; i++ {
		consumerWg.Add(1)
		go Consumer(i, dataChan, ctx, &consumerWg, minFilesToWait)
	}

	// Feed files
	for _, f := range files {
		filesChan <- f
	}
	close(filesChan)

	// Wait for producers to finish
	producerWg.Wait()
	close(dataChan) // Close data channel so consumers exit loop

	// Wait for consumers
	consumerWg.Wait()
}
