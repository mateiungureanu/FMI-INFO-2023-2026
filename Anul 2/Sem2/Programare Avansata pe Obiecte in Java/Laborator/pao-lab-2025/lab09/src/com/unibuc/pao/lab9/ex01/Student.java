package com.unibuc.pao.lab9.ex01;

import java.io.Serializable;
import java.util.Objects;

public class Student implements Serializable {

    private String cnp;

    private String name;

    private int age;

    private short group;

    private byte studyYear;

    private transient boolean studiesJava = false;
    private boolean studiesC = false;

    private static int count;

    private static final long serialVersionUID = -2812990639636624980L;

    public Student(String cnp, String name, int age, short group, byte studyYear) {
        this.cnp = cnp;
        this.name = name;
        this.age = age;
        this.group = group;
        this.studyYear = studyYear;
        count++;
    }

    public String getCnp() {
        return cnp;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public short getGroup() {
        return group;
    }

    public byte getStudyYear() {
        return studyYear;
    }

    @Override
    public String toString() {
        studiesJava = true;
        return "Student{" +
                "cnp='" + cnp + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", group=" + group +
                ", studyYear=" + studyYear +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return age == student.age && group == student.group && studyYear == student.studyYear && Objects.equals(cnp, student.cnp) && Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cnp, name, age, group, studyYear);
    }


//    private void writeObject(ObjectOutputStream out) throws java.io.IOException {
//        out.defaultWriteObject();
//        out.writeBoolean(studiesJava);
//    }
//
//    private void readObject(ObjectInputStream in) throws java.io.IOException, ClassNotFoundException {
//        in.defaultReadObject();
//        studiesJava = in.readBoolean();
//    }

    public static int getCount() {
        return count;
    }
}
