package com.unibuc.pao.lab4.ex1;

public class Book {

    private String title;

    private String author;

    private String isbnCode;

    public Book(String title, String author, String isbnCode) {
        this.title = title;
        this.author = author;
        this.isbnCode = isbnCode;
    }

    @Override
    public String toString() {
        return "Book{" +
                "title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", isbnCode='" + isbnCode + '\'' +
                '}';
    }
}
