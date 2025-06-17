package com.unibuc.pao.lab6.ex4;

public non-sealed class GeneralPractitioner extends Doctor {

    public GeneralPractitioner(String name) {
        super(name);
    }

    @Override
    public void treatPatient() {
        System.out.println("General Practitioner is treating a patient");
    }
}
