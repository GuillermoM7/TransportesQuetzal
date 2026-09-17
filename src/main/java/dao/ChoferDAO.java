package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Chofer; 

public class ChoferDAO implements MantenimientoAcceso<Chofer> {

    @Override
    public boolean insertar(Chofer chofer) {
        String sql = "INSERT INTO chofer (id_sucursal, nombre, licencia, tipo_licencia, fecha_vencimiento, telefono, salario_base, estado, foto_url) VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVO', ?)";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, chofer.getIdSucursal());
            ps.setString(2, chofer.getNombre());
            ps.setString(3, chofer.getLicencia());
            ps.setString(4, chofer.getTipoLicencia());
            ps.setDate(5, chofer.getFechaVencimiento());
            ps.setString(6, chofer.getTelefono());
            ps.setDouble(7, chofer.getSalarioBase());
            ps.setString(8, chofer.getFoto());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al insertar chofer: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<Chofer> listarTodos() {
        return listarPorSucursal(0); 
    }

    public List<Chofer> listarPorSucursal(int idSucursal) {
        List<Chofer> listaChoferes = new ArrayList<>();
        String sql = "SELECT * FROM chofer";
        
        if (idSucursal > 0) {
            sql += " WHERE id_sucursal = ?";
        }
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursal > 0) {
                ps.setInt(1, idSucursal);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Chofer c = new Chofer();
                    c.setIdChofer(rs.getInt("id_chofer"));
                    c.setIdSucursal(rs.getInt("id_sucursal"));
                    c.setNombre(rs.getString("nombre"));
                    c.setLicencia(rs.getString("licencia"));
                    c.setTipoLicencia(rs.getString("tipo_licencia"));
                    c.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
                    c.setTelefono(rs.getString("telefono"));
                    c.setSalarioBase(rs.getDouble("salario_base"));
                    c.setEstado(modelos.enums.Estado.valueOf(rs.getString("estado").toUpperCase()));
                    c.setFoto(rs.getString("foto_url"));
                    
                    listaChoferes.add(c);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar choferes: " + e.getMessage());
        }
        return listaChoferes;
    }

    public boolean cambiarEstado(int idChofer, String nuevoEstado) {
        String sql = "UPDATE chofer SET estado = ? WHERE id_chofer = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idChofer);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado de chofer: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean actualizar(Chofer chofer) {
        String sql = "UPDATE chofer SET nombre = ?, licencia = ?, tipo_licencia = ?, fecha_vencimiento = ?, telefono = ?, salario_base = ?, foto_url = ? WHERE id_chofer = ?";
        
        try (java.sql.Connection con = config.ConexionDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, chofer.getNombre());
            ps.setString(2, chofer.getLicencia());
            ps.setString(3, chofer.getTipoLicencia());
            ps.setDate(4, new java.sql.Date(chofer.getFechaVencimiento().getTime())); 
            ps.setString(5, chofer.getTelefono());
            ps.setDouble(6, chofer.getSalarioBase());
            ps.setString(7, chofer.getFoto());
            ps.setInt(8, chofer.getIdChofer());
            
            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (java.sql.SQLException e) {
            System.out.println("Error al actualizar chofer: " + e.getMessage());
            return false;
        }
    }

    @Override
    public Chofer obtener(Object id) {
        return null;
    }
}