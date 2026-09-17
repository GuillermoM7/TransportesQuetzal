package modelos;

import java.sql.Timestamp;

public class ControlViaje {
    private int idControl;
    private Integer idViajeReg; 
    private Integer idViajePriv;
    private Timestamp horaRealSalida;
    private double kilometrajeInicial;
    private Timestamp horaRealLlegada;
    private double kilometrajeFinal;
    private double gastoCombustible;
    private double montoDepreciacionAplicado;

    public ControlViaje() {
    }

    public ControlViaje(int idControl, Integer idViajeReg, Integer idViajePriv, Timestamp horaRealSalida, double kilometrajeInicial, Timestamp horaRealLlegada, double kilometrajeFinal, double gastoCombustible, double montoDepreciacionAplicado) {
        this.idControl = idControl;
        this.idViajeReg = idViajeReg;
        this.idViajePriv = idViajePriv;
        this.horaRealSalida = horaRealSalida;
        this.kilometrajeInicial = kilometrajeInicial;
        this.horaRealLlegada = horaRealLlegada;
        this.kilometrajeFinal = kilometrajeFinal;
        this.gastoCombustible = gastoCombustible;
        this.montoDepreciacionAplicado = montoDepreciacionAplicado;
    }

    public int getIdControl() {
        return idControl;
    }

    public void setIdControl(int idControl) {
        this.idControl = idControl;
    }

    public Integer getIdViajeReg() {
        return idViajeReg;
    }

    public void setIdViajeReg(Integer idViajeReg) {
        this.idViajeReg = idViajeReg;
    }

    public Integer getIdViajePriv() {
        return idViajePriv;
    }

    public void setIdViajePriv(Integer idViajePriv) {
        this.idViajePriv = idViajePriv;
    }

    public Timestamp getHoraRealSalida() {
        return horaRealSalida;
    }

    public void setHoraRealSalida(Timestamp horaRealSalida) {
        this.horaRealSalida = horaRealSalida;
    }

    public double getKilometrajeInicial() {
        return kilometrajeInicial;
    }

    public void setKilometrajeInicial(double kilometrajeInicial) {
        this.kilometrajeInicial = kilometrajeInicial;
    }

    public Timestamp getHoraRealLlegada() {
        return horaRealLlegada;
    }

    public void setHoraRealLlegada(Timestamp horaRealLlegada) {
        this.horaRealLlegada = horaRealLlegada;
    }

    public double getKilometrajeFinal() {
        return kilometrajeFinal;
    }

    public void setKilometrajeFinal(double kilometrajeFinal) {
        this.kilometrajeFinal = kilometrajeFinal;
    }

    public double getGastoCombustible() {
        return gastoCombustible;
    }

    public void setGastoCombustible(double gastoCombustible) {
        this.gastoCombustible = gastoCombustible;
    }

    public double getMontoDepreciacionAplicado() {
        return montoDepreciacionAplicado;
    }

    public void setMontoDepreciacionAplicado(double montoDepreciacionAplicado) {
        this.montoDepreciacionAplicado = montoDepreciacionAplicado;
    }
    
    

}