import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

public class FutureTaskWebCrawler {
    public static void main(String[] args) {
        List<String> urls = List.of(
            "https://google.com",
            "https://jsonplaceholder.typicode.com/posts/1",
            "https://jsonplaceholder.typicode.com/posts/2",
            "https://jsonplaceholder.typicode.com/posts/3"
        );

        List<FutureTask<String>> futureTasks = new ArrayList<>();

        for (String url : urls) {
            Callable<String> task = new CrawlerTask(url);
            FutureTask<String> futureTask = new FutureTask<>(task);
            futureTasks.add(futureTask);

            Thread thread = new Thread(futureTask);
            thread.start();
        }

        for (FutureTask<String> futureTask : futureTasks) {
            try {
                String content = futureTask.get();
                System.out.println(content);
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}

class CrawlerTask implements Callable<String> {
    private String url;

    public CrawlerTask(String url) {
        this.url = url;
    }

    @Override
    public String call() {
        StringBuilder content = new StringBuilder();

        try {
            System.out.println("Accesing " + url);

            HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("GET");
            connection.setReadTimeout(5000);
            connection.setConnectTimeout(5000);

            int status = connection.getResponseCode();

            if (status == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line;
                while ((line = reader.readLine()) != null) {
                    content.append(line).append("\n");
                }
                reader.close();
            }
            else {
                content.append("Cannot access this page: " + status);
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }

        return content.toString();
    }
}