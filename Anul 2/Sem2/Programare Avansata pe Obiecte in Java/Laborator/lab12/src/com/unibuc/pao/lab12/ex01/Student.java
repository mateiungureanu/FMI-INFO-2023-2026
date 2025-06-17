package com.unibuc.pao.lab12.ex01;

public class Student {

    private int id;
    private String name;
    private int studyGroup;
    private int studyYear;

    public Student(int id, String name, int studyGroup, int studyYear) {
        this.id = id;
        this.name = name;
        this.studyGroup = studyGroup;
        this.studyYear = studyYear;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", studyGroup=" + studyGroup +
                ", studyYear=" + studyYear +
                '}';
    }
}
