package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Boleto;
import config.ConexionDB; 

public class BoletoDAO {


    public List<Integer> obtenerAsientosOcupados(int idViajeReg) {
        List<Integer> ocupados = new ArrayList<>();
        String sql = "SELECT numero_asiento FROM boleto WHERE id_viaje_reg = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idViajeReg);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ocupados.add(rs.getInt("numero_asiento"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener asientos ocupados: " + e.getMessage());
        }
        return ocupados;
    }

    
    public boolean registrarCompraSegura(List<Boleto> boletos) {
        if (boletos == null || boletos.isEmpty()) return false;
        
        double totalCobrar = 0;
        for (Boleto b : boletos) {
            totalCobrar = totalCobrar + b.getPrecioPagado();
        }

        String sqlCobro = "UPDATE usuario SET saldo_cartera = saldo_cartera - ? WHERE id_usuario = ? AND saldo_cartera >= ?";
        
        String sqlBoleto = "INSERT INTO boleto (id_viaje_reg, id_usuario_cliente, numero_asiento, fecha_pago, monto_pagado) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = config.ConexionDB.getConnection()) {
            con.setAutoCommit(false); 
            
            try (PreparedStatement psCobro = con.prepareStatement(sqlCobro);
                 PreparedStatement psBoleto = con.prepareStatement(sqlBoleto)) {
                 
                 psCobro.setDouble(1, totalCobrar);
                 psCobro.setInt(2, boletos.get(0).getIdUsuarioCliente()); 
                 psCobro.setDouble(3, totalCobrar);
                 int filasCobro = psCobro.executeUpdate();
                 
                 if (filasCobro == 0) {
                     System.out.println("No se cobró: O el usuario no existe, o su saldo real en BD es menor a " + totalCobrar);
                     con.rollback(); 
                     return false; 
                 }
                 
                 for (Boleto boleto : boletos) {
                     psBoleto.setInt(1, boleto.getIdViajeReg());
                     psBoleto.setInt(2, boleto.getIdUsuarioCliente());
                     psBoleto.setInt(3, boleto.getNumeroAsiento());
                     psBoleto.setTimestamp(4, boleto.getFechaCompra());
                     psBoleto.setDouble(5, boleto.getPrecioPagado());
                     
                     psBoleto.addBatch();
                 }
                 psBoleto.executeBatch(); 
                 
                 con.commit(); 
                 return true;
                 
            } catch (SQLException ex) {
                con.rollback();
                System.out.println("ERROR SQL AL INSERTAR BOLETOS:");
                ex.printStackTrace();
                return false;
            }
        } catch (SQLException e) {
            System.out.println("ERROR GENERAL DE CONEXIÓN:");
            e.printStackTrace();
            return false;
        }
    }
    
    
    public List<Boleto> obtenerHistorialPorCliente(int idUsuarioCliente) {
        List<Boleto> lista = new ArrayList<>();
        
        String sql = "SELECT b.id_boleto, b.numero_asiento, b.fecha_pago, b.monto_pagado, " +
                     "vr.fecha_hora_salida, bus.placa, " +
                     "so.nombre AS nombre_origen, sd.nombre AS nombre_destino " +
                     "FROM boleto b " +
                     "INNER JOIN viaje_regular vr ON b.id_viaje_reg = vr.id_viaje_reg " +
                     "INNER JOIN ruta r ON vr.id_ruta = r.id_ruta " +
                     "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
                     "INNER JOIN bus ON vr.id_bus = bus.id_bus " +
                     "WHERE b.id_usuario_cliente = ? " +
                     "ORDER BY b.fecha_pago DESC"; 
                     
        try (java.sql.Connection con = config.ConexionDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idUsuarioCliente);
            
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Boleto boleto = new Boleto();
                    boleto.setIdBoleto(rs.getInt("id_boleto"));
                    boleto.setNumeroAsiento(rs.getInt("numero_asiento"));
                    boleto.setFechaCompra(rs.getTimestamp("fecha_pago"));
                    boleto.setPrecioPagado(rs.getDouble("monto_pagado"));                  
                    boleto.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    boleto.setPlacaBus(rs.getString("placa"));
                    boleto.setNombreRuta(rs.getString("nombre_origen") + " - " + rs.getString("nombre_destino"));
                    
                    lista.add(boleto);
                }
            }
        } catch (java.sql.SQLException e) {
            System.out.println("Error al obtener historial de boletos: " + e.getMessage());
        }
        return lista;
    }
}