public class ThreadBasics {
    public static void main(String[] args) throws InterruptedException {
        // try {
            System.out.println("Test");

            Thread myThread = new Thread(new MyThread());
            myThread.start();
            myThread.join();

            Thread anonThread = new Thread(() -> {
                // metoda run
                System.out.print("Anonymous Thread: " + Thread.currentThread().getId());
            });
            anonThread.start();
            anonThread.join();
        // } 
        // catch (InterruptedException e) {
        //     e.printStackTrace();
        // }
    }
}

class MyThread extends Thread {
    @Override
    public void run(){
        System.out.println("Thread: " + Thread.currentThread().getId());
    }
}

class MyThread2 implements Runnable {
    @Override
    public void run(){
        System.out.println("Thread: " + Thread.currentThread().getId());
    }
}

//  threadId in loc de getId in versiuni mai noi de java