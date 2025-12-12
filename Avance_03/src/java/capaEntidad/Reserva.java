package capaEntidad;

public class Reserva {
    private int idReserva;
    private String marcaVehiculo;
    private String modeloVehiculo;
    private String fechaInicio;
    private String fechaFin;
    private int dias;
    private double total;
    private String metodoPago;
    private String estado;
    private String nombreCliente;
    private String dniCliente;
    
    // NUEVOS CAMPOS para información detallada
    private String telefonoCliente;
    private String emailCliente;
    private String matriculaVehiculo;
    private String tipoVehiculo;
    private double precioDiario;
    
    // Constructores
    public Reserva() {}
    
    public Reserva(int idReserva, String marcaVehiculo, String modeloVehiculo, String fechaInicio, 
                   String fechaFin, int dias, double total, String metodoPago, String estado,
                   String nombreCliente, String dniCliente) {
        this.idReserva = idReserva;
        this.marcaVehiculo = marcaVehiculo;
        this.modeloVehiculo = modeloVehiculo;
        this.fechaInicio = fechaInicio;
        this.fechaFin = fechaFin;
        this.dias = dias;
        this.total = total;
        this.metodoPago = metodoPago;
        this.estado = estado;
        this.nombreCliente = nombreCliente;
        this.dniCliente = dniCliente;
    }
    
    // Getters y Setters existentes...
    public int getIdReserva() { return idReserva; }
    public void setIdReserva(int idReserva) { this.idReserva = idReserva; }
    
    public String getMarcaVehiculo() { return marcaVehiculo; }
    public void setMarcaVehiculo(String marcaVehiculo) { this.marcaVehiculo = marcaVehiculo; }
    
    public String getModeloVehiculo() { return modeloVehiculo; }
    public void setModeloVehiculo(String modeloVehiculo) { this.modeloVehiculo = modeloVehiculo; }
    
    public String getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }
    
    public String getFechaFin() { return fechaFin; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }
    
    public int getDias() { return dias; }
    public void setDias(int dias) { this.dias = dias; }
    
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    
    public String getMetodoPago() { return metodoPago; }
    public void setMetodoPago(String metodoPago) { this.metodoPago = metodoPago; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }
    
    public String getDniCliente() { return dniCliente; }
    public void setDniCliente(String dniCliente) { this.dniCliente = dniCliente; }
    
    // NUEVOS Getters y Setters
    public String getTelefonoCliente() { return telefonoCliente; }
    public void setTelefonoCliente(String telefonoCliente) { this.telefonoCliente = telefonoCliente; }
    
    public String getEmailCliente() { return emailCliente; }
    public void setEmailCliente(String emailCliente) { this.emailCliente = emailCliente; }
    
    public String getMatriculaVehiculo() { return matriculaVehiculo; }
    public void setMatriculaVehiculo(String matriculaVehiculo) { this.matriculaVehiculo = matriculaVehiculo; }
    
    public String getTipoVehiculo() { return tipoVehiculo; }
    public void setTipoVehiculo(String tipoVehiculo) { this.tipoVehiculo = tipoVehiculo; }
    
    public double getPrecioDiario() { return precioDiario; }
    public void setPrecioDiario(double precioDiario) { this.precioDiario = precioDiario; }
}