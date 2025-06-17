package com.unibuc.pao.lab6.ex3;

public interface Bird {

    default void fly() {
        System.out.println("Bird is flying");
    }

    static void printSpeed() {
        System.out.println("Bird is flying at a speed of 10 km/h");
    }
}
