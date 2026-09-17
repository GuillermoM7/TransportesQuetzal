package dtos;
import java.sql.Timestamp;

public class IngresoAlquilerDTO {
    private int idViajePriv;
    private String nombreCliente;
    private String origen;
    private String destino;
    private Timestamp fechaHoraSalida;
    private String placaBus;
    private double precioTotal;

    
    public IngresoAlquilerDTO() {
    }

    
    public int getIdViajePriv() {
        return idViajePriv;
    }

    public void setIdViajePriv(int idViajePriv) {
        this.idViajePriv = idViajePriv;
    }

    public String getNombreCliente() {
        return nombreCliente;
    }

    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
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

    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    public double getPrecioTotal() {
        return precioTotal;
    }

    public void setPrecioTotal(double precioTotal) {
        this.precioTotal = precioTotal;
    }

}