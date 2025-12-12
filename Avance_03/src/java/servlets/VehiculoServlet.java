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

@WebServlet(name = "VehiculoServlet", urlPatterns = {"/vehiculos"})  
public class VehiculoServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    
    @Override
    public void init() {
        vehiculoDAO = new VehiculoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("🚗 Servlet de vehículos accedido");
        
        try {
            // Obtener parámetros de filtro
            String tipo = request.getParameter("tipo");
            String fecha = request.getParameter("fecha");
            String busqueda = request.getParameter("busqueda");
            String marca = request.getParameter("marca");
            String precioMin = request.getParameter("precioMin");
            String precioMax = request.getParameter("precioMax");
            
            System.out.println("🔍 Filtros aplicados:");
            System.out.println("   Tipo: " + tipo);
            System.out.println("   Fecha: " + fecha);
            System.out.println("   Búsqueda: " + busqueda);
            System.out.println("   Marca: " + marca);
            System.out.println("   Precio Min: " + precioMin);
            System.out.println("   Precio Max: " + precioMax);
            
            List<Vehiculo> vehiculos;
            
            // Lógica de filtrado
            if (busqueda != null && !busqueda.trim().isEmpty()) {
                // Si hay búsqueda por texto
                System.out.println("🔍 Buscando vehículos por texto: " + busqueda);
                vehiculos = vehiculoDAO.buscarVehiculos(busqueda);
            } else if (tipo != null || fecha != null || marca != null || precioMin != null || precioMax != null) {
                // Si hay filtros avanzados
                System.out.println("🔍 Aplicando filtros avanzados");
                vehiculos = aplicarFiltrosAvanzados(tipo, fecha, marca, precioMin, precioMax);
            } else {
                // Listar todos los disponibles
                System.out.println("🔍 Listando todos los vehículos disponibles");
                vehiculos = vehiculoDAO.listarVehiculosDisponibles();
            }
            
            // Pasar parámetros de filtro para mantenerlos en la vista
            request.setAttribute("tipoFiltro", tipo);
            request.setAttribute("fechaFiltro", fecha);
            request.setAttribute("busquedaFiltro", busqueda);
            request.setAttribute("marcaFiltro", marca);
            request.setAttribute("precioMinFiltro", precioMin);
            request.setAttribute("precioMaxFiltro", precioMax);
            
            // Pasar la lista al JSP
            request.setAttribute("vehiculos", vehiculos);
            
            System.out.println("✅ Vehículos encontrados: " + (vehiculos != null ? vehiculos.size() : 0));
            
            // Redirigir al catálogo
            request.getRequestDispatcher("/client/catalogo.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.out.println("❌ Error en VehiculoServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error al procesar la solicitud");
        }
    }
    
    // Método para aplicar filtros avanzados
    private List<Vehiculo> aplicarFiltrosAvanzados(String tipo, String fecha, String marca, 
                                                  String precioMinStr, String precioMaxStr) {
        List<Vehiculo> todosVehiculos = vehiculoDAO.listarVehiculosDisponibles();
        
        // Aplicar filtros manualmente
        return todosVehiculos.stream()
                .filter(vehiculo -> filtrarPorTipo(vehiculo, tipo))
                .filter(vehiculo -> filtrarPorMarca(vehiculo, marca))
                .filter(vehiculo -> filtrarPorPrecio(vehiculo, precioMinStr, precioMaxStr))
                .filter(vehiculo -> filtrarPorFecha(vehiculo, fecha)) // Este filtro es más complejo
                .toList();
    }
    
    private boolean filtrarPorTipo(Vehiculo vehiculo, String tipo) {
        if (tipo == null || tipo.isEmpty() || tipo.equals("Todos los modelos")) {
            return true;
        }
        return vehiculo.getTipo().equalsIgnoreCase(tipo);
    }
    
    private boolean filtrarPorMarca(Vehiculo vehiculo, String marca) {
        if (marca == null || marca.isEmpty() || marca.equals("Todas")) {
            return true;
        }
        return vehiculo.getMarca().equalsIgnoreCase(marca);
    }
    
    private boolean filtrarPorPrecio(Vehiculo vehiculo, String precioMinStr, String precioMaxStr) {
        double precioMin = 0;
        double precioMax = Double.MAX_VALUE;
        
        try {
            if (precioMinStr != null && !precioMinStr.isEmpty()) {
                precioMin = Double.parseDouble(precioMinStr);
            }
            if (precioMaxStr != null && !precioMaxStr.isEmpty()) {
                precioMax = Double.parseDouble(precioMaxStr);
            }
        } catch (NumberFormatException e) {
            System.out.println("⚠️ Error en formato de precio: " + e.getMessage());
            return true; // Si hay error en formato, no filtrar por precio
        }
        
        double precio = vehiculo.getPrecioDiario();
        return precio >= precioMin && precio <= precioMax;
    }
    
    private boolean filtrarPorFecha(Vehiculo vehiculo, String fecha) {
        if (fecha == null || fecha.isEmpty()) {
            return true;
        }
        
        // Nota: Este filtro requiere lógica de disponibilidad por fecha
        // Por ahora, retornamos true y la validación real se hace en la reserva
        return true;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Para formularios POST de búsqueda/filtrado
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para gestión de vehículos con filtros";
    }
}