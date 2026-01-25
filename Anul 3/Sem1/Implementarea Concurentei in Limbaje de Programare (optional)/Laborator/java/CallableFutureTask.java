import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

public class CallableFutureTask {
    public static void main(String[] args) {
        Callable<String> task = new MyTask();

        // sau cu lambda
        // Callable<String> task = () -> {
        //     Thread.sleep(50000);
        //     return "Task completed";
        // };

        FutureTask<String> futureTask = new FutureTask<>(task);

        Thread thread = new Thread(futureTask);
        thread.start();

        try {
            System.out.println("Main...");
            String result = futureTask.get();
            System.out.println("Result: " + result);
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}

class MyTask implements Callable<String> {
    @Override
    public String call() {
        try {
            Thread.sleep(5000);
            return "Task completed";
        }
        catch (InterruptedException ex) {
            ex.printStackTrace();
            return "Error";
        }
    }
}