package modelos;

import java.sql.Timestamp;

public class Boleto {
    private int idBoleto;
    private int idViajeReg;
    private int idUsuarioCliente;
    private int numeroAsiento;
    private double precioPagado;
    private Timestamp fechaCompra;
    
    private String nombreRuta;
    private java.sql.Timestamp fechaHoraSalida;
    private String placaBus;

    public Boleto() {
    }

    public Boleto(int idBoleto, int idViajeReg, int idUsuarioCliente, int numeroAsiento, double precioPagado, Timestamp fechaCompra) {
        this.idBoleto = idBoleto;
        this.idViajeReg = idViajeReg;
        this.idUsuarioCliente = idUsuarioCliente;
        this.numeroAsiento = numeroAsiento;
        this.precioPagado = precioPagado;
        this.fechaCompra = fechaCompra;
    }

    public int getIdBoleto() {
        return idBoleto;
    }

    public void setIdBoleto(int idBoleto) {
        this.idBoleto = idBoleto;
    }

    public int getIdViajeReg() {
        return idViajeReg;
    }

    public void setIdViajeReg(int idViajeReg) {
        this.idViajeReg = idViajeReg;
    }

    public int getIdUsuarioCliente() {
        return idUsuarioCliente;
    }

    public void setIdUsuarioCliente(int idUsuarioCliente) {
        this.idUsuarioCliente = idUsuarioCliente;
    }

    public int getNumeroAsiento() {
        return numeroAsiento;
    }

    public void setNumeroAsiento(int numeroAsiento) {
        this.numeroAsiento = numeroAsiento;
    }

    public double getPrecioPagado() {
        return precioPagado;
    }

    public void setPrecioPagado(double precioPagado) {
        this.precioPagado = precioPagado;
    }

    public Timestamp getFechaCompra() {
        return fechaCompra;
    }

    public void setFechaCompra(Timestamp fechaCompra) {
        this.fechaCompra = fechaCompra;
    }

    public String getNombreRuta() {
        return nombreRuta;
    }

    public void setNombreRuta(String nombreRuta) {
        this.nombreRuta = nombreRuta;
    }

    public Timestamp getFechaHoraSalida() {
        return fechaHoraSalida;
    }

    public void setFechaHoraSalida(Timestamp fechaHoraSalida) {
        this.fechaHoraSalida = fechaHoraSalida;
    }

    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    
}