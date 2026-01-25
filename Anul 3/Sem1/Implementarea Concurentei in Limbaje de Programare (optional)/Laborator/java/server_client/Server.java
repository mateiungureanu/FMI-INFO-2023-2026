import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class Server {
    public static void main(String args[]) throws IOException {
        ServerSocket serverSocket = new ServerSocket(9090);
        System.out.println("Server is running.");
        Socket clientSocket = serverSocket.accept();
        System.out.println("Client connected!");
        BufferedReader in = new BufferedReader(new InputStreamReader(
                clientSocket
                        .getInputStream()));
        PrintWriter out = new PrintWriter(
                clientSocket
                        .getOutputStream(),
                true);
        String message = in.readLine();
        System.out.println("From client: " + message);
        out.println("Message received!");
        clientSocket.close();
        serverSocket.close();
    }
}