package com.unibuc.pao.lab8.ex04;

import java.util.Stack;

public class StackMain {

    public static void main(String[] args) {
        Stack<String> stack = new Stack<>();


        stack.push("First");
        stack.push("Second");
        stack.add("Third");

        System.out.println("Stack: " + stack);

        String head = stack.peek();
        System.out.println("Head of the stack: " + head);

        String removed = stack.pop();
        System.out.println("Removed: " + removed);

        stack.remove("Second");

        System.out.println("Stack: " + stack);


    }
}
