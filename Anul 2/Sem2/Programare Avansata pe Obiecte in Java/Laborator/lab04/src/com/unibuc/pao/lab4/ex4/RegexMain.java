package com.unibuc.pao.lab4.ex4;

import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexMain {

    public static void main(String[] args) {

        String cnp = "1991013777209";
        String cnpTwo = "2991133777209";
        System.out.println("cnp is valid? " + cnp.matches("[1,2][1-9][0-9](0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0,1])[0-9]{6}"));
        System.out.println("cnpTwo is valid? " + cnpTwo.matches("[1,2][1-9][0-9](0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0,1])[0-9]{6}"));

        String phrase = "Ana are mere dar are si gutui.";

        String[] words = phrase.split("\s");
        System.out.println(Arrays.toString(words));
        words = phrase.split("\\b");
        System.out.println(Arrays.toString(words));

        Pattern pattern = Pattern.compile("[a-zA-Z]+");
        Matcher matcher = pattern.matcher(phrase);
        System.out.println("Words are: ");
        while (!matcher.hitEnd()) {
            matcher.find();
            if (matcher.hasMatch()) {
                System.out.println(matcher.group());
            }

        }
    }
}
