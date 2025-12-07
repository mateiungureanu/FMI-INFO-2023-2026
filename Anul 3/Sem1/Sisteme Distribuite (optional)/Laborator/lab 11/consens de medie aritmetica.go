package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Node reprezinta un nod intr-un sistem distribuit.
type Node struct {
	ID        int     // Identificator unic
	Value     float64 // Valoarea curenta a nodului
	Neighbors []*Node // Vecinii nodului
	mu        sync.Mutex
}

// Cluster reprezinta un grup de noduri distribuite.
type Cluster struct {
	Nodes []*Node
	mu    sync.Mutex
}

// NewNode creeaza un nod cu o valoare initiala aleatorie.
func NewNode(id int) *Node {
	rand.Seed(time.Now().UnixNano() + int64(id))
	return &Node{
		ID:        id,
		Value:     rand.Float64() * 100, // Valoare initiala intre 0 si 100
		Neighbors: []*Node{},
	}
}

// NewCluster creeaza un cluster cu noduri distribuite.
func NewCluster(size int) *Cluster {
	cluster := &Cluster{}
	for i := 1; i <= size; i++ {
		cluster.Nodes = append(cluster.Nodes, NewNode(i))
	}
	return cluster
}

// ConnectNodes stabileste conexiuni intre noduri, simuland o retea distribuita.
func (c *Cluster) ConnectNodes() {
	for _, node := range c.Nodes {
		for _, neighbor := range c.Nodes {
			if node.ID != neighbor.ID {
				node.Neighbors = append(node.Neighbors, neighbor)
			}
		}
	}
}

// UpdateValue calculeaza noua valoare a nodului bazata pe valorile vecinilor.
func (n *Node) UpdateValue() {
	n.mu.Lock()
	defer n.mu.Unlock()

	sum := n.Value
	count := 1

	for _, neighbor := range n.Neighbors {
		neighbor.mu.Lock()
		sum += neighbor.Value
		count++
		neighbor.mu.Unlock()
	}

	newValue := sum / float64(count)
	n.Value = newValue
}

// PerformConsensus executa iterativ actualizarile pentru a ajunge la consens.
func (c *Cluster) PerformConsensus(iterations int) {
	for i := 0; i < iterations; i++ {
		fmt.Printf("\n=== Iteratia %d ===\n", i+1)
		var wg sync.WaitGroup

		// Actualizam valoarea fiecarui nod concurent
		for _, node := range c.Nodes {
			wg.Add(1)
			go func(n *Node) {
				defer wg.Done()
				n.UpdateValue()
			}(node)
		}

		wg.Wait()

		// Afisam valorile actualizate ale nodurilor
		c.PrintClusterStatus()
	}
}

// PrintClusterStatus afiseaza valorile curente ale nodurilor din cluster.
func (c *Cluster) PrintClusterStatus() {
	c.mu.Lock()
	defer c.mu.Unlock()

	fmt.Println("Valori noduri:")
	for _, node := range c.Nodes {
		fmt.Printf("Nod %d: %.2f\n", node.ID, node.Value)
	}
}

func main() {
	// Initializam un cluster cu 5 noduri
	cluster := NewCluster(5)

	// Conectam nodurile intre ele
	cluster.ConnectNodes()

	// Afisam valorile initiale ale nodurilor
	fmt.Println("Valori initiale ale nodurilor:")
	cluster.PrintClusterStatus()

	// Executam consensul timp de 10 iterari
	fmt.Println("\n=== inceperea consensului ===")
	cluster.PerformConsensus(10)
}
