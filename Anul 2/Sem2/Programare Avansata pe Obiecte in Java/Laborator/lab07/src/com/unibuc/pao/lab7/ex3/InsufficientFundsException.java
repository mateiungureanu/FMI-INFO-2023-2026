package com.unibuc.pao.lab7.ex3;

public class InsufficientFundsException extends RuntimeException { //runtime exception, not checked

    public InsufficientFundsException(String message) {
        super(message);
    }
}
