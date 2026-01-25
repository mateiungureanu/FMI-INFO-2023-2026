package main

import (
	"crypto/sha256"
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Transaction represents a simple unit of data
type Transaction struct {
	ID string
}

// Block represents a unit of storage
type Block struct {
	Index        int
	Transactions []Transaction
	PreviousHash string
	Hash         string
}

// Blockchain manages the state
type Blockchain struct {
	chain []Block
	mu    sync.Mutex
}

func NewBlockchain() *Blockchain {
	bc := &Blockchain{
		chain: make([]Block, 0),
	}
	// Genesis block
	bc.chain = append(bc.chain, Block{Index: 0, PreviousHash: "0", Hash: "GENESIS"})
	return bc
}

func (bc *Blockchain) AddBlock(newBlock Block) {
	bc.mu.Lock()
	defer bc.mu.Unlock()

	lastBlock := bc.chain[len(bc.chain)-1]

	// Validate continuity
	if lastBlock.Hash == newBlock.PreviousHash {
		bc.chain = append(bc.chain, newBlock)
		fmt.Printf("⛓️ Block %d added [Hash: %.8s]\n", newBlock.Index, newBlock.Hash)
	} else {
		fmt.Printf("❌ Fork detected! Block %d rejected.\n", newBlock.Index)
	}
}

func (bc *Blockchain) GetLastBlock() Block {
	bc.mu.Lock()
	defer bc.mu.Unlock()
	return bc.chain[len(bc.chain)-1]
}

// ComputeHash generates a SHA256 hash for the block content
func ComputeHash(index int, txs []Transaction, prevHash string) string {
	data := fmt.Sprintf("%d%v%s", index, txs, prevHash)
	hash := sha256.Sum256([]byte(data))
	return fmt.Sprintf("%x", hash)
}

// Node simulates a miner
func Node(id string, bc *Blockchain, txPool <-chan Transaction, wg *sync.WaitGroup) {
	defer wg.Done()
	fmt.Printf("🤖 %s started mining...\n", id)

	for {
		// 1. Gather Transactions (Drain Strategy)
		txs := make([]Transaction, 0, 5)

	CollectionLoop:
		for i := 0; i < 5; i++ {
			select {
			case tx, ok := <-txPool:
				if !ok {
					// Channel closed, process what we have then exit
					if len(txs) == 0 {
						fmt.Printf("🔌 %s shutting down.\n", id)
						return
					}
					break CollectionLoop
				}
				txs = append(txs, tx)
			default:
				// Pool is empty for now, stop trying to collect
				break CollectionLoop
			}
		}

		// 2. Process or Wait
		if len(txs) > 0 {
			lastBlock := bc.GetLastBlock()

			// Simulate Proof of Work (Mining)
			time.Sleep(time.Duration(rand.Intn(1000)) * time.Millisecond)

			newBlock := Block{
				Index:        lastBlock.Index + 1,
				Transactions: txs,
				PreviousHash: lastBlock.Hash,
			}
			newBlock.Hash = ComputeHash(newBlock.Index, newBlock.Transactions, newBlock.PreviousHash)

			bc.AddBlock(newBlock)
		} else {
			// If channel is open but empty, wait a bit to avoid hot-looping
			time.Sleep(500 * time.Millisecond)
		}
	}
}

func main() {
	// Note: rand.Seed is deprecated in Go 1.20+ (it is auto-seeded)

	txPool := make(chan Transaction, 100)
	blockchain := NewBlockchain()
	var wg sync.WaitGroup

	// Start Miners
	wg.Add(3)
	go Node("Miner-1", blockchain, txPool, &wg)
	go Node("Miner-2", blockchain, txPool, &wg)
	go Node("Miner-3", blockchain, txPool, &wg)

	// Start Producer
	// We run this in the main routine or a separate one.
	// Here we separate it to demonstrate "Closing" the channel.
	go func() {
		for i := 1; i <= 100; i++ {
			tx := Transaction{ID: fmt.Sprintf("Tx-%d", i)}
			txPool <- tx
			// Random production speed
			time.Sleep(time.Duration(rand.Intn(100)) * time.Millisecond)
		}
		// Crucial: Close the channel to signal workers to stop
		close(txPool)
		fmt.Println("✅ All transactions submitted. Pool closed.")
	}()

	// Wait for all miners to finish draining the pool and shutting down
	wg.Wait()
	fmt.Println("Simulation Complete.")
}
