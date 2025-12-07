package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

// Node reprezinta un nod din sistemul distribuit.
type Node struct {
	id       int        // ID unic al nodului
	value    int        // Valoare curenta
	decision int        // Decizia finala
	mutex    sync.Mutex // Mutex pentru acces sincronizat
}

// System reprezinta intregul sistem distribuit.
type System struct {
	nodes   []*Node       // Lista de noduri
	k       int           // Numarul minim de noduri care trebuie sa cada de acord
	timeout time.Duration // Timpul pentru un ciclu de consens
}

// NewSystem creeaza un nou sistem distribuit cu `n` noduri.
func NewSystem(n, k int, timeout time.Duration) *System {
	nodes := make([]*Node, n)
	for i := 0; i < n; i++ {
		nodes[i] = &Node{id: i, value: rand.Intn(100), decision: -1}
	}
	return &System{nodes: nodes, k: k, timeout: timeout}
}

// proposeValue simuleaza propunerea unei valori de catre un nod.
func (n *Node) proposeValue() int {
	n.mutex.Lock()
	defer n.mutex.Unlock()
	return n.value
}

// decideValue finalizeaza consensul pentru un nod.
func (n *Node) decideValue(value int) {
	n.mutex.Lock()
	defer n.mutex.Unlock()
	n.decision = value
}

// runConsensus executa ciclul de consens relaxat (k-consensus).
func (s *System) runConsensus() {
	var wg sync.WaitGroup
	for _, node := range s.nodes {
		wg.Add(1)
		go func(n *Node) {
			defer wg.Done()
			// Propunere: fiecare nod trimite o valoare.
			proposals := make([]int, len(s.nodes))
			for i, peer := range s.nodes {
				proposals[i] = peer.proposeValue()
			}

			// Calcul probabilistic pentru decizia finala
			finalDecision := s.calculateConsensus(proposals)
			n.decideValue(finalDecision)
		}(node)
	}
	wg.Wait()
}

// calculateConsensus determina consensul bazat pe un subset de valori (probabilistic/k).
func (s *System) calculateConsensus(proposals []int) int {
	// Alegem aleator `k` valori din propuneri pentru consens.
	rand.Seed(time.Now().UnixNano())
	selected := rand.Perm(len(proposals))[:s.k]
	sum := 0
	for _, idx := range selected {
		sum += proposals[idx]
	}
	return sum / s.k // Media valorilor selectate.
}

// printDecisions afiseaza deciziile finale ale nodurilor.
func (s *System) printDecisions() {
	for _, node := range s.nodes {
		fmt.Printf("Node %d: Final Decision = %d\n", node.id, node.decision)
	}
}

func main() {
	// Parametrii sistemului: 5 noduri, k = 3, timeout = 1 sec.
	system := NewSystem(5, 3, 1*time.Second)

	// Rulam ciclul de consens.
	fmt.Println("Starting k-consensus...")
	system.runConsensus()

	// Afisam rezultatele.
	fmt.Println("Consensus Results:")
	system.printDecisions()
}
