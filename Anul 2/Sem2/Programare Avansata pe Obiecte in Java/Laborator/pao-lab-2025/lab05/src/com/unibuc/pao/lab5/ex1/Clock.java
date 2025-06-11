package com.unibuc.pao.lab5.ex1;

public class Clock implements TimeKeeper {

    @Override
    public long getTime() {
        return System.currentTimeMillis();
    }
}
