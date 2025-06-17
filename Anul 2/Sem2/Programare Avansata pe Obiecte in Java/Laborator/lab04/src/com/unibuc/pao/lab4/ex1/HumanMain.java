package com.unibuc.pao.lab4.ex1;

import java.util.Calendar;

public class HumanMain {


    public static void main(String[] args) {

        Brain genericBrain = new Brain(new String[] {"left", "right"});

        Calendar calendar = Calendar.getInstance();
        calendar.set(1990, 10, 15);

        //composition
        Human humanOne = new Human(calendar.getTime(), "Gigel Popescu", genericBrain);
        Human humanTwo = new Human(calendar.getTime(), "Ionel Popescu", genericBrain.getEmispheres());


        System.out.println("Gigel has generic brain?" + (genericBrain == humanOne.getBrain()));
        System.out.println("Ionel has generic brain?" + (genericBrain == humanTwo.getBrain()));
        System.out.println("Ionel and Gigel share the same brain?" + (humanOne.getBrain() == humanTwo.getBrain()));

        humanOne = null;
        humanTwo = null;
    }
}
