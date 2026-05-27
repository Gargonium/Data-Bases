package ru.java.server;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://localhost:5432/librarydb";
        String user = "admin";
        String password = "admin";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("✅ Успешное подключение к БД!");
        } catch (SQLException e) {
            System.err.println("❌ Ошибка подключения: " + e.getMessage());
        }
    }
}