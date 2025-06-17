package com.unibuc.pao.lab4.ex5;

public class StringBuilderMain {

    public static void main(String[] args) {
        StringBuilder stringBuilder = new StringBuilder();

        stringBuilder.append("Astazi ");
        stringBuilder.append("este ").append("o zi ").append("frumoasa");

        System.out.println(stringBuilder);

        stringBuilder.replace(0, 6, "Maine");
        System.out.println(stringBuilder);
    }
}
