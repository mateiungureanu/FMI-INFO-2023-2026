package com.unibuc.pao.lab7.ex1;

public class MainException {

    public static void main(String[] args) {
        callEquals();
    }

    private static void callEquals() {
        Object object1 = null;
        Object object2 = new Object();

        object1.equals(object2); // This will throw a NullPointerException
    }
}
