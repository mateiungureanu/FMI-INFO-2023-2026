// modelam scenariul Reader-Writer 
// avem un singur Writer care poate scrie la un moment de timp in zona critica de memorie
// dar putem avea mai multi Readeri simultan 
 
// avem doua semafoare - unul pt a gestiona ce rol are acces
// respectiv unul pentru sincronizarea operatiilor pe readeri 
 
import java.util.concurrent.Semaphore;
 
// trebuie sa tinem minte numarul de Readeri 
// ReaderCounter.inc() // ReaderCounter.dec() // ReaderCounter.get() 
class ReaderCounter {
    private static int count = 0; 
 
    public static int get() {
        return count;
    }
 
    public static void inc() {
        count++;
    }
 
    public static void dec() {
        count--;
    }
}
 
class Writer implements Runnable {
    private Semaphore wrt; 
 
    public Writer(Semaphore wrt) {
        this.wrt = wrt; 
    }
 
    @Override
    public void run() {
        while(true) {
            try {
                wrt.acquire();
 
                System.out.println(Thread.currentThread().getName() + " writes...");
                Thread.sleep(3000);
                wrt.release();
                Thread.sleep(3000);
            }
            catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }
}
 
class Reader implements Runnable {
    private Semaphore wrt;
    private Semaphore mutex; 
 
    public Reader(Semaphore wrt, Semaphore mutex) {
        this.wrt = wrt;
        this.mutex = mutex;
    }
 
    @Override 
    public void run() {
        while(true) {
            try {
 
                mutex.acquire();
                ReaderCounter.inc();
 
                if (ReaderCounter.get() == 1) {
                    wrt.acquire();
                }
 
                mutex.release();
 
                System.out.println(Thread.currentThread().getName() + " reads...");
                Thread.sleep(1000);
 
                mutex.acquire();
                ReaderCounter.dec();
 
                if (ReaderCounter.get() == 0) {
                    wrt.release();
                }
 
                mutex.release();
            }
            catch (InterruptedException ex) {
                ex.printStackTrace();
            }
        }
    }
}
 
 
 
public class ReaderWriter {
    public static void main(String[] args) {
        Semaphore wrt = new Semaphore(1);
        Semaphore mutex = new Semaphore(1);
        (new Thread(new Writer(wrt))).start();
        (new Thread(new Writer(wrt))).start();
 
        (new Thread(new Reader(wrt, mutex))).start();
        (new Thread(new Reader(wrt, mutex))).start();
        (new Thread(new Reader(wrt, mutex))).start();
        (new Thread(new Reader(wrt, mutex))).start();
        (new Thread(new Reader(wrt, mutex))).start();
        (new Thread(new Reader(wrt, mutex))).start();
 
 
 
    }
}