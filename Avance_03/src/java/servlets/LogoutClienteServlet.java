package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LogoutClienteServlet", urlPatterns = {"/logout-cliente"})
public class LogoutClienteServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String dniCliente = (String) session.getAttribute("dniCliente");
            System.out.println("👤 Cliente cerrando sesión - DNI: " + dniCliente);
            
            session.removeAttribute("dniCliente");
            session.removeAttribute("clienteAutenticado");
            session.invalidate();
        }
        
        // Redirigir al login de clientes
        response.sendRedirect("auth/login-cliente.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para cerrar sesión de clientes";
    }
}