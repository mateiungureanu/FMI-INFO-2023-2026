package com.unibuc.pao.lab4.ex2;

public class StringMain {


    // immutability

    // String constant pool

    private static String name = "Cristina Ionescu";
    private static String address = new String("Bd. Dorobanti nr. 7");

    private static String bookTitle = "Ion";
    private static String bookTitleTwo = "Ion";
    private static String anotherBookTitle = new String("Ion");

    private static Integer myInt = Integer.valueOf("1");
    private static Integer myIntOne = 1;

    private static Integer myIntTwo = 127;
    private static Integer myIntThree = 127;

    private static Integer myIntFour = 128;
    private static Integer myIntFive = 128;

    public static void main(String[] args) {
        name = "Gigel Popescu";
        System.out.println(name);


       // StringMain.name = "";

        String lowerCase = name.toLowerCase();// gigel popescu
        System.out.println(name);
        System.out.println(lowerCase);

        System.out.println(bookTitle == bookTitleTwo);
        System.out.println(bookTitle == anotherBookTitle);

        System.out.println("127==127?" + (myIntTwo == myIntThree));
        System.out.println("128==128?" + (myIntFour == myIntFive));


    }

}
