package com.unibuc.pao.lab6.ex5;

public enum Weekday {

    MONDAY("Luni"),
    TUESDAY("Marti"),
    WEDNESDAY("Miercuri"),
    THURSDAY("Joi"),
    FRIDAY("Vineri"),
    SATURDAY("Sambata"),
    SUNDAY("Duminica");

    private String dayName;

    Weekday(String dayName) {
        this.dayName = dayName;
    }

    @Override
    public String toString() {
        return "Weekday: " + name().toLowerCase() + " dayName: " + dayName;
    }

    public String getDayName() {
        return dayName;
    }

    public Weekday getNextDay() {
        int nextOrdinal = (this.ordinal() + 1) % values().length;
        return values()[nextOrdinal];
    }

    public static Weekday getByName(String dayName) {
        for (Weekday weekday : values()) {
            if (weekday.getDayName().equalsIgnoreCase(dayName)) {
                return weekday;
            }
        }
        throw new IllegalArgumentException("No such weekday: " + dayName);
    }
}
