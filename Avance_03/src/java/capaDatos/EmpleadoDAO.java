package capaDatos;

import capaEntidad.Empleado;
import java.sql.*;

public class EmpleadoDAO {
    
    public Empleado autenticar(String usuario, String contraseña) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_AutenticarEmpleado(?, ?)";
            stmt = conn.prepareCall(sql);
            
            stmt.setString(1, usuario);
            stmt.setString(2, contraseña);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Empleado emp = new Empleado();
                emp.setIdEmpleado(rs.getInt("id_empleado"));
                emp.setNombre(rs.getString("nombre"));
                emp.setApellido(rs.getString("apellido"));
                emp.setCargo(rs.getString("cargo"));
                emp.setUsuario(rs.getString("usuario"));
                return emp;
            }
        } catch (SQLException e) {
            System.out.println("Error en autenticación: " + e.getMessage());
        } finally {
            // Cerrar recursos manualmente
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("Error cerrando recursos: " + e.getMessage());
            }
        }
        return null;
    }
}