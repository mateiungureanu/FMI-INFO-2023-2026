package com.unibuc.pao.lab8.ex04;

import java.util.ArrayDeque;

public class QueueMain {

    public static void main(String[] args) {
        ArrayDeque<String> queue = new ArrayDeque<>();

        queue.add("First");
        queue.addFirst("Actual first");
        queue.addLast("Last");

        queue.offer("Second");
        String head = queue.peek();
        System.out.println("Head of the queue: " + head);

        System.out.println("All elements: " + queue);

        String polled = queue.poll();
        System.out.println("Polled: " + polled);
        String polledLast = queue.pollLast();
        System.out.println("Polled last: " + polledLast);


        System.out.println("Queue size: " + queue.size());
        System.out.println("Queue is empty: " + queue.isEmpty());

        System.out.println("All elements: " + queue);
    }
}
