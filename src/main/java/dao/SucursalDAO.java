package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Sucursal;

public class SucursalDAO implements MantenimientoAcceso<Sucursal> {

    @Override
    public boolean insertar(Sucursal sucursal) {
        String sql = "INSERT INTO sucursal (nombre, direccion) VALUES (?, ?)";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, sucursal.getNombre());
            ps.setString(2, sucursal.getDireccion());
            
            return ps.executeUpdate() > 0;
            
         } catch (SQLException e) {
            System.out.println("Error al insertar sucursal: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<Sucursal> listarTodos() {
        List<Sucursal> listaSucursales = new ArrayList<>();
        String sql = "SELECT * FROM sucursal";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Sucursal suc = new Sucursal();
                suc.setIdSucursal(rs.getInt("id_sucursal")); 
                suc.setNombre(rs.getString("nombre"));
                suc.setDireccion(rs.getString("direccion"));
                
                listaSucursales.add(suc);
            }
            
        } catch (SQLException e) {
            System.out.println("Error al listar sucursales: " + e.getMessage());
        }
        
        return listaSucursales;
    }

    @Override
    public boolean actualizar(Sucursal sucursal) {
        return false;
    }

    @Override
    public Sucursal obtener(Object id) {
        return null;
    }
}