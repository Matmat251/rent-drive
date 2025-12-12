package capaDatos;

import capaEntidad.Reserva;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;

public class ReservaDAO {
    
    // Crear reserva real en la base de datos - CON PROCEDIMIENTO ALMACENADO
   public int crearReserva(int idVehiculo, String nombre, String dni, String telefono, 
                           String email, String fechaInicio, String fechaFin, 
                           String metodoPago) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("📝 Creando reserva para vehículo: " + idVehiculo);
            
            // Obtener o crear cliente real
            int idCliente = obtenerOcrearCliente(nombre, dni, telefono, email, conn);
            System.out.println("✅ ID Cliente obtenido/creado: " + idCliente);
            
            // Usar el procedimiento almacenado con el ID real del cliente
            String sql = "CALL sp_CrearReservaReal(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);
            
            stmt.setInt(1, idCliente);
            stmt.setInt(2, idVehiculo);
            stmt.setInt(3, 2); // id_empleado (por defecto - recepcionista)
            stmt.setDate(4, Date.valueOf(fechaInicio));
            stmt.setDate(5, Date.valueOf(fechaFin));
            stmt.setString(6, metodoPago);
            stmt.setString(7, nombre);
            stmt.setString(8, dni);
            stmt.setString(9, telefono);
            stmt.setString(10, email);
            stmt.registerOutParameter(11, Types.INTEGER);
            
            stmt.execute();
            
            int idReserva = stmt.getInt(11);
            System.out.println("✅ Reserva creada con ID: " + idReserva + " para cliente: " + idCliente);
            return idReserva; // MODIFICADO: Retornar el ID en lugar de boolean
            
        } catch (SQLException e) {
            System.out.println("❌ Error al crear reserva: " + e.getMessage());
            e.printStackTrace();
            return -1; // MODIFICADO: Retornar -1 en caso de error
        } finally {
            try {
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
   public boolean crearReservaBoolean(int idVehiculo, String nombre, String dni, String telefono, 
                                  String email, String fechaInicio, String fechaFin, 
                                  String metodoPago) {
    int idReserva = crearReserva(idVehiculo, nombre, dni, telefono, email, fechaInicio, fechaFin, metodoPago);
    return idReserva > 0;
}

    // MÉTODO ALTERNATIVO: Crear reserva usando consulta directa para obtener el ID generado
    public int crearReservaDirecta(int idVehiculo, String nombre, String dni, String telefono, 
                                  String email, String fechaInicio, String fechaFin, 
                                  String metodoPago) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("📝 Creando reserva directa para vehículo: " + idVehiculo);
            
            // Obtener o crear cliente real
            int idCliente = obtenerOcrearCliente(nombre, dni, telefono, email, conn);
            System.out.println("✅ ID Cliente obtenido/creado: " + idCliente);
            
            // Calcular días y total
            long diff = Date.valueOf(fechaFin).getTime() - Date.valueOf(fechaInicio).getTime();
            int dias = (int) (diff / (1000 * 60 * 60 * 24));
            
            // Obtener precio diario del vehículo
            double precioDiario = obtenerPrecioDiarioVehiculo(idVehiculo, conn);
            double total = dias * precioDiario;
            
            // Insertar reserva y obtener ID generado
            String sql = "INSERT INTO reservas (id_cliente, id_vehiculo, id_empleado, fecha_inicio, " +
                        "fecha_fin, dias, total, metodo_pago, estado, fecha_reserva, nombre_cliente, " +
                        "dni_cliente, telefono_cliente, email_cliente) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMADA', NOW(), ?, ?, ?, ?)";
            
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setInt(1, idCliente);
            stmt.setInt(2, idVehiculo);
            stmt.setInt(3, 2); // id_empleado por defecto
            stmt.setDate(4, Date.valueOf(fechaInicio));
            stmt.setDate(5, Date.valueOf(fechaFin));
            stmt.setInt(6, dias);
            stmt.setDouble(7, total);
            stmt.setString(8, metodoPago);
            stmt.setString(9, nombre);
            stmt.setString(10, dni);
            stmt.setString(11, telefono);
            stmt.setString(12, email);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int idReserva = generatedKeys.getInt(1);
                    System.out.println("✅ Reserva creada exitosamente con ID: " + idReserva);
                    return idReserva;
                }
            }
            
            return -1;
            
        } catch (SQLException e) {
            System.out.println("❌ Error al crear reserva directa: " + e.getMessage());
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // Método auxiliar para obtener precio diario del vehículo
    private double obtenerPrecioDiarioVehiculo(int idVehiculo, Connection conn) throws SQLException {
        String sql = "SELECT precio_diario FROM vehiculos WHERE id_vehiculo = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, idVehiculo);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getDouble("precio_diario");
            }
        }
        return 50.0; // Precio por defecto si no se encuentra
    }
    
    // Buscar o crear cliente (método existente - sin cambios)
    private int obtenerOcrearCliente(String nombre, String dni, String telefono, 
                                    String email, Connection conn) throws SQLException {
        // Primero buscar si el cliente ya existe por DNI
        String sqlBuscar = "SELECT id_cliente FROM clientes WHERE dni = ?";
        PreparedStatement stmtBuscar = conn.prepareStatement(sqlBuscar);
        stmtBuscar.setString(1, dni);
        ResultSet rs = stmtBuscar.executeQuery();
        
        if (rs.next()) {
            int idClienteExistente = rs.getInt("id_cliente");
            System.out.println("✅ Cliente existente encontrado: " + idClienteExistente);
            rs.close();
            stmtBuscar.close();
            return idClienteExistente;
        }
        
        rs.close();
        stmtBuscar.close();
        
        // Si no existe, crear nuevo cliente
        System.out.println("🆕 Creando nuevo cliente con DNI: " + dni);
        String sqlInsert = "INSERT INTO clientes (nombre, apellido, dni, telefono, email) VALUES (?, '', ?, ?, ?)";
        PreparedStatement stmtInsert = conn.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
        stmtInsert.setString(1, nombre);
        stmtInsert.setString(2, dni);
        stmtInsert.setString(3, telefono);
        stmtInsert.setString(4, email);
        stmtInsert.executeUpdate();
        
        ResultSet keys = stmtInsert.getGeneratedKeys();
        if (keys.next()) {
            int nuevoIdCliente = keys.getInt(1);
            System.out.println("✅ Nuevo cliente creado con ID: " + nuevoIdCliente);
            keys.close();
            stmtInsert.close();
            return nuevoIdCliente;
        }
        
        // Fallback: usar cliente por defecto si hay error
        System.out.println("⚠️ Usando cliente por defecto (fallback)");
        return 1;
    }
    
    // Obtener reservas reales por DNI del cliente - CON PROCEDIMIENTO ALMACENADO
public List<Reserva> obtenerReservasPorCliente(String dniCliente) {
        List<Reserva> reservas = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("🔍 Buscando reservas para DNI: " + dniCliente);
            
            String sql = "CALL sp_ObtenerReservasPorCliente(?)";
            stmt = conn.prepareCall(sql);
            stmt.setString(1, dniCliente);
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setMarcaVehiculo(rs.getString("marca"));
                reserva.setModeloVehiculo(rs.getString("modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                reserva.setNombreCliente(rs.getString("nombre_cliente"));
                reserva.setDniCliente(rs.getString("dni"));
                
                reservas.add(reserva);
                
                System.out.println("📋 Reserva encontrada: " + reserva.getMarcaVehiculo() + " " + reserva.getModeloVehiculo() + " - Estado: " + reserva.getEstado());
            }
            
            System.out.println("✅ Total reservas encontradas: " + reservas.size() + " para DNI: " + dniCliente);
            
        } catch (SQLException e) {
            System.out.println("❌ Error al obtener reservas: " + e.getMessage());
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
        
        return reservas;
    }
    
    // Cancelar reserva - CON PROCEDIMIENTO ALMACENADO
    public boolean cancelarReserva(int idReserva) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("🗑️ Cancelando reserva: " + idReserva);
            
            String sql = "CALL sp_CancelarReserva(?)";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, idReserva);
            
            stmt.execute();
            System.out.println("✅ Reserva cancelada: " + idReserva);
            return true;
            
        } catch (SQLException e) {
            System.out.println("❌ Error al cancelar reserva: " + e.getMessage());
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
    
    // Listar todas las reservas - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public List<Reserva> listarTodasReservas() {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ListarTodasReservas()";
            stmt = conn.prepareCall(sql);
            
            rs = stmt.executeQuery();
            
            List<Reserva> reservas = new ArrayList<>();
            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                reservas.add(reserva);
            }
            
            System.out.println("✅ Todas las reservas encontradas (procedimiento): " + reservas.size());
            return reservas;
            
        } catch (SQLException e) {
            System.out.println("❌ Error con procedimiento, usando fallback: " + e.getMessage());
            return listarTodasReservasFallback(conn);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // FALLBACK para listar reservas
    private List<Reserva> listarTodasReservasFallback(Connection conn) {
        List<Reserva> reservas = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT r.id_reserva, r.fecha_inicio, r.fecha_fin, r.dias, r.total, " +
                        "r.metodo_pago, r.estado, c.nombre as cliente_nombre, c.apellido as cliente_apellido, " +
                        "c.dni as cliente_dni, v.marca as vehiculo_marca, v.modelo as vehiculo_modelo " +
                        "FROM reservas r " +
                        "JOIN clientes c ON r.id_cliente = c.id_cliente " +
                        "JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo " +
                        "ORDER BY r.id_reserva DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                reservas.add(reserva);
            }
            
            System.out.println("✅ Fallback: Reservas obtenidas por consulta directa: " + reservas.size());
            
        } catch (SQLException e) {
            System.out.println("❌ Error en fallback: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos fallback: " + e.getMessage());
            }
        }
        
        return reservas;
    }
    
    // Obtener detalles completos de una reserva - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public Reserva obtenerDetallesReserva(int idReserva) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ObtenerDetallesReserva(?)";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, idReserva);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                // Información adicional para detalles
                reserva.setTelefonoCliente(rs.getString("cliente_telefono"));
                reserva.setEmailCliente(rs.getString("cliente_email"));
                reserva.setMatriculaVehiculo(rs.getString("vehiculo_matricula"));
                reserva.setTipoVehiculo(rs.getString("vehiculo_tipo"));
                reserva.setPrecioDiario(rs.getDouble("precio_diario"));
                
                return reserva;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error con procedimiento, usando fallback: " + e.getMessage());
            return obtenerDetallesReservaFallback(idReserva, conn);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        return null;
    }
    
    // FALLBACK para detalles de reserva
    private Reserva obtenerDetallesReservaFallback(int idReserva, Connection conn) {
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT r.*, c.nombre as cliente_nombre, c.apellido as cliente_apellido, " +
                        "c.dni as cliente_dni, c.telefono as cliente_telefono, c.email as cliente_email, " +
                        "v.marca as vehiculo_marca, v.modelo as vehiculo_modelo, v.matricula as vehiculo_matricula, " +
                        "v.tipo as vehiculo_tipo, v.precio_diario " +
                        "FROM reservas r " +
                        "JOIN clientes c ON r.id_cliente = c.id_cliente " +
                        "JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo " +
                        "WHERE r.id_reserva = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idReserva);
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                reserva.setTelefonoCliente(rs.getString("cliente_telefono"));
                reserva.setEmailCliente(rs.getString("cliente_email"));
                reserva.setMatriculaVehiculo(rs.getString("vehiculo_matricula"));
                reserva.setTipoVehiculo(rs.getString("vehiculo_tipo"));
                reserva.setPrecioDiario(rs.getDouble("precio_diario"));
                
                return reserva;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en fallback de detalles: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos fallback: " + e.getMessage());
            }
        }
        
        return null;
    }
    
    // Cambiar estado de reserva - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public String cambiarEstadoReserva(int idReserva, String nuevoEstado) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        
        try {
            conn = conexion.Conectar();
            System.out.println("🔄 Cambiando estado reserva " + idReserva + " a: " + nuevoEstado);
            
            String sql = "CALL sp_CambiarEstadoReserva(?, ?, ?)";
            stmt = conn.prepareCall(sql);
            
            stmt.setInt(1, idReserva);
            stmt.setString(2, nuevoEstado);
            stmt.registerOutParameter(3, Types.VARCHAR);
            
            stmt.execute();
            
            String resultado = stmt.getString(3);
            System.out.println("✅ Resultado cambio estado reserva: " + resultado);
            
            return resultado;
            
        } catch (SQLException e) {
            System.out.println("❌ Error con procedimiento, usando fallback: " + e.getMessage());
            return cambiarEstadoReservaFallback(idReserva, nuevoEstado, conn);
        } finally {
            try {
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // FALLBACK para cambiar estado
    private String cambiarEstadoReservaFallback(int idReserva, String nuevoEstado, Connection conn) {
        PreparedStatement stmt = null;
        
        try {
            String sql = "UPDATE reservas SET estado = ? WHERE id_reserva = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, nuevoEstado);
            stmt.setInt(2, idReserva);
            
            int filasAfectadas = stmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                System.out.println("✅ Fallback: Estado de reserva cambiado exitosamente");
                return "EXITO";
            } else {
                return "NO_ENCONTRADA";
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error en fallback de cambio estado: " + e.getMessage());
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos fallback: " + e.getMessage());
            }
        }
    }
    
    // =============================================
    // MÉTODOS PARA REPORTES - CON PROCEDIMIENTOS + FALLBACKS
    // =============================================
    
    // Contar reservas por estado - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public Map<String, Integer> contarReservasPorEstado() {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ContarReservasPorEstado()";
            stmt = conn.prepareCall(sql);
            
            rs = stmt.executeQuery();
            
            Map<String, Integer> estadisticas = new HashMap<>();
            while (rs.next()) {
                estadisticas.put(rs.getString("estado"), rs.getInt("total"));
            }
            
            // Asegurar que existan todas las claves necesarias
            if (!estadisticas.containsKey("Activa")) estadisticas.put("Activa", 0);
            if (!estadisticas.containsKey("Finalizada")) estadisticas.put("Finalizada", 0);
            if (!estadisticas.containsKey("Cancelada")) estadisticas.put("Cancelada", 0);
            
            System.out.println("✅ Estadísticas de reservas (procedimiento): " + estadisticas);
            return estadisticas;
            
        } catch (SQLException e) {
            System.out.println("❌ Error con procedimiento, usando fallback: " + e.getMessage());
            return contarReservasPorEstadoFallback(conn);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // FALLBACK para contar reservas por estado
    private Map<String, Integer> contarReservasPorEstadoFallback(Connection conn) {
        Map<String, Integer> estadisticas = new HashMap<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT estado, COUNT(*) as total FROM reservas GROUP BY estado";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                estadisticas.put(rs.getString("estado"), rs.getInt("total"));
            }
            
            // Valores por defecto
            if (!estadisticas.containsKey("Activa")) estadisticas.put("Activa", 0);
            if (!estadisticas.containsKey("Finalizada")) estadisticas.put("Finalizada", 0);
            if (!estadisticas.containsKey("Cancelada")) estadisticas.put("Cancelada", 0);
            
            System.out.println("✅ Fallback: Estadísticas de reservas: " + estadisticas);
            
        } catch (SQLException e) {
            System.out.println("❌ Error en fallback de estadísticas: " + e.getMessage());
            estadisticas.put("Activa", 0);
            estadisticas.put("Finalizada", 0);
            estadisticas.put("Cancelada", 0);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos fallback: " + e.getMessage());
            }
        }
        
        return estadisticas;
    }
    
    // Obtener ingresos mensuales - CON PROCEDIMIENTO ALMACENADO + FALLBACK
public Map<String, Double> obtenerIngresosMensuales() {
    ConexionBD conexion = new ConexionBD();
    Connection conn = null;
    CallableStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = conexion.Conectar();
        
        // INTENTAR con procedimiento si existe
        try {
            String sql = "CALL sp_ObtenerIngresosMensuales()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            Map<String, Double> ingresos = new LinkedHashMap<>();
            while (rs.next()) {
                ingresos.put(rs.getString("mes"), rs.getDouble("total"));
            }
            
            if (!ingresos.isEmpty()) {
                System.out.println("✅ Ingresos mensuales (procedimiento): " + ingresos.size());
                return ingresos;
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Procedimiento sp_ObtenerIngresosMensuales no disponible, usando fallback");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        // FALLBACK: Consulta directa
        PreparedStatement pstmt = null;
        try {
            String sql = "SELECT DATE_FORMAT(fecha_inicio, '%Y-%m') as mes, " +
                        "COALESCE(SUM(total), 0) as total_ingresos " +
                        "FROM reservas " +
                        "WHERE estado IN ('Finalizada', 'Activa') AND fecha_inicio IS NOT NULL " +
                        "GROUP BY DATE_FORMAT(fecha_inicio, '%Y-%m') " +
                        "ORDER BY mes DESC LIMIT 6";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            Map<String, Double> ingresos = new LinkedHashMap<>();
            while (rs.next()) {
                ingresos.put(rs.getString("mes"), rs.getDouble("total_ingresos"));
            }
            
            System.out.println("✅ Fallback: Ingresos mensuales obtenidos: " + ingresos.size());
            
            if (ingresos.isEmpty()) {
                System.out.println("📊 No hay datos reales, usando datos de ejemplo");
                return crearDatosEjemploIngresos();
            }
            
            return ingresos;
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        
    } catch (SQLException e) {
        System.out.println("❌ Error general en obtenerIngresosMensuales: " + e.getMessage());
        return crearDatosEjemploIngresos();
    } finally {
        try {
            conexion.Desconectar();
        } catch (Exception e) {
            System.out.println("❌ Error cerrando conexión: " + e.getMessage());
        }
    }
}
   
    
    // Obtener reservas por mes - CON PROCEDIMIENTO ALMACENADO + FALLBACK
   public Map<String, Integer> obtenerReservasPorMes() {
    ConexionBD conexion = new ConexionBD();
    Connection conn = null;
    CallableStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = conexion.Conectar();
        
        // INTENTAR con procedimiento si existe
        try {
            String sql = "CALL sp_ObtenerReservasPorMes()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            Map<String, Integer> reservas = new LinkedHashMap<>();
            while (rs.next()) {
                reservas.put(rs.getString("mes"), rs.getInt("total"));
            }
            
            if (!reservas.isEmpty()) {
                System.out.println("✅ Reservas por mes (procedimiento): " + reservas.size());
                return reservas;
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Procedimiento sp_ObtenerReservasPorMes no disponible, usando fallback");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        // FALLBACK: Consulta directa
        PreparedStatement pstmt = null;
        try {
            String sql = "SELECT DATE_FORMAT(fecha_inicio, '%Y-%m') as mes, COUNT(*) as total " +
                        "FROM reservas " +
                        "WHERE fecha_inicio IS NOT NULL " +
                        "GROUP BY DATE_FORMAT(fecha_inicio, '%Y-%m') " +
                        "ORDER BY mes DESC LIMIT 6";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            Map<String, Integer> reservas = new LinkedHashMap<>();
            while (rs.next()) {
                reservas.put(rs.getString("mes"), rs.getInt("total"));
            }
            
            System.out.println("✅ Fallback: Reservas por mes obtenidas: " + reservas.size());
            
            if (reservas.isEmpty()) {
                System.out.println("📊 No hay datos reales, usando datos de ejemplo");
                return crearDatosEjemploReservas();
            }
            
            return reservas;
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        
    } catch (SQLException e) {
        System.out.println("❌ Error general en obtenerReservasPorMes: " + e.getMessage());
        return crearDatosEjemploReservas();
    } finally {
        try {
            conexion.Desconectar();
        } catch (Exception e) {
            System.out.println("❌ Error cerrando conexión: " + e.getMessage());
        }
    }
}

    // Obtener métodos de pago más utilizados - CON PROCEDIMIENTO ALMACENADO + FALLBACK
   public Map<String, Integer> obtenerMetodosPagoPopulares() {
    ConexionBD conexion = new ConexionBD();
    Connection conn = null;
    CallableStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = conexion.Conectar();
        
        // INTENTAR con procedimiento si existe
        try {
            String sql = "CALL sp_ObtenerMetodosPagoPopulares()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            Map<String, Integer> metodosPago = new HashMap<>();
            while (rs.next()) {
                metodosPago.put(rs.getString("metodo_pago"), rs.getInt("total"));
            }
            
            if (!metodosPago.isEmpty()) {
                System.out.println("✅ Métodos de pago (procedimiento): " + metodosPago.size());
                return metodosPago;
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Procedimiento sp_ObtenerMetodosPagoPopulares no disponible, usando fallback");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        // FALLBACK: Consulta directa
        PreparedStatement pstmt = null;
        try {
            String sql = "SELECT metodo_pago, COUNT(*) as total " +
                        "FROM reservas " +
                        "WHERE metodo_pago IS NOT NULL " +
                        "GROUP BY metodo_pago " +
                        "ORDER BY total DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            Map<String, Integer> metodosPago = new HashMap<>();
            while (rs.next()) {
                metodosPago.put(rs.getString("metodo_pago"), rs.getInt("total"));
            }
            
            System.out.println("✅ Fallback: Métodos de pago obtenidos: " + metodosPago.size());
            
            if (metodosPago.isEmpty()) {
                System.out.println("📊 No hay datos reales, usando datos de ejemplo");
                return crearDatosEjemploMetodosPago();
            }
            
            return metodosPago;
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        
    } catch (SQLException e) {
        System.out.println("❌ Error general en obtenerMetodosPagoPopulares: " + e.getMessage());
        return crearDatosEjemploMetodosPago();
    } finally {
        try {
            conexion.Desconectar();
        } catch (Exception e) {
            System.out.println("❌ Error cerrando conexión: " + e.getMessage());
        }
    }
}
    

    // Obtener vehículos más rentables - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public Map<String, Double> obtenerVehiculosMasRentables() {
    ConexionBD conexion = new ConexionBD();
    Connection conn = null;
    CallableStatement stmt = null;
    ResultSet rs = null;
    
    try {
        conn = conexion.Conectar();
        
        // INTENTAR con procedimiento si existe
        try {
            String sql = "CALL sp_ObtenerVehiculosMasRentables()";
            stmt = conn.prepareCall(sql);
            rs = stmt.executeQuery();
            
            Map<String, Double> vehiculosRentables = new LinkedHashMap<>();
            while (rs.next()) {
                String vehiculo = rs.getString("marca") + " " + rs.getString("modelo");
                vehiculosRentables.put(vehiculo, rs.getDouble("total_ingresos"));
            }
            
            if (!vehiculosRentables.isEmpty()) {
                System.out.println("✅ Vehículos rentables (procedimiento): " + vehiculosRentables.size());
                return vehiculosRentables;
            }
        } catch (SQLException e) {
            System.out.println("⚠️ Procedimiento sp_ObtenerVehiculosMasRentables no disponible, usando fallback");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        // FALLBACK: Consulta directa
        PreparedStatement pstmt = null;
        try {
            String sql = "SELECT v.marca, v.modelo, COALESCE(SUM(r.total), 0) as total_ingresos " +
                        "FROM vehiculos v " +
                        "LEFT JOIN reservas r ON v.id_vehiculo = r.id_vehiculo " +
                        "AND r.estado IN ('Finalizada', 'Activa') " +
                        "GROUP BY v.id_vehiculo, v.marca, v.modelo " +
                        "ORDER BY total_ingresos DESC " +
                        "LIMIT 5";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            Map<String, Double> vehiculosRentables = new LinkedHashMap<>();
            while (rs.next()) {
                String vehiculo = rs.getString("marca") + " " + rs.getString("modelo");
                vehiculosRentables.put(vehiculo, rs.getDouble("total_ingresos"));
            }
            
            System.out.println("✅ Fallback: Vehículos rentables obtenidos: " + vehiculosRentables.size());
            
            if (vehiculosRentables.isEmpty()) {
                System.out.println("📊 No hay datos reales, usando datos de ejemplo");
                return crearDatosEjemploVehiculosRentables();
            }
            
            return vehiculosRentables;
            
        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }
        
    } catch (SQLException e) {
        System.out.println("❌ Error general en obtenerVehiculosMasRentables: " + e.getMessage());
        return crearDatosEjemploVehiculosRentables();
    } finally {
        try {
            conexion.Desconectar();
        } catch (Exception e) {
            System.out.println("❌ Error cerrando conexión: " + e.getMessage());
        }
    }
}
    
    // FALLBACK para vehículos rentables
    
    
    // =============================================
    // MÉTODOS AUXILIARES PARA DATOS DE EJEMPLO
    // =============================================
    
    private Map<String, Double> crearDatosEjemploIngresos() {
        Map<String, Double> ingresos = new LinkedHashMap<>();
        ingresos.put("2024-01", 1500.0);
        ingresos.put("2024-02", 2300.0);
        ingresos.put("2024-03", 1800.0);
        ingresos.put("2024-04", 2100.0);
        System.out.println("📊 Usando datos de ejemplo para ingresos mensuales");
        return ingresos;
    }
    
    private Map<String, Integer> crearDatosEjemploReservas() {
        Map<String, Integer> reservas = new LinkedHashMap<>();
        reservas.put("2024-01", 5);
        reservas.put("2024-02", 8);
        reservas.put("2024-03", 6);
        reservas.put("2024-04", 7);
        System.out.println("📊 Usando datos de ejemplo para reservas por mes");
        return reservas;
    }
    
    private Map<String, Integer> crearDatosEjemploMetodosPago() {
        Map<String, Integer> metodosPago = new HashMap<>();
        metodosPago.put("Tarjeta", 12);
        metodosPago.put("Efectivo", 5);
        metodosPago.put("Transferencia", 3);
        System.out.println("📊 Usando datos de ejemplo para métodos de pago");
        return metodosPago;
    }
    
    private Map<String, Double> crearDatosEjemploVehiculosRentables() {
        Map<String, Double> vehiculosRentables = new LinkedHashMap<>();
        vehiculosRentables.put("Toyota Corolla", 4500.0);
        vehiculosRentables.put("Honda Civic", 3800.0);
        vehiculosRentables.put("Ford Focus", 2900.0);
        vehiculosRentables.put("Nissan Sentra", 2700.0);
        System.out.println("📊 Usando datos de ejemplo para vehículos rentables");
        return vehiculosRentables;
    }
    
    // =============================================
    // MÉTODOS ADICIONALES
    // =============================================
    
    // Buscar reservas por criterios - CON PROCEDIMIENTO ALMACENADO + FALLBACK
    public List<Reserva> buscarReservas(String dniCliente, String matriculaVehiculo, String estado, String fechaDesde, String fechaHasta) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_BuscarReservas(?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);
            
            // Establecer parámetros (pueden ser nulos)
            if (dniCliente != null && !dniCliente.trim().isEmpty()) {
                stmt.setString(1, dniCliente.trim());
            } else {
                stmt.setNull(1, Types.VARCHAR);
            }
            
            if (matriculaVehiculo != null && !matriculaVehiculo.trim().isEmpty()) {
                stmt.setString(2, matriculaVehiculo.trim().toUpperCase());
            } else {
                stmt.setNull(2, Types.VARCHAR);
            }
            
            if (estado != null && !estado.trim().isEmpty()) {
                stmt.setString(3, estado.trim());
            } else {
                stmt.setNull(3, Types.VARCHAR);
            }
            
            if (fechaDesde != null && !fechaDesde.trim().isEmpty()) {
                stmt.setDate(4, Date.valueOf(fechaDesde));
            } else {
                stmt.setNull(4, Types.DATE);
            }
            
            if (fechaHasta != null && !fechaHasta.trim().isEmpty()) {
                stmt.setDate(5, Date.valueOf(fechaHasta));
            } else {
                stmt.setNull(5, Types.DATE);
            }
            
            rs = stmt.executeQuery();
            
            List<Reserva> reservas = new ArrayList<>();
            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                reservas.add(reserva);
            }
            
            System.out.println("✅ Reservas encontradas en búsqueda (procedimiento): " + reservas.size());
            return reservas;
            
        } catch (SQLException e) {
            System.out.println("❌ Error con procedimiento, usando fallback: " + e.getMessage());
            return buscarReservasFallback(dniCliente, matriculaVehiculo, estado, fechaDesde, fechaHasta, conn);
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
    
    // FALLBACK para buscar reservas
    private List<Reserva> buscarReservasFallback(String dniCliente, String matriculaVehiculo, String estado, 
                                                String fechaDesde, String fechaHasta, Connection conn) {
        List<Reserva> reservas = new ArrayList<>();
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            // Construir consulta dinámica
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT r.id_reserva, r.fecha_inicio, r.fecha_fin, r.dias, r.total, ");
            sql.append("r.metodo_pago, r.estado, c.nombre as cliente_nombre, c.apellido as cliente_apellido, ");
            sql.append("c.dni as cliente_dni, v.marca as vehiculo_marca, v.modelo as vehiculo_modelo ");
            sql.append("FROM reservas r ");
            sql.append("JOIN clientes c ON r.id_cliente = c.id_cliente ");
            sql.append("JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo ");
            sql.append("WHERE 1=1 ");
            
            List<Object> parametros = new ArrayList<>();
            
            if (dniCliente != null && !dniCliente.trim().isEmpty()) {
                sql.append("AND c.dni LIKE ? ");
                parametros.add("%" + dniCliente.trim() + "%");
            }
            
            if (matriculaVehiculo != null && !matriculaVehiculo.trim().isEmpty()) {
                sql.append("AND v.matricula LIKE ? ");
                parametros.add("%" + matriculaVehiculo.trim().toUpperCase() + "%");
            }
            
            if (estado != null && !estado.trim().isEmpty()) {
                sql.append("AND r.estado = ? ");
                parametros.add(estado.trim());
            }
            
            if (fechaDesde != null && !fechaDesde.trim().isEmpty()) {
                sql.append("AND r.fecha_inicio >= ? ");
                parametros.add(Date.valueOf(fechaDesde));
            }
            
            if (fechaHasta != null && !fechaHasta.trim().isEmpty()) {
                sql.append("AND r.fecha_fin <= ? ");
                parametros.add(Date.valueOf(fechaHasta));
            }
            
            sql.append("ORDER BY r.id_reserva DESC");
            
            stmt = conn.prepareStatement(sql.toString());
            
            // Establecer parámetros
            for (int i = 0; i < parametros.size(); i++) {
                stmt.setObject(i + 1, parametros.get(i));
            }
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                Reserva reserva = new Reserva();
                reserva.setIdReserva(rs.getInt("id_reserva"));
                reserva.setNombreCliente(rs.getString("cliente_nombre") + " " + rs.getString("cliente_apellido"));
                reserva.setDniCliente(rs.getString("cliente_dni"));
                reserva.setMarcaVehiculo(rs.getString("vehiculo_marca"));
                reserva.setModeloVehiculo(rs.getString("vehiculo_modelo"));
                reserva.setFechaInicio(rs.getString("fecha_inicio"));
                reserva.setFechaFin(rs.getString("fecha_fin"));
                reserva.setDias(rs.getInt("dias"));
                reserva.setTotal(rs.getDouble("total"));
                reserva.setMetodoPago(rs.getString("metodo_pago"));
                reserva.setEstado(rs.getString("estado"));
                
                reservas.add(reserva);
            }
            
            System.out.println("✅ Fallback: Reservas encontradas en búsqueda: " + reservas.size());
            
        } catch (SQLException e) {
            System.out.println("❌ Error en fallback de búsqueda: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos fallback: " + e.getMessage());
            }
        }
        
        return reservas;
    }
    /**
 * Obtener el ID de la última reserva creada por un cliente
 */
 public int obtenerUltimaReservaPorCliente(String dniCliente) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            String sql = "SELECT r.id_reserva FROM reservas r " +
                        "JOIN clientes c ON r.id_cliente = c.id_cliente " +
                        "WHERE c.dni = ? " +
                        "ORDER BY r.id_reserva DESC LIMIT 1";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, dniCliente);
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                int idReserva = rs.getInt("id_reserva");
                System.out.println("✅ Última reserva obtenida: " + idReserva);
                return idReserva;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error obteniendo última reserva: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        
        return 0;
    }
    
    // Verificar disponibilidad completa (reservas + bloqueos)
    public String verificarDisponibilidadCompleta(int idVehiculo, String fechaInicio, String fechaFin) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = conexion.Conectar();
            
            // Verificar si el vehículo existe y está disponible
            String sqlVehiculo = "SELECT estado FROM vehiculos WHERE id_vehiculo = ?";
            stmt = conn.prepareStatement(sqlVehiculo);
            stmt.setInt(1, idVehiculo);
            rs = stmt.executeQuery();
            
            if (!rs.next()) {
                return "VEHICULO_NO_EXISTE";
            }
            
            String estadoVehiculo = rs.getString("estado");
            if (!"Disponible".equals(estadoVehiculo)) {
                return "VEHICULO_NO_DISPONIBLE";
            }
            
            rs.close();
            stmt.close();
            
            // Verificar si hay reservas activas en el rango de fechas
            String sqlReservas = "SELECT COUNT(*) as conflictos " +
                               "FROM reservas " +
                               "WHERE id_vehiculo = ? " +
                               "AND estado = 'Activa' " +
                               "AND ((fecha_inicio BETWEEN ? AND ?) " +
                               "OR (fecha_fin BETWEEN ? AND ?) " +
                               "OR (? BETWEEN fecha_inicio AND fecha_fin) " +
                               "OR (? BETWEEN fecha_inicio AND fecha_fin))";
            
            stmt = conn.prepareStatement(sqlReservas);
            stmt.setInt(1, idVehiculo);
            stmt.setDate(2, Date.valueOf(fechaInicio));
            stmt.setDate(3, Date.valueOf(fechaFin));
            stmt.setDate(4, Date.valueOf(fechaInicio));
            stmt.setDate(5, Date.valueOf(fechaFin));
            stmt.setDate(6, Date.valueOf(fechaInicio));
            stmt.setDate(7, Date.valueOf(fechaFin));
            
            rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt("conflictos") > 0) {
                return "CONFLICTO_RESERVAS";
            }
            
            return "DISPONIBLE";
            
        } catch (SQLException e) {
            System.out.println("❌ Error verificando disponibilidad: " + e.getMessage());
            e.printStackTrace();
            return "ERROR";
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }
}