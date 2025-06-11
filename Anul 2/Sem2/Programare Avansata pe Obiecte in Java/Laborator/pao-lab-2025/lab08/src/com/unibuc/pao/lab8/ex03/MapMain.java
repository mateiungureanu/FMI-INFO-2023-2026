package com.unibuc.pao.lab8.ex03;

import com.unibuc.pao.lab7.ex8.Student;

import java.util.HashMap;
import java.util.Hashtable;
import java.util.TreeMap;

public class MapMain {

    public static void main(String[] args) {

        hashtableMethods();

        hashMapMethods();

        treeMapMethods();

    }

    private static void treeMapMethods() {
        Student student1 = new Student("1234567890123", "John Doe", 23, (short) 1, (byte) 1);
        Student student2 = new Student("1204567890123", "Jane Doe", 23, (short) 1, (byte) 1);
        TreeMap<String, Student> treeMap = new TreeMap<>();

        treeMap.put("1234567890123", student1);
        treeMap.put("1204567890123", student2);

        System.out.println("TreeMap: " + treeMap);


        TreeMap<Student, String> treeMap2 = new TreeMap<>((studentOne, studentTwo) -> {
            if (studentOne.getCnp().equals(studentTwo.getCnp())) {
                return 0;
            } else if (studentOne.getCnp().compareTo(studentTwo.getCnp()) < 0) {
                return -1;
            } else {
                return 1;
            }
        });

        treeMap2.put(student1, "1234567890123");
        treeMap2.put(student2, "1204567890123");

        System.out.println("TreeMap: " + treeMap2);
    }

    private static void hashMapMethods() {
        HashMap<String, Student> hashMap = new HashMap<>();

        hashMap.put("1234567890123", new Student("1234567890123", "John Doe", 23, (short) 1, (byte) 1));
        hashMap.put("1204567890123", new Student("1204567890123", "Jane Doe", 23, (short) 1, (byte) 1));
        hashMap.put(null, new Student("1204567890123", "No name", 23, (short) 1, (byte) 1));

        Student student2 = hashMap.get("1234567890123");

        hashMap.forEach((key, value) -> System.out.println(value));

        hashMap.entrySet().forEach(entry ->
                System.out.println("Key: " + entry.getKey() + ", Value: " + entry.getValue())
        );

        hashMap.keySet().forEach(key ->
                System.out.println("Key: " + key)
        );

        hashMap.values().forEach(value -> System.out.println(value));
    }

    private static void hashtableMethods() {
        Hashtable<String, Student> hashtable = new Hashtable<>();


        hashtable.put("1234567890123", new Student("1234567890123", "John Doe", 23, (short) 1, (byte) 1));
        hashtable.put("1204567890123", new Student("1204567890123", "Jane Doe", 23, (short) 1, (byte) 1));

        Student student = hashtable.get("1234567890123");

        hashtable.forEach((key, value) -> System.out.println(value));

        hashtable.entrySet().forEach(entry ->
                System.out.println("Key: " + entry.getKey() + ", Value: " + entry.getValue())
        );

        hashtable.keySet().forEach(key ->
                System.out.println("Key: " + key)
        );

        hashtable.values().forEach(value -> System.out.println(value));


        System.out.println("Student with CNP 1234567890123: " + student);
    }
}
