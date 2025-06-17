package com.unibuc.pao.lab3.ex1;

public class Cat extends Pet {

    protected String name;

    public static String type = "Cat";

    public Cat(String name) {
        super("Cat");
        this.name = name;
    }

    public String makeNoise() {
        return "Meow";
    }

    @Override
    public String getFood() {
        return "Cat food";
    }

    public static String getType() {
        return type;
    }

    public void play() {
        System.out.println("The cat is playing");
    }
}
