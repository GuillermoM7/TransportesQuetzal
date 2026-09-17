package dao;

import config.ConexionDB;
import dtos.BusReporteDTO;
import dtos.ChoferReporteDTO;
import dtos.DepreciacionReporteDTO;
import dtos.IngresoAlquilerDTO;
import dtos.IngresosBoletosDTO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReportesDAO {


    public List<BusReporteDTO> reporteGeneralBuses(int idSucursal, String filtroEstado) {
        List<BusReporteDTO> lista = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder(
            "SELECT b.placa, b.marca, b.modelo, b.capacidad_pasajeros, b.estado_operativo, b.kilometraje_actual, " +
            "(SELECT c.nombre FROM chofer c INNER JOIN viaje_regular vr ON c.id_chofer = vr.id_chofer WHERE vr.id_bus = b.id_bus AND vr.estado = 'en_curso' " +
            " UNION " +
            " SELECT c.nombre FROM chofer c INNER JOIN viaje_privado vp ON c.id_chofer = vp.id_chofer WHERE vp.id_bus = b.id_bus AND vp.estado = 'en_curso' LIMIT 1) as chofer_actual, " +
            "(SELECT COUNT(*) FROM viaje_regular vr WHERE vr.id_bus = b.id_bus AND vr.estado = 'finalizado') + " +
            "(SELECT COUNT(*) FROM viaje_privado vp WHERE vp.id_bus = b.id_bus AND vp.estado = 'finalizado') as total_viajes " +
            "FROM bus b " +
            "WHERE b.id_sucursal = ?"
        );


        if (filtroEstado != null && !filtroEstado.trim().isEmpty() && !filtroEstado.equals("Todos")) {
            sql.append(" AND b.estado_operativo = ?");
        }

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            ps.setInt(1, idSucursal); 
            
            if (filtroEstado != null && !filtroEstado.trim().isEmpty() && !filtroEstado.equals("Todos")) {
                ps.setString(2, filtroEstado);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BusReporteDTO dto = new BusReporteDTO();
                    dto.setPlaca(rs.getString("placa"));
                    dto.setMarca(rs.getString("marca"));
                    dto.setModelo(rs.getString("modelo"));
                    dto.setCapacidad(rs.getInt("capacidad_pasajeros"));
                    dto.setEstadoOperativo(rs.getString("estado_operativo"));
                    dto.setKilometrajeActual(rs.getDouble("kilometraje_actual"));
                    dto.setTotalViajesRealizados(rs.getInt("total_viajes"));
                    
                    String chofer = rs.getString("chofer_actual");
                    dto.setChoferAsignadoActual(chofer != null ? chofer : "Ninguno asignado");
                    
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Reporte Buses: " + e.getMessage());
        }
        return lista;
    }


    public List<ChoferReporteDTO> reporteGeneralChoferes(int idSucursal) {
        List<ChoferReporteDTO> lista = new ArrayList<>();
        String sql = "SELECT c.licencia, c.nombre, c.tipo_licencia, c.fecha_vencimiento, c.estado, " +
                     "(SELECT COUNT(*) FROM viaje_regular vr WHERE vr.id_chofer = c.id_chofer AND vr.estado = 'finalizado') + " +
                     "(SELECT COUNT(*) FROM viaje_privado vp WHERE vp.id_chofer = c.id_chofer AND vp.estado = 'finalizado') as total_viajes " +
                     "FROM chofer c " +
                     "WHERE c.id_sucursal = ?";
                     
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idSucursal);
             
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    ChoferReporteDTO dto = new ChoferReporteDTO();
                    dto.setLicencia(rs.getString("licencia"));
                    dto.setNombreCompleto(rs.getString("nombre"));
                    dto.setTipoLicencia(rs.getString("tipo_licencia"));
                    dto.setFechaVencimiento(rs.getDate("fecha_vencimiento"));
                    dto.setEstado(rs.getString("estado"));
                    dto.setTotalViajesRealizados(rs.getInt("total_viajes"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Reporte Choferes: " + e.getMessage());
        }
        return lista;
    }

    
    public List<DepreciacionReporteDTO> reporteDepreciacion(int idSucursal, double depreciacionConfigurada) {
        List<DepreciacionReporteDTO> lista = new ArrayList<>();
        
        String sql = "SELECT b.placa, " +
                     "IFNULL((SELECT SUM(cv.kilometraje_final - cv.kilometraje_inicial) FROM control_viaje cv INNER JOIN viaje_regular vr ON cv.id_viaje_reg = vr.id_viaje_reg WHERE vr.id_bus = b.id_bus), 0) + " +
                     "IFNULL((SELECT SUM(cv.kilometraje_final - cv.kilometraje_inicial) FROM control_viaje cv INNER JOIN viaje_privado vp ON cv.id_viaje_priv = vp.id_viaje_priv WHERE vp.id_bus = b.id_bus), 0) as km_recorridos_totales, " +
                     "IFNULL((SELECT SUM(cv.monto_depreciacion_aplicado) FROM control_viaje cv INNER JOIN viaje_regular vr ON cv.id_viaje_reg = vr.id_viaje_reg WHERE vr.id_bus = b.id_bus), 0) + " +
                     "IFNULL((SELECT SUM(cv.monto_depreciacion_aplicado) FROM control_viaje cv INNER JOIN viaje_privado vp ON cv.id_viaje_priv = vp.id_viaje_priv WHERE vp.id_bus = b.id_bus), 0) as depreciacion_total " +
                     "FROM bus b " +
                     "WHERE b.id_sucursal = ?";

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setInt(1, idSucursal);
             
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    DepreciacionReporteDTO dto = new DepreciacionReporteDTO();
                    dto.setPlacaBus(rs.getString("placa"));
                    dto.setTotalKilometrosRecorridos(rs.getDouble("km_recorridos_totales"));
                    dto.setDepreciacionPorKm(depreciacionConfigurada);
                    dto.setDepreciacionAcumuladaTotal(rs.getDouble("depreciacion_total"));
                    
                    if(dto.getTotalKilometrosRecorridos() > 0) {
                        lista.add(dto);
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Reporte Depreciacion: " + e.getMessage());
        }
        return lista;
    }
    
    
    public List<IngresosBoletosDTO> reporteIngresosBoletos(int idSucursal, String fechaInicio, String fechaFin, String idRutaFiltro, String idBusFiltro) {
        List<IngresosBoletosDTO> lista = new ArrayList<>();
        List<Object> parametros = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT vr.id_viaje_reg, so.nombre as origen, sd.nombre as destino, " +
            "vr.fecha_hora_salida, b.placa, COUNT(bol.id_boleto) as cant_boletos, SUM(bol.monto_pagado) as ingreso_total " +
            "FROM viaje_regular vr " +
            "INNER JOIN ruta r ON vr.id_ruta = r.id_ruta " +
            "INNER JOIN sucursal so ON r.id_sucursal_origen = so.id_sucursal " +
            "INNER JOIN sucursal sd ON r.id_sucursal_destino = sd.id_sucursal " +
            "INNER JOIN bus b ON vr.id_bus = b.id_bus " +
            "INNER JOIN boleto bol ON vr.id_viaje_reg = bol.id_viaje_reg " +
            "WHERE so.id_sucursal = ? " 
        );
        parametros.add(idSucursal);

        if (fechaInicio != null && !fechaInicio.isEmpty() && fechaFin != null && !fechaFin.isEmpty()) {
            sql.append(" AND DATE(vr.fecha_hora_salida) BETWEEN ? AND ? ");
            parametros.add(fechaInicio);
            parametros.add(fechaFin);
        }

        if (idRutaFiltro != null && !idRutaFiltro.isEmpty() && !idRutaFiltro.equals("Todas")) {
            sql.append(" AND vr.id_ruta = ? ");
            parametros.add(Integer.parseInt(idRutaFiltro));
        }

        if (idBusFiltro != null && !idBusFiltro.isEmpty() && !idBusFiltro.equals("Todos")) {
            sql.append(" AND vr.id_bus = ? ");
            parametros.add(Integer.parseInt(idBusFiltro));
        }

        sql.append(" GROUP BY vr.id_viaje_reg ORDER BY vr.fecha_hora_salida DESC");

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }
             
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    IngresosBoletosDTO dto = new IngresosBoletosDTO();
                    dto.setIdViajeReg(rs.getInt("id_viaje_reg"));
                    dto.setOrigen(rs.getString("origen"));
                    dto.setDestino(rs.getString("destino"));
                    dto.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    dto.setPlacaBus(rs.getString("placa"));
                    dto.setCantidadBoletosVendidos(rs.getInt("cant_boletos"));
                    dto.setIngresoTotal(rs.getDouble("ingreso_total"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Reporte Boletos: " + e.getMessage());
        }
        return lista;
    }


    public List<IngresoAlquilerDTO> reporteIngresosAlquiler(int idSucursal, String fechaInicio, String fechaFin) {
        List<IngresoAlquilerDTO> lista = new ArrayList<>();
        List<Object> parametros = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT vp.id_viaje_priv, u.nombre as cliente, vp.origen, vp.destino, " +
            "vp.fecha_hora_salida, b.placa, vp.precio_estimado " +
            "FROM viaje_privado vp " +
            "INNER JOIN usuario u ON vp.id_usuario_cliente = u.id_usuario " +
            "INNER JOIN bus b ON vp.id_bus = b.id_bus " +
            "WHERE vp.id_sucursal = ? AND vp.estado IN ('pagado', 'en_curso', 'finalizado') "
        );
        parametros.add(idSucursal);

        if (fechaInicio != null && !fechaInicio.isEmpty() && fechaFin != null && !fechaFin.isEmpty()) {
            sql.append(" AND DATE(vp.fecha_hora_salida) BETWEEN ? AND ? ");
            parametros.add(fechaInicio);
            parametros.add(fechaFin);
        }

        sql.append(" ORDER BY vp.fecha_hora_salida DESC");

        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
             
            for (int i = 0; i < parametros.size(); i++) {
                ps.setObject(i + 1, parametros.get(i));
            }
             
            try (ResultSet rs = ps.executeQuery()) {
                while(rs.next()) {
                    IngresoAlquilerDTO dto = new IngresoAlquilerDTO();
                    dto.setIdViajePriv(rs.getInt("id_viaje_priv"));
                    dto.setNombreCliente(rs.getString("cliente"));
                    dto.setOrigen(rs.getString("origen"));
                    dto.setDestino(rs.getString("destino"));
                    dto.setFechaHoraSalida(rs.getTimestamp("fecha_hora_salida"));
                    dto.setPlacaBus(rs.getString("placa"));
                    dto.setPrecioTotal(rs.getDouble("precio_estimado"));
                    lista.add(dto);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error Reporte Alquileres: " + e.getMessage());
        }
        return lista;
    }
}