package capaDatos;

import capaEntidad.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    public Cliente autenticar(String usuario, String contrasena) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexion.Conectar();

            String sql = "SELECT * FROM clientes WHERE usuario = ? AND contraseña = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, usuario);
            stmt.setString(2, contrasena);

            rs = stmt.executeQuery();

            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDni(rs.getString("dni"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setUsuario(rs.getString("usuario"));
                cliente.setIdCiudad(rs.getInt("id_ciudad"));
                cliente.setFechaRegistro(rs.getString("fecha_registro"));

                System.out.println("✅ Cliente autenticado: " + cliente.getNombre());
                return cliente;
            }

            System.out.println("❌ Cliente no encontrado: " + usuario);
            return null;

        } catch (SQLException e) {
            System.out.println("❌ Error en autenticar cliente: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }

    // Método para autenticar cliente con DNI y contraseña
    public String autenticarCliente(String dni, String contraseña) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = conexion.Conectar();
            System.out.println("🔐 Autenticando cliente - DNI: " + dni);

            String sql = "CALL sp_AutenticarCliente(?, ?, ?)";
            stmt = conn.prepareCall(sql);

            stmt.setString(1, dni);
            stmt.setString(2, contraseña);
            stmt.registerOutParameter(3, Types.VARCHAR);

            stmt.execute();

            String resultado = stmt.getString(3);
            System.out.println("🔑 Resultado autenticación: " + resultado);

            return resultado;

        } catch (SQLException e) {
            System.out.println("❌ Error al autenticar cliente: " + e.getMessage());
            e.printStackTrace();
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }

    // Método para obtener datos del cliente por DNI
    public Cliente obtenerClientePorDni(String dni) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexion.Conectar();
            String sql = "CALL sp_ObtenerClientePorDni(?)";
            stmt = conn.prepareCall(sql);
            stmt.setString(1, dni);

            rs = stmt.executeQuery();

            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDni(rs.getString("dni"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                cliente.setDireccion(rs.getString("direccion"));

                return cliente;
            }

        } catch (SQLException e) {
            System.out.println("❌ Error al obtener cliente: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }

        return null;
    }

    // Método registrarCliente actualizado (sin parámetro de usuario)
    public String registrarCliente(String nombre, String apellido, String dni,
            String telefono, String email, String direccion,
            String contraseña) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = conexion.Conectar();
            System.out.println("📝 Registrando cliente en BD - DNI: " + dni);

            String sql = "CALL sp_RegistrarCliente(?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);

            stmt.setString(1, nombre);
            stmt.setString(2, apellido);
            stmt.setString(3, dni);
            stmt.setString(4, telefono);
            stmt.setString(5, email);
            stmt.setString(6, direccion);
            stmt.setString(7, contraseña);
            stmt.registerOutParameter(8, Types.VARCHAR);

            stmt.execute();

            String resultado = stmt.getString(8);
            System.out.println("✅ Resultado registro: " + resultado);

            return resultado;

        } catch (SQLException e) {
            System.out.println("❌ Error al registrar cliente: " + e.getMessage());
            e.printStackTrace();
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }

    // NUEVO: Método para registrar cliente con ciudad
    public String registrarClienteConCiudad(String nombre, String apellido, String dni,
            String telefono, String email, String direccion,
            int idCiudad, String contraseña) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = conexion.Conectar();
            System.out.println("📝 Registrando cliente con ciudad - DNI: " + dni + ", Ciudad: " + idCiudad);

            String sql = "CALL sp_RegistrarCliente(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);

            stmt.setString(1, nombre);
            stmt.setString(2, apellido);
            stmt.setString(3, dni);
            stmt.setString(4, telefono);
            stmt.setString(5, email);
            stmt.setString(6, direccion);
            stmt.setInt(7, idCiudad);
            stmt.setString(8, contraseña);
            stmt.registerOutParameter(9, Types.VARCHAR);

            stmt.execute();

            String resultado = stmt.getString(9);
            System.out.println("✅ Resultado registro con ciudad: " + resultado);

            return resultado;

        } catch (SQLException e) {
            System.out.println("❌ Error al registrar cliente con ciudad: " + e.getMessage());
            e.printStackTrace();
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }

    // MÉTODO PARA OBTENER CLIENTE COMPLETO CON PROCEDIMIENTO ALMACENADO
    public Cliente obtenerClienteCompleto(int idCliente) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexion.Conectar();
            System.out.println("👤 Obteniendo cliente completo ID: " + idCliente);

            // Usar procedimiento almacenado
            String sql = "CALL sp_ObtenerClienteCompleto(?)";
            stmt = conn.prepareCall(sql);
            stmt.setInt(1, idCliente);

            rs = stmt.executeQuery();

            if (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDni(rs.getString("dni"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setIdCiudad(rs.getInt("id_ciudad"));
                cliente.setUsuario(rs.getString("usuario"));
                cliente.setFechaRegistro(rs.getString("fecha_registro"));
                cliente.setNombreCiudad(rs.getString("nombre_ciudad"));

                System.out.println("✅ Cliente obtenido: " + cliente.getNombre());
                return cliente;
            }

            System.out.println("❌ Cliente no encontrado ID: " + idCliente);
            return null;

        } catch (SQLException e) {
            System.out.println("❌ Error al obtener cliente completo: " + e.getMessage());
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Método para actualizar cliente desde Administrador
    public String actualizarCliente(Cliente cliente) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = conexion.Conectar();
            System.out.println("✏️ Actualizando cliente - ID: " + cliente.getIdCliente());

            String sql = "CALL sp_ActualizarCliente(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);

            stmt.setInt(1, cliente.getIdCliente());
            stmt.setString(2, cliente.getNombre());
            stmt.setString(3, cliente.getApellido());
            stmt.setString(4, cliente.getDni());
            stmt.setString(5, cliente.getTelefono());
            stmt.setString(6, cliente.getEmail());
            stmt.setString(7, cliente.getDireccion());
            stmt.setInt(8, cliente.getIdCiudad());
            stmt.registerOutParameter(9, Types.VARCHAR);

            stmt.execute();

            String resultado = stmt.getString(9);
            System.out.println("✅ Resultado actualización: " + resultado);

            return resultado;

        } catch (SQLException e) {
            System.out.println("❌ Error al actualizar cliente: " + e.getMessage());
            e.printStackTrace();
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
    }

    // Método para buscar clientes

    public List<Cliente> buscarClientes(String nombre, String dni, String email) {
        List<Cliente> clientes = new ArrayList<>();
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = conexion.Conectar();
            System.out.println("🔍 Buscando clientes - Nombre: " + nombre + ", DNI: " + dni + ", Email: " + email);

            String sql = "CALL sp_BuscarClientes(?, ?, ?)";
            stmt = conn.prepareCall(sql);

            // Manejar parámetros NULL correctamente
            if (nombre != null && !nombre.trim().isEmpty()) {
                stmt.setString(1, nombre.trim());
            } else {
                stmt.setNull(1, Types.VARCHAR);
            }

            if (dni != null && !dni.trim().isEmpty()) {
                stmt.setString(2, dni.trim());
            } else {
                stmt.setNull(2, Types.VARCHAR);
            }

            if (email != null && !email.trim().isEmpty()) {
                stmt.setString(3, email.trim());
            } else {
                stmt.setNull(3, Types.VARCHAR);
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                Cliente cliente = new Cliente();
                cliente.setIdCliente(rs.getInt("id_cliente"));
                cliente.setNombre(rs.getString("nombre"));
                cliente.setApellido(rs.getString("apellido"));
                cliente.setDni(rs.getString("dni"));
                cliente.setTelefono(rs.getString("telefono"));
                cliente.setEmail(rs.getString("email"));
                cliente.setDireccion(rs.getString("direccion"));
                cliente.setIdCiudad(rs.getInt("id_ciudad"));
                cliente.setNombreCiudad(rs.getString("nombre_ciudad"));
                cliente.setFechaRegistro(rs.getString("fecha_registro"));
                clientes.add(cliente);
            }

            System.out.println("✅ Clientes encontrados: " + clientes.size());

        } catch (SQLException e) {
            System.out.println("❌ Error al buscar clientes: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null)
                    rs.close();
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando recursos: " + e.getMessage());
            }
        }
        return clientes;
    }

    // MÉTODO PARA ACTUALIZAR PERFIL (YA LO TENÍAS CON PROCEDIMIENTO ALMACENADO)
    public String actualizarPerfilCliente(Cliente cliente) {
        ConexionBD conexion = new ConexionBD();
        Connection conn = null;
        CallableStatement stmt = null;

        try {
            conn = conexion.Conectar();
            System.out.println("✏️ Actualizando perfil de cliente - ID: " + cliente.getIdCliente());

            String sql = "CALL sp_ActualizarPerfilCliente(?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareCall(sql);

            stmt.setInt(1, cliente.getIdCliente());
            stmt.setString(2, cliente.getNombre());
            stmt.setString(3, cliente.getApellido());
            stmt.setString(4, cliente.getTelefono());
            stmt.setString(5, cliente.getEmail());
            stmt.setString(6, cliente.getDireccion());
            stmt.setInt(7, cliente.getIdCiudad());
            stmt.registerOutParameter(8, java.sql.Types.VARCHAR);

            stmt.execute();

            String resultado = stmt.getString(8);
            System.out.println("✅ Resultado actualización: " + resultado);

            return resultado;

        } catch (SQLException e) {
            System.out.println("❌ Error en actualizarPerfilCliente: " + e.getMessage());
            e.printStackTrace();
            return "ERROR_BD";
        } finally {
            try {
                if (stmt != null)
                    stmt.close();
                conexion.Desconectar();
            } catch (SQLException e) {
                System.out.println("❌ Error cerrando conexión: " + e.getMessage());
            }
        }
    }

}