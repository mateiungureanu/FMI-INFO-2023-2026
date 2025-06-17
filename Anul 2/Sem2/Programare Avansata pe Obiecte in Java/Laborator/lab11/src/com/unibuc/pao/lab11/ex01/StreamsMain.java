package com.unibuc.pao.lab11.ex01;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class StreamsMain {

    public static void main(String[] args) {
        Book book1 = new Book("1984", "George Orwell", 1949, "Dystopian", 15.99);
        Book book2 = new Book("To Kill a Mockingbird", "Harper Lee", 1960, "Fiction", 10.99);
        Book book3 = new Book("The Great Gatsby", "F. Scott Fitzgerald", 1925, "Classic", 12.99);
        Book book4 = new Book("Brave New World", "Aldous Huxley", 2012, "Dystopian", 14.99);
        Book book5 = new Book("Brave New World new edition", "Aldous Huxley", 2019, "Dystopian", 14.99);
        Book book6 = new Book("The Catcher in the Rye", "J.D. Salinger", 1951, "Fiction", 9.99);
        Book book7 = new Book("Fahrenheit 451", "Ray Bradbury", 2010, "Dystopian", 13.99);

        List<Book> books = List.of(book1, book2, book3, book4, book5, book6, book7);


        List<Book> booksAfter2010 = books.stream().filter(book -> book.getPublicationYear() >= 2010).toList();
        System.out.println("Books published after 2010:" + booksAfter2010);


        Map<String, List<Book>> booksByGenre = books.stream().collect(Collectors.groupingBy(Book::getGenre));
        System.out.println("Books grouped by genre: " + booksByGenre);
        booksByGenre.values().stream().flatMap(bookList -> Stream.of(bookList.stream().map(book -> book.getTitle()).toList())).forEach(System.out::println);

        System.out.println("Books sorted by price desc:");
        books.stream().sorted(Comparator.comparing(Book::getPrice).reversed())
                .forEach(System.out::println);

        System.out.println("Distinct authors:");
        books.stream().map(Book::getAuthor)
                .distinct()
                .forEach(System.out::println);

        System.out.println("Total price of books:");
        Double totalPrice = books.stream().map(Book::getPrice).reduce(0.0, Double::sum);
        System.out.println("Total price: " + totalPrice);

        System.out.println("Most expensive book:");
        Optional<Book> mostExpensiveBookOptional = books.stream().reduce((bookOne, bookTwo) -> bookOne.getPrice() > bookTwo.getPrice() ? bookOne : bookTwo);
        mostExpensiveBookOptional.ifPresent(System.out::println);

        List<Book> booksOver14 = books.stream().filter(book -> book.getPrice() > 14.00)
                .peek(book -> System.out.println("Book with price > 14.00: " + book.getTitle())).toList();

        books.stream().map(Book::getTitle)
                .forEach(title -> System.out.println("Book title: " + title));

        Stream.of(new Integer[] {1,2,3})
                .forEach(System.out::println);

      //  System.out.println("Books with price over 14.00: " + booksOver14);


    }
}
