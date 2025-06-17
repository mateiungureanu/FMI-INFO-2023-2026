package com.unibuc.pao.lab13;

import java.io.*;
import java.net.*;

public class ServerSocketMain {

    public static void main(String[] args) {
        int port = 12345;
        try (ServerSocket serverSocket = new ServerSocket(port)) {
            System.out.println("Server is listening on port " + port);

            Socket socket = serverSocket.accept(); //wait for a client to connect
            System.out.println("Client connected");

            BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

            String receivedMessage;
            while ((receivedMessage = in.readLine()) != null) {
                System.out.println("Received: " + receivedMessage);
                out.println("I received: " + receivedMessage);
            }

            socket.close();
            System.out.println("Client disconnected");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

