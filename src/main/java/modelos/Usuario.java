package modelos;
import modelos.enums.Rol;
import modelos.enums.Estado;

public class Usuario {
    private int idUsuario;
    private String dpi;
    private String nombre;
    private String nit;
    private String telefono;
    private String direccion;
    private String contrasena;
    private double saldoCartera; 
    private Estado estado;
    private Rol rol;
    private Integer idSucursalAsignada; 

    public Usuario() {
    }

    public Usuario(int idUsuario, String dpi, String nombre, String nit, String telefono, String direccion, String contrasena, double saldoCartera, Estado estado, Rol rol, Integer idSucursalAsignada) {
        this.idUsuario = idUsuario;
        this.dpi = dpi;
        this.nombre = nombre;
        this.nit = nit;
        this.telefono = telefono;
        this.direccion = direccion;
        this.contrasena = contrasena;
        this.saldoCartera = saldoCartera;
        this.estado = estado;
        this.rol = rol;
        this.idSucursalAsignada = idSucursalAsignada;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getDpi() {
        return dpi;
    }

    public void setDpi(String dpi) {
        this.dpi = dpi;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getNit() {
        return nit;
    }

    public void setNit(String nit) {
        this.nit = nit;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public double getSaldoCartera() {
        return saldoCartera;
    }

    public void setSaldoCartera(double saldoCartera) {
        this.saldoCartera = saldoCartera;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    public Rol getRol() {
        return rol;
    }

    public void setRol(Rol rol) {
        this.rol = rol;
    }

    public Integer getIdSucursalAsignada() {
        return idSucursalAsignada;
    }

    public void setIdSucursalAsignada(Integer idSucursalAsignada) {
        this.idSucursalAsignada = idSucursalAsignada;
    }
    
}