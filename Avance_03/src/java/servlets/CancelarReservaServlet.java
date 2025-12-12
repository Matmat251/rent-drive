package servlets;

import capaDatos.ReservaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CancelarReservaServlet", urlPatterns = {"/cancelar-reserva"})
public class CancelarReservaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idReservaParam = request.getParameter("id");
        
        System.out.println("🗑️ Intentando cancelar reserva: " + idReservaParam);
        
        if (idReservaParam != null && !idReservaParam.trim().isEmpty()) {
            try {
                int idReserva = Integer.parseInt(idReservaParam);
                
                // Cancelar reserva en la base de datos
                boolean cancelada = reservaDAO.cancelarReserva(idReserva);
                
                if (cancelada) {
                    System.out.println("✅ Reserva cancelada exitosamente: " + idReserva);
                    response.setStatus(200); // OK
                    response.getWriter().write("success");
                } else {
                    System.out.println("❌ Error al cancelar reserva: " + idReserva);
                    response.setStatus(500); // Error interno
                    response.getWriter().write("error");
                }
                
            } catch (NumberFormatException e) {
                System.out.println("❌ ID de reserva inválido: " + idReservaParam);
                response.setStatus(400); // Bad request
                response.getWriter().write("invalid_id");
            }
        } else {
            System.out.println("❌ ID de reserva no proporcionado");
            response.setStatus(400); // Bad request
            response.getWriter().write("no_id");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet para cancelar reservas";
    }
}