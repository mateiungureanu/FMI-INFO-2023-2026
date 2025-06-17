package com.unibuc.pao.lab8.ex02;

import com.unibuc.pao.lab7.ex8.Student;

import java.util.EnumSet;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.TreeSet;

public class SetMain {

    public static void main(String[] args) {

        Student johnDoe = new Student("1234567890123", "John Doe", 23, (short) 1, (byte) 1);
        Student johnDoeAgain = new Student("1234567890123", "John Doe", 23, (short) 1, (byte) 1);
        Student janeDoe = new Student("1204567890123", "Jane Doe", 21, (short) 1, (byte) 1);

        hashSetMethods(johnDoe, janeDoe);

        linkedHashSetMethods(johnDoe, janeDoe);

        treeSetMethods(johnDoe, janeDoe, johnDoeAgain);

        enumSetMethods();
    }

    private static void enumSetMethods() {
        EnumSet<TaskType> enumSet = EnumSet.allOf(TaskType.class);

        enumSet.forEach(System.out::println);

        enumSet = EnumSet.of(TaskType.MANUAL);

        enumSet.forEach(System.out::println);
    }

    private static void treeSetMethods(Student johnDoe, Student janeDoe, Student johnDoeAgain) {
        TreeSet<Student> treeSet = new TreeSet<>((student1, student2) -> {
            if (student1.getAge() != student2.getAge()) {
                return student1.getAge() - student2.getAge();
            }
            return 1;
        });

        treeSet.add(johnDoe);
        treeSet.add(janeDoe);
        treeSet.add(johnDoeAgain);

        //   treeSet.removeFirst();

        treeSet.forEach(System.out::println);
    }

    private static void linkedHashSetMethods(Student johnDoe, Student janeDoe) {
        LinkedHashSet<Student> linkedHashSet = new LinkedHashSet();

        linkedHashSet.addFirst(johnDoe);
        linkedHashSet.add(janeDoe);
        linkedHashSet.addLast(johnDoe);

        linkedHashSet.forEach(System.out::println);
    }

    private static void hashSetMethods(Student johnDoe, Student janeDoe) {
        HashSet<Student> studentsSet = new HashSet<>();

        studentsSet.add(johnDoe);

        studentsSet.add(janeDoe);

        studentsSet.forEach(System.out::println);

        System.out.println("John Doe present in set: " + studentsSet.contains(johnDoe));

        System.out.println("Jane Doe removed successfully: " + studentsSet.remove(janeDoe));
    }
}
