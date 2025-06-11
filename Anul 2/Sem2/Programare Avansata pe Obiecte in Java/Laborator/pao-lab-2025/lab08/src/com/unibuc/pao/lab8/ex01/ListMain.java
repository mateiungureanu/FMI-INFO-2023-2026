package com.unibuc.pao.lab8.ex01;

import com.unibuc.pao.lab7.ex8.Student;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

public class ListMain {

    public static void main(String[] args) {

        Student student1 = new Student("1234567890123", "John Doe", 20, (short) 1, (byte) 1);
        Student student1Again = new Student("1234567890123", "John Doe", 20, (short) 1, (byte) 1);
        Student student2 = new Student("1234567890124", "Jane Doe", 20, (short) 1, (byte) 1);
        Student student3 = new Student("1204567890124", "George White", 20, (short) 1, (byte) 1);

        vectorMethods(student1, student2);

        arrayListMethods(student1, student2, student1Again);

        linkedListMethods(student1, student1Again, student2, student3);

    }

    private static void linkedListMethods(Student student1, Student student1Again, Student student2, Student student3) {
        LinkedList<Student> linkedList = new LinkedList<>();

        linkedList.addFirst(student1);
        linkedList.addLast(student1Again);
        linkedList.addLast(student2);
        linkedList.add(3, student1);

        linkedList.offer(student3);
        System.out.println("Students in the linked list:" + linkedList);

        Student peeked = linkedList.peek();
        System.out.println("Peeked student: " + peeked);
        System.out.println("Students in the linked list:" + linkedList);

        linkedList.poll();
        System.out.println("Students in the linked list:" + linkedList);

        linkedList.pop();
        System.out.println("Students in the linked list:" + linkedList);

        linkedList.forEach(student -> System.out.println("Student: " + student));

        linkedList.descendingIterator().forEachRemaining(student -> System.out.println("Student: " + student));

        linkedList.set(1, student2);

        linkedList.forEach(student -> System.out.println("\nStudent: " + student));

        List<Student> johnDoes = linkedList.stream().filter(student -> student.getName().equals("Jane Doe")).toList();

        for (Student student : linkedList) {
            System.out.println("Student: " + student);
            //linkedList.add(new Student("12345678956753", "Jill White", 20, (short) 1, (byte) 1)); // causes ConcurrentModificationException to be thrown
            //  linkedList.remove(student2);
        }

        johnDoes.forEach(student -> System.out.println("\n Jane Doe Student: " + student));
    }

    private static void arrayListMethods(Student student1, Student student2, Student student1Again) {
        List<Student> students = new ArrayList<>();
        students.add(student1);
        students.add(student2);

        System.out.println("\nStudents in the list:" + students);
        System.out.println("Size of ArrayList: " + students.size());

        System.out.println("Index of student1: " + students.indexOf(student1Again));

        System.out.println("Student2: " + students.get(1));

        students.remove(student1Again);
        System.out.println("Students in the list:" + students);
    }

    private static void vectorMethods(Student student1, Student student2) {
        Vector<Student> students = new Vector<>();
        students.add(student1);
        students.addFirst(student2);

        System.out.println("\nStudents in the list:" + students);

        Iterator<Student> iterator = students.iterator();

        iterator.forEachRemaining(student -> {
            System.out.println("Student: " + student);
        });

        students.set(0, null);

        iterator = students.iterator();
        while (iterator.hasNext()) {
            Student student = iterator.next();
            System.out.println("Student: " + student);
            // students.add(new Student("12345678956753", "Jill White", 20, (short) 1, (byte) 1)); // causes ConcurrentModificationException to be thrown
        }

    }
}
