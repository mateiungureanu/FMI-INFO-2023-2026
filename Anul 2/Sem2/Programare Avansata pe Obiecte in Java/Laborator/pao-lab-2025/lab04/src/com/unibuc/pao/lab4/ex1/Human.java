package com.unibuc.pao.lab4.ex1;

import java.util.Date;

public class Human {

    private Date birthDate;

    private String name;

    private Brain brain;

    public Human(Date birthDate, String name, Brain brain) {
        this.birthDate = birthDate;
        this.name = name;
        this.brain = new Brain(brain);
    }

    public Human(Date birthDate, String name, String[] emispheres) {
        this.birthDate = birthDate;
        this.name = name;
        this.brain = new Brain(emispheres);
    }

    public Brain getBrain() {
        return brain;
    }
}
