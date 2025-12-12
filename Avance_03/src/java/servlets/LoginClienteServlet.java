package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import capaDatos.ClienteDAO;
import capaEntidad.Cliente;





@WebServlet(name = "LoginClienteServlet", urlPatterns = {"/login-cliente"})
public class LoginClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        
        System.out.println("🔐 Cliente intentando login: " + usuario);
        
        // 2. Validar que no estén vacíos
        if (usuario == null || usuario.trim().isEmpty() || 
            contrasena == null || contrasena.trim().isEmpty()) {
            
            System.out.println("❌ ERROR: Usuario o contraseña vacíos");
            request.setAttribute("error", "Usuario y contraseña son obligatorios");
            request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
            return;
        }
        
        // 3. Autenticar CLIENTE (no empleado)
        Cliente cliente = clienteDAO.autenticar(usuario, contrasena);
        
        // 4. Verificar si la autenticación fue exitosa
        if (cliente != null) {
            System.out.println("✅ Login CLIENTE exitoso: " + cliente.getNombre());
            
            // Login exitoso - Crear sesión de CLIENTE
            HttpSession session = request.getSession();
            session.setAttribute("cliente", cliente);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos
            
            // Redirigir al catálogo de clientes
            System.out.println("🎯 Redirigiendo cliente a catálogo");
            response.sendRedirect("client/catalogo.jsp");
            
        } else {
            System.out.println("❌ Login CLIENTE fallido para: " + usuario);
            
            // Login fallido
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
        }        
    }
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir GET a la página de login de clientes
        response.sendRedirect("auth/login-cliente.jsp");
    }
    
    
    
    
}