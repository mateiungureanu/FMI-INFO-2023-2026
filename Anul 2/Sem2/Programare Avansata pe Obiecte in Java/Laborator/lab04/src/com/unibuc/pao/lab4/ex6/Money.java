package com.unibuc.pao.lab4.ex6;

public final class Money {

    private final int amount;

    private final Currency currency;

    public Money(int amount, Currency currency) {
        this.amount = amount;
        this.currency = new Currency(currency.getCurrency());
    }

    public int getAmount() {
        return amount;
    }

    public Currency getCurrency() {
        return new Currency(currency.getCurrency());
    }

    public static void main(String[] args) {
        Money money = new Money(100, new Currency("EUR"));
        System.out.println(money.getAmount());
        System.out.println(money.getCurrency());

        money.getCurrency().setCurrency("USD");
        System.out.println(money.getCurrency());


    }


}
