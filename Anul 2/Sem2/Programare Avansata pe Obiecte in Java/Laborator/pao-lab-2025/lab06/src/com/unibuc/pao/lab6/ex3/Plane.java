package com.unibuc.pao.lab6.ex3;

public interface Plane {

    default void fly() {
        System.out.println("Plane is flying");
    }

    static void printSpeed() {
        System.out.println("Plane is flying at a speed of 10000 km/h");
    }
}
