package com.unibuc.pao.lab2.ex2;

import java.util.Arrays;

public class ArraysUtilityClassMain {

    public static void main(String[] args) {

        int[][] multidimensional = new int[3][];
        multidimensional[0] = new int[]{1, 2, 3};
        multidimensional[1] = new int[]{4, 5, 6, 7};
        multidimensional[2] = new int[]{8, 9};
        System.out.println("multidimensional = " + multidimensional);
        System.out.println("multidimensional = " + Arrays.toString(multidimensional));
        System.out.println("multidimensional = " + Arrays.deepToString(multidimensional));

        int[] unidimensional = new int[] {1, 2, 3, 4, 5};
        System.out.println("unidimensional = " + unidimensional);
        System.out.println("unidimensional = " + Arrays.toString(unidimensional));

        int[] unidimensional2 = new int[]{1, 2, 3, 4, 5};
        System.out.println("unidimensional == unidimensional2? " + (unidimensional == unidimensional2));
        System.out.println("unidimensional.equals(unidimensional2)? " + unidimensional.equals(unidimensional2));
        System.out.println("unidimensional.equals(unidimensional2)? " + Arrays.equals(unidimensional, unidimensional2));

        unidimensional2 = unidimensional;  // now they point to the same object in memory!
        System.out.println("unidimensional == unidimensional2? " + (unidimensional == unidimensional2));
        System.out.println("unidimensional.equals(unidimensional2)? " + unidimensional.equals(unidimensional2));
        System.out.println("unidimensional.equals(unidimensional2)? " + Arrays.equals(unidimensional, unidimensional2));

        long[] longs = new long[]{1, -2, 17, 4, 0};
        System.out.println("unsorted longs = " + Arrays.toString(longs));
        Arrays.sort(longs);
        System.out.println("sorted longs = " + Arrays.toString(longs));


        String[] myArray = {"1", "2", "3", "4", "5"};
        String[] myArray2 = Arrays.copyOf(myArray, myArray.length);
        // are they equal ?
        System.out.println("myArray == myArray2" + (myArray == myArray2));
        System.out.println("myArray.equals(myArray2)" + Arrays.equals(myArray, myArray2));

    }
}
