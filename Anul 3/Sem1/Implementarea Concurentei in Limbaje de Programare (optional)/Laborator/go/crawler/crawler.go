package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"
)

// Result holds the data for a specific URL so we don't lose context
// in the unordered channel.
type Result struct {
	URL     string
	Content string
	Error   error
}

// CrawlerTask fetches content and returns a Result struct
func CrawlerTask(url string) Result {
	fmt.Printf("Accessing %s\n", url)

	client := &http.Client{Timeout: 5 * time.Second}
	resp, err := client.Get(url)
	if err != nil {
		return Result{URL: url, Error: err}
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return Result{URL: url, Error: fmt.Errorf("status code: %d", resp.StatusCode)}
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return Result{URL: url, Error: err}
	}

	return Result{URL: url, Content: string(body)}
}

func main() {
	urls := []string{
		"https://google.com",
		"https://jsonplaceholder.typicode.com/posts/1",
		"https://jsonplaceholder.typicode.com/posts/2",
		"https://jsonplaceholder.typicode.com/posts/3",
	}

	// 1. Setup synchronization
	var wg sync.WaitGroup
	// Buffered channel ensures goroutines don't block while sending
	results := make(chan Result, len(urls))

	// 2. Scatter: Launch goroutines
	for _, url := range urls {
		wg.Add(1)
		go func(u string) {
			defer wg.Done()
			results <- CrawlerTask(u)
		}(url)
	}

	// 3. Monitor: Close channel when all tasks are done
	go func() {
		wg.Wait()
		close(results)
	}()

	// 4. Gather: Print results as they arrive
	for res := range results {
		fmt.Println(strings.Repeat("=", 80))
		if res.Error != nil {
			fmt.Printf("FAILURE [%s]: %v\n", res.URL, res.Error)
		} else {
			fmt.Printf("%s\n%s\n", res.URL, res.Content)
		}
	}
}
