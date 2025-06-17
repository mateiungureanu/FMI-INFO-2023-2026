package com.unibuc.pao.lab10.ex01;

public class StudentChatAnswerThread implements Runnable {

    private final Student student;

    private final ChatRoom chatRoom;

    public StudentChatAnswerThread(Student student, ChatRoom chatRoom) {
        this.student = student;
        this.chatRoom = chatRoom;
    }

    @Override
    public void run() {
        synchronized (chatRoom) {
            try {
                System.out.println(student.getName() + " is waiting for a question...");
                chatRoom.wait();
                student.postMessage(chatRoom, "Got answer from " + student.getName());
                System.out.println(student.getName() + " has answered the question.");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }

        synchronized (chatRoom) {
            chatRoom.notify();
        }
    }
}
