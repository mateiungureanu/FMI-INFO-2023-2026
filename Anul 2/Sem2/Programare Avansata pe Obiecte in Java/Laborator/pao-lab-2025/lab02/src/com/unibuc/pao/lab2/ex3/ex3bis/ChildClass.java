package com.unibuc.pao.lab2.ex3.ex3bis;

import com.unibuc.pao.lab2.ex3.ParentClass;

import java.io.IOException;

public class ChildClass extends ParentClass {

    // constructor(s): default, parameterized, copy constructor

    public ChildClass() {
        super(6);
    }

    public ChildClass(int i) {
        super(i);
    }


    // override parent method
    @Override
    public void doSomethingPublic() {

        super.doSomethingPublic();

        System.out.println(this.protectedField);
        //  System.out.println(this.defaultField);  -> not accessible!
        //  System.out.println(this.id); -> private, not accessible!
        System.out.println(this.getId()); // ok, public getter accessing private field


        System.out.println("ChildClass.doSomethingPublic()");
    }


   // @Override
    public void doSomethingPublic(int i) { // using an Integer type parameter would not be a valid override!
        System.out.println("ChildClass.doSomething() with int parameter");
    }

    //override with covariant return type
    //override with different access modifier
    //override with exceptions declared

    @Override
    protected Short doSomethingProtected(Integer i, int j) throws IOException {
        System.out.println("ParentClass.doSomething()");
        return (short) (i.intValue() + j);
    }


    //static methods

    //@Override //- doesn't work for static methods, not an override but rather parent method accessible in child class
    public static void staticDoSomethingPublic() {
        ParentClass.staticDoSomethingPublic();
       // ChildClass.staticDoSomethingPublic();
        System.out.println("ChildClass.staticDoSomethingPublic()");
    }

    private static Integer staticDoSomethingPublic(String s) {
        ParentClass.staticDoSomethingPublic();
       // ChildClass.staticDoSomethingPublic();
        System.out.println("ChildClass.staticDoSomethingPublic()");
        return 0;
    }



    // overload method
    public void doSomethingProtected(byte i, int j) {
        System.out.println("ChildClass.doSomethingProtected()");
    }

    protected void doSomethingProtected(int i, byte b) throws Exception {
        System.out.println("ChildClass.doSomethingProtected()");
    }

    protected void doSomethingProtected(Integer i) {
        System.out.println("ChildClass.doSomethingProtected()");
    }

    protected int doSomethingProtected(Number i) {
        System.out.println("ChildClass.doSomethingProtected()");
        return i.intValue();
    }

    public static void main(String[] args) throws IOException {
        ChildClass childObject = new ChildClass(2);
        ChildClass.staticDoSomethingPublic();

        childObject.doSomethingProtected(2);
        childObject.doSomethingProtected(2, 3);
    }

}
