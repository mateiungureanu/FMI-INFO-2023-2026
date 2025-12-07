package main

import (
	"fmt"
	"sync"
	"time"
)

// Node reprezinta un nod dintr-un sistem distribuit, care utilizeaza un ceas logic.
type Node struct {
	ID      int          // Identificator unic pentru nod
	Clock   int          // Ceasul logic al nodului
	Channel chan Message // Canal pentru a primi mesaje
	mu      sync.Mutex   // Mutex pentru sincronizare
}

// Message reprezinta un mesaj trimis intre noduri.
type Message struct {
	SenderID int // ID-ul nodului care a trimis mesajul
	Clock    int // Valoarea ceasului logic la momentul trimiterii
	Content  string
}

// NewNode creeaza un nou nod distribuit.
func NewNode(id int) *Node {
	return &Node{
		ID:      id,
		Clock:   0,
		Channel: make(chan Message, 10),
	}
}

// IncrementClock incrementeaza ceasul logic al nodului.
func (n *Node) IncrementClock() {
	n.mu.Lock()
	defer n.mu.Unlock()
	n.Clock++
}

// UpdateClock actualizeaza ceasul logic pe baza ceasului primit.
func (n *Node) UpdateClock(receivedClock int) {
	n.mu.Lock()
	defer n.mu.Unlock()
	if n.Clock < receivedClock {
		n.Clock = receivedClock
	}
	n.Clock++ // Incrementam ceasul pentru evenimentul curent.
}

// SendMessage trimite un mesaj catre un alt nod.
func (n *Node) SendMessage(target *Node, content string) {
	n.IncrementClock() // Incrementam ceasul inainte de a trimite mesajul.
	msg := Message{
		SenderID: n.ID,
		Clock:    n.Clock,
		Content:  content,
	}
	fmt.Printf("Nodul %d trimite mesaj: '%s' (ceas: %d) catre nodul %d\n", n.ID, content, n.Clock, target.ID)
	target.Channel <- msg
}

// ReceiveMessage proceseaza mesajele primite.
func (n *Node) ReceiveMessage() {
	for msg := range n.Channel {
		fmt.Printf("Nodul %d primeste mesaj: '%s' (ceas: %d) de la nodul %d\n", n.ID, msg.Content, msg.Clock, msg.SenderID)
		n.UpdateClock(msg.Clock) // Actualizam ceasul logic pe baza mesajului primit.
		fmt.Printf("Ceasul actualizat al nodului %d: %d\n", n.ID, n.Clock)
	}
}

func main() {
	// Cream doua noduri
	nodeA := NewNode(1)
	nodeB := NewNode(2)

	// Pornim procesul de primire a mesajelor in goroutines separate.
	go nodeA.ReceiveMessage()
	go nodeB.ReceiveMessage()

	// Simulam trimiterea mesajelor.
	time.Sleep(1 * time.Second) // Pauza pentru a permite initializarea.

	nodeA.SendMessage(nodeB, "Salut de la A!")
	time.Sleep(500 * time.Millisecond) // Pauza pentru a simula latenta.

	nodeB.SendMessage(nodeA, "Salut de la B!")
	time.Sleep(500 * time.Millisecond)

	nodeA.SendMessage(nodeB, "Cum merge?")
	time.Sleep(500 * time.Millisecond)

	nodeB.SendMessage(nodeA, "Bine, tu?")
	time.Sleep(500 * time.Millisecond)

	// inchidem canalele dupa ce toate mesajele au fost procesate.
	close(nodeA.Channel)
	close(nodeB.Channel)
}
