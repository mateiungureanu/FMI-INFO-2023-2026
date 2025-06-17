package com.unibuc.pao.lab6.ex1;

import java.util.Objects;

public class Vessel implements Cloneable {

    private String name;

    public Vessel(String name) {
        this.name = name;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        return super.clone();  // requires implementing Cloneable
        //return new Vessel(this.name);  // doesn't require implementing Cloneable
    }

    @Override
    public String toString() {
        return "Vessel{" +
                "name='" + name + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (o == null || getClass() != o.getClass()) return false;
        Vessel vessel = (Vessel) o;
        return Objects.equals(name, vessel.name);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(name);
    }
}
