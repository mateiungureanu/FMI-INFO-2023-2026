package com.unibuc.pao.lab4.ex1;

public class Brain {

    private String[] emispheres;

    public Brain(String[] emispheres) {
        this.emispheres = emispheres;
    }

    public Brain(Brain brain) {
        this.emispheres = brain.emispheres;
    }

    public String[] getEmispheres() {
        return emispheres;
    }

    public void think() {
        System.out.println("Thinking...");
    }
}
