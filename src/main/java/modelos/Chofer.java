package modelos;
import modelos.enums.Estado;
import java.sql.Date;

public class Chofer {
    private int idChofer;
    private String nombre;
    private String licencia;
    private String tipoLicencia;
    private Date fechaVencimiento;
    private String telefono;
    private double salarioBase;
    private String foto;
    private Estado estado;
    private int idSucursal;

    public Chofer() {
    }

    public Chofer(int idChofer, String nombre, String licencia, String tipoLicencia, Date fechaVencimiento, String telefono, double salarioBase, String foto, Estado estado, int idSucursal) {
        this.idChofer = idChofer;
        this.nombre = nombre;
        this.licencia = licencia;
        this.tipoLicencia = tipoLicencia;
        this.fechaVencimiento = fechaVencimiento;
        this.telefono = telefono;
        this.salarioBase = salarioBase;
        this.foto = foto;
        this.estado = estado;
        this.idSucursal = idSucursal;
    }

    public int getIdChofer() {
        return idChofer;
    }

    public void setIdChofer(int idChofer) {
        this.idChofer = idChofer;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getLicencia() {
        return licencia;
    }

    public void setLicencia(String licencia) {
        this.licencia = licencia;
    }

    public String getTipoLicencia() {
        return tipoLicencia;
    }

    public void setTipoLicencia(String tipoLicencia) {
        this.tipoLicencia = tipoLicencia;
    }

    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public double getSalarioBase() {
        return salarioBase;
    }

    public void setSalarioBase(double salarioBase) {
        this.salarioBase = salarioBase;
    }

    public String getFoto() {
        return foto;
    }

    public void setFoto(String foto) {
        this.foto = foto;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    public int getIdSucursal() {
        return idSucursal;
    }

    public void setIdSucursal(int idSucursal) {
        this.idSucursal = idSucursal;
    }
    
    

}