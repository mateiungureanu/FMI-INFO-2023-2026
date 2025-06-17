package com.unibuc.pao.lab2.ex3;

public class ParentClass {

    private final int id;

    protected float protectedField;

    double defaultField;

    private final static int staticId;


    static {
        staticId = 7;
    }

    public ParentClass(int id) {
        this.id = id;
    }

    protected void doSomethingPublic() {
        System.out.println("ParentClass.doSomething()");
    }

    protected Number doSomethingProtected(Integer i, int j) throws Exception {
        System.out.println("ParentClass.doSomething()");
        return i + j;
    }

    public void doSomethingPublic(int i) {
        System.out.println("ParentClass.doSomething() with int parameter");
    }

    protected void doSomethingProtected() {
        System.out.println("ParentClass.doSomethingProtected()");
    }

    private void doSomethingPrivate() {
        System.out.println("ParentClass.doSomethingPrivate()");
    }

    public final void doSomethingDefault() {
        System.out.println("ParentClass.doSomethingDefault()");
    }


    public int getId() {
        return id;
    }

    // static methods

    public static void staticDoSomethingPublic() {
        System.out.println("ParentClass.staticDoSomethingPublic()");
    }
}
