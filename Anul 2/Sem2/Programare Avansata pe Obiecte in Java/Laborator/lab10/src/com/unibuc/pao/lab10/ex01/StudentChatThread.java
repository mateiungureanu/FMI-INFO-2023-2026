package com.unibuc.pao.lab10.ex01;

public class StudentChatThread extends Thread {

    private final Student student;

    private final ChatRoom chatRoom;

    public StudentChatThread(Student student, ChatRoom chatRoom) {
        this.student = student;
        this.chatRoom = chatRoom;
    }

    @Override
    public void run() {
        student.postMessage(chatRoom, "Hello from " + student.getName() + "!");
        student.postMessage(chatRoom, student.getName() + " would like to ask a question.");
    }
}
