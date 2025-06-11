package com.unibuc.pao.lab6.ex4;

public abstract sealed class MedicalStaff permits Doctor, Nurse {

    public abstract void treatPatient();
}
