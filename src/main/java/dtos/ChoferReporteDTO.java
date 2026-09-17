package dtos;

import java.sql.Date;

public class ChoferReporteDTO {
    private String licencia;
    private String nombreCompleto;
    private String tipoLicencia;
    private Date fechaVencimiento;
    private String estado;
    private int totalViajesRealizados;

    public ChoferReporteDTO() {
    }

    
    public String getLicencia() {
        return licencia;
    }

    public void setLicencia(String licencia) {
        this.licencia = licencia;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
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

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getTotalViajesRealizados() {
        return totalViajesRealizados;
    }

    public void setTotalViajesRealizados(int totalViajesRealizados) {
        this.totalViajesRealizados = totalViajesRealizados;
    }
    
    
}
