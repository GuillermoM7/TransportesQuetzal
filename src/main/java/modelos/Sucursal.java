package modelos;

public class Sucursal {
    private int idSucursal;
    private String nombre;
    private String direccion;
    private double latitud;
    private double longitud;

    public Sucursal() {
    }

    public Sucursal(int idSucursal, String nombre, String direccion) {
        this.idSucursal = idSucursal;
        this.nombre = nombre;
        this.direccion = direccion;
    }

    public int getIdSucursal() {
        return idSucursal;
    }

    public void setIdSucursal(int idSucursal) {
        this.idSucursal = idSucursal;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public double getLatitud() {
        return latitud;
    }

    public void setLatitud(double latitud) {
        this.latitud = latitud;
    }

    public double getLongitud() {
        return longitud;
    }

    public void setLongitud(double longitud) {
        this.longitud = longitud;
    }
    
}