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

@WebServlet(name = "PerfilClienteServlet", urlPatterns = {"/perfil-cliente"})
public class PerfilClienteServlet extends HttpServlet {
    
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
            // Usar el cliente de la sesión directamente
            request.setAttribute("cliente", cliente);
            
            // Intentar cargar ciudades, si falla continuar sin ellas
            try {
                List<Ciudad> ciudades = ciudadDAO.obtenerCiudadesActivas();
                request.setAttribute("ciudades", ciudades);
            } catch (Exception e) {
                System.out.println("⚠️ No se pudieron cargar las ciudades: " + e.getMessage());
            }
            
            request.getRequestDispatcher("/client/perfil-cliente.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error al cargar el perfil: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/client/mis-reservas.jsp");
        }
    }
}