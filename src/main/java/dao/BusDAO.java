package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Bus;

public class BusDAO implements MantenimientoAcceso<Bus> {

    @Override
    public boolean insertar(Bus bus) {
        String sql = "INSERT INTO bus (id_sucursal, placa, marca, modelo, anio, capacidad_pasajeros, estado_operativo, kilometraje_actual, foto_url) VALUES (?, ?, ?, ?, ?, ?, 'ACTIVO', ?, ?)";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bus.getIdSucursal());
            ps.setString(2, bus.getPlaca());
            ps.setString(3, bus.getMarca());
            ps.setString(4, bus.getModelo());
            ps.setInt(5, bus.getAnio());
            ps.setInt(6, bus.getCapacidad());
            ps.setDouble(7, bus.getKilometraje());
            ps.setString(8, bus.getFoto());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al insertar bus: " + e.getMessage());
            return false;
        }
    }


    @Override
    public List<Bus> listarTodos() {
        return listarPorSucursal(0); 
    }

    public List<Bus> listarPorSucursal(int idSucursal) {
        List<Bus> listaBuses = new ArrayList<>();
        String sql = "SELECT * FROM bus";
        
        if (idSucursal > 0) {
            sql = sql + " WHERE id_sucursal = ?";
        }
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursal > 0) {
                ps.setInt(1, idSucursal);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bus b = new Bus();
                    b.setIdBus(rs.getInt("id_bus"));
                    b.setIdSucursal(rs.getInt("id_sucursal"));
                    b.setPlaca(rs.getString("placa"));
                    b.setMarca(rs.getString("marca"));
                    b.setModelo(rs.getString("modelo"));
                    b.setAnio(rs.getInt("anio"));
                    b.setCapacidad(rs.getInt("capacidad_pasajeros"));
                    b.setKilometraje(rs.getDouble("kilometraje_actual"));
                    b.setFoto(rs.getString("foto_url"));
                    b.setEstado(modelos.enums.Estado.valueOf(rs.getString("estado_operativo").toUpperCase()));
                    
                    listaBuses.add(b);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar buses: " + e.getMessage());
        }
        return listaBuses;
    }

    
    public boolean cambiarEstado(int idBus, String nuevoEstado) {
        String sql = "UPDATE bus SET estado_operativo = ? WHERE id_bus = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idBus);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado de bus: " + e.getMessage());
            return false;
        }
    }

    
    @Override
    public boolean actualizar(Bus objeto) {
        return false;
    }

    
    @Override
    public Bus obtener(Object id) {
        return null;
    }
}