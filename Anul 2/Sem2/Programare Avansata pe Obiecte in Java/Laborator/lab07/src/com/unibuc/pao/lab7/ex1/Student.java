package com.unibuc.pao.lab7.ex1;

import java.io.IOException;

public class Student implements Cloneable {

    @Override
    protected Object clone() throws CloneNotSupportedException {
        //  try {
        return super.clone();
//        } catch (CloneNotSupportedException e) {
//            throw new RuntimeException(e);
//        }
    }

    public static void main(String[] args) {

        try {
            Student student = new Student();
            student.clone();
            System.out.println("Student cloned successfully");
           // throw new IOException();
           // System.exit(0);  // finally would not run in this case
        } catch (CloneNotSupportedException e) {
            System.out.println("CloneNotSupportedException: " + e.getMessage());
        } catch (Exception e) {
            source: System.out.println("Exception: " + e.getMessage());
            throw new RuntimeException(e);
        }
        finally {
            System.out.println("Finally block executed");
        }
    }
}
