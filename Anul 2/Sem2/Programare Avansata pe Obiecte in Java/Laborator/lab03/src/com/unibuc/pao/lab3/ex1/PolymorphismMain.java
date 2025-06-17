package com.unibuc.pao.lab3.ex1;

public class PolymorphismMain {

    public static void main(String[] args) {

        // polymorphism examples - which field/method gets called?
        Pet dog = new Dog("Rex");
        Pet cat = new Cat("Tom");

        System.out.println(dog.makeNoise());
        System.out.println(dog.getFood());

        System.out.println(cat.makeNoise());
        System.out.println(cat.getFood());

        System.out.println(dog.name);
        System.out.println(cat.name);

        System.out.println(dog.type);
        System.out.println(cat.type);

        System.out.println(dog.getType());
        System.out.println(cat.getType());


        Pet myCatPet = new Cat("Miaunel");
        Pet myDogPet = new Dog("Blacky");

        if (myCatPet instanceof Cat) {
            Cat myCat = (Cat) myCatPet;
            myCat.play();
        }


        // upcast
        Cat cat2 = new Cat("Xena");
        Pet newPet = cat2;
        Pet otherPet = new Dog("Rex");

        // downcast
        cat2 = (Cat) newPet;
        if (otherPet instanceof Cat) {
            cat2 = (Cat) otherPet;
        }

        // array of objects and subclasses
        Pet[] pets = new Pet[3];
        Pet[] newPets = new Dog[2];

        pets[0] = new Dog("Rex");
        pets[1] = new Cat("Tom");
        pets[2] = new Pet("My pet");

        for (Pet pet : pets) {
            System.out.println(pet.makeNoise());
        }


        newPets[0] = new Dog("Rex");
        Pet myOtherGenericPet = new Dog("My dog");
        newPets[1] = myOtherGenericPet;

        for (Pet pet : newPets) {
            System.out.println(pet.makeNoise());
        }


    }
}
