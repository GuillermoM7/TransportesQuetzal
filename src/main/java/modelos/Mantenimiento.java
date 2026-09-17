package modelos;

import java.sql.Date;

public class Mantenimiento {
    private int idMantenimiento;
    private int idBus;
    private double montoManoDeObra;
    private double montoRepuesto;
    private Date fechaMantenimiento;

    public Mantenimiento() {
    }

    public Mantenimiento(int idMantenimiento, int idBus, double montoManoDeObra, double montoRepuesto, Date fechaMantenimiento) {
        this.idMantenimiento = idMantenimiento;
        this.idBus = idBus;
        this.montoManoDeObra = montoManoDeObra;
        this.montoRepuesto = montoRepuesto;
        this.fechaMantenimiento = fechaMantenimiento;
    }

    public int getIdMantenimiento() {
        return idMantenimiento;
    }

    public void setIdMantenimiento(int idMantenimiento) {
        this.idMantenimiento = idMantenimiento;
    }

    public int getIdBus() {
        return idBus;
    }

    public void setIdBus(int idBus) {
        this.idBus = idBus;
    }

    public double getMontoManoDeObra() {
        return montoManoDeObra;
    }

    public void setMontoManoDeObra(double montoManoDeObra) {
        this.montoManoDeObra = montoManoDeObra;
    }

    public double getMontoRepuesto() {
        return montoRepuesto;
    }

    public void setMontoRepuesto(double montoRepuesto) {
        this.montoRepuesto = montoRepuesto;
    }

    public Date getFechaMantenimiento() {
        return fechaMantenimiento;
    }

    public void setFechaMantenimiento(Date fechaMantenimiento) {
        this.fechaMantenimiento = fechaMantenimiento;
    }
    
}
