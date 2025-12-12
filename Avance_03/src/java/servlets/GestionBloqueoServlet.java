package servlets;

import capaDatos.BloqueoCalendarioDAO;
import capaDatos.VehiculoDAO;
import capaEntidad.BloqueoCalendario;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GestionBloqueoServlet", urlPatterns = {"/admin/gestion-bloqueo"})
public class GestionBloqueoServlet extends HttpServlet {

    private BloqueoCalendarioDAO bloqueoDAO;
    private VehiculoDAO vehiculoDAO;
    
    @Override
    public void init() {
        bloqueoDAO = new BloqueoCalendarioDAO();
        vehiculoDAO = new VehiculoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idVehiculoParam = request.getParameter("idVehiculo");
        
        System.out.println("📅 Gestión bloqueo - Action: " + action + ", Vehículo: " + idVehiculoParam);
        
        if ("ver".equals(action) && idVehiculoParam != null) {
            int idVehiculo = Integer.parseInt(idVehiculoParam);
            
            // Obtener vehículo y sus bloqueos
            request.setAttribute("vehiculo", vehiculoDAO.obtenerVehiculoPorId(idVehiculo));
            request.setAttribute("bloqueos", bloqueoDAO.obtenerBloqueosPorVehiculo(idVehiculo));
            request.setAttribute("fechasOcupadas", bloqueoDAO.obtenerFechasOcupadas(idVehiculo));
            
            request.getRequestDispatcher("/admin/bloqueos-vehiculo.jsp").forward(request, response);
            return;
        }
        
        // Redirigir al calendario principal si no hay parámetros válidos
        response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        System.out.println("📝 Procesando bloqueo - Action: " + action);
        
        try {
            if ("crear".equals(action)) {
                crearBloqueo(request, response);
            } else if ("eliminar".equals(action)) {
                eliminarBloqueo(request, response);
            } else {
                request.getSession().setAttribute("mensajeError", "❌ Acción no válida");
                response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en gestión de bloqueo: " + e.getMessage());
            request.getSession().setAttribute("mensajeError", "❌ Error en la operación");
            response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
        }
    }
    
    private void crearBloqueo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idVehiculoParam = request.getParameter("idVehiculo");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        String motivo = request.getParameter("motivo");
        String descripcion = request.getParameter("descripcion");
        
        // Validaciones
        if (idVehiculoParam == null || fechaInicio == null || fechaFin == null || motivo == null) {
            request.getSession().setAttribute("mensajeError", "❌ Todos los campos son obligatorios");
            response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
            return;
        }
        
        try {
            int idVehiculo = Integer.parseInt(idVehiculoParam);
            LocalDate inicio = LocalDate.parse(fechaInicio);
            LocalDate fin = LocalDate.parse(fechaFin);
            
            // Validar que la fecha fin no sea anterior a la fecha inicio
            if (fin.isBefore(inicio)) {
                request.getSession().setAttribute("mensajeError", "❌ La fecha fin no puede ser anterior a la fecha inicio");
                response.sendRedirect(request.getContextPath() + "/admin/gestion-bloqueo?action=ver&idVehiculo=" + idVehiculo);
                return;
            }
            
            // Verificar disponibilidad
            if (!bloqueoDAO.verificarDisponibilidad(idVehiculo, inicio, fin)) {
                request.getSession().setAttribute("mensajeError", "❌ El vehículo no está disponible en las fechas seleccionadas");
                response.sendRedirect(request.getContextPath() + "/admin/gestion-bloqueo?action=ver&idVehiculo=" + idVehiculo);
                return;
            }
            
            // Crear bloqueo
            BloqueoCalendario bloqueo = new BloqueoCalendario();
            bloqueo.setIdVehiculo(idVehiculo);
            bloqueo.setFechaInicio(inicio);
            bloqueo.setFechaFin(fin);
            bloqueo.setMotivo(motivo);
            bloqueo.setDescripcion(descripcion != null ? descripcion : "");
            
            boolean exito = bloqueoDAO.crearBloqueo(bloqueo);
            
            if (exito) {
                request.getSession().setAttribute("mensajeExito", "✅ Bloqueo creado correctamente");
            } else {
                request.getSession().setAttribute("mensajeError", "❌ Error al crear el bloqueo");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error creando bloqueo: " + e.getMessage());
            request.getSession().setAttribute("mensajeError", "❌ Error en el formato de las fechas");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestion-bloqueo?action=ver&idVehiculo=" + idVehiculoParam);
    }
    
    private void eliminarBloqueo(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idBloqueoParam = request.getParameter("idBloqueo");
        String idVehiculoParam = request.getParameter("idVehiculo");
        
        if (idBloqueoParam == null || idVehiculoParam == null) {
            request.getSession().setAttribute("mensajeError", "❌ Parámetros inválidos");
            response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
            return;
        }
        
        try {
            int idBloqueo = Integer.parseInt(idBloqueoParam);
            boolean exito = bloqueoDAO.eliminarBloqueo(idBloqueo);
            
            if (exito) {
                request.getSession().setAttribute("mensajeExito", "✅ Bloqueo eliminado correctamente");
            } else {
                request.getSession().setAttribute("mensajeError", "❌ Error al eliminar el bloqueo");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error eliminando bloqueo: " + e.getMessage());
            request.getSession().setAttribute("mensajeError", "❌ Error al eliminar el bloqueo");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/gestion-bloqueo?action=ver&idVehiculo=" + idVehiculoParam);
    }
}