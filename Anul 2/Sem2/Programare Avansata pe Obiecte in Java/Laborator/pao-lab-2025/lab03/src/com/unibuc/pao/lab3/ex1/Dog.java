package com.unibuc.pao.lab3.ex1;

public class Dog extends Pet {

    protected String name;

    public static String type = "Dog";

    public Dog(String name) {
        super("Dog");
        this.name = name;
    }

    public String makeNoise() {
        return "Woof";
    }

    @Override
    public String getFood() {
        return "Dog food";
    }

    public static String getType() {
        return type;
    }

    public boolean equals(Object dog) {
        if (dog == null) {
            return false;
        }

        if (this == dog) {
            return true;
        }

        if (dog instanceof Dog) {
            Dog myDog = (Dog) dog;
            return this.name.equals(myDog.name);
        }
        return false;
    }

    public int hashCode() {
        return name.hashCode();
    }
}
