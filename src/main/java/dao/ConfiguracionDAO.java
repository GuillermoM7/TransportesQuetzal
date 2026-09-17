package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import config.ConexionDB;

public class ConfiguracionDAO {

    public double obtenerMontoDepreciacion() {
        double monto = 0.0;
        String sql = "SELECT monto_depreciacion_por_km FROM configuracion_sistema WHERE id_configuracion = 1";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            if (rs.next()) {
                monto = rs.getDouble("monto_depreciacion_por_km");
            }
            
        } catch (SQLException e) {
            System.out.println("Error al obtener la depreciación: " + e.getMessage());
        }
        return monto;
    }


    public boolean actualizarMontoDepreciacion(double nuevoMonto) {
        String sql = "UPDATE configuracion_sistema SET monto_depreciacion_por_km = ? WHERE id_configuracion = 1";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setDouble(1, nuevoMonto);
            int filas = ps.executeUpdate();
            return filas > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al actualizar la depreciación: " + e.getMessage());
            return false;
        }
    }
}