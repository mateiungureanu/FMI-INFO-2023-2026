package com.unibuc.pao.lab6.ex4;

import java.util.Objects;

public sealed abstract class Doctor extends MedicalStaff permits Surgeon, GeneralPractitioner {

    protected String name;

    public Doctor(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Doctor doctor = (Doctor) o;
        return Objects.equals(name, doctor.name);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name);
    }
}
