package servlets;

import capaDatos.ReservaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AccionReservaServlet", urlPatterns = {"/admin/reserva-accion"})
public class AccionReservaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        System.out.println("⚡ Acción reserva - Action: " + action + ", ID: " + idParam);
        
        if (idParam == null || !idParam.matches("\\d+")) {
            response.sendRedirect(request.getContextPath() + "/admin/reservas?error=ID+inválido");
            return;
        }
        
        int idReserva = Integer.parseInt(idParam);
        String resultado;
        
        try {
            switch (action) {
                case "finalizar":
                    resultado = reservaDAO.cambiarEstadoReserva(idReserva, "Finalizada");
                    if ("EXITO".equals(resultado)) {
                        request.getSession().setAttribute("mensajeExito", "✅ Reserva finalizada correctamente");
                    } else if ("RESERVA_NO_EXISTE".equals(resultado)) {
                        request.getSession().setAttribute("mensajeError", "❌ La reserva no existe");
                    } else {
                        request.getSession().setAttribute("mensajeError", "❌ Error al finalizar la reserva");
                    }
                    break;
                    
                case "cancelar":
                    resultado = reservaDAO.cambiarEstadoReserva(idReserva, "Cancelada");
                    if ("EXITO".equals(resultado)) {
                        request.getSession().setAttribute("mensajeExito", "✅ Reserva cancelada correctamente");
                    } else if ("RESERVA_NO_EXISTE".equals(resultado)) {
                        request.getSession().setAttribute("mensajeError", "❌ La reserva no existe");
                    } else {
                        request.getSession().setAttribute("mensajeError", "❌ Error al cancelar la reserva");
                    }
                    break;
                    
                case "reactivar":
                    resultado = reservaDAO.cambiarEstadoReserva(idReserva, "Activa");
                    if ("EXITO".equals(resultado)) {
                        request.getSession().setAttribute("mensajeExito", "✅ Reserva reactivada correctamente");
                    } else if ("RESERVA_NO_EXISTE".equals(resultado)) {
                        request.getSession().setAttribute("mensajeError", "❌ La reserva no existe");
                    } else {
                        request.getSession().setAttribute("mensajeError", "❌ Error al reactivar la reserva");
                    }
                    break;
                    
                default:
                    request.getSession().setAttribute("mensajeError", "❌ Acción no válida");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en acción reserva: " + e.getMessage());
            request.getSession().setAttribute("mensajeError", "❌ Error en la operación");
        }
        
        // Redirigir de vuelta a la página de reservas
        response.sendRedirect(request.getContextPath() + "/admin/reservas");
    }

    @Override
    public String getServletInfo() {
        return "Servlet para acciones de reservas";
    }
}