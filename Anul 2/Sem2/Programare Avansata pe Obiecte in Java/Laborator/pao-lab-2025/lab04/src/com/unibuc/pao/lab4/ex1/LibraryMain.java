package com.unibuc.pao.lab4.ex1;

import java.util.UUID;

public class LibraryMain {

    public static void main(String[] args) {
        Book bookOne = new Book("Informatica an II", "Radu Boriga", UUID.randomUUID().toString());
        Book bookTwo = new Book("Informatica an I", "Radu Boriga", UUID.randomUUID().toString());
        Book bookThree = new Book("Informatica an III", "Radu Boriga", UUID.randomUUID().toString());
        Book bookFour = new Book("Informatica master an II", "Radu Boriga", UUID.randomUUID().toString());


        Book[] books = {bookOne, bookTwo, bookThree, bookFour};
        // aggregation
        Library library = new Library("Mihail Sadoveanu", "Piata Romana nr. 5", books);

        library = null;
    }
}
