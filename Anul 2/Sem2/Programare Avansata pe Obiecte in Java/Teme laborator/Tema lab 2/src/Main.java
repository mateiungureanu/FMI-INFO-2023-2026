import java.util.Arrays;

public class Main {
    public static void main(String[] args) {
        Object[] students = new Object[5];
        students[0] = new Student("John Doe", 20, "Strada1_1_Bucuresti_Romania", 2, 232, new int[][]{{10, 9, 10}, {7, 8}, {10, 7}, {2, 9, 10}});
        students[1] = new Student("Jane Doe", 20, "Strada1_1_Bucuresti_Romania", 2, 232, new int[][]{{7, 9}, {7, 7, 4}, {4, 5}, {2, 8}});
        students[2] = new Student("John Smith", 19, "Strada3_5_Bucuresti_Romania", 1, 131, new int[][]{{10, 9, 8}, {7, 6, 5}, {4, 3}, {2, 1}});
        students[3] = new Student("Jane Smith", 21, "Strada3_5_Bucuresti_Romania", 3, 332, new int[][]{{10, 10, 10}, {8, 9, 9}, {5, 8}, {8, 3}});
        students[4] = new Student("John Johnson", 20, "Strada7_2_Bucuresti_Romania", 2, 232, new int[][]{{8, 7, 8}, {7, 6, 5}, {6}, {5, 3, 8}});
        Arrays.sort(students, (Object o1, Object o2) -> {
            Student s1 = (Student) o1;
            Student s2 = (Student) o2;
            return s2.getYearAverage() - s1.getYearAverage();
        });
        for (int i = 0; i < 3; i++) {
            Student student = (Student) students[i];
            student.getSituation();
            System.out.println("--------------------");
        }
    }
}