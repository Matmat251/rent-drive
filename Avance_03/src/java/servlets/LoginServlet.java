package servlets;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import capaDatos.EmpleadoDAO;
import capaEntidad.Empleado;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private EmpleadoDAO empleadoDAO;
    
    @Override
    public void init() {
        empleadoDAO = new EmpleadoDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");
        
        System.out.println("🔐 Intentando login: " + usuario);
        
        // 2. Validar que no estén vacíos
        if (usuario == null || usuario.trim().isEmpty() || 
            contrasena == null || contrasena.trim().isEmpty()) {
            
            request.setAttribute("error", "Usuario y contraseña son obligatorios");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }
        
        // 3. Autenticar empleado
        Empleado empleado = empleadoDAO.autenticar(usuario, contrasena);
        
        // 4. Verificar si la autenticación fue exitosa
        if (empleado != null) {
            System.out.println("✅ Login exitoso: " + empleado.getNombre() + " - Cargo: " + empleado.getCargo());
            
            // Login exitoso - Crear sesión
            HttpSession session = request.getSession();
            session.setAttribute("empleado", empleado);
            session.setMaxInactiveInterval(30 * 60); // 30 minutos
            
            // ✅ SOLUCIÓN: Redirigir según el cargo
            if ("Administrador".equals(empleado.getCargo())) {
                System.out.println("🎯 Redirigiendo administrador a dashboard");
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                System.out.println("🎯 Redirigiendo empleado a catálogo");
                response.sendRedirect("vehiculos");
            }
            
        } else {
            System.out.println("❌ Login fallido para: " + usuario);
            
            // Login fallido
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir GET a la página de login
        response.sendRedirect("auth/login.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para autenticación de empleados";
    }
}