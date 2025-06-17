package com.unibuc.pao.lab10.ex01;

import java.util.LinkedList;
import java.util.List;

public class ChatRoom {

    private String topic;

    private List<String> messages = new LinkedList<>();

    public ChatRoom(String topic) {
        this.topic = topic;
    }

    public synchronized void addMessage(String message) {
        messages.addLast(message);
    }

    public List<String> getMessages() {
        return messages;
    }

    public void clearMessages() {
        messages.clear();
    }
}
