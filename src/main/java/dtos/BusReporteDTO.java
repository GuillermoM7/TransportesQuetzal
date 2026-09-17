package dtos;

public class BusReporteDTO {
    private String placa;
    private String marca;
    private String modelo;
    private int capacidad;
    private String estadoOperativo;
    private String choferAsignadoActual; 
    private double kilometrajeActual;
    private int totalViajesRealizados;

    public BusReporteDTO() {
    }
    
    
    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public void setCapacidad(int capacidad) {
        this.capacidad = capacidad;
    }

    public String getEstadoOperativo() {
        return estadoOperativo;
    }

    public void setEstadoOperativo(String estadoOperativo) {
        this.estadoOperativo = estadoOperativo;
    }

    public String getChoferAsignadoActual() {
        return choferAsignadoActual;
    }

    public void setChoferAsignadoActual(String choferAsignadoActual) {
        this.choferAsignadoActual = choferAsignadoActual;
    }

    public double getKilometrajeActual() {
        return kilometrajeActual;
    }

    public void setKilometrajeActual(double kilometrajeActual) {
        this.kilometrajeActual = kilometrajeActual;
    }

    public int getTotalViajesRealizados() {
        return totalViajesRealizados;
    }

    public void setTotalViajesRealizados(int totalViajesRealizados) {
        this.totalViajesRealizados = totalViajesRealizados;
    }
}