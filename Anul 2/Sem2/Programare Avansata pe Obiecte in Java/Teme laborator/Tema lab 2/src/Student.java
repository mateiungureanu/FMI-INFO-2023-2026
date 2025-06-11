public final class Student extends Person {
    private int studyYear;
    private int studyGroup;
    private int[][] gradesPerDiscipline = new int[4][4];

    public Student() {}

    public Student(String name, int age, String address, int studyYear, int studyGroup, int[][] gradesPerDiscipline) {
        super(name, age, address);
        this.studyYear = studyYear;
        this.studyGroup = studyGroup;
        this.gradesPerDiscipline = gradesPerDiscipline;
    }
    public int getYearAverage() {
        int suma = 0;
        for (int i = 0; i < 4; i++) {
            int[] grades = gradesPerDiscipline[i];
            int sumaMaterie = 0;
            for (int grade : grades) {
                sumaMaterie += grade;
            }
            if (grades.length < 2) {
                throw new IllegalArgumentException("Media nu poate fi incheiata.");
            }
            suma += sumaMaterie / grades.length;
        }
        return suma / 4;
    }


    public void getSituation() {
        System.out.println("Nume Prenume: " + getName());
        System.out.println("An de studiu:" + studyYear);
        System.out.println("Group de studiu: " + studyGroup);
        System.out.println("Media generala: " + getYearAverage());
    }
}
