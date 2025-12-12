package servlets;
// SERVLET PARA ELIMINAR/CAMBIAR ESTADO

import capaDatos.VehiculoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AccionVehiculoServlet", urlPatterns = {"/admin/vehiculo-accion"})
public class AccionVehiculoServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    
    @Override
    public void init() {
        vehiculoDAO = new VehiculoDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        System.out.println("⚡ Acción rápida vehículo - Action: " + action + ", ID: " + idParam);
        
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/vehiculos?error=ID+inválido");
            return;
        }
        
        int idVehiculo = Integer.parseInt(idParam);
        String resultado;
        
        try {
            switch (action) {
                case "eliminar":
                    resultado = vehiculoDAO.eliminarVehiculo(idVehiculo);
                    if ("EXITO".equals(resultado)) {
                        request.getSession().setAttribute("mensajeExito", "✅ Vehículo eliminado correctamente");
                    } else if ("TIENE_RESERVAS".equals(resultado)) {
                        request.getSession().setAttribute("mensajeError", "❌ No se puede eliminar - El vehículo tiene reservas activas");
                    } else {
                        request.getSession().setAttribute("mensajeError", "❌ Error al eliminar el vehículo");
                    }
                    break;
                    
                case "cambiar-estado":
                    String nuevoEstado = request.getParameter("estado");
                    if (nuevoEstado != null) {
                        resultado = vehiculoDAO.cambiarEstadoVehiculo(idVehiculo, nuevoEstado);
                        if ("EXITO".equals(resultado)) {
                            request.getSession().setAttribute("mensajeExito", "✅ Estado del vehículo actualizado correctamente");
                        } else {
                            request.getSession().setAttribute("mensajeError", "❌ Error al cambiar el estado");
                        }
                    }
                    break;
                    
                default:
                    request.getSession().setAttribute("mensajeError", "❌ Acción no válida");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en acción vehículo: " + e.getMessage());
            request.getSession().setAttribute("mensajeError", "❌ Error en la operación");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/vehiculos");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para acciones rápidas de vehículos";
    }
}