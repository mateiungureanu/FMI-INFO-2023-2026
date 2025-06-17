package com.unibuc.pao.lab10.ex01;

import java.io.Serializable;
import java.util.Objects;

public class Student implements Serializable {

    private String cnp;

    private String name;


    public Student(String cnp, String name) {
        this.cnp = cnp;
        this.name = name;
    }

    public String getCnp() {
        return cnp;
    }

    public String getName() {
        return name;
    }


    @Override
    public String toString() {
        return "Student{" +
                "cnp='" + cnp + '\'' +
                ", name='" + name + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Student student = (Student) o;
        return Objects.equals(cnp, student.cnp) && Objects.equals(name, student.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cnp, name);
    }


    public void postMessage(ChatRoom chatRoom, String message) {
        chatRoom.addMessage(message);
    }

}
