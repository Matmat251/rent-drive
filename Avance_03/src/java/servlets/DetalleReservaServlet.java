package servlets;

import capaDatos.ReservaDAO;
import capaEntidad.Reserva;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DetalleReservaServlet", urlPatterns = {"/admin/reserva-detalle"})
public class DetalleReservaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        System.out.println("🔍 Solicitando detalles de reserva ID: " + idParam);
        
        if (idParam == null || !idParam.matches("\\d+")) {
            request.setAttribute("error", "ID de reserva inválido");
            request.getRequestDispatcher("/admin/gestion-reservas.jsp").forward(request, response);
            return;
        }
        
        int idReserva = Integer.parseInt(idParam);
        Reserva reserva = reservaDAO.obtenerDetallesReserva(idReserva);
        
        if (reserva != null) {
            request.setAttribute("reserva", reserva);
            System.out.println("✅ Detalles de reserva cargados: " + reserva.getMarcaVehiculo() + " " + reserva.getModeloVehiculo());
        } else {
            request.setAttribute("error", "Reserva no encontrada");
        }
        
        request.getRequestDispatcher("/admin/reserva-detalle.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para ver detalles de reservas";
    }
}