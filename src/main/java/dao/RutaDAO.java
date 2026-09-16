package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Ruta;

public class RutaDAO implements MantenimientoAcceso<Ruta> {

    @Override
    public boolean insertar(Ruta ruta) {
        String sql = "INSERT INTO ruta (id_sucursal_origen, id_sucursal_destino, distancia_km, precio_boleto, estado) VALUES (?, ?, ?, ?, 'activo')";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, ruta.getIdSucursalOrigen());
            ps.setInt(2, ruta.getIdSucursalDestino());
            ps.setDouble(3, ruta.getDistanciaKm());
            ps.setDouble(4, ruta.getPrecioBoleto());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al insertar ruta: " + e.getMessage());
            return false;
        }
    }

    
    @Override
    public List<Ruta> listarTodos() {
        List<Ruta> listaRutas = new ArrayList<>();
        String sql = "SELECT r.*, so.nombre AS nombre_origen, sd.nombre AS nombre_destino, sd.direccion AS direccion_destino " +
                     "FROM ruta r " +
                     "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Ruta r = new Ruta();
                r.setIdRuta(rs.getInt("id_ruta"));
                r.setIdSucursalOrigen(rs.getInt("id_sucursal_origen"));
                r.setIdSucursalDestino(rs.getInt("id_sucursal_destino"));
                r.setDistanciaKm(rs.getDouble("distancia_km"));
                r.setPrecioBoleto(rs.getDouble("precio_boleto"));
                r.setEstado(rs.getString("estado")); 
                
                r.setNombreOrigen(rs.getString("nombre_origen"));
                r.setNombreDestino(rs.getString("nombre_destino"));
                r.setDireccionDestino(rs.getString("direccion_destino"));
                
                listaRutas.add(r);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar rutas: " + e.getMessage());
        }
        return listaRutas;
    }

    public List<Ruta> listarRutasParaMapa(int idSucursalOrigenFiltro) {
        List<Ruta> lista = new ArrayList<>();
        String sql = "SELECT r.id_ruta, " +
                     "so.latitud AS lat_origen, so.longitud AS lon_origen, " +
                     "sd.latitud AS lat_destino, sd.longitud AS lon_destino, sd.nombre AS nombre_destino " +
                     "FROM ruta r " +
                     "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
                     "WHERE so.latitud IS NOT NULL AND sd.latitud IS NOT NULL";
        
        if (idSucursalOrigenFiltro > 0) {
            sql += " AND r.id_sucursal_origen = ?";
        }
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursalOrigenFiltro > 0) {
                ps.setInt(1, idSucursalOrigenFiltro);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ruta r = new Ruta();
                    r.setIdRuta(rs.getInt("id_ruta"));
                    r.setLatOrigen(rs.getDouble("lat_origen"));
                    r.setLonOrigen(rs.getDouble("lon_origen"));
                    r.setLatDestino(rs.getDouble("lat_destino"));
                    r.setLonDestino(rs.getDouble("lon_destino"));
                    r.setNombreDestino(rs.getString("nombre_destino"));
                    lista.add(r);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error en mapa de rutas: " + e.getMessage());
        }
        return lista;
    }


    
    @Override
    public boolean actualizar(Ruta objeto) {
        return false; 
    }

    
    @Override
    public Ruta obtener(Object id) {
        return null;
    }
    
    
    public boolean eliminar(int idRuta) {
        String sql = "DELETE FROM ruta WHERE id_ruta = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idRuta);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al eliminar ruta (Posible restricción de llave foránea): " + e.getMessage());
            return false;
        }
    }
    
    public boolean cambiarEstado(int idRuta, String nuevoEstado) {
        String sql = "UPDATE ruta SET estado = ? WHERE id_ruta = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idRuta);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado de ruta: " + e.getMessage());
            return false;
        }
    }
}