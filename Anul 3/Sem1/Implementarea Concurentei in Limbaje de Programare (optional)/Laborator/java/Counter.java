public class Counter {

    static int counter = 0;
    static int ITERATIONS = 1_000_000;
    static Object lock = new Object();

    // thread-safe (operatii atomice)
    public static void main(String[] args) throws InterruptedException {
        Thread myThread = new Thread(() -> {
            for (int i = 0; i < ITERATIONS; ++i) {
                synchronized (lock) {
                    counter++;
                }
            }

        });
        myThread.start();

        for (int i = 0; i < ITERATIONS; ++i) {
            synchronized (lock) {
                counter++;
            }
        }

        myThread.join();
    }
}