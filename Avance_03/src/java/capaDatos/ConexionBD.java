package capaDatos;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionBD {
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String USUARIO = "root";
    private static final String CLAVE = "002513";
    private static final String URL = "jdbc:mysql://localhost:3306/alquiler_vehiculos";
    
    private Connection cnn;

    // Constructor
    public ConexionBD() {
        this.cnn = null;
    }

    // Metodo Conectar
    public Connection Conectar() {
        try {
            Class.forName(DRIVER);
            cnn = DriverManager.getConnection(URL, USUARIO, CLAVE);
            System.out.println("Conexión exitosa a la BD");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        return cnn;
    }

    // Metodo Desaconectar
    public void Desconectar() {
        try {
            cnn.close();
        } catch (SQLException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}