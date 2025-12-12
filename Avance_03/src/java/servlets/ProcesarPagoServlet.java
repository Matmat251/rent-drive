package servlets;

import capaDatos.ReservaDAO;
import capaEntidad.Cliente;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProcesarPagoServlet", urlPatterns = {"/procesar-pago"})
public class ProcesarPagoServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Cliente clienteLogueado = (Cliente) session.getAttribute("clienteLogueado");
        
        if (clienteLogueado == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
            return;
        }
        
        System.out.println("💳 Procesando pago...");
        
        // Obtener parámetros
        String idVehiculoParam = request.getParameter("idVehiculo");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String metodoPago = request.getParameter("metodoPago");
        String numeroTarjeta = request.getParameter("numeroTarjeta");
        String nombreTitular = request.getParameter("nombreTitular");
        String fechaVencimiento = request.getParameter("fechaVencimiento");
        String cvv = request.getParameter("cvv");
        
        System.out.println("🚗 ID Vehículo: " + idVehiculoParam);
        System.out.println("📅 Fechas: " + fechaInicio + " - " + fechaFin);
        System.out.println("💳 Método Pago: " + metodoPago);
        if (numeroTarjeta != null) {
            // Mostrar solo últimos 4 dígitos para seguridad
            String tarjetaSegura = numeroTarjeta.length() >= 4 ? 
                "****" + numeroTarjeta.substring(numeroTarjeta.length() - 4) : "****";
            System.out.println("💳 Tarjeta: " + tarjetaSegura);
        }
        
        // Validar datos obligatorios
        if (idVehiculoParam == null || idVehiculoParam.trim().isEmpty() ||
            fechaInicio == null || fechaInicio.trim().isEmpty() ||
            fechaFin == null || fechaFin.trim().isEmpty() ||
            metodoPago == null || metodoPago.trim().isEmpty()) {
            
            System.out.println("❌ Datos incompletos en el formulario de pago");
            session.setAttribute("errorPago", "Por favor, complete todos los campos obligatorios");
            response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
            return;
        }
        
        // Validar datos de tarjeta si el método es tarjeta
        if ("tarjeta".equals(metodoPago)) {
            if (numeroTarjeta == null || numeroTarjeta.trim().isEmpty() ||
                nombreTitular == null || nombreTitular.trim().isEmpty() ||
                fechaVencimiento == null || fechaVencimiento.trim().isEmpty() ||
                cvv == null || cvv.trim().isEmpty()) {
                
                System.out.println("❌ Datos de tarjeta incompletos");
                session.setAttribute("errorPago", "Por favor, complete todos los datos de la tarjeta");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
                return;
            }
            
            // CORRECCIÓN: Validación más flexible del número de tarjeta
            String numeroTarjetaLimpio = numeroTarjeta.replaceAll("[\\s-]+", "");
            
            if (!validarNumeroTarjeta(numeroTarjetaLimpio)) {
                System.out.println("❌ Formato de tarjeta inválido: " + numeroTarjeta);
                session.setAttribute("errorPago", "Número de tarjeta inválido. Debe tener entre 13 y 19 dígitos");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
                return;
            }
            
            // CORRECCIÓN: Validar fecha de vencimiento
            if (!validarFechaVencimiento(fechaVencimiento)) {
                System.out.println("❌ Fecha de vencimiento inválida: " + fechaVencimiento);
                session.setAttribute("errorPago", "Fecha de vencimiento inválida o tarjeta expirada");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
                return;
            }
            
            // CORRECCIÓN: Validar CVV
            if (!validarCVV(cvv)) {
                System.out.println("❌ CVV inválido: " + cvv);
                session.setAttribute("errorPago", "CVV inválido. Debe tener 3 o 4 dígitos");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
                return;
            }
            
            // CORRECCIÓN: Validar nombre del titular
            if (!validarNombreTitular(nombreTitular)) {
                System.out.println("❌ Nombre del titular inválido: " + nombreTitular);
                session.setAttribute("errorPago", "Nombre del titular inválido. Solo se permiten letras y espacios");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculoParam);
                return;
            }
        }
        
        try {
            int idVehiculo = Integer.parseInt(idVehiculoParam);
            
            // Verificar disponibilidad antes de procesar el pago
            String disponibilidad = reservaDAO.verificarDisponibilidadCompleta(
                idVehiculo, fechaInicio, fechaFin
            );
            
            if (!"DISPONIBLE".equals(disponibilidad)) {
                System.out.println("❌ Vehículo no disponible: " + disponibilidad);
                String mensajeError = obtenerMensajeErrorDisponibilidad(disponibilidad);
                session.setAttribute("errorPago", mensajeError);
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculo);
                return;
            }
            
            // Crear reserva y obtener el ID directamente
            int idReserva = reservaDAO.crearReserva(
                idVehiculo,
                clienteLogueado.getNombre() + " " + clienteLogueado.getApellido(),
                clienteLogueado.getDni(),
                clienteLogueado.getTelefono(),
                clienteLogueado.getEmail(),
                fechaInicio,
                fechaFin,
                metodoPago
            );
            
            if (idReserva > 0) {
                System.out.println("✅ Pago procesado y reserva creada correctamente. ID Reserva: " + idReserva);
                
                // Guardar datos para la boleta
                session.setAttribute("idReservaExitosa", idReserva);
                session.setAttribute("fechaInicioReserva", fechaInicio);
                session.setAttribute("fechaFinReserva", fechaFin);
                session.setAttribute("clienteReserva", clienteLogueado);
                
                // Limpiar posibles errores anteriores
                session.removeAttribute("errorPago");
                
                // Redirigir a página de éxito con opción de descargar boleta
                response.sendRedirect("client/pago-exitoso.jsp?idReserva=" + idReserva);
                
            } else {
                System.out.println("❌ Error al crear reserva - ID no válido: " + idReserva);
                session.setAttribute("errorPago", "Error al procesar el pago. No se pudo crear la reserva.");
                response.sendRedirect("client/reserva-form.jsp?id=" + idVehiculo);
            }
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Error en formato de ID vehículo: " + e.getMessage());
            session.setAttribute("errorPago", "Error en el vehículo seleccionado");
            response.sendRedirect("client/reserva-form.jsp");
        } catch (Exception e) {
            System.out.println("❌ Error procesando pago: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorPago", "Error interno del sistema: " + e.getMessage());
            response.sendRedirect("client/reserva-form.jsp");
        }
    }
    
    // CORRECCIÓN: Método mejorado para validar número de tarjeta
    private boolean validarNumeroTarjeta(String numeroTarjeta) {
        if (numeroTarjeta == null || numeroTarjeta.trim().isEmpty()) {
            return false;
        }
        
        // Remover cualquier carácter que no sea dígito
        String numeroLimpio = numeroTarjeta.replaceAll("[^0-9]", "");
        
        // Validar longitud (13-19 dígitos para diferentes tipos de tarjetas)
        if (numeroLimpio.length() < 13 || numeroLimpio.length() > 19) {
            return false;
        }
        
        // Validar que solo contenga dígitos
        if (!numeroLimpio.matches("\\d+")) {
            return false;
        }
        
        // CORRECCIÓN: Aplicar algoritmo de Luhn para validación básica
        return validarAlgoritmoLuhn(numeroLimpio);
    }
    
    // CORRECCIÓN: Algoritmo de Luhn para validación de tarjetas
    private boolean validarAlgoritmoLuhn(String numeroTarjeta) {
        int suma = 0;
        boolean alternar = false;
        
        for (int i = numeroTarjeta.length() - 1; i >= 0; i--) {
            int n = Integer.parseInt(numeroTarjeta.substring(i, i + 1));
            if (alternar) {
                n *= 2;
                if (n > 9) {
                    n = (n % 10) + 1;
                }
            }
            suma += n;
            alternar = !alternar;
        }
        
        return (suma % 10 == 0);
    }
    
    // CORRECCIÓN: Método para validar fecha de vencimiento
    private boolean validarFechaVencimiento(String fechaVencimiento) {
        if (fechaVencimiento == null || !fechaVencimiento.matches("(0[1-9]|1[0-2])/[0-9]{2}")) {
            return false;
        }
        
        try {
            String[] partes = fechaVencimiento.split("/");
            int mes = Integer.parseInt(partes[0]);
            int año = Integer.parseInt(partes[1]);
            
            // Añadir 2000 si el año es menor a 100
            if (año < 100) {
                año += 2000;
            }
            
            // Validar que el mes esté entre 1 y 12
            if (mes < 1 || mes > 12) {
                return false;
            }
            
            // Validar que la fecha no esté expirada
            java.time.YearMonth fechaActual = java.time.YearMonth.now();
            java.time.YearMonth fechaVenc = java.time.YearMonth.of(año, mes);
            
            return !fechaVenc.isBefore(fechaActual);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    // CORRECCIÓN: Método para validar CVV
    private boolean validarCVV(String cvv) {
        if (cvv == null) return false;
        
        // Remover espacios
        String cvvLimpio = cvv.trim();
        
        // Validar que tenga 3 o 4 dígitos
        return cvvLimpio.matches("\\d{3,4}");
    }
    
    // CORRECCIÓN: Método para validar nombre del titular
    private boolean validarNombreTitular(String nombreTitular) {
        if (nombreTitular == null || nombreTitular.trim().isEmpty()) {
            return false;
        }
        
        // Validar que solo contenga letras, espacios y algunos caracteres especiales comunes
        return nombreTitular.matches("^[a-zA-ZáéíóúÁÉÍÓÚñÑ\\s\\-'.]{2,50}$");
    }
    
    // Método auxiliar para obtener mensajes de error de disponibilidad
    private String obtenerMensajeErrorDisponibilidad(String codigoError) {
        switch (codigoError) {
            case "VEHICULO_NO_EXISTE":
                return "El vehículo seleccionado no existe";
            case "VEHICULO_NO_DISPONIBLE":
                return "El vehículo no está disponible para alquiler";
            case "CONFLICTO_RESERVAS":
                return "El vehículo ya tiene reservas en las fechas seleccionadas. Por favor, elige otras fechas.";
            case "CONFLICTO_BLOQUEOS":
                return "El vehículo está en mantenimiento en las fechas seleccionadas. Por favor, elige otras fechas.";
            default:
                return "Error verificando disponibilidad del vehículo";
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/vehiculos");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para procesar pagos con tarjeta y crear reservas";
    }
}