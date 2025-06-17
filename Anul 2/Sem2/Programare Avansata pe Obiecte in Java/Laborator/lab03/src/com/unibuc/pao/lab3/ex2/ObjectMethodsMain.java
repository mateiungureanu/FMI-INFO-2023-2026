package com.unibuc.pao.lab3.ex2;

import com.unibuc.pao.lab3.ex1.Dog;
import com.unibuc.pao.lab3.ex1.Pet;

public class ObjectMethodsMain {

    // getClass()
    // toString()
    // equals()
    // hashCode()
    // the contract between equals() and hashCode()


    public static void main(String[] args) {
        Pet myPet = new Dog("Rex");
        System.out.println(myPet.getClass());

        Pet myPet2 = new Dog("Rex");
        //myPet2 = myPet;

        System.out.println(myPet.equals(myPet2));
        System.out.println(myPet.hashCode());
        System.out.println(myPet2.hashCode());
    }

}
