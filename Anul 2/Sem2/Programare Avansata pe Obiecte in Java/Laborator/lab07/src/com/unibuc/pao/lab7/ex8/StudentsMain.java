package com.unibuc.pao.lab7.ex8;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class StudentsMain {

    public static void main(String[] args) {
        Student student1 = new Student("1201006890123", "John Doe", 24, (short) 1, (byte) 2);
        Student student2 = new Student("2210507890123", "Jane Doe", 23, (short) 2, (byte) 3);
        Student student3 = new Student("2220307890123", "George Doe", 22, (short) 2, (byte) 1);
        List<Student> students = List.of(student1, student2, student3);
        List<Student> studentsRead = new ArrayList<>();

        File binaryFile = new File("lab07/src/com/unibuc/pao/lab7/ex8/studentsFile.bin");

        try (DataOutputStream dataOutputStream = new DataOutputStream(new FileOutputStream(binaryFile))) {

            for (Student student : students) {
                dataOutputStream.writeUTF(student.getCnp());
                dataOutputStream.writeUTF(student.getName());
                dataOutputStream.writeInt(student.getAge());
                dataOutputStream.writeShort(student.getGroup());
                dataOutputStream.writeByte(student.getStudyYear());
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (DataInputStream dataInputStream = new DataInputStream(new FileInputStream(binaryFile))) {
            for (int i = 0; i < students.size(); i++) {
                studentsRead.add(readStudent(dataInputStream));
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        System.out.println("Students read from file: " + studentsRead);
//        for (Student student : studentsRead) {
//            System.out.println(student);
//        }
    }

    private static Student readStudent(DataInputStream dataInputStream) throws IOException {
        String cnp = dataInputStream.readUTF();
        String name = dataInputStream.readUTF();
        int age = dataInputStream.readInt();
        short group = dataInputStream.readShort();
        byte studyYear = dataInputStream.readByte();

        return new Student(cnp, name, age, group, studyYear);
    }
}
