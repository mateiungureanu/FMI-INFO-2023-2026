package main

import (
	"fmt"
	"sync"
)

// fibonacci calculates the nth Fibonacci number recursively
func fibonacci(n int) int64 {
	if n <= 1 {
		return int64(n)
	}
	return fibonacci(n-1) + fibonacci(n-2)
}

func main() {
	n := 20
	fmt.Printf("Fibonacci for n = %d\n", n)

	// Java: CompletableFuture<Long> future = CompletableFuture.supplyAsync(() -> fibonacci(n));
	// In Go, we launch a goroutine and use a channel for the result.
	future := make(chan int64, 1) // Buffered to prevent leaking if we didn't read (though we do here)

	go func() {
		future <- fibonacci(n)
	}()

	// Java: future.thenAccept(result -> { ... });
	// We can do this with another goroutine that waits on the first channel
	// or just wait in main. To mimic the "async callback" nature of thenAccept:
	var wg sync.WaitGroup
	wg.Add(1)

	go func() {
		defer wg.Done()
		// Wait for the result from the "future"
		result := <-future
		fmt.Printf("Fibo(%d) = %d\n", n, result)
	}()

	fmt.Println("Main...")

	// Java: future.join();
	// Blocks main thread until everything is done
	wg.Wait()
}
