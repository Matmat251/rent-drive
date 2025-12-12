package servlets;

import capaDatos.ClienteDAO;
import capaDatos.ReservaDAO;
import capaEntidad.Cliente;
import capaEntidad.Reserva;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AccesoClienteServlet", urlPatterns = {"/acceso-cliente"})
public class AccesoClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;
    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario (DNI y contraseña)
        String dni = request.getParameter("dni");
        String contraseña = request.getParameter("contraseña");
        
        System.out.println("🔐 Cliente intentando acceder - DNI: " + dni);
        
        // 2. Validar que no estén vacíos
        if (dni == null || dni.trim().isEmpty() || 
            contraseña == null || contraseña.trim().isEmpty()) {
            
            System.out.println("❌ DNI o contraseña vacíos");
            request.setAttribute("error", "DNI y contraseña son obligatorios");
            request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
            return;
        }
        
        // 3. Validar formato DNI (8 dígitos)
        if (!dni.matches("\\d{8}")) {
            System.out.println("❌ Formato DNI inválido: " + dni);
            request.setAttribute("error", "El DNI debe tener 8 dígitos numéricos");
            request.setAttribute("dni", dni); // Mantener DNI en el formulario
            request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
            return;
        }
        
        // 4. Autenticar cliente con DNI y contraseña
        String resultado = clienteDAO.autenticarCliente(dni, contraseña);
        
        // 5. Manejar resultado de la autenticación
        switch(resultado) {
            case "EXITO":
                // ✅ Autenticación exitosa
                System.out.println("✅ Cliente autenticado: " + dni);
                
                // Obtener datos completos del cliente
                Cliente cliente = clienteDAO.obtenerClientePorDni(dni);
                
                if (cliente != null) {
                    // Obtener reservas del cliente
                    List<Reserva> reservas = reservaDAO.obtenerReservasPorCliente(dni);
                    
                    // ✅ CREAR SESIÓN CON EL NOMBRE CORRECTO
                    HttpSession session = request.getSession();
                    session.setAttribute("clienteLogueado", cliente); // ✅ Nombre correcto para el JSP
                    session.setAttribute("dniCliente", dni);
                    session.setAttribute("nombreCliente", cliente.getNombre() + " " + cliente.getApellido());
                    session.setAttribute("clienteAutenticado", true);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutos
                    
                    System.out.println("✅ Sesión creada para cliente: " + cliente.getNombre() + " " + cliente.getApellido());
                    System.out.println("📋 Datos completos guardados: " + cliente.toString());
                    System.out.println("📊 Reservas encontradas: " + reservas.size());
                    
                    // Redirigir a mis reservas o catálogo
                    response.sendRedirect(request.getContextPath() + "/client/mis-reservas.jsp");
                    
                } else {
                    System.out.println("❌ Error al obtener datos del cliente autenticado");
                    request.setAttribute("error", "Error al cargar datos del cliente. Intente nuevamente.");
                    request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
                }
                break;
                
            case "USUARIO_NO_EXISTE":
                System.out.println("❌ DNI no existe: " + dni);
                request.setAttribute("error", "El DNI no está registrado en el sistema");
                request.setAttribute("dni", dni); // Mantener DNI en el formulario
                request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
                break;
                
            case "CONTRASEÑA_INCORRECTA":
                System.out.println("❌ Contraseña incorrecta para DNI: " + dni);
                request.setAttribute("error", "La contraseña es incorrecta");
                request.setAttribute("dni", dni); // Mantener DNI en el formulario
                request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
                break;
                
            case "ERROR_BD":
                System.out.println("❌ Error de BD en autenticación");
                request.setAttribute("error", "Error en el sistema. Intente nuevamente.");
                request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
                break;
                
            default:
                System.out.println("❌ Error desconocido en autenticación: " + resultado);
                request.setAttribute("error", "Error inesperado. Intente nuevamente.");
                request.getRequestDispatcher("/auth/login-cliente.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir GET a la página de login cliente
        response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para autenticación de clientes con DNI y contraseña";
    }
}