package com.unibuc.pao.lab9.ex02;

import com.unibuc.pao.lab9.ex01.Student;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class ExternalizationMain {


    public static void main(String[] args) throws Exception {
        // Create a new Student object
        StudentExternal student = new StudentExternal("1200613456789", "John Doe", 20, (short)1, (byte)2);
        System.out.println("Student: " + student);

        // Serialize the Student object to a file
        String filename = "C:\\Users\\oionescu\\OneDrive - ENDAVA\\Documents\\endava\\PAO\\pao-lab-2025\\lab09\\src\\com\\unibuc\\pao\\lab9\\ex01\\student.ser";

        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(filename))) {
            oos.writeObject(student);
        }

        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(filename))) {
            Object object = ois.readObject();
            if (object instanceof StudentExternal deserializedStudent) {
                System.out.println("Deserialized Student: " + deserializedStudent);
                System.out.println("Count:" + Student.getCount());
            } else {
                System.out.println("Object is not a Student");
            }
        }


    }
}
