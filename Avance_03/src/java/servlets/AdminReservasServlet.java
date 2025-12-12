package servlets;

import capaDatos.ReservaDAO;
import capaEntidad.Reserva;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminReservasServlet", urlPatterns = {"/admin/reservas"})
public class AdminReservasServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("📋 Administrador - Listando todas las reservas");
        
        // Verificar parámetros de búsqueda
        String dniCliente = request.getParameter("dniCliente");
        String matriculaVehiculo = request.getParameter("matriculaVehiculo");
        String estado = request.getParameter("estado");
        String fechaDesde = request.getParameter("fechaDesde");
        String fechaHasta = request.getParameter("fechaHasta");
        
        List<Reserva> reservas;
        
        // Si hay parámetros de búsqueda, usar búsqueda filtrada
        if ((dniCliente != null && !dniCliente.trim().isEmpty()) ||
            (matriculaVehiculo != null && !matriculaVehiculo.trim().isEmpty()) ||
            (estado != null && !estado.trim().isEmpty()) ||
            (fechaDesde != null && !fechaDesde.trim().isEmpty()) ||
            (fechaHasta != null && !fechaHasta.trim().isEmpty())) {
            
            System.out.println("🔍 Búsqueda filtrada - DNI: " + dniCliente + ", Matrícula: " + matriculaVehiculo);
            reservas = reservaDAO.buscarReservas(dniCliente, matriculaVehiculo, estado, fechaDesde, fechaHasta);
            
            // Mantener parámetros de búsqueda en el request
            request.setAttribute("dniCliente", dniCliente);
            request.setAttribute("matriculaVehiculo", matriculaVehiculo);
            request.setAttribute("estado", estado);
            request.setAttribute("fechaDesde", fechaDesde);
            request.setAttribute("fechaHasta", fechaHasta);
            
        } else {
            // Listar todas las reservas
            reservas = reservaDAO.listarTodasReservas();
        }
        
        // Pasar la lista al JSP
        request.setAttribute("reservas", reservas);
        
        System.out.println("✅ Reservas cargadas: " + (reservas != null ? reservas.size() : 0));
        
        // Redirigir al panel de administración de reservas
        request.getRequestDispatcher("/admin/gestion-reservas.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión administrativa de reservas";
    }
}