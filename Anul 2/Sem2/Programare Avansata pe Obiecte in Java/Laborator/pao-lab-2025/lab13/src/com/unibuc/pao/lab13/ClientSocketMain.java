package com.unibuc.pao.lab13;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClientSocketMain {

        public static void main(String[] args) throws Exception {
            String hostname = "localhost";
            int port = 12345;

            try (Socket socket = new Socket(hostname, port)) {
                BufferedReader userInput = new BufferedReader(new InputStreamReader(System.in));
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

                System.out.println("Connected to server. Type something:");

                String input;
                while ((input = userInput.readLine()) != null) {
                    out.println(input);
                    String response = in.readLine();
                    System.out.println("Server says: " + response);
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
