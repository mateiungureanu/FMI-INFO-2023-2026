package com.unibuc.pao.lab12.ex01;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class JDBCMain {


    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver").getDeclaredConstructor().newInstance();

            try (Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/pao", "root", "my-secret-pw")) {

                queryStudents(connection);

                insertStudents(connection);

                List<Integer> studentIds = queryStudents(connection);

                updateStudentById(connection, studentIds.get(0), "John Doe");
                updateStudentById(connection, studentIds.get(1), "Jane Smith");

                createTableGrades(connection);
                insertGrades(connection, studentIds);

                callFunctionAvgPerStudent(connection, studentIds.get(0));

                deleteAllGrades(connection);
                deleteAllStudents(connection);
                queryStudents(connection);
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static void callFunctionAvgPerStudent(Connection connection, int id) throws SQLException {
        try (CallableStatement callableStatement = connection.prepareCall("{?=call avg_per_student(?)}")) {
            callableStatement.registerOutParameter(1, java.sql.Types.DOUBLE);

            callableStatement.setInt(2, id);
            callableStatement.execute();
            double avg = callableStatement.getDouble(1);
            System.out.println("Average grade for student with ID : " + id + " is: " + avg);
        }
    }

    private static void insertGrades(Connection connection, List<Integer> studentIds) throws SQLException {
        String insertSql = "INSERT INTO pao.GRADES(STUDENT_ID, SUBJECT, GRADE) VALUES(?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(insertSql)) {

            for (int id : studentIds) {
                int no_grades = 3;
                do {
                    preparedStatement.setInt(1, id); // Assuming STUDENT_ID corresponds to the ID in STUDENTS
                    preparedStatement.setString(2, "Subject " + id);
                    int grade = (int) (Math.random() * 10);
                    preparedStatement.setInt(3, grade); // Random grade between 0 and 10

                    int inserted = preparedStatement.executeUpdate();
                    System.out.println("Inserted " + inserted + " row(s) for student ID: " + id + " with grade: " + grade);
                } while (--no_grades > 0);
            }
        }
    }

    private static void createTableGrades(Connection connection) throws SQLException {
        try (Statement statement = connection.createStatement()) {
            String createTableGradesSql = "CREATE TABLE IF NOT EXISTS pao.GRADES(ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, STUDENT_ID INT UNSIGNED, SUBJECT VARCHAR(50), GRADE INT UNSIGNED, FOREIGN KEY (STUDENT_ID) REFERENCES STUDENTS(ID))";
            statement.execute(createTableGradesSql);
        }
    }

    private static void deleteAllStudents(Connection connection) throws SQLException {
        String deleteSql = "DELETE FROM STUDENTS";

        int rows = connection.createStatement().executeUpdate(deleteSql);
        System.out.println("Deleted " + rows + " row(s) from STUDENTS table.");
    }

    private static void deleteAllGrades(Connection connection) throws SQLException {
        String deleteSql = "DELETE FROM GRADES";

        connection.createStatement().execute(deleteSql);
    }

    private static void updateStudentById(Connection connection, int id, String name) throws SQLException {
        String updateSql = "UPDATE STUDENTS SET name=? WHERE id=?";
        try (PreparedStatement updateStudentPreparedStatement = connection.prepareStatement(updateSql)) {
            updateStudentPreparedStatement.setString(1, name);
            updateStudentPreparedStatement.setInt(2, id);

            int updated = updateStudentPreparedStatement.executeUpdate();
            System.out.println("Updated " + updated + " row(s) for student with ID: " + id);
        }
    }

    private static void insertStudents(Connection connection) throws SQLException {

        String insertSql = "INSERT INTO STUDENTS(NAME, STUDY_YEAR, STUDY_GROUP) VALUES(?, ?, ?)";
        try (PreparedStatement insertStudentPreparedStatement = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

            for (int i = 0; i < 5; i++) {
                String name = "Student " + i;
                int studyYear = 1 + (int) (Math.random() * 3); // Random year between 1 and 3
                int studyGroup = 1 + (int) (Math.random() * 5); // Random group between 1 and 5

                insertStudentPreparedStatement.setString(1, name);
                insertStudentPreparedStatement.setInt(2, studyYear);
                insertStudentPreparedStatement.setInt(3, studyGroup);

                int inserted = insertStudentPreparedStatement.executeUpdate();
                try (ResultSet keys = insertStudentPreparedStatement.getGeneratedKeys()) {
                    if (keys.next()) {
                        int generatedId = keys.getInt(1);
                        System.out.println("Inserted " + inserted + " row(s) for student: " + name + ", id: " + generatedId);
                    }
                }
            }
        }
    }

    private static List<Integer> queryStudents(Connection connection) throws SQLException {
        try (Statement statement = connection.createStatement(); ResultSet studentsResultSet = statement.executeQuery("select * from pao.STUDENTS")) {
            List<Integer> studentIds = new ArrayList<>();
            System.out.println();
            while (studentsResultSet.next()) {
                int id = studentsResultSet.getInt("ID");
                String name = studentsResultSet.getString("NAME");
                int studyYear = studentsResultSet.getInt("STUDY_YEAR");
                int studyGroup = studentsResultSet.getInt("STUDY_GROUP");

                Student student = new Student(id, name, studyGroup, studyYear);
                studentIds.add(id);
                System.out.println(student);
            }

            System.out.println("Total students: " + studentIds.size());
            return studentIds;
        }
    }
}
