package com.unibuc.pao.lab4.ex7;

import com.unibuc.pao.lab4.ex6.Currency;

public class RecordsMain {

    public static void main(String[] args) {
        Currency originalCurrency = new Currency("USD");
        Money money = new Money(100, originalCurrency);

        System.out.println(money.amount());
        System.out.println(money.currency());
        System.out.println(Money.getCurrencyFormat());
        money.currency().setCurrency("RON");
        System.out.println(money.currency());

        originalCurrency.setCurrency("EUR");
        System.out.println(money.currency());



    }
}
