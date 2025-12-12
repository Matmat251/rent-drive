package servlets;

import capaDatos.ReservaDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VerificarDisponibilidadServlet", urlPatterns = {"/verificar-disponibilidad"})
public class VerificarDisponibilidadServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idVehiculoParam = request.getParameter("idVehiculo");
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFin = request.getParameter("fechaFin");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            if (idVehiculoParam == null || fechaInicio == null || fechaFin == null) {
                out.print("{\"disponible\": false, \"mensaje\": \"Parámetros incompletos\"}");
                return;
            }
            
            int idVehiculo = Integer.parseInt(idVehiculoParam);
            String resultado = reservaDAO.verificarDisponibilidadCompleta(idVehiculo, fechaInicio, fechaFin);
            
            if ("DISPONIBLE".equals(resultado)) {
                out.print("{\"disponible\": true, \"mensaje\": \"✅ Vehículo disponible en las fechas seleccionadas\"}");
            } else {
                String mensaje = "";
                switch (resultado) {
                    case "VEHICULO_NO_EXISTE": mensaje = "❌ El vehículo no existe"; break;
                    case "VEHICULO_NO_DISPONIBLE": mensaje = "❌ El vehículo no está disponible"; break;
                    case "CONFLICTO_RESERVAS": mensaje = "❌ Ya hay reservas en estas fechas"; break;
                    case "CONFLICTO_BLOQUEOS": mensaje = "❌ El vehículo está en mantenimiento"; break;
                    default: mensaje = "❌ Error verificando disponibilidad";
                }
                out.print("{\"disponible\": false, \"mensaje\": \"" + mensaje + "\"}");
            }
            
        } catch (Exception e) {
            System.out.println("❌ Error en verificación de disponibilidad: " + e.getMessage());
            out.print("{\"disponible\": false, \"mensaje\": \"❌ Error del servidor\"}");
        }
    }
}