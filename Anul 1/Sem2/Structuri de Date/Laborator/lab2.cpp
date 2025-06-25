#include <iostream>
#include <string>

using namespace std;


// pb1
struct Node {
    int key;
    Node* next;
};

struct SimplaInlantuita {
    Node* head;

    SimplaInlantuita() : head(nullptr) {}

    ~SimplaInlantuita() {
        Node* current = head;
        while (current != nullptr) {
            Node* temp = current;
            current = current->next;
            delete temp;
        }
    }

    [[nodiscard]] Node* search(int k) const {
        Node* current = head;
        while (current != nullptr) {
            if (current->key == k) {
                return current;
            }
            current = current->next;
        }
        return nullptr;
    }

    void insert(Node* x) {
        if (head == nullptr) {
            head = x;
            x->next = nullptr;
        } else {
            x->next = head;
            head = x;
        }
    }

    void deleteNode(Node* x) {
        if (x == nullptr || head == nullptr) {
            return;
        }
        if (x == head) {
            head = x->next;
            delete x;
            return;
        }
        Node* current = head;
        while (current->next != nullptr) {
            if (current->next == x) {
                current->next = x->next;
                delete x;
                return;
            }
            current = current->next;
        }
    }

    [[nodiscard]] Node* minimum() const {
        if (head == nullptr) {
            return nullptr;
        }
        Node* minNode = head;
        Node* current = head->next;
        while (current != nullptr) {
            if (current->key < minNode->key) {
                minNode = current;
            }
            current = current->next;
        }
        return minNode;
    }

    [[nodiscard]] Node* maximum() const {
        if (head == nullptr) {
            return nullptr;
        }
        Node* maxNode = head;
        Node* current = head->next;
        while (current != nullptr) {
            if (current->key > maxNode->key) {
                maxNode = current;
            }
            current = current->next;
        }
        return maxNode;
    }

    static Node* successor(Node* x) {
        return x != nullptr ? x->next : nullptr;
    }

    Node* predecessor(Node* x) const {
        if (x == nullptr || x == head) {
            return nullptr;
        }

        Node* current = head;
        while (current != nullptr && current->next != x) {
            current = current->next;
        }
        return current;
    }
};

int main()
{
    SimplaInlantuita linkedList;
    bool ok = true;
    int x, primul = 0;
    while (ok)
    {
        std::cin >> x;
        if (x == 0)
        {
            ok = false;
        }
        else
        {
            if (primul == 0)
            {
                primul = x;
            }
            linkedList.insert(new Node{x, nullptr});
        }
    }
    Node *node = linkedList.search(x);
    while(node != nullptr)
    {
        std::cout<<node->key<<" ";
        node = node->next;
    }
    linkedList.deleteNode(node);
    std::cout << "nod eliminat: " << primul;
    return 0;
}
///// am comentat liniile astea ca sa modific codul pentru problema 2 din test
//    linkedList.insert(new Node{5, nullptr});
//    linkedList.insert(new Node{10, nullptr});
//    linkedList.insert(new Node{3, nullptr});
//    linkedList.insert(new Node{8, nullptr});
//
//    Node* node = linkedList.search(3);
//    cout << "Search result: " << (node ? to_string(node->key) : "NIL") << endl;
//
//    Node* minNode = linkedList.minimum();
//    Node* maxNode = linkedList.maximum();
//    cout << "Minimum: " << (minNode ? to_string(minNode->key) : "NIL") << endl;
//    cout << "Maximum: " << (maxNode ? to_string(maxNode->key) : "NIL") << endl;
//
//    Node* successorNode = SimplaInlantuita::successor(node);
//    Node* predecessorNode = linkedList.predecessor(node);
//    cout << "Successor: " << (successorNode ? to_string(successorNode->key) : "NIL") << endl;
//    cout << "Predecessor: " << (predecessorNode ? to_string(predecessorNode->key) : "NIL") << endl;
//
//    linkedList.deleteNode(node);
//
//    return 0;
//}


/*
// pb2
struct Node {
    int key;
    Node* prev;
    Node* next;
};

struct DublaInlantuita {
    Node* head;
    Node* tail;

    DublaInlantuita() : head(nullptr), tail(nullptr) {}

    ~DublaInlantuita() {
        Node* current = head;
        while (current != nullptr) {
            Node* temp = current;
            current = current->next;
            delete temp;
        }
    }

    [[nodiscard]] Node* search(int k) const {
        Node* current = head;
        while (current != nullptr) {
            if (current->key == k) {
                return current;
            }
            current = current->next;
        }
        return nullptr;
    }

    void insert(Node* x) {
        if (head == nullptr) {
            head = x;
            tail = x;
            x->prev = nullptr;
            x->next = nullptr;
        } else {
            x->next = head;
            head->prev = x;
            head = x;
            x->prev = nullptr;
        }
    }

    void deleteNode(Node* x) {
        if (x == nullptr) {
            return;
        }
        if (x == head) {
            head = x->next;
        }
        if (x == tail) {
            tail = x->prev;
        }
        if (x->prev != nullptr) {
            x->prev->next = x->next;
        }
        if (x->next != nullptr) {
            x->next->prev = x->prev;
        }
        delete x;
    }

    [[nodiscard]] Node* minimum() const {
        if (head == nullptr)
            return nullptr;

        Node* minNode = head;
        Node* current = head->next;
        while (current != head && current != nullptr) {
            if (current->key < minNode->key)
                minNode = current;
            current = current->next;
        }
        return minNode;
    }

    [[nodiscard]] Node* maximum() const {
        if (head == nullptr)
            return nullptr;

        Node* maxNode = head;
        Node* current = head->next;
        while (current != head && current != nullptr) {
            if (current->key > maxNode->key)
                maxNode = current;
            current = current->next;
        }
        return maxNode;
    }

    static Node* successor(Node* x) {
        return x != nullptr ? x->next : nullptr;
    }

    static Node* predecessor(Node* x) {
        return x != nullptr ? x->prev : nullptr;
    }
};

int main() {
    DublaInlantuita linkedList;

    linkedList.insert(new Node{5, nullptr, nullptr});
    linkedList.insert(new Node{10, nullptr, nullptr});
    linkedList.insert(new Node{3, nullptr, nullptr});
    linkedList.insert(new Node{8, nullptr, nullptr});

    Node* node = linkedList.search(3);
    cout << "Search result: " << (node ? to_string(node->key) : "NIL") << endl;

    Node* minNode = linkedList.minimum();
    Node* maxNode = linkedList.maximum();
    cout << "Minimum: " << (minNode ? to_string(minNode->key) : "NIL") << endl;
    cout << "Maximum: " << (maxNode ? to_string(maxNode->key) : "NIL") << endl;

    Node* successorNode = DublaInlantuita::successor(node);
    Node* predecessorNode = DublaInlantuita::predecessor(node);
    cout << "Successor: " << (successorNode ? to_string(successorNode->key) : "NIL") << endl;
    cout << "Predecessor: " << (predecessorNode ? to_string(predecessorNode->key) : "NIL") << endl;

    linkedList.deleteNode(node);

    return 0;
}
*/

/*
// pb3
struct Node {
    int key;
    Node* prev;
    Node* next;

    explicit Node(int k) : key(k), prev(nullptr), next(nullptr) {}
};

struct CircularInlanuita {
    Node* head;

    CircularInlanuita() : head(nullptr) {}

    ~CircularInlanuita() {
        if (head == nullptr) return;

        Node* current = head;
        do {
            Node* temp = current;
            current = current->next;
            delete temp;
        } while (current != head);
    }

    [[nodiscard]] Node* search(int k) const {
        if (head == nullptr) return nullptr;

        Node* current = head;
        do {
            if (current->key == k) return current;
            current = current->next;
        } while (current != head);

        return nullptr;
    }

    void insert(Node* x) {
        if (head == nullptr) {
            head = x;
            head->next = head;
            head->prev = head;
        } else {
            x->next = head;
            x->prev = head->prev;
            head->prev->next = x;
            head->prev = x;
            head = x;
        }
    }

    void deleteNode(Node* x) {
        if (x == nullptr || head == nullptr) return;

        if (x == head) {
            if (head->next == head) {
                delete head;
                head = nullptr;
            } else {
                head->prev->next = head->next;
                head->next->prev = head->prev;
                Node* temp = head;
                head = head->next;
                delete temp;
            }
        } else {
            x->prev->next = x->next;
            x->next->prev = x->prev;
            delete x;
        }
    }

    [[nodiscard]] Node* minimum() const {
        if (head == nullptr) return nullptr;

        Node* minNode = head;
        Node* current = head->next;
        do {
            if (current->key < minNode->key) minNode = current;
            current = current->next;
        } while (current != head);

        return minNode;
    }

    [[nodiscard]] Node* maximum() const {
        if (head == nullptr) return nullptr;

        Node* maxNode = head;
        Node* current = head->next;
        do {
            if (current->key > maxNode->key) maxNode = current;
            current = current->next;
        } while (current != head);

        return maxNode;
    }

    Node* successor(Node* x) const {
        if (head == nullptr || x == nullptr) return nullptr;
        return x->next;
    }

    Node* predecessor(Node* x) const {
        if (head == nullptr || x == nullptr) return nullptr;
        return x->prev;
    }
};

int main() {
    CircularInlanuita linkedList;

    linkedList.insert(new Node(5));
    linkedList.insert(new Node(10));
    linkedList.insert(new Node(3));
    linkedList.insert(new Node(8));

    Node* node = linkedList.search(3);
    cout << "Search result: " << (node ? to_string(node->key) : "NIL") << endl;

    Node* minNode = linkedList.minimum();
    Node* maxNode = linkedList.maximum();
    cout << "Minimum: " << (minNode ? to_string(minNode->key) : "NIL") << endl;
    cout << "Maximum: " << (maxNode ? to_string(maxNode->key) : "NIL") << endl;

    Node* successorNode = linkedList.successor(node);
    Node* predecessorNode = linkedList.predecessor(node);
    cout << "Successor: " << (successorNode ? to_string(successorNode->key) : "NIL") << endl;
    cout << "Predecessor: " << (predecessorNode ? to_string(predecessorNode->key) : "NIL") << endl;

    linkedList.deleteNode(node);

    return 0;
}
*/