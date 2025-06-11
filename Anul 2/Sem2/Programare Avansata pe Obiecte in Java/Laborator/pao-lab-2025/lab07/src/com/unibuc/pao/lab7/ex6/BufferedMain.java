package com.unibuc.pao.lab7.ex6;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class BufferedMain {

    public static void main(String[] args) {

        File textFile = new File("lab07/src/com/unibuc/pao/lab7/ex6/textFile.txt");
        try (BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(textFile))) {
            bufferedWriter.append("First line of text\n");
            bufferedWriter.append("Second line of text");
            System.out.println("File written successfully");
        } catch (IOException e) {
            System.out.println("An error occurred while writing to the buffered file: " + e.getMessage());
        }

        try(BufferedReader bufferedReader = new BufferedReader(new FileReader(textFile))) {
            String firstLine = bufferedReader.readLine();
            String secondLine = bufferedReader.readLine();
            System.out.println("File read successfully");
            System.out.println("First line: " + firstLine);
            System.out.println("Second line: " + secondLine);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
