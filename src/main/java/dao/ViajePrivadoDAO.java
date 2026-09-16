package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.ViajePrivado;

public class ViajePrivadoDAO implements MantenimientoAcceso<ViajePrivado> {

    @Override
    public boolean insertar(ViajePrivado viaje) {
        String sql = "INSERT INTO viaje_privado (id_sucursal, id_usuario_cliente, origen, destino, fecha_hora_salida, fecha_hora_retorno, cantidad_pasajeros, estado) VALUES (?, ?, ?, ?, ?, ?, ?, 'solicitado')";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, viaje.getIdSucursal());
            ps.setInt(2, viaje.getIdUsuarioCliente());
            ps.setString(3, viaje.getOrigen());
            ps.setString(4, viaje.getDestino());
            ps.setTimestamp(5, viaje.getFechaHoraSalida());
            ps.setTimestamp(6, viaje.getFechaHoraRetorno());
            ps.setInt(7, viaje.getCantidadPasajeros());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al registrar solicitud de viaje privado: " + e.getMessage());
            return false;
        }
    }

    
    public boolean cotizarViaje(int idViaje, int idBus, int idChofer, double precioEstimado) {
        String sql = "UPDATE viaje_privado SET id_bus = ?, id_chofer = ?, precio_estimado = ?, estado = 'cotizado' WHERE id_viaje_priv = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idBus);
            ps.setInt(2, idChofer);
            ps.setDouble(3, precioEstimado);
            ps.setInt(4, idViaje);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cotizar viaje: " + e.getMessage());
            return false;
        }
    }


    public boolean iniciarViaje(int idViaje, int idChofer) {
        String sql = "UPDATE viaje_privado " + "SET estado = 'en_curso', " + "    bono_chofer = (SELECT sueldo * 0.15 FROM chofer WHERE id_chofer = ?) " + "WHERE id_viaje_priv = ?";
                     
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idChofer);
            ps.setInt(2, idViaje);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al iniciar viaje y calcular bono: " + e.getMessage());
            return false;
        }
    }

    
    @Override
    public List<ViajePrivado> listarTodos() {
        return listarPorSucursal(0);
    }

    public List<ViajePrivado> listarPorSucursal(int idSucursal) {
        List<ViajePrivado> lista = new ArrayList<>();
        
        String sql = "SELECT viaje privado *, usuario.nombre AS nombre_cliente, bus.placa AS placa_bus, chofer.nombre AS nombre_chofer " + "FROM viaje_privado" +
                     "INNER JOIN usuario usuario ON viaje_privadop.id_usuario_cliente = usuario.id_usuario " +
                     "LEFT JOIN bus ON viaje_privado.id_bus = bus.id_bus " +
                     "LEFT JOIN chofer ON viaje_privado.id_chofer = chofer.id_chofer ";
                     
        if (idSucursal > 0) {
            sql = sql + "WHERE vp.id_sucursal = ? ";
        }
        
        sql = sql + "ORDER BY vp.fecha_hora_salida ASC";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            if (idSucursal > 0) {
                ps.setInt(1, idSucursal);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ViajePrivado v = new ViajePrivado();
                    v.setIdViajePriv(rs.getInt("id_viaje_priv"));
                    v.setIdSucursal(rs.getInt("id_sucursal"));
                    v.setIdUsuarioCliente(rs.getInt("id_usuario_cliente"));
                    v.setIdBus(rs.getInt("id_bus"));
                    v.setIdChofer(rs.getInt("id_chofer"));
                    v.setOrigen(rs.getString("origen"));
                    v.setDestino(rs.getString("destino"));
                    v.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    v.setFechaHoraRetorno(rs.getTimestamp("fecha_hora_retorno"));
                    v.setCantidadPasajeros(rs.getInt("cantidad_pasajeros"));
                    v.setPrecioEstimado(rs.getDouble("precio_estimado"));
                    v.setBonoChofer(rs.getDouble("bono_chofer"));
                    v.setEstado(rs.getString("estado"));
                    v.setNombreCliente(rs.getString("nombre_cliente"));                   
                    v.setPlacaBus(rs.getString("placa_bus") != null ? rs.getString("placa_bus") : "Por asignar");
                    v.setNombreChofer(rs.getString("nombre_chofer") != null ? rs.getString("nombre_chofer") : "Por asignar");
                    
                    lista.add(v);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar viajes privados: " + e.getMessage());
        }
        return lista;
    }
    

    public List<ViajePrivado> listarPorCliente(int idCliente) {
        List<ViajePrivado> lista = new ArrayList<>();
        
        String sql = "SELECT vp.*, s.nombre AS nombre_sucursal, b.placa AS placa_bus, c.nombre AS nombre_chofer " + "FROM viaje_privado vp " +
                     "INNER JOIN sucursal s ON vp.id_sucursal = s.id_sucursal " +
                     "LEFT JOIN bus b ON vp.id_bus = b.id_bus " +
                     "LEFT JOIN chofer c ON vp.id_chofer = c.id_chofer " +
                     "WHERE vp.id_usuario_cliente = ? " +
                     "ORDER BY vp.fecha_hora_salida ASC";
                     
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, idCliente);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ViajePrivado v = new ViajePrivado();
                    v.setIdViajePriv(rs.getInt("id_viaje_priv"));
                    v.setIdSucursal(rs.getInt("id_sucursal"));
                    v.setIdUsuarioCliente(rs.getInt("id_usuario_cliente"));
                    v.setIdBus(rs.getInt("id_bus"));
                    v.setIdChofer(rs.getInt("id_chofer"));
                    v.setOrigen(rs.getString("origen"));
                    v.setDestino(rs.getString("destino"));
                    v.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    v.setFechaHoraRetorno(rs.getTimestamp("fecha_hora_retorno"));
                    v.setCantidadPasajeros(rs.getInt("cantidad_pasajeros"));
                    v.setPrecioEstimado(rs.getDouble("precio_estimado"));
                    v.setEstado(rs.getString("estado"));
                    v.setNombreCliente(rs.getString("nombre_sucursal"));                    
                    v.setPlacaBus(rs.getString("placa_bus") != null ? rs.getString("placa_bus") : "Por asignar");
                    v.setNombreChofer(rs.getString("nombre_chofer") != null ? rs.getString("nombre_chofer") : "Por asignar");
                    
                    lista.add(v);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al listar viajes del cliente: " + e.getMessage());
        }
        return lista;
    }

    
    public boolean cambiarEstado(int idViaje, String nuevoEstado) {
        String sql = "UPDATE viaje_privado SET estado = ? WHERE id_viaje_priv = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idViaje);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            return false;
        }
    }

    
    @Override
    public boolean actualizar(ViajePrivado objeto) {
        return false;
    }

    @Override
    public ViajePrivado obtener(Object id) {
        return null;
    }
    
    
    public boolean pagarViaje(int idViaje, int idCliente, double monto) {
        String sqlRestarSaldo = "UPDATE usuario SET saldo_cartera = saldo_cartera - ? WHERE id_usuario = ? AND saldo_cartera >= ?";
        String sqlCambiarEstado = "UPDATE viaje_privado SET estado = 'pagado' WHERE id_viaje_priv = ?";
        
        try (Connection con = ConexionDB.getConnection()) {
            con.setAutoCommit(false);
            
            try (PreparedStatement psSaldo = con.prepareStatement(sqlRestarSaldo);
                 PreparedStatement psEstado = con.prepareStatement(sqlCambiarEstado)) {
                
                psSaldo.setDouble(1, monto);
                psSaldo.setInt(2, idCliente);
                psSaldo.setDouble(3, monto);
                int filasAfectadas = psSaldo.executeUpdate();
                
                if (filasAfectadas == 0) {
                    con.rollback(); 
                    return false;
                }

                psEstado.setInt(1, idViaje);
                psEstado.executeUpdate();
                
                con.commit(); 
                return true;
                
            } catch (SQLException ex) {
                con.rollback(); 
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("Error en transacción de pago: " + e.getMessage());
            return false;
        }
    }
}