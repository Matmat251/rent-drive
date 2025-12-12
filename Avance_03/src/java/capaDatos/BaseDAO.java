package capaDatos;

import java.sql.*;

/**
 * Clase base para todos los DAOs del sistema.
 * Proporciona métodos comunes para manejo de conexiones y recursos.
 * Elimina código repetitivo en las operaciones de base de datos.
 */
public abstract class BaseDAO {

    /**
     * Obtiene una nueva conexión a la base de datos.
     */
    protected Connection getConnection() {
        ConexionBD conexion = new ConexionBD();
        return conexion.Conectar();
    }

    /**
     * Cierra todos los recursos de base de datos de forma segura.
     */
    protected void cerrarRecursos(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null)
                rs.close();
        } catch (SQLException e) {
            System.err.println("Error cerrando ResultSet: " + e.getMessage());
        }
        try {
            if (stmt != null)
                stmt.close();
        } catch (SQLException e) {
            System.err.println("Error cerrando Statement: " + e.getMessage());
        }
        try {
            if (conn != null)
                conn.close();
        } catch (SQLException e) {
            System.err.println("Error cerrando Connection: " + e.getMessage());
        }
    }

    /**
     * Establece un parámetro String o NULL en un PreparedStatement.
     */
    protected void setStringOrNull(PreparedStatement stmt, int index, String value) throws SQLException {
        if (value != null && !value.trim().isEmpty()) {
            stmt.setString(index, value.trim());
        } else {
            stmt.setNull(index, Types.VARCHAR);
        }
    }

    /**
     * Establece un parámetro Integer o NULL en un PreparedStatement.
     */
    protected void setIntOrNull(PreparedStatement stmt, int index, Integer value) throws SQLException {
        if (value != null && value > 0) {
            stmt.setInt(index, value);
        } else {
            stmt.setNull(index, Types.INTEGER);
        }
    }

    /**
     * Establece un parámetro Date o NULL en un PreparedStatement.
     */
    protected void setDateOrNull(PreparedStatement stmt, int index, String value) throws SQLException {
        if (value != null && !value.trim().isEmpty()) {
            stmt.setDate(index, java.sql.Date.valueOf(value.trim()));
        } else {
            stmt.setNull(index, Types.DATE);
        }
    }

    protected void logInfo(String message) {
        System.out.println("ℹ️ " + message);
    }

    protected void logSuccess(String message) {
        System.out.println("✅ " + message);
    }

    protected void logError(String message, Exception e) {
        System.err.println("❌ " + message);
        if (e != null)
            e.printStackTrace();
    }
}
