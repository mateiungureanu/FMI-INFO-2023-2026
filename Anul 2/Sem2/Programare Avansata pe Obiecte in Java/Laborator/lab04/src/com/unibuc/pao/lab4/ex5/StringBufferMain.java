package com.unibuc.pao.lab4.ex5;

public class StringBufferMain {

    public static void main(String[] args) {
        StringBuffer stringBuffer = new StringBuffer();

        stringBuffer.append("Astazi ");
        stringBuffer.append("este ").append("o zi ").append("frumoasa");

        System.out.println(stringBuffer);

        stringBuffer.replace(0, 6, "Maine");
        System.out.println(stringBuffer);
    }
}
