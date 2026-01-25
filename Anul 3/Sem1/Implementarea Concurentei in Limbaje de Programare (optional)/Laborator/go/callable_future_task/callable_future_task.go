package main

import (
	"fmt"
	"time"
)

// Helper function to simulate a thread-like behavior
func runInThread(fn func()) {
	go fn()
}

// Equivalent to Callable<String> from Java
// Instead of an interface, we can use a function type func() (string, error)
// or just a channel to receive the result.
func MyTask() (string, error) {
	time.Sleep(5 * time.Second)
	return "Task completed", nil
}

func main() {
	// Java: Callable<String> task = new MyTask();
	// In Go, we just refer to the function or a closure
	task := MyTask

	// Java: FutureTask<String> futureTask = new FutureTask<>(task);
	// Java: Thread thread = new Thread(futureTask);
	// Java: thread.start();

	// In Go, we launch a goroutine that pushes to a channel
	// to simulate the "Future" part.
	resultChan := make(chan string)
	errChan := make(chan error)

	go func() {
		res, err := task()
		if err != nil {
			errChan <- err
		} else {
			resultChan <- res
		}
	}()

	fmt.Println("Main...")

	// Java: String result = futureTask.get();
	// This blocks until the result is available
	select {
	case res := <-resultChan:
		fmt.Println("Result: " + res)
	case err := <-errChan:
		fmt.Printf("Error: %v\n", err)
	}
}
