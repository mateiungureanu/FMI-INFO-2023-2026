package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Node reprezinta un nod intr-un sistem distribuit.
type Node struct {
	ID       int  // Identificator unic pentru nod
	IsAlive  bool // Indica daca nodul este activ
	IsLeader bool // Indica daca nodul este lider
}

// Cluster reprezinta un grup de noduri.
type Cluster struct {
	Nodes []*Node
	mu    sync.Mutex // Mutex pentru operatiuni concurente
}

// NewCluster initializeaza un cluster cu noduri.
func NewCluster(size int) *Cluster {
	nodes := make([]*Node, size)
	for i := 0; i < size; i++ {
		nodes[i] = &Node{ID: i + 1, IsAlive: true, IsLeader: false}
	}
	return &Cluster{Nodes: nodes}
}

// ElectLeader implementeaza algoritmul de alegere a liderului folosind Bully.
func (c *Cluster) ElectLeader() {
	c.mu.Lock()
	defer c.mu.Unlock()

	// Filtram nodurile active
	var activeNodes []*Node
	for _, node := range c.Nodes {
		if node.IsAlive {
			activeNodes = append(activeNodes, node)
		}
	}

	if len(activeNodes) == 0 {
		fmt.Println("Nu exista noduri active in cluster.")
		return
	}

	// Alegem liderul cu cel mai mare ID
	leader := activeNodes[0]
	for _, node := range activeNodes {
		if node.ID > leader.ID {
			leader = node
		}
	}

	// Marcam nodul ca lider
	for _, node := range c.Nodes {
		node.IsLeader = (node.ID == leader.ID)
	}

	fmt.Printf("Nodul %d a fost ales lider.\n", leader.ID)
}

// FailNode marcheaza un nod ca fiind inactiv.
func (c *Cluster) FailNode(nodeID int) {
	c.mu.Lock()
	defer c.mu.Unlock()

	for _, node := range c.Nodes {
		if node.ID == nodeID {
			node.IsAlive = false
			fmt.Printf("Nodul %d a fost dezactivat.\n", node.ID)
			break
		}
	}
}

// PrintStatus afiseaza starea actuala a clusterului.
func (c *Cluster) PrintStatus() {
	c.mu.Lock()
	defer c.mu.Unlock()

	fmt.Println("Starea clusterului:")
	for _, node := range c.Nodes {
		status := "inactiv"
		if node.IsAlive {
			status = "activ"
		}
		role := ""
		if node.IsLeader {
			role = "(Lider)"
		}
		fmt.Printf("Nod %d: %s %s\n", node.ID, status, role)
	}
}

func main() {
	// Initializam clusterul cu 5 noduri
	cluster := NewCluster(5)

	// Alegem liderul initial
	cluster.ElectLeader()
	cluster.PrintStatus()

	// Simulam esecul unui nod
	time.Sleep(2 * time.Second)
	cluster.FailNode(5)

	// Alegem din nou liderul
	time.Sleep(2 * time.Second)
	cluster.ElectLeader()
	cluster.PrintStatus()

	// Adaugam latente aleatorii pentru a simula un mediu distribuit
	rand.Seed(time.Now().UnixNano())
	time.Sleep(time.Duration(rand.Intn(3000)) * time.Millisecond)
}
