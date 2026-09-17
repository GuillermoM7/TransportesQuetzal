package dtos;
import java.sql.Timestamp;

public class IngresosBoletosDTO {
    private int idViajeReg;
    private String origen;
    private String destino;
    private Timestamp fechaHoraSalida;
    private String placaBus;
    private int cantidadBoletosVendidos;
    private double ingresoTotal;

    
    public IngresosBoletosDTO() {
    }

    
    public int getIdViajeReg() {
        return idViajeReg;
    }

    public void setIdViajeReg(int idViajeReg) {
        this.idViajeReg = idViajeReg;
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

    public int getCantidadBoletosVendidos() {
        return cantidadBoletosVendidos;
    }

    public void setCantidadBoletosVendidos(int cantidadBoletosVendidos) {
        this.cantidadBoletosVendidos = cantidadBoletosVendidos;
    }

    public double getIngresoTotal() {
        return ingresoTotal;
    }

    public void setIngresoTotal(double ingresoTotal) {
        this.ingresoTotal = ingresoTotal;
    }

}