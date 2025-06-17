package com.unibuc.pao.lab7.ex7;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

public class BufferedStreamMain {

    public static void main(String[] args) {

        File binaryFile = new File("lab07/src/com/unibuc/pao/lab7/ex7/binaryFile.bin");

        try (BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(binaryFile))) {
            String data = "Buffered file data\n";
            String data2 = "Other buffered file data";
            bufferedOutputStream.write(data.getBytes());
            bufferedOutputStream.write(data2.getBytes());
            System.out.println("Buffered file written successfully");

        } catch (Exception e) {
            System.out.println("An error occurred while writing to the buffered file: " + e.getMessage());
        }

        try (BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(binaryFile))) {
            byte[] bytes = bufferedInputStream.readAllBytes();
            System.out.println("Buffered file read successfully, read " + bytes.length + " bytes");
            System.out.println("Buffered file content: " + new String(bytes));
        } catch (Exception e) {
            System.out.println("An error occurred while reading from the buffered file: " + e.getMessage());
        }
    }
}
