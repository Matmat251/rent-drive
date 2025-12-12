package capaDatos;

import capaEntidad.BloqueoCalendario;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BloqueoCalendarioDAO {
    
    // Verificar disponibilidad de vehículo en un rango de fechas
    public boolean verificarDisponibilidad(int idVehiculo, LocalDate fechaInicio, LocalDate fechaFin) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            
            // Verificar si hay bloqueos en el rango de fechas
            String sql = "SELECT COUNT(*) as bloqueos " +
                        "FROM bloqueos_calendario " +
                        "WHERE id_vehiculo = ? " +
                        "AND ((fecha_inicio BETWEEN ? AND ?) " +
                        "OR (fecha_fin BETWEEN ? AND ?) " +
                        "OR (? BETWEEN fecha_inicio AND fecha_fin) " +
                        "OR (? BETWEEN fecha_inicio AND fecha_fin))";
            
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idVehiculo);
            stmt.setDate(2, Date.valueOf(fechaInicio));
            stmt.setDate(3, Date.valueOf(fechaFin));
            stmt.setDate(4, Date.valueOf(fechaInicio));
            stmt.setDate(5, Date.valueOf(fechaFin));
            stmt.setDate(6, Date.valueOf(fechaInicio));
            stmt.setDate(7, Date.valueOf(fechaFin));
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("bloqueos") == 0;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error verificando disponibilidad: " + e.getMessage());
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
        
        return false;
    }
    
    // Obtener todos los bloqueos de un vehículo
    public List<BloqueoCalendario> obtenerBloqueosPorVehiculo(int idVehiculo) {
        List<BloqueoCalendario> bloqueos = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "SELECT * FROM bloqueos_calendario WHERE id_vehiculo = ? ORDER BY fecha_inicio";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idVehiculo);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                BloqueoCalendario bloqueo = new BloqueoCalendario();
                bloqueo.setIdBloqueo(rs.getInt("id_bloqueo"));
                bloqueo.setIdVehiculo(rs.getInt("id_vehiculo"));
                bloqueo.setFechaInicio(rs.getDate("fecha_inicio").toLocalDate());
                bloqueo.setFechaFin(rs.getDate("fecha_fin").toLocalDate());
                bloqueo.setMotivo(rs.getString("motivo"));
                bloqueo.setDescripcion(rs.getString("descripcion"));
                bloqueo.setCreatedAt(rs.getString("created_at"));
                
                bloqueos.add(bloqueo);
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error obteniendo bloqueos: " + e.getMessage());
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
        
        return bloqueos;
    }
    
    // Crear nuevo bloqueo
    public boolean crearBloqueo(BloqueoCalendario bloqueo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "INSERT INTO bloqueos_calendario (id_vehiculo, fecha_inicio, fecha_fin, motivo, descripcion) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            
            stmt.setInt(1, bloqueo.getIdVehiculo());
            stmt.setDate(2, Date.valueOf(bloqueo.getFechaInicio()));
            stmt.setDate(3, Date.valueOf(bloqueo.getFechaFin()));
            stmt.setString(4, bloqueo.getMotivo());
            stmt.setString(5, bloqueo.getDescripcion());
            
            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error creando bloqueo: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // Eliminar bloqueo
    public boolean eliminarBloqueo(int idBloqueo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "DELETE FROM bloqueos_calendario WHERE id_bloqueo = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idBloqueo);
            
            int filasAfectadas = stmt.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            System.out.println("❌ Error eliminando bloqueo: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // Obtener fechas ocupadas de un vehículo (para el calendario)
    public List<String> obtenerFechasOcupadas(int idVehiculo) {
        List<String> fechasOcupadas = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            
            // Obtener fechas de bloqueos
            String sqlBloqueos = "SELECT fecha_inicio, fecha_fin FROM bloqueos_calendario WHERE id_vehiculo = ?";
            stmt = conn.prepareStatement(sqlBloqueos);
            stmt.setInt(1, idVehiculo);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                LocalDate inicio = rs.getDate("fecha_inicio").toLocalDate();
                LocalDate fin = rs.getDate("fecha_fin").toLocalDate();
                
                // Agregar todas las fechas del rango
                LocalDate fecha = inicio;
                while (!fecha.isAfter(fin)) {
                    fechasOcupadas.add(fecha.toString());
                    fecha = fecha.plusDays(1);
                }
            }
            
            rs.close();
            stmt.close();
            
            // Obtener fechas de reservas activas
            String sqlReservas = "SELECT fecha_inicio, fecha_fin FROM reservas WHERE id_vehiculo = ? AND estado = 'Activa'";
            stmt = conn.prepareStatement(sqlReservas);
            stmt.setInt(1, idVehiculo);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                LocalDate inicio = rs.getDate("fecha_inicio").toLocalDate();
                LocalDate fin = rs.getDate("fecha_fin").toLocalDate();
                
                // Agregar todas las fechas del rango
                LocalDate fecha = inicio;
                while (!fecha.isAfter(fin)) {
                    fechasOcupadas.add(fecha.toString());
                    fecha = fecha.plusDays(1);
                }
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error obteniendo fechas ocupadas: " + e.getMessage());
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
        
        return fechasOcupadas;
    }
}