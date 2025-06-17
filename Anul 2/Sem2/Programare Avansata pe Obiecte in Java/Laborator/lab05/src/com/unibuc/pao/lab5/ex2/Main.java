package com.unibuc.pao.lab5.ex2;

import java.util.Comparator;

public class Main {


    public static void main(String[] args) {
        // instantiate class implementing interface
        TwoFactorsFunction multiply = new MultiplyFunction();
        System.out.println(multiply.apply(2, 3));

        // instantiate class implementing interface as anonymous class
        TwoFactorsFunction multiply2 = new TwoFactorsFunction() {
            @Override
            public int apply(int a, int b) {
                return a * b;
            }
        };

        System.out.println(multiply2.apply(2, 3));

        // use lambda expression
        TwoFactorsFunction multiply3 = (a, b) -> a * b;
        System.out.println(multiply3.apply(2, 3));


        Runnable runnable = () -> {
            System.out.println("Hello from lambda expression");
            System.out.println("it works");
        };

        runnable.run();


        Comparable comparable = new Comparable() {
            @Override
            public int compareTo(Object o) {
                return 0;
            }
        };

        Comparable comparable2 = o -> o.hashCode();

        Comparator comparator = (o1, o2) -> {
            return o1.hashCode() - o2.hashCode();
        };

        compareUsing((o1, o2) -> o1.hashCode() - o2.hashCode());
    }


    public static int compareUsing(Comparator comparator) {
       return comparator.compare(new Object(), new Object());
    }
}
