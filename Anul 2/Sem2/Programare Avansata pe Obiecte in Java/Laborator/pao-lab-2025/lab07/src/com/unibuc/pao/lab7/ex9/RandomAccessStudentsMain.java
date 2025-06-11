package com.unibuc.pao.lab7.ex9;

import com.unibuc.pao.lab7.ex8.Student;

import java.io.DataInput;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.ArrayList;
import java.util.List;

public class RandomAccessStudentsMain {

    public static void main(String[] args) {
        Student student1 = new Student("1201006890123", "John Doe", 24, (short) 1, (byte) 2);
        Student student2 = new Student("2210507890123", "Jane Doe", 23, (short) 2, (byte) 3);
        Student student3 = new Student("2220307890123", "George Doe", 22, (short) 2, (byte) 1);
        List<Student> students = List.of(student1, student2, student3);
        List<Student> studentsRead = new ArrayList<>();

        File binaryFile = new File("lab07/src/com/unibuc/pao/lab7/ex9/studentsFile.bin");

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

        try (RandomAccessFile randomAccessFile = new RandomAccessFile(binaryFile, "rw")) {

            readStudent(randomAccessFile);
            Student newStudent = new Student("1234567890123", "John Gre", 20, (short) 3, (byte) 3);
            randomAccessFile.writeUTF(newStudent.getCnp());
            randomAccessFile.writeUTF(newStudent.getName());
            randomAccessFile.writeInt(newStudent.getAge());
            randomAccessFile.writeShort(newStudent.getGroup());
            randomAccessFile.writeByte(newStudent.getStudyYear());

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
    }

    private static Student readStudent(DataInput randomAccessFile) throws IOException {
        String cnp = randomAccessFile.readUTF();
        String name = randomAccessFile.readUTF();
        int age = randomAccessFile.readInt();
        short group = randomAccessFile.readShort();
        byte studyYear = randomAccessFile.readByte();

        return new Student(cnp, name, age, group, studyYear);
    }
}
