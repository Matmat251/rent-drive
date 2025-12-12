package capaDatos;

import capaEntidad.Ciudad;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CiudadDAO {
    
    /*
    public List<Ciudad> obtenerCiudadesActivas() {
        List<Ciudad> ciudades = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("🏙️ Obteniendo ciudades activas");
            
            String sql = "CALL sp_ObtenerCiudadesActivas()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Ciudad ciudad = new Ciudad();
                ciudad.setIdCiudad(rs.getInt("id_ciudad"));
                ciudad.setNombreCiudad(rs.getString("nombre_ciudad"));
                ciudades.add(ciudad);
            }
            
            System.out.println("✅ Ciudades obtenidas: " + ciudades.size());
            
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener ciudades activas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        return ciudades;
    }
    */
    
    public List<Ciudad> obtenerCiudadesActivas() {
    ConexionBD conexion = new ConexionBD();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    List<Ciudad> ciudades = new ArrayList<>();
    
        try {
            conn = conexion.Conectar();
            String sql = "SELECT * FROM ciudades WHERE estado = 'Activa' ORDER BY nombre_ciudad";

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Ciudad ciudad = new Ciudad();
                ciudad.setIdCiudad(rs.getInt("id_ciudad"));
                ciudad.setNombreCiudad(rs.getString("nombre_ciudad"));
                ciudad.setEstado(rs.getString("estado"));

                ciudades.add(ciudad);
            }

            return ciudades;

        } catch (SQLException e) {
            System.out.println("❌ Error al obtener ciudades activas: " + e.getMessage());
            e.printStackTrace();
            return ciudades;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    
    
       
    // método ObtenerCiudadPorId:
    public Ciudad obtenerCiudadPorId(int idCiudad) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexion.Conectar();
            String sql = "SELECT * FROM ciudades WHERE id_ciudad = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idCiudad);

            rs = stmt.executeQuery();

            if (rs.next()) {
                Ciudad ciudad = new Ciudad();
                ciudad.setIdCiudad(rs.getInt("id_ciudad"));
                ciudad.setNombreCiudad(rs.getString("nombre_ciudad"));
                ciudad.setEstado(rs.getString("estado"));
                return ciudad;
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener ciudad por ID: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.err.println("Error cerrando recursos: " + e.getMessage());
            }
        }
        return null;
    }
    
    
}