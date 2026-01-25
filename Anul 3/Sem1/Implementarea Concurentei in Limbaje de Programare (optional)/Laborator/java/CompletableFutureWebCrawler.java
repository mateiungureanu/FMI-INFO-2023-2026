// utilizand CompletableFuture, implementati un program care
// acceseaza fmi.unibuc.ro si afiseaza urmatoarele:
// anunturi secretariat, noutati, anunturi doctorat

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Callable;

public class CompletableFutureWebCrawler {
    public static void main(String[] args) {
        List<String> urls = List.of(
                "https://fmi.unibuc.ro/category/anunturi-secretariat/",
                "https://fmi.unibuc.ro/category/noutati/",
                "https://fmi.unibuc.ro/category/anunturi-doctorat/");

        List<CompletableFuture<String>> futures = urls.stream()
                .map(url -> CompletableFuture.supplyAsync(() -> {
                    CrawlerTask task = new CrawlerTask(url);
                    return task.call();
                }))
                .toList();

        CompletableFuture<Void> allFutures = CompletableFuture.allOf(
                futures.toArray(new CompletableFuture[0]));

        allFutures.thenRun(() -> {
            System.out.println("All tasks completed!");
            futures.forEach(future -> {
                try {
                    String content = future.get();
                    System.out.println(content);
                    System.out.println("=".repeat(80));
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            });
        });

        System.out.println("Main thread continues...");
        allFutures.join();
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
            System.out.println("Accessing " + url);

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
            } else {
                content.append("Cannot access this page: " + status);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return content.toString();
    }
}