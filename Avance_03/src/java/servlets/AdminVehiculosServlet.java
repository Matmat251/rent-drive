package servlets;

import capaDatos.VehiculoDAO;
import capaEntidad.Vehiculo;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminVehiculosServlet", urlPatterns = {"/admin/vehiculos"})
public class AdminVehiculosServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    
    @Override
    public void init() {
        vehiculoDAO = new VehiculoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtener parámetro de búsqueda del formulario JSP
        String busqueda = request.getParameter("busqueda");
        List<Vehiculo> vehiculos;
        
        // 2. Decidir qué método del DAO usar
        if (busqueda != null && !busqueda.trim().isEmpty()) {
            System.out.println("🔍 Buscando vehículos con texto: " + busqueda);
            vehiculos = vehiculoDAO.buscarVehiculos(busqueda.trim());
        } else {
            System.out.println("🚗 Listando todos los vehículos (sin filtro)");
            vehiculos = vehiculoDAO.listarTodosVehiculos();
        }
        
        // 3. Enviar lista y término de búsqueda al JSP
        request.setAttribute("vehiculos", vehiculos);
        request.setAttribute("busqueda", busqueda); // Para mantener el texto en el input
        
        System.out.println("✅ Vehículos enviados al JSP: " + (vehiculos != null ? vehiculos.size() : 0));
        
        // 4. Redirigir
        request.getRequestDispatcher("/admin/gestion-vehiculos.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión administrativa de vehículos con búsqueda";
    }
}