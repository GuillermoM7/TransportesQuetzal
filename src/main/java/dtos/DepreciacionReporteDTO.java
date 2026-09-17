package dtos;


public class DepreciacionReporteDTO {
   private String placaBus;
    private double totalKilometrosRecorridos;
    private double depreciacionPorKm;
    private double depreciacionAcumuladaTotal;
    

    public DepreciacionReporteDTO() {
    }

    
    public String getPlacaBus() {
        return placaBus;
    }

    public void setPlacaBus(String placaBus) {
        this.placaBus = placaBus;
    }

    public double getTotalKilometrosRecorridos() {
        return totalKilometrosRecorridos;
    }

    public void setTotalKilometrosRecorridos(double totalKilometrosRecorridos) {
        this.totalKilometrosRecorridos = totalKilometrosRecorridos;
    }

    public double getDepreciacionPorKm() {
        return depreciacionPorKm;
    }

    public void setDepreciacionPorKm(double depreciacionPorKm) {
        this.depreciacionPorKm = depreciacionPorKm;
    }

    public double getDepreciacionAcumuladaTotal() {
        return depreciacionAcumuladaTotal;
    }

    public void setDepreciacionAcumuladaTotal(double depreciacionAcumuladaTotal) {
        this.depreciacionAcumuladaTotal = depreciacionAcumuladaTotal;
    }
      
}
