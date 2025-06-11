package com.unibuc.pao.lab5.ex1;

public class Smartphone implements TimeKeeper, Timer {

    @Override
    public long getTime() {
        return System.currentTimeMillis();
    }

    @Override
    public long start() {
        return System.currentTimeMillis() - 2000;
    }

    @Override
    public long stop() {
        return System.currentTimeMillis() + 2000;
    }


    public static void main(String[] args) {
        Smartphone smartphone = new Smartphone();
        System.out.println(smartphone.getDuration());

        Timer smartPhoneTimer = new Smartphone();
        System.out.println(smartPhoneTimer.getDuration());

        Timer.myStaticMethod();




    }
}
