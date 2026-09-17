package dtos;

public class GananciaReporteDTO {
    private String nombreSucursal;
    private double ingresosBoletos;
    private double ingresosAlquiler;
    private double costoCombustible;
    private double costoTaller; 
    private double costoDepreciacion;
    private double pagoChoferes;


    public double getTotalIngresos() { 
        return ingresosBoletos + ingresosAlquiler;
    }
    public double getTotalCostos() {
        return costoCombustible + costoTaller + costoDepreciacion + pagoChoferes; 
    }
    public double getGananciaNeta() {
        return getTotalIngresos() - getTotalCostos(); 
    }

    public String getNombreSucursal() {
        return nombreSucursal;
    }

    public void setNombreSucursal(String nombreSucursal) {
        this.nombreSucursal = nombreSucursal;
    }

    public double getIngresosBoletos() {
        return ingresosBoletos;
    }

    public void setIngresosBoletos(double ingresosBoletos) {
        this.ingresosBoletos = ingresosBoletos;
    }

    public double getIngresosAlquiler() {
        return ingresosAlquiler;
    }

    public void setIngresosAlquiler(double ingresosAlquiler) {
        this.ingresosAlquiler = ingresosAlquiler;
    }

    public double getCostoCombustible() {
        return costoCombustible;
    }

    public void setCostoCombustible(double costoCombustible) {
        this.costoCombustible = costoCombustible;
    }

    public double getCostoTaller() {
        return costoTaller;
    }

    public void setCostoTaller(double costoTaller) {
        this.costoTaller = costoTaller;
    }

    public double getCostoDepreciacion() {
        return costoDepreciacion;
    }

    public void setCostoDepreciacion(double costoDepreciacion) {
        this.costoDepreciacion = costoDepreciacion;
    }

    public double getPagoChoferes() {
        return pagoChoferes;
    }

    public void setPagoChoferes(double pagoChoferes) {
        this.pagoChoferes = pagoChoferes;
    }

}