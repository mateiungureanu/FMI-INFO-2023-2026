package com.unibuc.pao.lab6.ex3;

public class Superman implements Bird, Plane {

    @Override
    public void fly() {
        Bird.super.fly(); // Calls the fly method from the Bird interface
        Plane.super.fly(); // Calls the fly method from the Bird interface
        System.out.println("Superman is flying");
    }

    public static void main(String[] args) {
        Superman superman = new Superman();
        superman.fly(); // Output: Superman is flying
        Bird.printSpeed(); // Output: Bird is flying at a speed of 10 km/h
        Plane.printSpeed(); // Output: Bird is flying at a speed of 10 km/h
    }
}
