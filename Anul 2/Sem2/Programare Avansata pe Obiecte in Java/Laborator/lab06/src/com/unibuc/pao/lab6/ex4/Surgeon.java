package com.unibuc.pao.lab6.ex4;

public non-sealed class Surgeon extends Doctor {

    public Surgeon(String name) {
        super(name);
    }

    @Override
    public void treatPatient() {
        System.out.println("Surgeon " + name + " is treating a patient");
    }

    @Override
    public String toString() {
        return "Surgeon with name: " + name;
    }
}
