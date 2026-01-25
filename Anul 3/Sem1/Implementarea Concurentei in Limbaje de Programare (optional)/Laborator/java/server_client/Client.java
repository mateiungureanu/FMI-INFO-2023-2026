import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
// import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class Client {
    public static void main(String args[]) throws IOException {
        try (Socket socket = new Socket("localhost", 9090);
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                Scanner clientin = new Scanner(System.in)) {

            String message = clientin.nextLine();
            out.println(message);
            String response = in.readLine();
            System.out.println("From server: " + response);
        }
    }
}