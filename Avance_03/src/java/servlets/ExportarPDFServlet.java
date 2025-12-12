package servlets;

import capaDatos.VehiculoDAO;
import capaDatos.ReservaDAO;
import capaEntidad.Reserva;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ExportarPDFServlet", urlPatterns = {"/admin/exportar-pdf"})
public class ExportarPDFServlet extends HttpServlet {

    private VehiculoDAO vehiculoDAO;
    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        vehiculoDAO = new VehiculoDAO();
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String tipoReporte = request.getParameter("tipo");
        if (tipoReporte == null) {
            tipoReporte = "reservas";
        }
        
        try {
            // Configurar respuesta para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"reporte_fastwheels.pdf\"");
            
            // Crear documento PDF
            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            
            document.open();
            
            // Agregar contenido según el tipo de reporte
            switch (tipoReporte) {
                case "reservas":
                    generarReporteReservas(document);
                    break;
                case "financiero":
                    generarReporteFinanciero(document);
                    break;
                case "vehiculos":
                    generarReporteVehiculos(document);
                    break;
                default:
                    generarReporteCompleto(document);
            }
            
            document.close();
            
        } catch (Exception e) {
            System.out.println("❌ Error generando PDF: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generando PDF");
        }
    }
    
    private void generarReporteCompleto(Document document) throws DocumentException {
        // Título
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE COMPLETO - FASTWHEELS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        // Fecha de generación
        Font dateFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC, BaseColor.GRAY);
        Paragraph date = new Paragraph("Generado el: " + new java.util.Date(), dateFont);
        date.setAlignment(Element.ALIGN_RIGHT);
        date.setSpacingAfter(30);
        document.add(date);
        
        // Estadísticas generales
        agregarEstadisticasGenerales(document);
        document.add(new Paragraph("\n"));
        
        // Reporte de reservas
        agregarReporteReservas(document);
        document.add(new Paragraph("\n"));
        
        // Reporte financiero
        agregarReporteFinanciero(document);
    }
    
    private void generarReporteReservas(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE RESERVAS - FASTWHEELS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        agregarReporteReservas(document);
    }
    
    private void generarReporteFinanciero(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE FINANCIERO - FASTWHEELS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        agregarReporteFinanciero(document);
    }
    
    private void generarReporteVehiculos(Document document) throws DocumentException {
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD, BaseColor.DARK_GRAY);
        Paragraph title = new Paragraph("REPORTE DE VEHÍCULOS - FASTWHEELS", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);
        
        agregarEstadisticasVehiculos(document);
    }
    
    private void agregarEstadisticasGenerales(Document document) throws DocumentException {
        // Obtener datos
        List<Reserva> todasReservas = reservaDAO.listarTodasReservas();
        Map<String, Integer> reservasPorEstado = reservaDAO.contarReservasPorEstado();
        
        int totalVehiculos = vehiculoDAO.listarTodosVehiculos().size();
        int vehiculosDisponibles = vehiculoDAO.contarVehiculosPorEstado("Disponible");
        int reservasActivas = reservasPorEstado.getOrDefault("Activa", 0);
        
        // Calcular ingresos totales
        double ingresosTotales = 0;
        for (Reserva reserva : todasReservas) {
            if ("Finalizada".equals(reserva.getEstado()) || "Activa".equals(reserva.getEstado())) {
                ingresosTotales += reserva.getTotal();
            }
        }
        
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        Paragraph section = new Paragraph("ESTADÍSTICAS GENERALES", sectionFont);
        section.setSpacingAfter(10);
        document.add(section);
        
        // Crear tabla de estadísticas
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        // Agregar filas
        agregarFilaTabla(table, "Total Vehículos:", String.valueOf(totalVehiculos));
        agregarFilaTabla(table, "Vehículos Disponibles:", String.valueOf(vehiculosDisponibles));
        agregarFilaTabla(table, "Total Reservas:", String.valueOf(todasReservas.size()));
        agregarFilaTabla(table, "Reservas Activas:", String.valueOf(reservasActivas));
        agregarFilaTabla(table, "Ingresos Totales:", String.format("$%.2f", ingresosTotales));
        
        document.add(table);
    }
    
    private void agregarReporteReservas(Document document) throws DocumentException {
        List<Reserva> reservas = reservaDAO.listarTodasReservas();
        Map<String, Integer> reservasPorEstado = reservaDAO.contarReservasPorEstado();
        
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        Paragraph section = new Paragraph("REPORTE DE RESERVAS", sectionFont);
        section.setSpacingAfter(10);
        document.add(section);
        
        // Estadísticas de reservas
        PdfPTable statsTable = new PdfPTable(2);
        statsTable.setWidthPercentage(100);
        statsTable.setSpacingBefore(10);
        
        for (Map.Entry<String, Integer> entry : reservasPorEstado.entrySet()) {
            agregarFilaTabla(statsTable, "Reservas " + entry.getKey() + ":", entry.getValue().toString());
        }
        
        document.add(statsTable);
        
        // Tabla detallada de reservas (solo si hay reservas)
        if (!reservas.isEmpty()) {
            document.add(new Paragraph("\n"));
            Font subSectionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph subSection = new Paragraph("DETALLE DE RESERVAS", subSectionFont);
            subSection.setSpacingAfter(10);
            document.add(subSection);
            
            PdfPTable table = new PdfPTable(6);
            table.setWidthPercentage(100);
            table.setSpacingBefore(10);
            
            // Encabezados
            agregarCeldaEncabezado(table, "ID");
            agregarCeldaEncabezado(table, "Cliente");
            agregarCeldaEncabezado(table, "Vehículo");
            agregarCeldaEncabezado(table, "Fechas");
            agregarCeldaEncabezado(table, "Total");
            agregarCeldaEncabezado(table, "Estado");
            
            // Datos
            for (Reserva reserva : reservas) {
                table.addCell(new PdfPCell(new Paragraph(String.valueOf(reserva.getIdReserva()))));
                table.addCell(new PdfPCell(new Paragraph(reserva.getNombreCliente())));
                table.addCell(new PdfPCell(new Paragraph(reserva.getMarcaVehiculo() + " " + reserva.getModeloVehiculo())));
                table.addCell(new PdfPCell(new Paragraph(reserva.getFechaInicio() + " a " + reserva.getFechaFin())));
                table.addCell(new PdfPCell(new Paragraph(String.format("$%.2f", reserva.getTotal()))));
                
                PdfPCell estadoCell = new PdfPCell(new Paragraph(reserva.getEstado()));
                if ("Activa".equals(reserva.getEstado())) {
                    estadoCell.setBackgroundColor(BaseColor.GREEN);
                } else if ("Cancelada".equals(reserva.getEstado())) {
                    estadoCell.setBackgroundColor(BaseColor.RED);
                } else {
                    estadoCell.setBackgroundColor(BaseColor.BLUE);
                }
                table.addCell(estadoCell);
            }
            
            document.add(table);
        }
    }
    
    private void agregarReporteFinanciero(Document document) throws DocumentException {
        Map<String, Double> ingresosMensuales = reservaDAO.obtenerIngresosMensuales();
        Map<String, Integer> metodosPago = reservaDAO.obtenerMetodosPagoPopulares();
        Map<String, Double> vehiculosRentables = reservaDAO.obtenerVehiculosMasRentables();
        
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        Paragraph section = new Paragraph("REPORTE FINANCIERO", sectionFont);
        section.setSpacingAfter(10);
        document.add(section);
        
        // Ingresos mensuales
        if (!ingresosMensuales.isEmpty()) {
            Font subSectionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph subSection = new Paragraph("INGRESOS MENSUALES", subSectionFont);
            subSection.setSpacingAfter(10);
            document.add(subSection);
            
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(50);
            table.setSpacingBefore(10);
            
            agregarCeldaEncabezado(table, "Mes");
            agregarCeldaEncabezado(table, "Ingresos");
            
            for (Map.Entry<String, Double> entry : ingresosMensuales.entrySet()) {
                table.addCell(new PdfPCell(new Paragraph(entry.getKey())));
                table.addCell(new PdfPCell(new Paragraph(String.format("$%.2f", entry.getValue()))));
            }
            
            document.add(table);
        }
        
        // Métodos de pago
        if (!metodosPago.isEmpty()) {
            document.add(new Paragraph("\n"));
            Font subSectionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph subSection = new Paragraph("MÉTODOS DE PAGO", subSectionFont);
            subSection.setSpacingAfter(10);
            document.add(subSection);
            
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(50);
            table.setSpacingBefore(10);
            
            agregarCeldaEncabezado(table, "Método");
            agregarCeldaEncabezado(table, "Cantidad");
            
            for (Map.Entry<String, Integer> entry : metodosPago.entrySet()) {
                table.addCell(new PdfPCell(new Paragraph(entry.getKey())));
                table.addCell(new PdfPCell(new Paragraph(entry.getValue().toString())));
            }
            
            document.add(table);
        }
        
        // Vehículos más rentables
        if (!vehiculosRentables.isEmpty()) {
            document.add(new Paragraph("\n"));
            Font subSectionFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD, BaseColor.DARK_GRAY);
            Paragraph subSection = new Paragraph("VEHÍCULOS MÁS RENTABLES", subSectionFont);
            subSection.setSpacingAfter(10);
            document.add(subSection);
            
            PdfPTable table = new PdfPTable(2);
            table.setWidthPercentage(80);
            table.setSpacingBefore(10);
            
            agregarCeldaEncabezado(table, "Vehículo");
            agregarCeldaEncabezado(table, "Ingresos Totales");
            
            for (Map.Entry<String, Double> entry : vehiculosRentables.entrySet()) {
                table.addCell(new PdfPCell(new Paragraph(entry.getKey())));
                table.addCell(new PdfPCell(new Paragraph(String.format("$%.2f", entry.getValue()))));
            }
            
            document.add(table);
        }
    }
    
    private void agregarEstadisticasVehiculos(Document document) throws DocumentException {
        int totalVehiculos = vehiculoDAO.listarTodosVehiculos().size();
        int vehiculosDisponibles = vehiculoDAO.contarVehiculosPorEstado("Disponible");
        int vehiculosAlquilados = vehiculoDAO.contarVehiculosPorEstado("Alquilado");
        int vehiculosMantenimiento = vehiculoDAO.contarVehiculosPorEstado("Mantenimiento");
        
        Font sectionFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        Paragraph section = new Paragraph("ESTADÍSTICAS DE VEHÍCULOS", sectionFont);
        section.setSpacingAfter(10);
        document.add(section);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10);
        
        agregarFilaTabla(table, "Total Vehículos:", String.valueOf(totalVehiculos));
        agregarFilaTabla(table, "Disponibles:", String.valueOf(vehiculosDisponibles));
        agregarFilaTabla(table, "Alquilados:", String.valueOf(vehiculosAlquilados));
        agregarFilaTabla(table, "En Mantenimiento:", String.valueOf(vehiculosMantenimiento));
        
        double porcentajeDisponibilidad = (vehiculosDisponibles * 100.0) / totalVehiculos;
        agregarFilaTabla(table, "Disponibilidad:", String.format("%.1f%%", porcentajeDisponibilidad));
        
        document.add(table);
    }
    
    private void agregarFilaTabla(PdfPTable table, String label, String value) {
        Font labelFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.BLACK);
        Font valueFont = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
        
        PdfPCell labelCell = new PdfPCell(new Paragraph(label, labelFont));
        labelCell.setBorderWidth(1);
        labelCell.setPadding(5);
        
        PdfPCell valueCell = new PdfPCell(new Paragraph(value, valueFont));
        valueCell.setBorderWidth(1);
        valueCell.setPadding(5);
        
        table.addCell(labelCell);
        table.addCell(valueCell);
    }
    
    private void agregarCeldaEncabezado(PdfPTable table, String texto) {
        Font font = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
        PdfPCell cell = new PdfPCell(new Paragraph(texto, font));
        cell.setBackgroundColor(BaseColor.DARK_GRAY);
        cell.setPadding(5);
        cell.setBorderWidth(1);
        table.addCell(cell);
    }
}