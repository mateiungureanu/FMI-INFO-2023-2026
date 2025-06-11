package com.unibuc.pao.lab10.ex01;

public class StudentChatQuestionThread implements Runnable {

    private final Student student;

    private final ChatRoom chatRoom;

    public StudentChatQuestionThread(Student student, ChatRoom chatRoom) {
        this.student = student;
        this.chatRoom = chatRoom;
    }

    @Override
    public void run() {

        synchronized (chatRoom) {
            System.out.println(student.getName() + " is posting a question...");
            student.postMessage(chatRoom, "Hello from " + student.getName() + "!");
            student.postMessage(chatRoom, student.getName() + " would like to ask a question.");
            chatRoom.notify();
        }
        synchronized (chatRoom) {
            // Simulate waiting for an answer
            try {
                System.out.println(student.getName() + " is waiting for an answer...");
                chatRoom.wait();
                student.postMessage(chatRoom, student.getName() + " says thank you for the answer.");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
