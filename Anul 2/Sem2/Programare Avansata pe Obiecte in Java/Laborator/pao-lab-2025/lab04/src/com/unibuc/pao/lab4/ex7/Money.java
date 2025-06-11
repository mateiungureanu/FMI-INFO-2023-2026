package com.unibuc.pao.lab4.ex7;

import com.unibuc.pao.lab4.ex6.Currency;

public record Money(int amount, Currency currency) {

    public Money {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        currency = new Currency(currency.getCurrency());
    }

    private static String currencyFormat = "%d %s";

    public static String getCurrencyFormat() {
        return currencyFormat;
    }

    public Currency currency() {
        return new Currency(currency.getCurrency());
    }
}
