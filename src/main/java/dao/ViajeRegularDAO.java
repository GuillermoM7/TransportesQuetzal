package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.ViajeRegular;

public class ViajeRegularDAO implements MantenimientoAcceso<ViajeRegular> {

    @Override
    public boolean insertar(ViajeRegular viaje) {
        String sql = "INSERT INTO viaje_regular (id_ruta, id_bus, id_chofer, fecha_hora_salida, fecha_hora_llegada_estimada, estado) VALUES (?, ?, ?, ?, ?, 'programado')";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, viaje.getIdRuta());
            ps.setInt(2, viaje.getIdBus());
            ps.setInt(3, viaje.getIdChofer());
            ps.setTimestamp(4, viaje.getFechaHoraSalida());
            ps.setTimestamp(5, viaje.getFechaHoraLlegadaEstimada());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al insertar viaje regular: " + e.getMessage());
            return false;
        }
    }

    @Override
    public List<ViajeRegular> listarTodos() {
        return listarPorSucursalOrigen(0);
    }

    public List<ViajeRegular> listarPorSucursalOrigen(int idSucursalOrigen) {
        List<ViajeRegular> lista = new ArrayList<>();
        
        String sql = "SELECT vr.*, sd.nombre AS destino_ruta, b.placa AS placa_bus, c.nombre AS nombre_chofer " +
                     "FROM viaje_regular vr " +
                     "INNER JOIN ruta r ON vr.id_ruta = r.id_ruta " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
                     "INNER JOIN bus b ON vr.id_bus = b.id_bus " +
                     "INNER JOIN chofer c ON vr.id_chofer = c.id_chofer ";
                     
        if (idSucursalOrigen > 0) {
            sql = sql + "WHERE r.id_sucursal_origen = ? ";
        }
        
        sql = sql + "ORDER BY vr.fecha_hora_salida ASC";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursalOrigen > 0) {
                ps.setInt(1, idSucursalOrigen);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ViajeRegular viaje = new ViajeRegular();
                    viaje.setIdViajeReg(rs.getInt("id_viaje_reg"));
                    viaje.setIdRuta(rs.getInt("id_ruta"));
                    viaje.setIdBus(rs.getInt("id_bus"));
                    viaje.setIdChofer(rs.getInt("id_chofer"));
                    viaje.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    viaje.setFechaHoraLlegadaEstimada(rs.getTimestamp("fecha_hora_llegada_estimada"));
                    viaje.setEstado(rs.getString("estado"));
                    
                    viaje.setDestinoRuta(rs.getString("destino_ruta"));
                    viaje.setPlacaBus(rs.getString("placa_bus"));
                    viaje.setNombreChofer(rs.getString("nombre_chofer"));
                    
                    lista.add(viaje);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar viajes regulares: " + e.getMessage());
        }
        return lista;
    }
    
    
    public List<ViajeRegular> listarViajesDisponiblesPorSucursal(int idSucursal) {
        List<ViajeRegular> lista = new ArrayList<>();
        
        String sql = "SELECT vr.*, " +
                     "so.nombre AS nombre_origen, " +
                     "sd.nombre AS nombre_destino, " +
                     "r.precio_boleto, b.placa, b.capacidad_pasajeros, " +
                     "(b.capacidad_pasajeros - (SELECT COUNT(*) FROM boleto bol WHERE bol.id_viaje_reg = vr.id_viaje_reg)) AS asientos_disponibles " +
                     "FROM viaje_regular vr " +
                     "INNER JOIN ruta r ON vr.id_ruta = r.id_ruta " +
                     "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
                     "INNER JOIN bus b ON vr.id_bus = b.id_bus " +
                     "WHERE vr.estado = 'programado' "; 
        
        if (idSucursal > 0) {
            sql = sql + " AND r.id_sucursal_origen = ?"; 
        }
        
        sql = sql + " ORDER BY vr.fecha_hora_salida ASC";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursal > 0) {
                ps.setInt(1, idSucursal);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ViajeRegular v = new ViajeRegular();
                    v.setIdViajeReg(rs.getInt("id_viaje_reg"));
                    v.setIdRuta(rs.getInt("id_ruta"));
                    v.setIdBus(rs.getInt("id_bus"));
                    v.setIdChofer(rs.getInt("id_chofer"));
                    v.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    v.setEstado(rs.getString("estado"));
                    v.setNombreRuta(rs.getString("nombre_origen") + " - " + rs.getString("nombre_destino"));                   
                    v.setPrecio(rs.getDouble("precio_boleto"));
                    v.setPlacaBus(rs.getString("placa"));
                    v.setAsientosDisponibles(rs.getInt("asientos_disponibles"));
                    
                    lista.add(v);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar viajes para catálogo: " + e.getMessage());
        }
        return lista;
    }



    @Override
    public boolean actualizar(ViajeRegular objeto) {
        return false;
    }

    @Override
    public ViajeRegular obtener(Object id) {
        return null;
    }
    
    public boolean cambiarEstado(int idViaje, String nuevoEstado) {
        String sql = "UPDATE viaje_regular SET estado = ? WHERE id_viaje_reg = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idViaje);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado de viaje regular: " + e.getMessage());
            return false;
        }
    }
    
}