package servlets;

import capaDatos.ReservaDAO;
import capaEntidad.Reserva;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DescargarBoletaServlet", urlPatterns = {"/descargar-boleta"})
public class DescargarBoletaServlet extends HttpServlet {

    private ReservaDAO reservaDAO;
    
    @Override
    public void init() {
        reservaDAO = new ReservaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idReservaParam = request.getParameter("idReserva");
        
        if (idReservaParam == null || idReservaParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de reserva no proporcionado");
            return;
        }
        
        try {
            int idReserva = Integer.parseInt(idReservaParam);
            
            // Obtener datos de la reserva
            Reserva reserva = reservaDAO.obtenerDetallesReserva(idReserva);
            
            if (reserva == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Reserva no encontrada");
                return;
            }
            
            // Configurar respuesta HTTP para PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=Boleta_FastWheels_" + idReserva + ".pdf");
            
            // Generar PDF
            generarBoletaPDF(reserva, response.getOutputStream());
            
            System.out.println("✅ Boleta PDF generada para reserva #" + idReserva);
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID de reserva inválido");
        } catch (DocumentException e) {
            System.out.println("❌ Error generando PDF: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generando boleta");
        }
    }
    
    private void generarBoletaPDF(Reserva reserva, OutputStream out) throws DocumentException, IOException {
        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, out);
        
        document.open();
        
        // ===== ENCABEZADO =====
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLUE);
        Font fontSubtitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL, BaseColor.DARK_GRAY);
        Font fontNegrita = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD);
        Font fontNormal = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL);
        Font fontGrande = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);
        
        // Logo y título (simulado con texto)
        Paragraph titulo = new Paragraph("FastWheels", fontTitulo);
        titulo.setAlignment(Element.ALIGN_CENTER);
        document.add(titulo);
        
        Paragraph subtitulo = new Paragraph("Alquiler de Vehículos", fontSubtitulo);
        subtitulo.setAlignment(Element.ALIGN_CENTER);
        subtitulo.setSpacingAfter(10);
        document.add(subtitulo);
        
        // Línea separadora usando LineSeparator corregido
        com.itextpdf.text.pdf.draw.LineSeparator linea = new com.itextpdf.text.pdf.draw.LineSeparator();
        linea.setLineColor(BaseColor.BLUE);
        document.add(new Chunk(linea));
        document.add(Chunk.NEWLINE);
        
        // Tipo de documento
        Paragraph tipoDeBoleta = new Paragraph("BOLETA DE ALQUILER", fontGrande);
        tipoDeBoleta.setAlignment(Element.ALIGN_CENTER);
        tipoDeBoleta.setSpacingAfter(5);
        document.add(tipoDeBoleta);
        
        Paragraph numeroReserva = new Paragraph("Reserva N° " + String.format("%06d", reserva.getIdReserva()), fontNegrita);
        numeroReserva.setAlignment(Element.ALIGN_CENTER);
        numeroReserva.setSpacingAfter(20);
        document.add(numeroReserva);
        
        // ===== INFORMACIÓN DE LA EMPRESA =====
        PdfPTable tablaEmpresa = new PdfPTable(2);
        tablaEmpresa.setWidthPercentage(100);
        tablaEmpresa.setSpacingAfter(15);
        
        agregarCeldaHeader(tablaEmpresa, "DATOS DE LA EMPRESA", 2, fontNegrita);
        agregarCelda(tablaEmpresa, "Razón Social:", "FastWheels S.A.C.", fontNegrita, fontNormal);
        agregarCelda(tablaEmpresa, "RUC:", "20123456789", fontNegrita, fontNormal);
        agregarCelda(tablaEmpresa, "Dirección:", "Av. Javier Prado 123, San Isidro, Lima", fontNegrita, fontNormal);
        agregarCelda(tablaEmpresa, "Teléfono:", "+51 986 131 694", fontNegrita, fontNormal);
        agregarCelda(tablaEmpresa, "Email:", "soporte@fastwheels.com", fontNegrita, fontNormal);
        
        document.add(tablaEmpresa);
        
        // ===== INFORMACIÓN DEL CLIENTE =====
        PdfPTable tablaCliente = new PdfPTable(2);
        tablaCliente.setWidthPercentage(100);
        tablaCliente.setSpacingAfter(15);
        
        agregarCeldaHeader(tablaCliente, "DATOS DEL CLIENTE", 2, fontNegrita);
        agregarCelda(tablaCliente, "Nombre:", reserva.getNombreCliente(), fontNegrita, fontNormal);
        agregarCelda(tablaCliente, "DNI:", reserva.getDniCliente(), fontNegrita, fontNormal);
        agregarCelda(tablaCliente, "Teléfono:", reserva.getTelefonoCliente(), fontNegrita, fontNormal);
        agregarCelda(tablaCliente, "Email:", reserva.getEmailCliente(), fontNegrita, fontNormal);
        
        document.add(tablaCliente);
        
        // ===== INFORMACIÓN DEL VEHÍCULO =====
        PdfPTable tablaVehiculo = new PdfPTable(2);
        tablaVehiculo.setWidthPercentage(100);
        tablaVehiculo.setSpacingAfter(15);
        
        agregarCeldaHeader(tablaVehiculo, "DATOS DEL VEHÍCULO", 2, fontNegrita);
        agregarCelda(tablaVehiculo, "Vehículo:", reserva.getMarcaVehiculo() + " " + reserva.getModeloVehiculo(), fontNegrita, fontNormal);
        agregarCelda(tablaVehiculo, "Matrícula:", reserva.getMatriculaVehiculo(), fontNegrita, fontNormal);
        agregarCelda(tablaVehiculo, "Tipo:", reserva.getTipoVehiculo(), fontNegrita, fontNormal);
        agregarCelda(tablaVehiculo, "Precio por día:", "S/ " + String.format("%.2f", reserva.getPrecioDiario()), fontNegrita, fontNormal);
        
        document.add(tablaVehiculo);
        
        // ===== DETALLES DE LA RESERVA =====
        PdfPTable tablaReserva = new PdfPTable(2);
        tablaReserva.setWidthPercentage(100);
        tablaReserva.setSpacingAfter(15);
        
        agregarCeldaHeader(tablaReserva, "DETALLES DE LA RESERVA", 2, fontNegrita);
        agregarCelda(tablaReserva, "Fecha de Inicio:", reserva.getFechaInicio(), fontNegrita, fontNormal);
        agregarCelda(tablaReserva, "Fecha de Devolución:", reserva.getFechaFin(), fontNegrita, fontNormal);
        agregarCelda(tablaReserva, "Días de alquiler:", String.valueOf(reserva.getDias()) + " días", fontNegrita, fontNormal);
        agregarCelda(tablaReserva, "Método de Pago:", reserva.getMetodoPago(), fontNegrita, fontNormal);
        agregarCelda(tablaReserva, "Estado:", reserva.getEstado(), fontNegrita, fontNormal);
        
        document.add(tablaReserva);
        
        // ===== DETALLE DE COSTOS =====
        double subtotal = reserva.getDias() * reserva.getPrecioDiario();
        double igv = subtotal * 0.18;
        double total = subtotal + igv;
        
        PdfPTable tablaCostos = new PdfPTable(2);
        tablaCostos.setWidthPercentage(100);
        tablaCostos.setWidths(new float[]{3, 1});
        tablaCostos.setSpacingAfter(20);
        
        agregarCeldaHeader(tablaCostos, "DETALLE DE COSTOS", 2, fontNegrita);
        
        // Subtotal
        PdfPCell cellSubtotalLabel = new PdfPCell(new Phrase("Subtotal:", fontNormal));
        cellSubtotalLabel.setBorder(Rectangle.NO_BORDER);
        cellSubtotalLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellSubtotalLabel.setPaddingRight(10);
        tablaCostos.addCell(cellSubtotalLabel);
        
        PdfPCell cellSubtotal = new PdfPCell(new Phrase("S/ " + String.format("%.2f", subtotal), fontNormal));
        cellSubtotal.setBorder(Rectangle.NO_BORDER);
        cellSubtotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tablaCostos.addCell(cellSubtotal);
        
        // IGV
        PdfPCell cellIgvLabel = new PdfPCell(new Phrase("IGV (18%):", fontNormal));
        cellIgvLabel.setBorder(Rectangle.NO_BORDER);
        cellIgvLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellIgvLabel.setPaddingRight(10);
        tablaCostos.addCell(cellIgvLabel);
        
        PdfPCell cellIgv = new PdfPCell(new Phrase("S/ " + String.format("%.2f", igv), fontNormal));
        cellIgv.setBorder(Rectangle.NO_BORDER);
        cellIgv.setHorizontalAlignment(Element.ALIGN_RIGHT);
        tablaCostos.addCell(cellIgv);
        
        // Total
        Font fontTotal = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLUE);
        
        PdfPCell cellTotalLabel = new PdfPCell(new Phrase("TOTAL A PAGAR:", fontTotal));
        cellTotalLabel.setBorder(Rectangle.TOP);
        cellTotalLabel.setBorderWidthTop(2);
        cellTotalLabel.setBorderColorTop(BaseColor.BLUE);
        cellTotalLabel.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellTotalLabel.setPaddingTop(10);
        cellTotalLabel.setPaddingRight(10);
        tablaCostos.addCell(cellTotalLabel);
        
        PdfPCell cellTotal = new PdfPCell(new Phrase("S/ " + String.format("%.2f", total), fontTotal));
        cellTotal.setBorder(Rectangle.TOP);
        cellTotal.setBorderWidthTop(2);
        cellTotal.setBorderColorTop(BaseColor.BLUE);
        cellTotal.setHorizontalAlignment(Element.ALIGN_RIGHT);
        cellTotal.setPaddingTop(10);
        tablaCostos.addCell(cellTotal);
        
        document.add(tablaCostos);
        
        // ===== TÉRMINOS Y CONDICIONES =====
        Paragraph tituloTerminos = new Paragraph("TÉRMINOS Y CONDICIONES", fontNegrita);
        tituloTerminos.setSpacingBefore(10);
        tituloTerminos.setSpacingAfter(10);
        document.add(tituloTerminos);
        
        Font fontPequeno = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL);
        
        Paragraph terminos = new Paragraph();
        terminos.setFont(fontPequeno);
        terminos.setAlignment(Element.ALIGN_JUSTIFIED);
        terminos.add("• El vehículo debe ser devuelto en la fecha y hora indicadas. Retrasos generan cargos adicionales.\n");
        terminos.add("• Es obligatorio presentar DNI vigente y licencia de conducir al momento de recoger el vehículo.\n");
        terminos.add("• El cliente es responsable por cualquier daño o multa durante el período de alquiler.\n");
        terminos.add("• Se requiere un depósito de garantía que será devuelto al finalizar el alquiler si no hay daños.\n");
        terminos.add("• Cancela tu reserva con al menos 24 horas de anticipación para evitar cargos.\n");
        terminos.setSpacingAfter(20);
        document.add(terminos);
        
        // ===== FECHA DE EMISIÓN =====
        Paragraph fechaEmision = new Paragraph(
            "Fecha de emisión: " + LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy")), 
            fontPequeno
        );
        fechaEmision.setAlignment(Element.ALIGN_RIGHT);
        fechaEmision.setSpacingAfter(30);
        document.add(fechaEmision);
        
        // ===== FIRMA =====
        Paragraph firma = new Paragraph("_______________________________", fontNormal);
        firma.setAlignment(Element.ALIGN_CENTER);
        document.add(firma);
        
        Paragraph nombreFirma = new Paragraph("Firma y Sello de FastWheels", fontPequeno);
        nombreFirma.setAlignment(Element.ALIGN_CENTER);
        document.add(nombreFirma);
        
        document.close();
    }
    
    // Métodos auxiliares para crear celdas de tabla
    private void agregarCeldaHeader(PdfPTable tabla, String texto, int colspan, Font font) {
        PdfPCell cell = new PdfPCell(new Phrase(texto, font));
        cell.setColspan(colspan);
        cell.setBackgroundColor(new BaseColor(30, 58, 138)); // Azul oscuro
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setPadding(8);
        Font fontBlanco = new Font(font);
        fontBlanco.setColor(BaseColor.WHITE);
        cell.setPhrase(new Phrase(texto, fontBlanco));
        tabla.addCell(cell);
    }
    
    private void agregarCelda(PdfPTable tabla, String label, String valor, Font fontLabel, Font fontValor) {
        PdfPCell cellLabel = new PdfPCell(new Phrase(label, fontLabel));
        cellLabel.setBorder(Rectangle.BOTTOM);
        cellLabel.setBorderColor(BaseColor.LIGHT_GRAY);
        cellLabel.setPadding(8);
        tabla.addCell(cellLabel);
        
        PdfPCell cellValor = new PdfPCell(new Phrase(valor, fontValor));
        cellValor.setBorder(Rectangle.BOTTOM);
        cellValor.setBorderColor(BaseColor.LIGHT_GRAY);
        cellValor.setPadding(8);
        tabla.addCell(cellValor);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet para generar y descargar boletas en PDF";
    }
}