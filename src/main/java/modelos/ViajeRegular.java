package modelos;

import java.sql.Timestamp;

public class ViajeRegular {
    private int idViajeReg;
    private int idRuta;
    private int idBus;
    private int idChofer;
    private Timestamp fechaHoraSalida;
    private Timestamp fechaHoraLlegadaEstimada;
    private String estado;
    private double kilometrajeBus;
    private double KilometrajeInicial;
    
    private String destinoRuta;
    private String placaBus;
    private String nombreChofer;
    private String nombreRuta;
    private double precio;
    private int asientosDisponibles;

    public ViajeRegular() {}

    
    public ViajeRegular(int idViajeReg, int idRuta, int idBus, int idChofer, Timestamp fechaHoraSalida, Timestamp fechaHoraLlegadaEstimada, String estado, String destinoRuta, String placaBus, String nombreChofer, double kilometrajeBus, double KilometrajeInicial) {
        this.idViajeReg = idViajeReg;
        this.idRuta = idRuta;
        this.idBus = idBus;
        this.idChofer = idChofer;
        this.fechaHoraSalida = fechaHoraSalida;
        this.fechaHoraLlegadaEstimada = fechaHoraLlegadaEstimada;
        this.estado = estado;
        this.destinoRuta = destinoRuta;
        this.placaBus = placaBus;
        this.nombreChofer = nombreChofer;
        this.kilometrajeBus = kilometrajeBus;
        this.KilometrajeInicial = KilometrajeInicial;
    }

    
    public int getIdViajeReg() {
        return idViajeReg;
    }

    public void setIdViajeReg(int idViajeReg) {
        this.idViajeReg = idViajeReg;
    }

    public int getIdRuta() {
        return idRuta;
    }

    public void setIdRuta(int idRuta) {
        this.idRuta = idRuta;
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

    public Timestamp getFechaHoraSalida() {
        return fechaHoraSalida;
    }

    public void setFechaHoraSalida(Timestamp fechaHoraSalida) {
        this.fechaHoraSalida = fechaHoraSalida;
    }

    public Timestamp getFechaHoraLlegadaEstimada() {
        return fechaHoraLlegadaEstimada;
    }

    public void setFechaHoraLlegadaEstimada(Timestamp fechaHoraLlegadaEstimada) {
        this.fechaHoraLlegadaEstimada = fechaHoraLlegadaEstimada;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getDestinoRuta() {
        return destinoRuta;
    }

    public void setDestinoRuta(String destinoRuta) {
        this.destinoRuta = destinoRuta;
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

    public String getNombreRuta() {
        return nombreRuta;
    }

    public void setNombreRuta(String nombreRuta) {
        this.nombreRuta = nombreRuta;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getAsientosDisponibles() {
        return asientosDisponibles;
    }

    public void setAsientosDisponibles(int asientosDisponibles) {
        this.asientosDisponibles = asientosDisponibles;
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