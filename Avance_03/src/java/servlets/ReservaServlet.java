package servlets;

import capaDatos.ReservaDAO;
import capaDatos.BloqueoCalendarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReservaServlet", urlPatterns = {"/procesar-reserva"})
public class ReservaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    private BloqueoCalendarioDAO bloqueoDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
        bloqueoDAO = new BloqueoCalendarioDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // VERIFICAR SESIÓN DE CLIENTE 
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        capaEntidad.Cliente cliente = (session != null) ? (capaEntidad.Cliente) session.getAttribute("cliente") : null;

        if (cliente == null) {
            System.out.println("❌ No hay sesión de cliente para procesar reserva");
            response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
            return;
        }

        System.out.println("✅ Cliente procesando reserva: " + cliente.getNombre() + " (ID: " + cliente.getIdCliente() + ")");

        
        
        System.out.println("📝 Procesando reserva ...");
        
        // 1. Obtener parámetros del formulario
        String idVehiculo = request.getParameter("idVehiculo");
        String nombre = request.getParameter("nombre");
        String dni = request.getParameter("dni");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String metodoPago = request.getParameter("metodoPago");
        String brevete = request.getParameter("brevete");
        
        System.out.println("🚗 ID Vehículo: " + idVehiculo);
        System.out.println("👤 Nombre: " + nombre);
        System.out.println("🆔 DNI: " + dni);
        System.out.println("📞 Teléfono: " + telefono);
        System.out.println("📧 Email: " + email);
        System.out.println("📅 Fecha Inicio: " + fechaInicio);
        System.out.println("📅 Fecha Fin: " + fechaFin);
        System.out.println("💳 Método Pago: " + metodoPago);
        System.out.println("🚦 Brevete: " + brevete);
        
        // 2. Validar datos obligatorios
        if (idVehiculo == null || idVehiculo.trim().isEmpty() ||
            nombre == null || nombre.trim().isEmpty() ||
            dni == null || dni.trim().isEmpty() ||
            fechaInicio == null || fechaInicio.trim().isEmpty() ||
            fechaFin == null || fechaFin.trim().isEmpty() ||
            metodoPago == null || metodoPago.trim().isEmpty()) {
            
            System.out.println("❌ Datos incompletos en el formulario");
            response.sendRedirect("client/reserva-error.jsp");
            return;
        }
        
        // 3. Validar que el brevete esté marcado
        if (!"on".equals(brevete)) {
            System.out.println("❌ Brevete no confirmado");
            response.sendRedirect("client/reserva-error.jsp?error=brevete");
            return;
        }
        
        // 4. VALIDAR DISPONIBILIDAD ANTES DE CREAR RESERVA
        try {
            int idVehiculoInt = Integer.parseInt(idVehiculo);
            String resultadoDisponibilidad = reservaDAO.verificarDisponibilidadCompleta(idVehiculoInt, fechaInicio, fechaFin);
            
            System.out.println("🔍 Resultado verificación disponibilidad: " + resultadoDisponibilidad);
            
            if (!"DISPONIBLE".equals(resultadoDisponibilidad)) {
                String mensajeError = "";
                String tipoError = "";
                
                switch (resultadoDisponibilidad) {
                    case "VEHICULO_NO_EXISTE":
                        mensajeError = "❌ El vehículo seleccionado no existe";
                        tipoError = "vehiculo_no_existe";
                        break;
                    case "VEHICULO_NO_DISPONIBLE":
                        mensajeError = "❌ El vehículo no está disponible para alquiler en este momento";
                        tipoError = "vehiculo_no_disponible";
                        break;
                    case "CONFLICTO_RESERVAS":
                        mensajeError = "❌ El vehículo ya tiene reservas activas en las fechas seleccionadas. Por favor, elige otras fechas.";
                        tipoError = "conflicto_reservas";
                        break;
                    case "CONFLICTO_BLOQUEOS":
                        mensajeError = "❌ El vehículo está programado para mantenimiento en las fechas seleccionadas. Por favor, elige otras fechas.";
                        tipoError = "conflicto_bloqueos";
                        break;
                    default:
                        mensajeError = "❌ Error verificando disponibilidad del vehículo";
                        tipoError = "error_disponibilidad";
                }
                
                System.out.println("❌ Reserva rechazada: " + mensajeError);
                
                // Guardar datos en sesión para volver a mostrar el formulario
                request.getSession().setAttribute("errorReserva", mensajeError);
                request.getSession().setAttribute("tipoError", tipoError);
                request.getSession().setAttribute("datosFormulario", crearMapaDatosFormulario(
                    idVehiculo, nombre, dni, telefono, email, fechaInicio, fechaFin, metodoPago));
                
                response.sendRedirect("client/reserva-form.jsp?idVehiculo=" + idVehiculo + "&error=" + tipoError);
                return;
            }
            
            // 5. Si está disponible, proceder con la creación de la reserva
            System.out.println("✅ Vehículo disponible, creando reserva...");
            
            // CORRECCIÓN: Usar el método correcto que existe en ReservaDAO
            int idReserva = reservaDAO.crearReserva(
                idVehiculoInt, 
                nombre, 
                dni, 
                telefono, 
                email,
                fechaInicio, 
                fechaFin, 
                metodoPago
            );
            
            // 6. Redirigir según el resultado
            if (idReserva > 0) {
                // Guardar DNI en sesión para mostrar sus reservas
                request.getSession().setAttribute("dniCliente", dni);
                // Guardar ID de reserva en sesión para la página de éxito
                request.getSession().setAttribute("idReserva", String.valueOf(idReserva));
                // Limpiar errores de sesión si existían
                request.getSession().removeAttribute("errorReserva");
                request.getSession().removeAttribute("tipoError");
                request.getSession().removeAttribute("datosFormulario");
                
                System.out.println("✅ Reserva exitosa para DNI: " + dni + " | ID Reserva: " + idReserva);
                
                // CORRECCIÓN: Redirigir a la página de éxito con el ID de reserva
                response.sendRedirect("client/reserva-exitosa.jsp?idReserva=" + idReserva);
            } else {
                System.out.println("❌ Error al crear reserva en BD - ID de reserva no válido: " + idReserva);
                request.getSession().setAttribute("errorReserva", "❌ Error al procesar la reserva en la base de datos");
                response.sendRedirect("client/reserva-form.jsp?idVehiculo=" + idVehiculo + "&error=bd");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Error en formato de ID vehículo: " + e.getMessage());
            request.getSession().setAttribute("errorReserva", "❌ Error en el formato del vehículo seleccionado");
            response.sendRedirect("client/reserva-form.jsp?error=formato");
        } catch (Exception e) {
            System.out.println("❌ Error general: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorReserva", "❌ Error interno del sistema");
            response.sendRedirect("client/reserva-form.jsp?error=general");
        }
    }
    
    // Método auxiliar para crear mapa de datos del formulario
    private java.util.Map<String, String> crearMapaDatosFormulario(
            String idVehiculo, String nombre, String dni, String telefono, 
            String email, String fechaInicio, String fechaFin, String metodoPago) {
        
        java.util.Map<String, String> datos = new java.util.HashMap<>();
        datos.put("idVehiculo", idVehiculo);
        datos.put("nombre", nombre);
        datos.put("dni", dni);
        datos.put("telefono", telefono != null ? telefono : "");
        datos.put("email", email != null ? email : "");
        datos.put("fechaInicio", fechaInicio);
        datos.put("fechaFin", fechaFin);
        datos.put("metodoPago", metodoPago);
        
        return datos;
    }

    @Override
    public String getServletInfo() {
        return "Servlet para procesar reservas reales de vehículos con verificación de disponibilidad";
    }
}