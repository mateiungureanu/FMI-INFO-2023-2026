package com.unibuc.pao.lab7.ex4;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class FileWriterReaderMain {

    public static void main(String[] args) {
        File file = new File("lab07/src/com/unibuc/pao/lab7/ex4/file.txt");

        if (!file.exists()) {
            try {
                boolean created = file.createNewFile();
                System.out.println("File was " + (created? "created" : "not created") + ": " + file.getAbsolutePath());
            } catch (IOException e) {
                System.out.println("Could not create file: " + file.getAbsolutePath());
                throw new RuntimeException(e);
            }
        }

        try (FileWriter fileWriter = new FileWriter(file)) {
            fileWriter.write("File data");
            System.out.println("File written successfully");
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (FileReader fileReader = new FileReader(file)) {
            char[] fileContent = new char[100];
            int charsRead = fileReader.read(fileContent);
            System.out.println("File read successfully, read " + charsRead + " characters");
            System.out.println("File content: " + new String(fileContent, 0, charsRead));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}

