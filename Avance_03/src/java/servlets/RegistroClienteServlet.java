package servlets;

import capaDatos.ClienteDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "RegistroClienteServlet", urlPatterns = {"/registro-cliente"})
public class RegistroClienteServlet extends HttpServlet {

    private ClienteDAO clienteDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetros del formulario con contraseña
        String nombre = request.getParameter("nombre");
        String apellido = request.getParameter("apellido");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String direccion = request.getParameter("direccion");
        String idCiudadStr = request.getParameter("idCiudad");
        String contraseña = request.getParameter("contraseña");
        String confirmarContraseña = request.getParameter("confirmarContraseña");
        
        System.out.println("📝 Procesando registro para DNI: " + dni);
        System.out.println("👤 Nombre: " + nombre + " " + apellido);
        System.out.println("🏙️ Ciudad ID: " + idCiudadStr);
        System.out.println("🔑 Contraseña recibida");
        
        // 2. Validaciones básicas
        if (nombre == null || nombre.trim().isEmpty() ||
            apellido == null || apellido.trim().isEmpty() ||
            dni == null || !dni.matches("\\d{8}") ||
            telefono == null || telefono.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            contraseña == null || contraseña.trim().isEmpty()) {
            
            System.out.println("❌ Validación fallida - campos incompletos");
            request.setAttribute("error", "Todos los campos obligatorios deben ser completados");
            mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
            request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
            return;
        }
        
        // 3. Validar formato de email
        if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            System.out.println("❌ Email con formato inválido: " + email);
            request.setAttribute("error", "El formato del email no es válido");
            mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
            request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
            return;
        }
        
        // 4. Validar que las contraseñas coincidan
        if (!contraseña.equals(confirmarContraseña)) {
            System.out.println("❌ Las contraseñas no coinciden");
            request.setAttribute("error", "Las contraseñas no coinciden");
            mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
            request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
            return;
        }
        
        // 5. Validar longitud mínima de contraseña
        if (contraseña.length() < 6) {
            System.out.println("❌ Contraseña muy corta");
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
            request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
            return;
        }
        
        // 6. Convertir idCiudad a entero
        int idCiudad = 0;
        if (idCiudadStr != null && !idCiudadStr.isEmpty()) {
            try {
                idCiudad = Integer.parseInt(idCiudadStr);
            } catch (NumberFormatException e) {
                System.out.println("❌ ID de ciudad inválido: " + idCiudadStr);
                request.setAttribute("error", "Seleccione una ciudad válida");
                mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
                request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
                return;
            }
        }
        
        // 7. Registrar cliente usando el procedimiento almacenado CON CIUDAD
        String resultado;
        if (idCiudad > 0) {
            resultado = clienteDAO.registrarClienteConCiudad(
                nombre.trim(), 
                apellido.trim(), 
                dni.trim(), 
                telefono.trim(), 
                email.trim(), 
                direccion != null ? direccion.trim() : "",
                idCiudad,
                contraseña.trim()
            );
        } else {
            // Fallback al método antiguo si no hay ciudad seleccionada
            resultado = clienteDAO.registrarCliente(
                nombre.trim(), 
                apellido.trim(), 
                dni.trim(), 
                telefono.trim(), 
                email.trim(), 
                direccion != null ? direccion.trim() : "",
                contraseña.trim()
            );
        }
        
        // 8. Manejar resultado
        System.out.println("🎯 Resultado del registro: " + resultado);
        
        switch(resultado) {
            case "EXITO":
                System.out.println("✅ Cliente registrado exitosamente: " + dni);
                
                // Guardar mensaje en sesión para mostrar en login
                HttpSession session = request.getSession();
                session.setAttribute("mensajeExito", "🎉 ¡Registro exitoso! Ahora puedes iniciar sesión con tu DNI y contraseña.");
                
                // Redirigir al login de clientes
                response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
                break;
                
            case "DNI_EXISTE":
                request.setAttribute("error", "❌ El DNI " + dni + " ya está registrado en el sistema");
                break;
                
            case "TELEFONO_EXISTE":
                request.setAttribute("error", "❌ El teléfono " + telefono + " ya está registrado en el sistema");
                break;
                
            case "EMAIL_EXISTE":
                request.setAttribute("error", "❌ El email " + email + " ya está registrado en el sistema");
                break;
                
            case "ERROR_BD":
                request.setAttribute("error", "⚠️ Error en la base de datos. Por favor, intenta nuevamente.");
                break;
                
            default:
                request.setAttribute("error", "⚠️ Error inesperado en el registro. Intente nuevamente.");
        }
        
        if (!"EXITO".equals(resultado)) {
            // Mantener los datos en el formulario en caso de error
            mantenerDatosFormulario(request, nombre, apellido, dni, telefono, email, direccion, idCiudadStr);
            request.getRequestDispatcher("/auth/registro-cliente.jsp").forward(request, response);
        }
    }
    
    // Método auxiliar para mantener datos en el formulario (ACTUALIZADO)
    private void mantenerDatosFormulario(HttpServletRequest request, String nombre, String apellido, 
                                       String dni, String telefono, String email, String direccion, String idCiudad) {
        request.setAttribute("nombre", nombre);
        request.setAttribute("apellido", apellido);
        request.setAttribute("dni", dni);
        request.setAttribute("telefono", telefono);
        request.setAttribute("email", email);
        request.setAttribute("direccion", direccion);
        request.setAttribute("idCiudad", idCiudad);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigir GET al formulario de registro
        System.out.println("🔗 Redirigiendo a formulario de registro");
        response.sendRedirect("auth/registro-cliente.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para registro de nuevos clientes con contraseña y ciudad";
    }
}