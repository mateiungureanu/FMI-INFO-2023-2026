package com.unibuc.pao.lab6.ex6;

import com.unibuc.pao.lab6.ex4.Doctor;
import com.unibuc.pao.lab6.ex4.GeneralPractitioner;
import com.unibuc.pao.lab6.ex4.Surgeon;

import java.util.ArrayList;
import java.util.List;

public class ListMain {

    public static void main(String[] args) {
        List<Doctor> doctors = new ArrayList<>();

        Surgeon surgeon1 = new Surgeon("dr1");
        doctors.add(surgeon1);
        doctors.add(new GeneralPractitioner("dr2"));
        doctors.add(new Surgeon("dr3"));

        for (Doctor doctor : doctors) {
            doctor.treatPatient();
        }

        System.out.println("Doctor at index 2: " + doctors.get(2));
        doctors.indexOf(surgeon1);

        doctors.stream().filter(doctor -> doctor instanceof Surgeon)
                .forEach(doctor -> System.out.println("Surgeon found: " + doctor));

    }
}
