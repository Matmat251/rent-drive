package servlets;

import capaDatos.VehiculoDAO;
import capaEntidad.Vehiculo;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GestionVehiculoServlet", urlPatterns = {"/admin/vehiculo"})
public class GestionVehiculoServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    
    @Override
    public void init() {
        vehiculoDAO = new VehiculoDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        System.out.println("🔧 Acción vehículo - Action: " + action + ", ID: " + idParam);
        
        if ("editar".equals(action) && idParam != null) {
            // Modo edición - obtener vehículo por ID
            try {
                int idVehiculo = Integer.parseInt(idParam);
                Vehiculo vehiculo = vehiculoDAO.obtenerVehiculoPorId(idVehiculo);
                
                if (vehiculo != null) {
                    request.setAttribute("vehiculo", vehiculo);
                    request.setAttribute("modo", "editar");
                    System.out.println("✏️ Editando vehículo: " + vehiculo.getMarca() + " " + vehiculo.getModelo());
                } else {
                    request.setAttribute("error", "Vehículo no encontrado");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de vehículo inválido");
            }
        } else {
            // Modo creación
            request.setAttribute("modo", "crear");
            System.out.println("🆕 Creando nuevo vehículo");
        }
        
        request.getRequestDispatcher("/admin/vehiculo-form.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("idVehiculo");
        
        System.out.println("📝 Procesando formulario vehículo - Action: " + action);
        
        // Obtener parámetros del formulario
        String marca = request.getParameter("marca");
        String modelo = request.getParameter("modelo");
        String anioParam = request.getParameter("anio");
        String matricula = request.getParameter("matricula");
        String tipo = request.getParameter("tipo");
        String precioParam = request.getParameter("precioDiario");
        String estado = request.getParameter("estado");
        
        // Validaciones básicas
        if (marca == null || marca.trim().isEmpty() ||
            modelo == null || modelo.trim().isEmpty() ||
            anioParam == null || anioParam.trim().isEmpty() ||
            matricula == null || matricula.trim().isEmpty() ||
            tipo == null || tipo.trim().isEmpty() ||
            precioParam == null || precioParam.trim().isEmpty() ||
            estado == null || estado.trim().isEmpty()) {
            
            request.setAttribute("error", "Todos los campos son obligatorios");
            mantenerDatosFormulario(request, marca, modelo, anioParam, matricula, tipo, precioParam, estado);
            request.getRequestDispatcher("/admin/vehiculo-form.jsp").forward(request, response);
            return;
        }
        
        try {
            Vehiculo vehiculo = new Vehiculo();
            vehiculo.setMarca(marca.trim());
            vehiculo.setModelo(modelo.trim());
            vehiculo.setAnio(Integer.parseInt(anioParam));
            vehiculo.setMatricula(matricula.trim().toUpperCase());
            vehiculo.setTipo(tipo);
            vehiculo.setPrecioDiario(Double.parseDouble(precioParam));
            vehiculo.setEstado(estado);
            
            String resultado;
            
            if ("editar".equals(action) && idParam != null) {
                // Modo edición
                vehiculo.setIdVehiculo(Integer.parseInt(idParam));
                resultado = vehiculoDAO.actualizarVehiculo(vehiculo);
                
                if ("EXITO".equals(resultado)) {
                    request.getSession().setAttribute("mensajeExito", "✅ Vehículo actualizado correctamente");
                    response.sendRedirect(request.getContextPath() + "/admin/vehiculos");
                    return;
                } else if ("MATRICULA_EXISTE".equals(resultado)) {
                    request.setAttribute("error", "❌ La matrícula ya existe en otro vehículo");
                } else {
                    request.setAttribute("error", "❌ Error al actualizar el vehículo");
                }
            } else {
                // Modo creación
                resultado = vehiculoDAO.crearVehiculo(vehiculo);
                
                if ("EXITO".equals(resultado)) {
                    request.getSession().setAttribute("mensajeExito", "✅ Vehículo creado correctamente");
                    response.sendRedirect(request.getContextPath() + "/admin/vehiculos");
                    return;
                } else if ("MATRICULA_EXISTE".equals(resultado)) {
                    request.setAttribute("error", "❌ La matrícula ya existe en el sistema");
                } else {
                    request.setAttribute("error", "❌ Error al crear el vehículo");
                }
            }
            
            // Si hay error, mantener datos en el formulario
            mantenerDatosFormulario(request, marca, modelo, anioParam, matricula, tipo, precioParam, estado);
            request.setAttribute("modo", action);
            if ("editar".equals(action)) {
                request.setAttribute("vehiculo", vehiculo);
            }
            request.getRequestDispatcher("/admin/vehiculo-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "❌ Formato inválido en año o precio");
            mantenerDatosFormulario(request, marca, modelo, anioParam, matricula, tipo, precioParam, estado);
            request.getRequestDispatcher("/admin/vehiculo-form.jsp").forward(request, response);
        }
    }
    
    private void mantenerDatosFormulario(HttpServletRequest request, String marca, String modelo, 
                                       String anio, String matricula, String tipo, String precio, String estado) {
        request.setAttribute("marca", marca);
        request.setAttribute("modelo", modelo);
        request.setAttribute("anio", anio);
        request.setAttribute("matricula", matricula);
        request.setAttribute("tipo", tipo);
        request.setAttribute("precioDiario", precio);
        request.setAttribute("estado", estado);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para crear y editar vehículos";
    }
}