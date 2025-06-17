package com.unibuc.pao.lab7.ex5;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class FileInputOutputStreamMain {

    public static void main(String[] args) {

        File binaryFile = new File("lab07/src/com/unibuc/pao/lab7/ex5/binaryFile.bin");

        try (FileOutputStream fileOutputStream = new FileOutputStream(binaryFile)) {
          fileOutputStream.write("File data".getBytes());
        } catch (IOException e) {
            System.out.println("An error occurred while writing to the binary file: " + e.getMessage());
        }

        try (FileInputStream fileInputStream = new FileInputStream(binaryFile)) {
            byte[] bytes = fileInputStream.readAllBytes();
            System.out.println("File read successfully, read " + bytes.length + " bytes");
            System.out.println("File content: " + new String(bytes));
        } catch (IOException e) {
            System.out.println("An error occurred while reading from the binary file: " + e.getMessage());
        }

    }
}
