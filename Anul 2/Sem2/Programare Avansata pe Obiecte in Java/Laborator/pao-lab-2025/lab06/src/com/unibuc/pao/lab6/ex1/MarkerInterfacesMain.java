package com.unibuc.pao.lab6.ex1;

public class MarkerInterfacesMain {


    public static void main(String[] args) throws CloneNotSupportedException {
        Vessel vessel = new Vessel("Vraja marii");

        Object vesselClone = vessel.clone();

        System.out.println(vessel);
        System.out.println(vesselClone);

        System.out.println("== " + (vessel == vesselClone)); // true
        System.out.println("equals? " + vessel.equals(vesselClone)); // true

        // equals vs ===
    }
}
