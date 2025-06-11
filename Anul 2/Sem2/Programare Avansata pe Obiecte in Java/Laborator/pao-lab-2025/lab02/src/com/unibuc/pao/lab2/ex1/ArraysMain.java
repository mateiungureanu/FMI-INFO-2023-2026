package com.unibuc.pao.lab2.ex1;

public class ArraysMain {

    static int[] staticIntegers;

    public static void main(String[] args) {

        // declare and initialize primitive arrays
        int[] integers; // default value is null but it's a local variable so we need to initialize it before using it
        System.out.println("staticIntegers: " + staticIntegers); // default value is null, not mandatory to initialize

        int[] integers1 = new int[10];
        integers1[0] = 5;
        integers1[1] = 7;
        int integers2[] = new int[10];  // works, but not recommended
           System.out.println("integers1[0] = " + integers1[0]);
           System.out.println("integers1.length = " + integers1.length);

        int[] integers3 = {1, 2, 3, 4, 5};
        System.out.println("integers3[0] = " + integers3[0]);
        System.out.println("integers3.length = " + integers3.length); // 0 based index, last index is length - 1
        System.out.println("integers3[4] = " + integers3[4]);
        //   System.out.println("integers3[5] = " + integers3[5]); // ArrayIndexOutOfBoundsException, 5 = length, max index = length - 1 = 4

        long[][] integers4 = {{1, 2, 3}, {4, 5}}; // different number of elements in each row
        System.out.println(integers4[1][1]);

        long[] longs = new long[1]; // no size specified ?? doesn't work
        longs[0] = 1;
        System.out.println("longs = " + longs);

        // but - for multidimensional arrays:
        long[][] longsMultidimensional = new long[2][]; // 2 rows, but no columns specified
        longsMultidimensional[0] = new long[3];
        longsMultidimensional[1] = new long[2];
        System.out.println("longsMultidimensional = " + longsMultidimensional);
        System.out.println("longsMultidimensional[0][1] = " + longsMultidimensional[0][1]);

        int[][] myArray = new int[3][];
        myArray[0] = new int[]{1, 2, 3};
        myArray[1] = new int[]{4, 5, 6, 7};

        // declare and initialize object type arrays
        Object[] objects1 = new Object[10];
        Object objects2[] = new Object[10];

        Object objects3[], objects4[][], objects5[][];
        objects3 = new Object[10];
        objects4 = new Object[10][10];
        objects5 = new Object[][]{
                {new Object(), new Object()},
                {new Object(), new Object()}
        }; // 2x2 matrix

        Object[][] objects6, objects7[], objects8[][];
        objects7 = new Object[][][]
                {
                        {
                                {new Object(), new Object()},
                                {new Object(), new Object()},
                                {new Object()},
                        },
                        {
                                {new Object(), new Object()}
                        }
                };

        // iterate over an array using for...

        for (int i = 0; i < objects7.length; i++) {
            for (int j = 0; j < objects7[i].length; j++) {
                for (int k = 0; k < objects7[i][j].length; k++) {
                    System.out.println("objects7[" + i + "][" + j + "][" + k + "] = " + objects7[i][j][k]);
                }
            }
        }

        // same but with enhanced for loop
        for (Object[][] objectsFirstLevel : objects7) {
            for (Object[] objectsSecondLevel : objectsFirstLevel) {
                for (Object objectsThirdLevel : objectsSecondLevel) {
                    System.out.println("ObjectsThirdLevel = " + objectsThirdLevel);
                }
            }
        }

        String[][] strings = new String[][]{
                {"string11", "string12"},
                {"string21", "string22", "string23"}
        };

        for (String[] stringFirstLevel : strings) {
            for (String stringSecondLevel : stringFirstLevel) {
                System.out.println("stringSecondLevel = " + stringSecondLevel);
            }
        }

        int[] myInts = {1, 2, 3};
        System.out.println(myInts);
        int[] myOtherInts;
        myOtherInts = new int[]{1, 2, 3};
        System.out.println(myOtherInts);

        myOtherInts = myInts;

        System.out.println("myInts == myOtherInts ?" + (myInts == myOtherInts));
    }
}
