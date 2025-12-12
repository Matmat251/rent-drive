package capaEntidad;

public class Vehiculo {
    private int idVehiculo;
    private String marca;
    private String modelo;
    private int anio;
    private String matricula;
    private String tipo;
    private double precioDiario;
    private String estado;
    
    // Constructores
    public Vehiculo() {}
    
    public Vehiculo(int idVehiculo, String marca, String modelo, int anio, String matricula, 
                   String tipo, double precioDiario, String estado) {
        this.idVehiculo = idVehiculo;
        this.marca = marca;
        this.modelo = modelo;
        this.anio = anio;
        this.matricula = matricula;
        this.tipo = tipo;
        this.precioDiario = precioDiario;
        this.estado = estado;
    }
    
    // Getters y Setters
    public int getIdVehiculo() { return idVehiculo; }
    public void setIdVehiculo(int idVehiculo) { this.idVehiculo = idVehiculo; }
    
    public String getMarca() { return marca; }
    public void setMarca(String marca) { this.marca = marca; }
    
    public String getModelo() { return modelo; }
    public void setModelo(String modelo) { this.modelo = modelo; }
    
    public int getAnio() { return anio; }
    public void setAnio(int anio) { this.anio = anio; }
    
    public String getMatricula() { return matricula; }
    public void setMatricula(String matricula) { this.matricula = matricula; }
    
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    
    public double getPrecioDiario() { return precioDiario; }
    public void setPrecioDiario(double precioDiario) { this.precioDiario = precioDiario; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}