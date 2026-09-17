
package dao;

import modelos.Mantenimiento;


public class MantenimientoDAO {
    
    public boolean registrarMantenimiento(Mantenimiento m) {
        String sql = "INSERT INTO mantenimiento (id_bus, monto_mano_obra, monto_repuestos, fecha_mantenimiento) VALUES (?, ?, ?, ?)";
        
        try (java.sql.Connection con = config.ConexionDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, m.getIdBus());
            ps.setDouble(2, m.getMontoManoDeObra());
            ps.setDouble(3, m.getMontoRepuesto());
            ps.setDate(4, m.getFechaMantenimiento());
            
            return ps.executeUpdate() > 0;
            
        } catch (java.sql.SQLException e) {
            System.out.println("Error al registrar mantenimiento: " + e.getMessage());
            return false;
        }
    }
    
}
