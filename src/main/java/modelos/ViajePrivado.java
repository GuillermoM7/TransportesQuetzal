package modelos;

import java.sql.Timestamp;

public class ViajePrivado {
    private int idViajePriv;
    private int idSucursal;
    private int idUsuarioCliente;
    private int idBus; 
    private int idChofer; 
    private String origen;
    private String destino;
    private Timestamp fechaHoraSalida;
    private Timestamp fechaHoraRetorno;
    private int cantidadPasajeros;
    private double precioEstimado;
    private String estado;
    private double kilometrajeBus;
    private double KilometrajeInicial;
    
    private double bonoChofer;
    private String nombreCliente;
    private String placaBus;
    private String nombreChofer;

    public ViajePrivado() {}

    public ViajePrivado(int idViajePriv, int idSucursal, int idUsuarioCliente, int idBus, int idChofer, String origen, String destino, Timestamp fechaHoraSalida, Timestamp fechaHoraRetorno, int cantidadPasajeros, double precioEstimado, String estado, String nombreCliente, String placaBus, String nombreChofer, double bonoChofer, double kilometrajeBus, double KilometrajeInicial) {
        this.idViajePriv = idViajePriv;
        this.idSucursal = idSucursal;
        this.idUsuarioCliente = idUsuarioCliente;
        this.idBus = idBus;
        this.idChofer = idChofer;
        this.origen = origen;
        this.destino = destino;
        this.fechaHoraSalida = fechaHoraSalida;
        this.fechaHoraRetorno = fechaHoraRetorno;
        this.cantidadPasajeros = cantidadPasajeros;
        this.precioEstimado = precioEstimado;
        this.estado = estado;
        this.nombreCliente = nombreCliente;
        this.placaBus = placaBus;
        this.nombreChofer = nombreChofer;
        this.kilometrajeBus = kilometrajeBus;
        this.KilometrajeInicial = KilometrajeInicial;
    }

    public int getIdViajePriv() {
        return idViajePriv;
    }

    public void setIdViajePriv(int idViajePriv) {
        this.idViajePriv = idViajePriv;
    }

    public int getIdSucursal() {
        return idSucursal;
    }

    public void setIdSucursal(int idSucursal) {
        this.idSucursal = idSucursal;
    }

    public int getIdUsuarioCliente() {
        return idUsuarioCliente;
    }

    public void setIdUsuarioCliente(int idUsuarioCliente) {
        this.idUsuarioCliente = idUsuarioCliente;
    }

    public int getIdBus() {
        return idBus;
    }

    public void setIdBus(int idBus) {
        this.idBus = idBus;
    }

    public int getIdChofer() {
        return idChofer;
    }

    public void setIdChofer(int idChofer) {
        this.idChofer = idChofer;
    }

    public String getOrigen() {
        return origen;
    }

    public void setOrigen(String origen) {
        this.origen = origen;
    }

    public String getDestino() {
        return destino;
    }

    public void setDestino(String destino) {
        this.destino = destino;
    }

    public Timestamp getFechaHoraSalida() {
        return fechaHoraSalida;
    }

    public void setFechaHoraSalida(Timestamp fechaHoraSalida) {
        this.fechaHoraSalida = fechaHoraSalida;
    }

    public Timestamp getFechaHoraRetorno() {
        return fechaHoraRetorno;
    }

    public void setFechaHoraRetorno(Timestamp fechaHoraRetorno) {
        this.fechaHoraRetorno = fechaHoraRetorno;
    }

    public int getCantidadPasajeros() {
        return cantidadPasajeros;
    }

    public void setCantidadPasajeros(int cantidadPasajeros) {
        this.cantidadPasajeros = cantidadPasajeros;
    }

    public double getPrecioEstimado() {
        return precioEstimado;
    }

    public void setPrecioEstimado(double precioEstimado) {
        this.precioEstimado = precioEstimado;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    public String getNombreChofer() {
        return nombreChofer;
    }

    public void setNombreChofer(String nombreChofer) {
        this.nombreChofer = nombreChofer;
    }

    public double getBonoChofer() {
        return bonoChofer;
    }

    public void setBonoChofer(double bonoChofer) {
        this.bonoChofer = bonoChofer;
    }

    public double getKilometrajeBus() {
        return kilometrajeBus;
    }

    public void setKilometrajeBus(double kilometrajeBus) {
        this.kilometrajeBus = kilometrajeBus;
    }

    public double getKilometrajeInicial() {
        return KilometrajeInicial;
    }

    public void setKilometrajeInicial(double KilometrajeInicial) {
        this.KilometrajeInicial = KilometrajeInicial;
    }    
}