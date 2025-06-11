package com.unibuc.pao.lab4.ex3;

import com.unibuc.pao.lab4.ex1.Book;

import java.util.UUID;

public class StringUtilityMethodsMain {

    //toUpperCase()
    //toLowerCase()
    //indexOf()
    //lastIndexOf
    //charAt()
    //compareTo()
    //equals() / equalsIgnoreCase()
    //trim()
    //startsWith() / endsWith()
    //substring()


    public static void main(String[] args) {
        String one = String.valueOf(1); //"1"
        String doubleString = String.valueOf(12.5);
        String chars = String.valueOf(new char[]{'a', 'b', 'c'});
        String abc = "abc";
        String book = String.valueOf(new Book("Title", "Author", UUID.randomUUID().toString()));

        System.out.println(one);
        System.out.println(doubleString);
        System.out.println(chars);
        System.out.println(book);

        System.out.println("Chars to uppercase: " + chars.toUpperCase());
        System.out.println("Book to lowercase: " + book.toLowerCase());

        System.out.println("Index of Author " + book.indexOf("Author"));
        System.out.println("Last index of t " + book.lastIndexOf("t"));

        System.out.println("Chat at 0:" + book.charAt(0));
        System.out.println("Char at index of t:" + book.charAt(book.indexOf("t")));
        System.out.println("Char at last index of t:" + book.charAt(book.lastIndexOf("t")));

        System.out.println("abc equals chars? " + chars.equals(abc));
        System.out.println("abc equals chars? " + chars.toUpperCase().equals(abc));
        System.out.println("abc equals chars? " + chars.toUpperCase().equalsIgnoreCase(abc));

        System.out.println("chars compareTo abc:" + chars.compareTo(abc));
        System.out.println("chars compareTo abc:" + chars.toUpperCase().compareTo(abc));

        String anotherString = " abc  ab ";
        System.out.println("abc trim: " + "#" + anotherString.trim() + "#");
        System.out.println("abc strip: " + "#" + anotherString.strip() + "#");
        System.out.println("abc strip: " + "#" + anotherString.replaceAll("\s", "") + "#");

        System.out.println("starts with abc? " + anotherString.trim().startsWith("abc"));
        System.out.println("ends with ab ? " + anotherString.endsWith("ab "));

        System.out.println("substring(2) " + anotherString.substring(2));
        System.out.println("substring(2, 4) " + anotherString.substring(2, 4));



    }
}
