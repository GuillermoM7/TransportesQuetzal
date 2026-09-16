package modelos;

public class Ruta {
    private int idRuta;
    private int idSucursalOrigen;
    private int idSucursalDestino;
    private double distanciaKm;
    private double precioBoleto;
    private String estado; 

    private String nombreOrigen;
    private String nombreDestino;
    private double latOrigen;
    private double lonOrigen;
    private double latDestino;
    private double lonDestino;
    private String direccionDestino;

    public Ruta() {
    }

    public Ruta(int idRuta, int idSucursalOrigen, int idSucursalDestino, double distanciaKm, double precioBoleto, String estado, String nombreOrigen, String nombreDestino) {
        this.idRuta = idRuta;
        this.idSucursalOrigen = idSucursalOrigen;
        this.idSucursalDestino = idSucursalDestino;
        this.distanciaKm = distanciaKm;
        this.precioBoleto = precioBoleto;
        this.estado = estado;
        this.nombreOrigen = nombreOrigen;
        this.nombreDestino = nombreDestino;
    }

    public int getIdRuta() {
        return idRuta;
    }

    public void setIdRuta(int idRuta) {
        this.idRuta = idRuta;
    }

    public int getIdSucursalOrigen() {
        return idSucursalOrigen;
    }

    public void setIdSucursalOrigen(int idSucursalOrigen) {
        this.idSucursalOrigen = idSucursalOrigen;
    }

    public int getIdSucursalDestino() {
        return idSucursalDestino;
    }

    public void setIdSucursalDestino(int idSucursalDestino) {
        this.idSucursalDestino = idSucursalDestino;
    }

    public double getDistanciaKm() {
        return distanciaKm;
    }

    public void setDistanciaKm(double distanciaKm) {
        this.distanciaKm = distanciaKm;
    }

    public double getPrecioBoleto() {
        return precioBoleto;
    }

    public void setPrecioBoleto(double precioBoleto) {
        this.precioBoleto = precioBoleto;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombreOrigen() {
        return nombreOrigen;
    }

    public void setNombreOrigen(String nombreOrigen) {
        this.nombreOrigen = nombreOrigen;
    }

    public String getNombreDestino() {
        return nombreDestino;
    }

    public void setNombreDestino(String nombreDestino) {
        this.nombreDestino = nombreDestino;
    }

    public String getDireccionDestino() {
        return direccionDestino;
    }

    public void setDireccionDestino(String direccionDestino) {
        this.direccionDestino = direccionDestino;
    }

    public double getLatOrigen() {
        return latOrigen;
    }

    public void setLatOrigen(double latOrigen) {
        this.latOrigen = latOrigen;
    }

    public double getLonOrigen() {
        return lonOrigen;
    }

    public void setLonOrigen(double lonOrigen) {
        this.lonOrigen = lonOrigen;
    }

    public double getLatDestino() {
        return latDestino;
    }

    public void setLatDestino(double latDestino) {
        this.latDestino = latDestino;
    }

    public double getLonDestino() {
        return lonDestino;
    }

    public void setLonDestino(double lonDestino) {
        this.lonDestino = lonDestino;
    }
     
    
}