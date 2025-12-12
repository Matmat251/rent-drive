package capaDatos;

import capaEntidad.Vehiculo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehiculoDAO {
    
    // Método existente - listar vehículos disponibles (para clientes)
    public List<Vehiculo> listarVehiculosDisponibles() {
        List<Vehiculo> vehiculos = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ObtenerVehiculosDisponibles()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                vehiculos.add(mapResultSetToVehiculo(rs));
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al listar vehículos disponibles: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn, conexion);
        }
        return vehiculos;
    }
    
    // Listar todos los vehículos (para administración)
    public List<Vehiculo> listarTodosVehiculos() {
        List<Vehiculo> vehiculos = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "SELECT * FROM vehiculos ORDER BY marca, modelo";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                vehiculos.add(mapResultSetToVehiculo(rs));
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al listar vehículos: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn, conexion);
        }
        return vehiculos;
    }
    
    // ✅ NUEVO MÉTODO: BUSCAR VEHÍCULOS POR TEXTO
    public List<Vehiculo> buscarVehiculos(String texto) {
        List<Vehiculo> vehiculos = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            // Busca por Marca, Modelo o Matrícula que coincidan con el texto
            String sql = "SELECT * FROM vehiculos WHERE marca LIKE ? OR modelo LIKE ? OR matricula LIKE ? ORDER BY marca, modelo";
            stmt = conn.prepareStatement(sql);
            String pattern = "%" + texto + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);
            stmt.setString(3, pattern);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                vehiculos.add(mapResultSetToVehiculo(rs));
            }
            System.out.println("🔍 Búsqueda de '" + texto + "' encontró " + vehiculos.size() + " resultados.");
            
        } catch (SQLException e) {
            System.out.println("❌ Error al buscar vehículos: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn, conexion);
        }
        return vehiculos;
    }
    
    // Contar vehículos por estado
    public int contarVehiculosPorEstado(String estado) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        int count = 0;
        
        try {
            conn = conexion.Conectar();
            String sql = "SELECT COUNT(*) as total FROM vehiculos WHERE estado = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, estado);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                count = rs.getInt("total");
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al contar vehículos: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn, conexion);
        }
        return count;
    }
    
    public Vehiculo obtenerVehiculoPorId(int idVehiculo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        Vehiculo vehiculo = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "SELECT * FROM vehiculos WHERE id_vehiculo = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idVehiculo);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                vehiculo = mapResultSetToVehiculo(rs);
            }
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener vehículo: " + e.getMessage());
        } finally {
            cerrarRecursos(rs, stmt, conn, conexion);
        }
        return vehiculo;
    }
    
    // Crear Vehículo
    public String crearVehiculo(Vehiculo vehiculo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_CrearVehiculo(?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);
            
            stmt.setString(1, vehiculo.getMarca());
            stmt.setString(2, vehiculo.getModelo());
            stmt.setInt(3, vehiculo.getAnio());
            stmt.setString(4, vehiculo.getMatricula());
            stmt.setString(5, vehiculo.getTipo());
            stmt.setDouble(6, vehiculo.getPrecioDiario());
            stmt.setString(7, vehiculo.getEstado());
            stmt.registerOutParameter(8, Types.VARCHAR);
            
            stmt.execute();
            return stmt.getString(8);
            
        } catch (SQLException e) {
            System.out.println("❌ Error crear vehículo: " + e.getMessage());
            return "ERROR_BD";
        } finally {
            cerrarRecursos(null, stmt, conn, conexion);
        }
    }
    
    // Actualizar Vehículo
    public String actualizarVehiculo(Vehiculo vehiculo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ActualizarVehiculo(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);
            
            stmt.setInt(1, vehiculo.getIdVehiculo());
            stmt.setString(2, vehiculo.getMarca());
            stmt.setString(3, vehiculo.getModelo());
            stmt.setInt(4, vehiculo.getAnio());
            stmt.setString(5, vehiculo.getMatricula());
            stmt.setString(6, vehiculo.getTipo());
            stmt.setDouble(7, vehiculo.getPrecioDiario());
            stmt.setString(8, vehiculo.getEstado());
            stmt.registerOutParameter(9, Types.VARCHAR);
            
            stmt.execute();
            return stmt.getString(9);
            
        } catch (SQLException e) {
            System.out.println("❌ Error actualizar vehículo: " + e.getMessage());
            return "ERROR_BD";
        } finally {
            cerrarRecursos(null, stmt, conn, conexion);
        }
    }
    
    // Eliminar Vehículo
    public String eliminarVehiculo(int idVehiculo) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_EliminarVehiculo(?, ?)";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, idVehiculo);
            stmt.registerOutParameter(2, Types.VARCHAR);
            stmt.execute();
            return stmt.getString(2);
        } catch (SQLException e) {
            System.out.println("❌ Error eliminar vehículo: " + e.getMessage());
            return "ERROR_BD";
        } finally {
            cerrarRecursos(null, stmt, conn, conexion);
        }
    }
    
    // Cambiar Estado
    public String cambiarEstadoVehiculo(int idVehiculo, String estado) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_CambiarEstadoVehiculo(?, ?, ?)";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, idVehiculo);
            stmt.setString(2, estado);
            stmt.registerOutParameter(3, Types.VARCHAR);
            stmt.execute();
            return stmt.getString(3);
        } catch (SQLException e) {
            System.out.println("❌ Error cambiar estado: " + e.getMessage());
            return "ERROR_BD";
        } finally {
            cerrarRecursos(null, stmt, conn, conexion);
        }
    }

    // --- Helpers ---
    private Vehiculo mapResultSetToVehiculo(ResultSet rs) throws SQLException {
        Vehiculo v = new Vehiculo();
        v.setIdVehiculo(rs.getInt("id_vehiculo"));
        v.setMarca(rs.getString("marca"));
        v.setModelo(rs.getString("modelo"));
        v.setAnio(rs.getInt("anio"));
        v.setMatricula(rs.getString("matricula"));
        v.setTipo(rs.getString("tipo"));
        v.setPrecioDiario(rs.getDouble("precio_diario"));
        v.setEstado(rs.getString("estado"));
        return v;
    }

    private void cerrarRecursos(ResultSet rs, Statement stmt, Connection conn, ConexionBD conexion) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conexion != null) conexion.Desconectar();
        } catch (SQLException e) {
            System.out.println("❌ Error cerrando recursos: " + e.getMessage());
        }
    }
    
    //  Filtrar vehículos para el catálogo (Tipo y Disponibilidad por fecha)
    public List<Vehiculo> filtrarVehiculosCatalogo(String tipo, String fecha) {
        List<Vehiculo> vehiculos = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            
            // Construimos la consulta base: Solo autos que no estén en "Mantenimiento" o "Inactivo"
            StringBuilder query = new StringBuilder();
            query.append("SELECT * FROM vehiculos WHERE estado != 'Inactivo' AND estado != 'Mantenimiento' ");
            
            // 1. Filtro por TIPO
            if (tipo != null && !tipo.isEmpty() && !tipo.equals("Todos los modelos")) {
                query.append(" AND tipo = ? ");
            }
            
            // 2. Filtro por FECHA (Verificar que no tenga reservas activas ese día)
            if (fecha != null && !fecha.isEmpty()) {
                // Subconsulta: Excluir vehículos que tengan una reserva activa que incluya la fecha seleccionada
                query.append(" AND id_vehiculo NOT IN (");
                query.append("   SELECT id_vehiculo FROM reservas ");
                query.append("   WHERE estado = 'Activa' ");
                query.append("   AND ? BETWEEN fecha_inicio AND fecha_fin"); // '?' es la fecha seleccionada
                query.append(" )");
            }
            
            // Preparamos la sentencia
            stmt = conn.prepareStatement(query.toString());
            
            int index = 1;
            
            // Asignar parámetro TIPO si existe
            if (tipo != null && !tipo.isEmpty() && !tipo.equals("Todos los modelos")) {
                stmt.setString(index++, tipo);
            }
            
            // Asignar parámetro FECHA si existe
            if (fecha != null && !fecha.isEmpty()) {
                stmt.setString(index++, fecha);
            }
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Vehiculo vehiculo = new Vehiculo();
                vehiculo.setIdVehiculo(rs.getInt("id_vehiculo"));
                vehiculo.setMarca(rs.getString("marca"));
                vehiculo.setModelo(rs.getString("modelo"));
                vehiculo.setAnio(rs.getInt("anio"));
                vehiculo.setMatricula(rs.getString("matricula"));
                vehiculo.setTipo(rs.getString("tipo"));
                vehiculo.setPrecioDiario(rs.getDouble("precio_diario"));
                vehiculo.setEstado(rs.getString("estado"));
                vehiculos.add(vehiculo);
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error al filtrar catálogo: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {}
        }
        
        return vehiculos;
    }
}