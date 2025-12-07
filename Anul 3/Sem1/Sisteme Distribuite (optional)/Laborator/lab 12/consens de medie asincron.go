package main

import (
	"fmt"
	"math/rand"
	"sync"
)

// Node reprezinta un nod din sistemul distribuit.
type Node struct {
	id        int        // ID unic al nodului
	value     float64    // Valoarea curenta a nodului
	neighbors []*Node    // Vecinii nodului
	mutex     sync.Mutex // Mutex pentru sincronizare
}

// System reprezinta sistemul distribuit.
type System struct {
	nodes []*Node // Lista de noduri
	steps int     // Numarul de iteratii pentru algoritm
}

// NewSystem creeaza un sistem distribuit cu `n` noduri si conexiuni aleatorii.
func NewSystem(n int, steps int) *System {
	nodes := make([]*Node, n)
	for i := 0; i < n; i++ {
		nodes[i] = &Node{
			id:    i,
			value: rand.Float64() * 100, // Valoare initiala aleatoare
		}
	}

	// Configuram vecinii aleatori pentru fiecare nod
	for _, node := range nodes {
		for _, potentialNeighbor := range nodes {
			if node != potentialNeighbor && rand.Float64() < 0.5 { // 50% probabilitate de a conecta
				node.neighbors = append(node.neighbors, potentialNeighbor)
			}
		}
	}

	return &System{nodes: nodes, steps: steps}
}

// updateValue actualizeaza valoarea unui nod pe baza vecinilor sai.
func (n *Node) updateValue(wg *sync.WaitGroup) {
	defer wg.Done()

	n.mutex.Lock()
	defer n.mutex.Unlock()

	// Calculeaza noua valoare ca media valorilor vecinilor
	var sum float64
	for _, neighbor := range n.neighbors {
		neighbor.mutex.Lock()
		sum += neighbor.value
		neighbor.mutex.Unlock()
	}

	if len(n.neighbors) > 0 {
		sum += n.value // Include valoarea proprie
		n.value = sum / float64(len(n.neighbors)+1)
	}
}

// runConsensus executa algoritmul de consens de medie asincron.
func (s *System) runConsensus() {
	for step := 0; step < s.steps; step++ {
		var wg sync.WaitGroup
		for _, node := range s.nodes {
			wg.Add(1)
			go node.updateValue(&wg) // Fiecare nod isi actualizeaza valoarea asincron
		}
		wg.Wait() // Asteptam toate nodurile sa-si finalizeze actualizarea
		fmt.Printf("Step %d completed\n", step+1)
		s.printValues()
	}
}

// printValues afiseaza valorile curente ale nodurilor.
func (s *System) printValues() {
	for _, node := range s.nodes {
		fmt.Printf("Node %d: Value = %.2f\n", node.id, node.value)
	}
	fmt.Println()
}

func main() {
	// Initializam sistemul cu 5 noduri si 10 pasi de consens.
	system := NewSystem(5, 10)

	// Afisam valorile initiale ale nodurilor.
	fmt.Println("Initial Values:")
	system.printValues()

	// Rulam algoritmul de consens de medie asincron.
	fmt.Println("Starting Averaging Consensus...")
	system.runConsensus()

	// Afisam valorile finale ale nodurilor.
	fmt.Println("Final Values:")
	system.printValues()
}
