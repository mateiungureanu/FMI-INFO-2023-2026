package main

import (
	"fmt"
	"io"
	"net/http"
	"strings"
	"time"
)

// CrawlerTask equivalent
func crawlerTaskCall(url string) string {
	var content strings.Builder

	fmt.Printf("Accesing %s\n", url) // Typo "Accesing" matches Java code

	client := &http.Client{Timeout: 5 * time.Second}
	resp, err := client.Get(url)
	if err != nil {
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
		content.WriteString(string(body))
		content.WriteString("\n")
	} else {
		content.WriteString(fmt.Sprintf("Cannot access this page: %d", resp.StatusCode))
	}

	urls := []string{
		"https://google.com",
		"https://jsonplaceholder.typicode.com/posts/1",
		"https://jsonplaceholder.typicode.com/posts/2",
		"https://jsonplaceholder.typicode.com/posts/3",
	}

	// Java: List<FutureTask<String>> futureTasks = new ArrayList<>();
	// In Go, our "FutureTask" can be a channel that eventually receives a value.
	futureTasks := make([]chan string, 0, len(urls))

	for _, url := range urls {
		// Java: FutureTask<String> futureTask = new FutureTask<>(task);
		// Java: Thread thread = new Thread(futureTask); thread.start();

		ch := make(chan string, 1) // Buffered so producer doesn't block if we're not ready
		futureTasks = append(futureTasks, ch)

		go func(u string, c chan<- string) {
			c <- crawlerTaskCall(u)
		}(url, ch)
	}

	// Java: for (FutureTask<String> futureTask : futureTasks) { futureTask.get(); ... }
	for _, ch := range futureTasks {
		// .get() blocks
		content := <-ch
		fmt.Println(content)
	}
}
