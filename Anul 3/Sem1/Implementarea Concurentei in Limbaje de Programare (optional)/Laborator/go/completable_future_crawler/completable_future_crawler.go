package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"sync"
	"time"
)

// CrawlerTask equivalent
// Returns content or prints error/status internally?
// The Java code returns String content.
func callCrawlerTask(url string) string {
	fmt.Printf("Accessing %s\n", url)

	client := &http.Client{Timeout: 5 * time.Second}
	resp, err := client.Get(url)
	if err != nil {
		// Java prints stack trace in catch
		fmt.Println(err)
		return ""
	}
	defer resp.Body.Close()

	if resp.StatusCode == 200 {
		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Println(err)
			return ""
		}
		return string(body)
	} else {
		return fmt.Sprintf("Cannot access this page: %d", resp.StatusCode)
	}
}

func main() {
	urls := []string{
		"https://fmi.unibuc.ro/category/anunturi-secretariat/",
		"https://fmi.unibuc.ro/category/noutati/",
		"https://fmi.unibuc.ro/category/anunturi-doctorat/",
	}

	// Java: List<CompletableFuture<String>> futures = ...
	// Java: CompletableFuture.allOf(...)
	// In Go, we use a WaitGroup to wait for all, and channels to collect results.
	// But since Java code processes them *after* all are done (allFutures.thenRun),
	// we will collect all results first.

	type Result struct {
		Content string
		Err     error
	}

	futures := make([]chan string, len(urls))

	for i, url := range urls {
		// Equivalent to supplyAsync
		ch := make(chan string, 1)
		futures[i] = ch
		go func(u string) {
			ch <- callCrawlerTask(u)
		}(url)
	}

	// CompletableFuture.allOf().thenRun(...)
	// We wait for all channels to have a value (or simply read from them in order if we want matching indices)
	var wg sync.WaitGroup
	wg.Add(1)

	go func() {
		defer wg.Done()
		fmt.Println("All tasks completed!")
		for _, fu := range futures {
			// future.get()
			content := <-fu
			fmt.Println(content)
			fmt.Println(strings.Repeat("=", 80))
		}
	}()

	// Java: System.out.println("Main thread continues...");
	fmt.Println("Main thread continues...")

	// Java: allFutures.join();
	wg.Wait()
}
