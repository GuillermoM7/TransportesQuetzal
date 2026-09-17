package dao;

import config.ConexionDB;
import dtos.GananciaReporteDTO;
import dtos.RutaDemandadaDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportesAdminDAO {

    public List<RutaDemandadaDTO> reporteRutasDemandadas(String fechaInicio, String fechaFin) {
        List<RutaDemandadaDTO> lista = new ArrayList<>();
        
        String sql = "SELECT so.nombre as origen, sd.nombre as destino, COUNT(b.id_boleto) as cant_boletos, SUM(b.monto_pagado) as ingresos " +
                     "FROM boleto b " +
                     "INNER JOIN viaje_regular vr ON b.id_viaje_reg = vr.id_viaje_reg " +
                     "INNER JOIN ruta r ON vr.id_ruta = r.id_ruta " +
                     "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
                     "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
                     "WHERE (DATE(vr.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vr.fecha_hora_salida) <= ? OR ? IS NULL) " +
                     "GROUP BY r.id_ruta, so.nombre, sd.nombre " +
                     "ORDER BY cant_boletos DESC";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            String fIni = (fechaInicio != null && !fechaInicio.isEmpty()) ? fechaInicio : null;
            String fFin = (fechaFin != null && !fechaFin.isEmpty()) ? fechaFin : null;
             
            ps.setString(1, fIni); ps.setString(2, fIni);
            ps.setString(3, fFin); ps.setString(4, fFin);
             
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    RutaDemandadaDTO dto = new RutaDemandadaDTO();
                    dto.setOrigen(rs.getString("origen"));
                    dto.setDestino(rs.getString("destino"));
                    dto.setBoletosVendidos(rs.getInt("cant_boletos"));
                    dto.setTotalIngresos(rs.getDouble("ingresos"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Rutas Demandadas: " + e.getMessage());
        }
        return lista;
    }

    
    public List<GananciaReporteDTO> reporteFinancieroSucursales(String fechaInicio, String fechaFin, String idSucursalFiltro) {
        List<GananciaReporteDTO> lista = new ArrayList<>();
        

        StringBuilder sql = new StringBuilder(
            "SELECT s.nombre as sucursal, " +
            
            "IFNULL((SELECT SUM(b.monto_pagado) FROM boleto b INNER JOIN viaje_regular vr ON b.id_viaje_reg = vr.id_viaje_reg INNER JOIN ruta r ON vr.id_ruta = r.id_ruta WHERE r.id_sucursal_origen = s.id_sucursal AND (DATE(vr.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vr.fecha_hora_salida) <= ? OR ? IS NULL)), 0) as ing_boletos, " +

            "IFNULL((SELECT SUM(vp.precio_estimado) FROM viaje_privado vp WHERE vp.id_sucursal = s.id_sucursal AND vp.estado IN ('pagado', 'en_curso', 'finalizado') AND (DATE(vp.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vp.fecha_hora_salida) <= ? OR ? IS NULL)), 0) as ing_alquiler, " +

            "IFNULL((SELECT SUM(cv.gasto_combustible) FROM control_viaje cv INNER JOIN viaje_regular vr ON cv.id_viaje_reg = vr.id_viaje_reg INNER JOIN ruta r ON vr.id_ruta = r.id_ruta WHERE r.id_sucursal_origen = s.id_sucursal AND (DATE(vr.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vr.fecha_hora_salida) <= ? OR ? IS NULL)), 0) + " +
            "IFNULL((SELECT SUM(cv.gasto_combustible) FROM control_viaje cv INNER JOIN viaje_privado vp ON cv.id_viaje_priv = vp.id_viaje_priv WHERE vp.id_sucursal = s.id_sucursal AND (DATE(vp.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vp.fecha_hora_salida) <= ? OR ? IS NULL)), 0) as costo_combustible, " +

            "IFNULL((SELECT SUM(m.monto_mano_obra + m.monto_repuestos) FROM mantenimiento m INNER JOIN bus b ON m.id_bus = b.id_bus WHERE b.id_sucursal = s.id_sucursal AND (m.fecha_mantenimiento >= ? OR ? IS NULL) AND (m.fecha_mantenimiento <= ? OR ? IS NULL)), 0) as costo_taller, " +

            "IFNULL((SELECT SUM(cv.monto_depreciacion_aplicado) FROM control_viaje cv INNER JOIN viaje_regular vr ON cv.id_viaje_reg = vr.id_viaje_reg INNER JOIN ruta r ON vr.id_ruta = r.id_ruta WHERE r.id_sucursal_origen = s.id_sucursal AND (DATE(vr.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vr.fecha_hora_salida) <= ? OR ? IS NULL)), 0) + " +
            "IFNULL((SELECT SUM(cv.monto_depreciacion_aplicado) FROM control_viaje cv INNER JOIN viaje_privado vp ON cv.id_viaje_priv = vp.id_viaje_priv WHERE vp.id_sucursal = s.id_sucursal AND (DATE(vp.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vp.fecha_hora_salida) <= ? OR ? IS NULL)), 0) as costo_depreciacion, " +

            "IFNULL((SELECT SUM(cv.pago_chofer_aplicado) FROM control_viaje cv INNER JOIN viaje_regular vr ON cv.id_viaje_reg = vr.id_viaje_reg INNER JOIN ruta r ON vr.id_ruta = r.id_ruta WHERE r.id_sucursal_origen = s.id_sucursal AND (DATE(vr.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vr.fecha_hora_salida) <= ? OR ? IS NULL)), 0) + " +
            "IFNULL((SELECT SUM(cv.pago_chofer_aplicado) FROM control_viaje cv INNER JOIN viaje_privado vp ON cv.id_viaje_priv = vp.id_viaje_priv WHERE vp.id_sucursal = s.id_sucursal AND (DATE(vp.fecha_hora_salida) >= ? OR ? IS NULL) AND (DATE(vp.fecha_hora_salida) <= ? OR ? IS NULL)), 0) as costo_choferes " +
            
            "FROM sucursal s "
        );

        if (idSucursalFiltro != null && !idSucursalFiltro.isEmpty() && !idSucursalFiltro.equals("Todas")) {
            sql.append("WHERE s.id_sucursal = ? ");
        }
        
        sql.append("ORDER BY s.nombre ASC");

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            String fIni = (fechaInicio != null && !fechaInicio.isEmpty()) ? fechaInicio : null;
            String fFin = (fechaFin != null && !fechaFin.isEmpty()) ? fechaFin : null;
            
            int idx = 1;
            for(int i=0; i<6; i++) { 
            }

            for (int subconsulta = 1; subconsulta <= 9; subconsulta++) {
                ps.setString(idx++, fIni); ps.setString(idx++, fIni);
                ps.setString(idx++, fFin); ps.setString(idx++, fFin);
            }
            
            if (idSucursalFiltro != null && !idSucursalFiltro.isEmpty() && !idSucursalFiltro.equals("Todas")) {
                ps.setInt(idx, Integer.parseInt(idSucursalFiltro));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    GananciaReporteDTO dto = new GananciaReporteDTO();
                    dto.setNombreSucursal(rs.getString("sucursal"));
                    dto.setIngresosBoletos(rs.getDouble("ing_boletos"));
                    dto.setIngresosAlquiler(rs.getDouble("ing_alquiler"));
                    dto.setCostoCombustible(rs.getDouble("costo_combustible"));
                    dto.setCostoTaller(rs.getDouble("costo_taller"));
                    dto.setCostoDepreciacion(rs.getDouble("costo_depreciacion"));
                    dto.setPagoChoferes(rs.getDouble("costo_choferes"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Financiero Admin: " + e.getMessage());
        }
        return lista;
    }
}