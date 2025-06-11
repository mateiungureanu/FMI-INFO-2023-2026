package com.unibuc.pao.lab10.ex01;

public class ThreadsMain {

    public static void main(String[] args) throws InterruptedException {
        ChatRoom chatRoom = new ChatRoom("Java programming");

        Student student1 = new Student("1234567890123", "User 1");
        Student student2 = new Student("1244567890164", "User 2");

        //sleepJoin(student1, chatRoom, student2);

        waitNotify(chatRoom, student1, student2);
    }

    private static void sleepJoin(Student student1, ChatRoom chatRoom, Student student2) throws InterruptedException {
        StudentChatThread t1 = new StudentChatThread(student1, chatRoom);
        StudentChatThread t2 = new StudentChatThread(student2, chatRoom);

//        Thread t3 = new Thread(() -> {
//            System.out.println("Hello from thread 3");
//            System.out.println("Hello from thread 3");
//        }
//        );

        t1.start();
        t2.start();

//        t1.run();  // not starting a new thread, just calling the run method
//        t2.run();

        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

      //  Thread.sleep(7);
        System.out.println("Messages in chat room:" + chatRoom.getMessages());
    }

    private static void waitNotify(ChatRoom chatRoom, Student student1, Student student2) throws InterruptedException {
        chatRoom.clearMessages();
        StudentChatQuestionThread studentChatQuestionThread = new StudentChatQuestionThread(student1, chatRoom);
        StudentChatAnswerThread studentChatAnswerThread = new StudentChatAnswerThread(student2, chatRoom);

        Thread question = new Thread(studentChatQuestionThread);
        Thread answer = new Thread(studentChatAnswerThread);

        answer.start();
        Thread.sleep(100);
        question.start();

        try {
            answer.join();
            question.join();

        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("Messages in chat room:" + chatRoom.getMessages());
    }
}
