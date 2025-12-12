package capaEntidad;

public class Empleado {
    private int idEmpleado;
    private String nombre;
    private String apellido;
    private String cargo;
    private String usuario;
    private String contraseña;
    
    // Constructores
    public Empleado() {}
    
    public Empleado(int idEmpleado, String nombre, String apellido, String cargo, String usuario, String contraseña) {
        this.idEmpleado = idEmpleado;
        this.nombre = nombre;
        this.apellido = apellido;
        this.cargo = cargo;
        this.usuario = usuario;
        this.contraseña = contraseña;
    }
    
    // Getters y Setters 
    public int getIdEmpleado() { return idEmpleado; }
    public void setIdEmpleado(int idEmpleado) { this.idEmpleado = idEmpleado; }
    
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    
    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }
    
    public String getUsuario() { return usuario; }
    public void setUsuario(String usuario) { this.usuario = usuario; }
    
    public String getContraseña() { return contraseña; }
    public void setContraseña(String contraseña) { this.contraseña = contraseña; }
}