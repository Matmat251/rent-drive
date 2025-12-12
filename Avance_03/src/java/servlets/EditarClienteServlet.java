package servlets;

import capaDatos.ClienteDAO;
import capaDatos.CiudadDAO;
import capaEntidad.Cliente;
import capaEntidad.Ciudad;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "EditarClienteServlet", urlPatterns = {"/editar-cliente"})
public class EditarClienteServlet extends HttpServlet {
    
    private ClienteDAO clienteDAO;
    private CiudadDAO ciudadDAO;
    
    @Override
    public void init() {
        clienteDAO = new ClienteDAO();
        ciudadDAO = new CiudadDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        System.out.println("🔍 Solicitando edición de cliente - ID: " + idParam);
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int idCliente = Integer.parseInt(idParam);
                Cliente cliente = clienteDAO.obtenerClienteCompleto(idCliente);
                List<Ciudad> ciudades = ciudadDAO.obtenerCiudadesActivas();
                
                if (cliente != null) {
                    request.setAttribute("cliente", cliente);
                    request.setAttribute("ciudades", ciudades);
                    System.out.println("✅ Cliente cargado para edición: " + cliente.getNombre());
                    request.getRequestDispatcher("/admin/editar-cliente.jsp").forward(request, response);
                } else {
                    System.out.println("❌ Cliente no encontrado - ID: " + idCliente);
                    response.sendRedirect(request.getContextPath() + "/admin/gestion-clientes.jsp?error=Cliente no encontrado");
                }
                
            } catch (NumberFormatException e) {
                System.out.println("❌ ID de cliente inválido: " + idParam);
                response.sendRedirect(request.getContextPath() + "/admin/gestion-clientes.jsp?error=ID inválido");
            }
        } else {
            System.out.println("❌ ID no proporcionado");
            response.sendRedirect(request.getContextPath() + "/admin/gestion-clientes.jsp?error=ID no proporcionado");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            System.out.println("✏️ Procesando actualización de cliente");
            
            Cliente cliente = new Cliente();
            cliente.setIdCliente(Integer.parseInt(request.getParameter("idCliente")));
            cliente.setNombre(request.getParameter("nombre"));
            cliente.setApellido(request.getParameter("apellido"));
            cliente.setDni(request.getParameter("dni"));
            cliente.setTelefono(request.getParameter("telefono"));
            cliente.setEmail(request.getParameter("email"));
            cliente.setDireccion(request.getParameter("direccion"));
            
            String idCiudadStr = request.getParameter("idCiudad");
            if (idCiudadStr != null && !idCiudadStr.isEmpty()) {
                cliente.setIdCiudad(Integer.parseInt(idCiudadStr));
            } else {
                cliente.setIdCiudad(0);
            }
            
            System.out.println("📝 Datos a actualizar - Cliente ID: " + cliente.getIdCliente() + ", Ciudad: " + cliente.getIdCiudad());
            
            String resultado = clienteDAO.actualizarCliente(cliente);
            
            if ("EXITO".equals(resultado)) {
                System.out.println("✅ Cliente actualizado exitosamente - ID: " + cliente.getIdCliente());
                response.sendRedirect(request.getContextPath() + "/admin/gestion-clientes.jsp?success=Cliente actualizado correctamente");
            } else {
                String errorMsg = obtenerMensajeError(resultado);
                System.out.println("❌ Error al actualizar: " + errorMsg);
                response.sendRedirect(request.getContextPath() + "/editar-cliente?id=" + cliente.getIdCliente() + "&error=" + errorMsg);
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en proceso de actualización: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/gestion-clientes.jsp?error=Error al actualizar cliente: " + e.getMessage());
        }
    }
    
    private String obtenerMensajeError(String codigoError) {
        switch (codigoError) {
            case "DNI_EXISTE": return "El DNI ya está registrado en otro cliente";
            case "TELEFONO_EXISTE": return "El teléfono ya está registrado en otro cliente";
            case "EMAIL_EXISTE": return "El email ya está registrado en otro cliente";
            case "ERROR_BD": return "Error en la base de datos";
            default: return "Error desconocido al actualizar cliente";
        }
    }
}