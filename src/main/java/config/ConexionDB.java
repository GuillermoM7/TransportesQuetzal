package config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    private static final String URL = "jdbc:mysql://localhost:3306/codenbugs_bd?useSSL=false&serverTimezone=UTC";
    private static final String USUARIO = "admin_guillermo"; 
    private static final String PASSWORD = "YKMemo2047**";
    
    public static Connection getConnection() {
        Connection conexion = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
            System.out.println("¡Conexión exitosa a codenbugs_bd!");
            
        } catch (ClassNotFoundException e) {
            System.out.println("Error Crítico: No se encontró el driver de MySQL - " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Error de conexión a la base de datos - " + e.getMessage());
        }
        return conexion;
    }
}