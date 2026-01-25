// fie urmatorul scenariu: 
// modelam un Blockchain 
// presupunem ca avem un pool de tranzactii 
// avem N noduri in paralel care vor sa valideze dintre tranzactiile respective 
// (5 tranzactii per node)
// fiecare nod valideaza trazactiile si le adauga intr-un block
// pe care apoi sa il lege de blockchain 
// nodurile simuleaza PoW (asteapta un maxim de 1000ms) (Thread.sleep() * Math.random())

// class Transaction - id 
// class Block - index, hash, previousHash 
// class Blockchain - List<Block>
// class Node - aici se intampla paralelismul 
// folosim LinkedBlockingQueue - structura de date concurenta 

import java.util.*;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.locks.ReentrantLock;

class Transaction {
    private String id;

    public Transaction(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }
}

class Block {
    private int index;
    private List<Transaction> transactions;
    private String previousHash;
    private String hash;

    public Block(int index, List<Transaction> transactions, String previousHash) {
        this.index = index;
        this.transactions = transactions;
        this.previousHash = previousHash;
        this.hash = computeHash();
    }

    private String computeHash() {
        return Integer.toHexString(Objects.hash(index, transactions, previousHash));
    }

    public String getHash() {
        return this.hash;
    }

    public String getPreviousHash() {
        return this.previousHash;
    }

    public int getIndex() {
        return this.index;
    }
}

class Blockchain {
    private List<Block> chain = new ArrayList<>();
    private ReentrantLock lock = new ReentrantLock();

    public Blockchain() {
        chain.add(new Block(0, new ArrayList<>(), "0"));
    }

    public void addBlock(Block block) {
        lock.lock();
        try {
            if (chain.get(chain.size() - 1).getHash().equals(block.getPreviousHash())) {
                chain.add(block);
                System.out.println("Block added: " + block.getIndex() + " with hash " + block.getHash());
            }
        } finally {
            lock.unlock();
        }
    }

    public Block getLastBlock() {
        return chain.get(chain.size() - 1);
    }
}

class Node implements Runnable {
    private Blockchain blockchain;
    private BlockingQueue<Transaction> transactionPool;
    private String nodeId;

    public Node(String nodeId, Blockchain blockchain, BlockingQueue<Transaction> transactionPool) {
        this.nodeId = nodeId;
        this.blockchain = blockchain;
        this.transactionPool = transactionPool;
    }

    @Override
    public void run() {
        while (true) {
            try {
                List<Transaction> transactions = new ArrayList<>();
                transactionPool.drainTo(transactions, 5);

                if (!transactions.isEmpty()) {
                    Block previousBlock = blockchain.getLastBlock();
                    Block newBlock = new Block(previousBlock.getIndex() + 1, transactions, previousBlock.getHash());

                    // simulam PoW
                    Thread.sleep((long) (Math.random() * 1000));

                    blockchain.addBlock(newBlock);
                } else {
                    System.out.println(nodeId + " found no transactions. Waiting...");
                    Thread.sleep(500);
                }
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }
}

public class BlockchainSimulation {
    public static void main(String[] args) {
        BlockingQueue<Transaction> transactionPool = new LinkedBlockingQueue<>();
        Blockchain blockchain = new Blockchain();

        Thread node1 = new Thread(new Node("Node 1", blockchain, transactionPool));
        Thread node2 = new Thread(new Node("Node 2", blockchain, transactionPool));
        Thread node3 = new Thread(new Node("Node 3", blockchain, transactionPool));

        node1.start();
        node2.start();
        node3.start();

        for (int i = 0; i < 100; i++) {
            System.out.println("Added transaction: " + i);
            transactionPool.add(new Transaction("Transaction " + i));

            try {
                Thread.sleep((long) Math.random() * 300);
            } catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }

        // node1.join();
        // node2.join();
        // node3.join();
    }
}

// nu mai folositi chatgpt E TOXIC multumesc