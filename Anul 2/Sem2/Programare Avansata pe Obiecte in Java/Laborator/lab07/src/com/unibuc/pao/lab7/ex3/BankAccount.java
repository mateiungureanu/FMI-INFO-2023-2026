package com.unibuc.pao.lab7.ex3;

public class BankAccount {

    private int balance;

    public int withdraw(int amount) throws InsufficientFundsException {
        if (amount <= balance) {
            return balance - amount;
        }
        throw new InsufficientFundsException("Insufficient funds in the account");
    }

    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.balance = 1000;

        // if InsufficientFundsException was a checked exception, we would have to handle it (try-catch)
        //try {
            System.out.println("New balance: " + account.withdraw(1100)); // would throw exception
//        } catch (InsufficientFundsException e) {
//            System.out.println("InsufficientFundsException: " + e.getMessage() + ". Balance is unmodified");
//        }
        System.out.println("Completed successfully");
    }
}
