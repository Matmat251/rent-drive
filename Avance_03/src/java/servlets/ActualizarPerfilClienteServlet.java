package servlets;

import capaDatos.ClienteDAO;
import capaEntidad.Cliente;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ActualizarPerfilClienteServlet", urlPatterns = {"/actualizar-perfil"})
public class ActualizarPerfilClienteServlet extends HttpServlet {
    
    private ClienteDAO clienteDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Cliente clienteSession = (session != null) ? (Cliente) session.getAttribute("cliente") : null;
        
        if (clienteSession == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
            return;
        }
        
        try {
            // ==================== DEBUG 1: MOSTRAR TODOS LOS PARÁMETROS ====================
            System.out.println("\n🔍 === DEBUG INICIO ACTUALIZACIÓN PERFIL ===");
            System.out.println("📦 TODOS LOS PARÁMETROS RECIBIDOS:");
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                System.out.println("   📌 " + paramName + " = '" + paramValue + "'");
            }
            
            Cliente cliente = new Cliente();
            cliente.setIdCliente(clienteSession.getIdCliente());
            
            // ==================== DEBUG 2: CADA CAMPO INDIVIDUAL ====================
            String nombre = request.getParameter("nombre");
            String apellido = request.getParameter("apellido");
            String telefono = request.getParameter("telefono");
            String email = request.getParameter("email");
            String direccion = request.getParameter("direccion");
            String idCiudadStr = request.getParameter("idCiudad");
            
            System.out.println("\n📝 VALORES INDIVIDUALES DE CAMPOS:");
            System.out.println("   👤 Nombre: '" + nombre + "'");
            System.out.println("   👤 Apellido: '" + apellido + "'");
            System.out.println("   📞 Teléfono: '" + telefono + "'");
            System.out.println("   📧 Email: '" + email + "'");
            System.out.println("   🏠 Dirección: '" + direccion + "'");
            System.out.println("   🏙️ ID Ciudad (string): '" + idCiudadStr + "'");
            
            cliente.setNombre(nombre);
            cliente.setApellido(apellido);
            cliente.setTelefono(telefono);
            cliente.setEmail(email);
            cliente.setDireccion(direccion);
            
            // ==================== DEBUG 3: PROCESAMIENTO ID CIUDAD ====================
            System.out.println("\n🔧 PROCESANDO ID CIUDAD:");
            if (idCiudadStr != null && !idCiudadStr.trim().isEmpty()) {
                try {
                    int idCiudad = Integer.parseInt(idCiudadStr.trim());
                    cliente.setIdCiudad(idCiudad);
                    System.out.println("   ✅ ID Ciudad convertido exitosamente: " + idCiudad);
                } catch (NumberFormatException e) {
                    System.out.println("   ❌ ERROR: No se pudo convertir ID Ciudad '" + idCiudadStr + "' a número");
                    cliente.setIdCiudad(0);
                }
            } else {
                System.out.println("   ⚠️ ADVERTENCIA: ID Ciudad está vacío o nulo");
                cliente.setIdCiudad(0);
            }
            
            // ==================== DEBUG 4: RESUMEN FINAL ====================
            System.out.println("\n📋 RESUMEN FINAL DE DATOS A ACTUALIZAR:");
            System.out.println("   🔑 ID Cliente: " + cliente.getIdCliente());
            System.out.println("   👤 Nombre: " + cliente.getNombre());
            System.out.println("   👤 Apellido: " + cliente.getApellido());
            System.out.println("   📞 Teléfono: " + cliente.getTelefono());
            System.out.println("   📧 Email: " + cliente.getEmail());
            System.out.println("   🏠 Dirección: " + cliente.getDireccion());
            System.out.println("   🏙️ ID Ciudad (final): " + cliente.getIdCiudad());
            
            System.out.println("\n🚀 LLAMANDO AL DAO PARA ACTUALIZAR...");
            String resultado = clienteDAO.actualizarPerfilCliente(cliente);
            System.out.println("🎯 RESULTADO DEL DAO: " + resultado);
            
            if ("EXITO".equals(resultado)) {
                // Actualizar datos en sesión
                clienteSession.setNombre(cliente.getNombre());
                clienteSession.setApellido(cliente.getApellido());
                clienteSession.setTelefono(cliente.getTelefono());
                clienteSession.setEmail(cliente.getEmail());
                clienteSession.setDireccion(cliente.getDireccion());
                clienteSession.setIdCiudad(cliente.getIdCiudad());
                
                session.setAttribute("cliente", clienteSession);
                session.setAttribute("mensajeExito", "Perfil actualizado correctamente");
                System.out.println("✅ PERFIL ACTUALIZADO EXITOSAMENTE");
            } else {
                String errorMsg = obtenerMensajeError(resultado);
                session.setAttribute("error", errorMsg);
                System.out.println("❌ ERROR AL ACTUALIZAR: " + errorMsg);
            }
            
            System.out.println("🔚 === DEBUG FIN ACTUALIZACIÓN PERFIL ===\n");
            response.sendRedirect(request.getContextPath() + "/perfil-cliente");
            
        } catch (Exception e) {
            System.out.println("💥 ERROR NO CONTROLADO: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error interno del servidor: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/perfil-cliente");
        }
    }
    
    private String obtenerMensajeError(String codigoError) {
        switch (codigoError) {
            case "TELEFONO_EXISTE": return "El teléfono ya está registrado por otro cliente";
            case "EMAIL_EXISTE": return "El email ya está registrado por otro cliente";
            case "ERROR_BD": return "Error en la base de datos";
            default: return "Error desconocido al actualizar perfil";
        }
    }
}