package capaEntidad;

import java.time.LocalDate;

public class BloqueoCalendario {
    private int idBloqueo;
    private int idVehiculo;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String motivo;
    private String descripcion;
    private String createdAt;
    
    // Constructores
    public BloqueoCalendario() {}
    
    public BloqueoCalendario(int idBloqueo, int idVehiculo, LocalDate fechaInicio, 
                           LocalDate fechaFin, String motivo, String descripcion) {
        this.idBloqueo = idBloqueo;
        this.idVehiculo = idVehiculo;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.motivo = motivo;
        this.descripcion = descripcion;
    }
    
    // Getters y Setters
    public int getIdBloqueo() { return idBloqueo; }
    public void setIdBloqueo(int idBloqueo) { this.idBloqueo = idBloqueo; }
    
    public int getIdVehiculo() { return idVehiculo; }
    public void setIdVehiculo(int idVehiculo) { this.idVehiculo = idVehiculo; }
    
    public LocalDate getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(LocalDate fechaInicio) { this.fechaInicio = fechaInicio; }
    
    public LocalDate getFechaFin() { return fechaFin; }
    public void setFechaFin(LocalDate fechaFin) { this.fechaFin = fechaFin; }
    
    public String getMotivo() { return motivo; }
    public void setMotivo(String motivo) { this.motivo = motivo; }
    
    public String getDescripcion() { return descripcion; }
    public void setDescripcion(String descripcion) { this.descripcion = descripcion; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}