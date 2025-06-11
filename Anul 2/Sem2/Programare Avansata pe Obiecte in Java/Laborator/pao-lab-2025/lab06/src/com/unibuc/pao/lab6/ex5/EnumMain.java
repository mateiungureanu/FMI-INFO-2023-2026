package com.unibuc.pao.lab6.ex5;

import java.util.Arrays;
import java.util.EnumSet;

public class EnumMain {

    public static void main(String[] args) {
        Weekday monday = Weekday.MONDAY;
        Weekday thursday = Weekday.THURSDAY;

        System.out.println("name: " + monday.name());
        System.out.println("ordinal: " + monday.ordinal());

        System.out.println("name: " + thursday.name());
        System.out.println("ordinal: " + thursday.ordinal());

        System.out.println("values: " + Arrays.deepToString(Weekday.values()));

        Weekday anotherMonday = Weekday.valueOf("MONDAY");
        System.out.println("anotherMonday: " + anotherMonday);

        System.out.println("anotherMonday == monday: " + (anotherMonday == monday));
        System.out.println("anotherMonday.equals(monday): " + (anotherMonday.equals(monday)));

        EnumSet<Weekday> weekdays = EnumSet.allOf(Weekday.class);
        weekdays.forEach(weekday -> System.out.println(weekday.getDayName()));

        Weekday sunday = Weekday.SUNDAY;
        System.out.println("Next day after Sunday: " + sunday.getNextDay());

        System.out.println("Get by name: " + Weekday.getByName("Sambata"));
    }
}
