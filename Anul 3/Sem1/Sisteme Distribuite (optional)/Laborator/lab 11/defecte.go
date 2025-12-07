package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Node reprezinta un nod intr-un sistem distribuit.
type Node struct {
	ID      int        // Identificator unic pentru nod
	IsAlive bool       // Indica daca nodul este activ
	mu      sync.Mutex // Mutex pentru a sincroniza accesul la starea nodului
	Channel chan bool  // Canal pentru monitorizarea starii nodului
}

// Cluster reprezinta un grup de noduri distribuite.
type Cluster struct {
	Nodes []*Node
	mu    sync.Mutex // Mutex pentru operatiuni asupra clusterului
}

// NewNode creeaza un nou nod activ.
func NewNode(id int) *Node {
	return &Node{
		ID:      id,
		IsAlive: true,
		Channel: make(chan bool, 1),
	}
}

// NewCluster creeaza un cluster de noduri.
func NewCluster(size int) *Cluster {
	cluster := &Cluster{}
	for i := 1; i <= size; i++ {
		cluster.Nodes = append(cluster.Nodes, NewNode(i))
	}
	return cluster
}

// SimulateFailure simuleaza defectarea unui nod dupa un timp aleator.
func (n *Node) SimulateFailure() {
	time.Sleep(time.Duration(rand.Intn(5)+1) * time.Second)
	n.mu.Lock()
	n.IsAlive = false
	n.mu.Unlock()
	fmt.Printf("Nodul %d a cazut!\n", n.ID)
	// Notificam canalul ca nodul a cazut
	n.Channel <- false
}

// MonitorNodes monitorizeaza toate nodurile din cluster pentru a detecta defectele.
func (c *Cluster) MonitorNodes() {
	for {
		c.mu.Lock()
		for _, node := range c.Nodes {
			go func(n *Node) {
				select {
				case status := <-n.Channel:
					if !status {
						fmt.Printf("Monitorizare: Nodul %d este defect!\n", n.ID)
					}
				case <-time.After(2 * time.Second): // Timeout daca nodul nu raspunde
					n.mu.Lock()
					if !n.IsAlive {
						fmt.Printf("Monitorizare: Timeout - Nodul %d nu raspunde.\n", n.ID)
					}
					n.mu.Unlock()
				}
			}(node)
		}
		c.mu.Unlock()
		time.Sleep(1 * time.Second) // Verificare periodica
	}
}

// RestartNode reporneste un nod defect.
func (n *Node) RestartNode() {
	n.mu.Lock()
	n.IsAlive = true
	n.mu.Unlock()
	fmt.Printf("Nodul %d a fost repornit!\n", n.ID)
	n.Channel <- true
}

func main() {
	rand.Seed(time.Now().UnixNano())

	// Cream un cluster cu 3 noduri
	cluster := NewCluster(3)

	// Pornim monitorizarea nodurilor in fundal
	go cluster.MonitorNodes()

	// Simulam defecte ale nodurilor
	for _, node := range cluster.Nodes {
		go node.SimulateFailure()
	}

	// Repornim un nod defect dupa cateva secunde
	time.Sleep(7 * time.Second)
	cluster.Nodes[0].RestartNode()

	// Asteptam pentru a permite monitorizarea si simularea sa se termine
	time.Sleep(5 * time.Second)
}
