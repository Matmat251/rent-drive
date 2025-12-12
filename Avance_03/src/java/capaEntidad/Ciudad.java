package capaEntidad;

public class Ciudad {
    private int idCiudad;
    private String nombreCiudad;
    private String estado;
    
    // Constructores
    public Ciudad() {}
    
    public Ciudad(int idCiudad, String nombreCiudad, String estado) {
        this.idCiudad = idCiudad;
        this.nombreCiudad = nombreCiudad;
        this.estado = estado;
    }
    
    // Getters y Setters
    public int getIdCiudad() {
        return idCiudad;
    }
    
    public void setIdCiudad(int idCiudad) {
        this.idCiudad = idCiudad;
    }
    
    public String getNombreCiudad() {
        return nombreCiudad;
    }
    
    public void setNombreCiudad(String nombreCiudad) {
        this.nombreCiudad = nombreCiudad;
    }
    
    public String getEstado() {
        return estado;
    }
    
    public void setEstado(String estado) {
        this.estado = estado;
    }
    
    @Override
    public String toString() {
        return "Ciudad{" + "idCiudad=" + idCiudad + ", nombreCiudad=" + nombreCiudad + ", estado=" + estado + '}';
    }
}