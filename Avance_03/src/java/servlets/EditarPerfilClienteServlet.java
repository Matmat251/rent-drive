package servlets;

import capaDatos.ClienteDAO;
import capaDatos.CiudadDAO;
import capaEntidad.Cliente;
import capaEntidad.Ciudad;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EditarPerfilClienteServlet", urlPatterns = {"/editar-perfil"})
public class EditarPerfilClienteServlet extends HttpServlet {
    
    private ClienteDAO clienteDAO;
    private CiudadDAO ciudadDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
        ciudadDAO = new CiudadDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Cliente cliente = (session != null) ? (Cliente) session.getAttribute("cliente") : null;
        
        if (cliente == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
            return;
        }
        
        try {
            System.out.println("\n🔍 === DEBUG CARGA FORMULARIO EDICIÓN ===");
            System.out.println("👤 Cliente en sesión - ID: " + cliente.getIdCliente() + ", Nombre: " + cliente.getNombre());
            
            // Obtener datos actualizados del cliente
            Cliente clienteActualizado = clienteDAO.obtenerClienteCompleto(cliente.getIdCliente());
            System.out.println("📊 Cliente actualizado obtenido: " + (clienteActualizado != null ? "SÍ" : "NO"));
            
            if (clienteActualizado != null) {
                System.out.println("   🏙️ ID Ciudad actual del cliente: " + clienteActualizado.getIdCiudad());
            }
            
            // Obtener ciudades para el select
            List<Ciudad> ciudades = ciudadDAO.obtenerCiudadesActivas();
            System.out.println("🏙️ Número de ciudades cargadas: " + (ciudades != null ? ciudades.size() : "NULL"));
            
            if (ciudades != null) {
                for (Ciudad ciudad : ciudades) {
                    System.out.println("   📍 " + ciudad.getIdCiudad() + ": " + ciudad.getNombreCiudad() + 
                                     (clienteActualizado != null && clienteActualizado.getIdCiudad() == ciudad.getIdCiudad() ? " ← ACTUAL" : ""));
                }
            }
            
            if (clienteActualizado != null) {
                request.setAttribute("cliente", clienteActualizado);
                request.setAttribute("ciudades", ciudades);
                request.getRequestDispatcher("/client/editar-perfil.jsp").forward(request, response);
            } else {
                System.out.println("❌ No se pudo cargar la información del cliente");
                session.setAttribute("error", "No se pudo cargar la información del perfil");
                response.sendRedirect(request.getContextPath() + "/perfil-cliente");
            }
            
            System.out.println("🔚 === DEBUG FIN CARGA FORMULARIO ===\n");
            
        } catch (Exception e) {
            System.out.println("💥 ERROR EN CARGA FORMULARIO: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Error al cargar el formulario de edición");
            response.sendRedirect(request.getContextPath() + "/perfil-cliente");
        }
    }
}