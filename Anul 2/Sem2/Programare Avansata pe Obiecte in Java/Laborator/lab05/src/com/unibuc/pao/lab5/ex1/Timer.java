package com.unibuc.pao.lab5.ex1;

public interface Timer {

    String TYPE = "Timer";

    long start();
    long stop();

    default long getDuration() {
        return stop() - start();
    }

    private int myPrivateMethod() {
         return 0;
    }

    static void myStaticMethod() {
        System.out.println("Static method");
    }

}
