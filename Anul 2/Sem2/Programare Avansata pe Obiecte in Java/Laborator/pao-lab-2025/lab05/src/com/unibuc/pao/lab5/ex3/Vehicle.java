package com.unibuc.pao.lab5.ex3;

public interface Vehicle extends Movable {

    void ride();

    default void move() {
        System.out.println("Vehicle is moving");
    }

}
