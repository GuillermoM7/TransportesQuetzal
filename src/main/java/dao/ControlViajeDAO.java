package dao;

import modelos.ControlViaje;
import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ControlViajeDAO {

    public boolean iniciarViajeSeguro(ControlViaje control, String tipoViaje) {

        String sqlControlReg = "INSERT INTO control_viaje (id_viaje_reg, hora_real_salida, kilometraje_inicial) VALUES (?, ?, ?)";
        String sqlEstadoReg = "UPDATE viaje_regular SET estado = 'en_curso' WHERE id_viaje_reg = ?"; 
        
        String sqlControlPriv = "INSERT INTO control_viaje (id_viaje_priv, hora_real_salida, kilometraje_inicial) VALUES (?, ?, ?)";
        String sqlEstadoPriv = "UPDATE viaje_privado SET estado = 'en_curso' WHERE id_viaje_priv = ?"; 

        boolean esRegular = "regular".equalsIgnoreCase(tipoViaje);
        String sqlControl = esRegular ? sqlControlReg : sqlControlPriv;
        String sqlEstado = esRegular ? sqlEstadoReg : sqlEstadoPriv;
        int idViaje = esRegular ? control.getIdViajeReg() : control.getIdViajePriv();

        try (Connection con = ConexionDB.getConnection()) {
            con.setAutoCommit(false); 

            try (PreparedStatement psControl = con.prepareStatement(sqlControl);
                 PreparedStatement psEstado = con.prepareStatement(sqlEstado)) {
                 
                psControl.setInt(1, idViaje);
                psControl.setTimestamp(2, control.getHoraRealSalida());
                psControl.setDouble(3, control.getKilometrajeInicial());
                psControl.executeUpdate();

                psEstado.setInt(1, idViaje);
                psEstado.executeUpdate();

                con.commit();
                return true;

            } catch (SQLException ex) {
                con.rollback(); 
                System.out.println("Error en la transacción de inicio de viaje: " + ex.getMessage());
                return false;
            }
        } catch (SQLException e) {
            System.out.println("Error de conexión al iniciar viaje: " + e.getMessage());
            return false;
        }
    }
    
    
public boolean finalizarViajeSeguro(ControlViaje control, String tipoViaje, double costoDepreciacionPorKm) {
        boolean esRegular = "regular".equalsIgnoreCase(tipoViaje);
        int idViaje = esRegular ? control.getIdViajeReg() : control.getIdViajePriv();

        String sqlSelect = esRegular ? 
            "SELECT cv.id_control, cv.kilometraje_inicial, v.id_bus, c.salario_base " +
            "FROM control_viaje cv " +
            "INNER JOIN viaje_regular v ON cv.id_viaje_reg = v.id_viaje_reg " +
            "INNER JOIN chofer c ON v.id_chofer = c.id_chofer " +
            "WHERE cv.id_viaje_reg = ?" 
            : 
            "SELECT cv.id_control, cv.kilometraje_inicial, v.id_bus, c.salario_base " +
            "FROM control_viaje cv " +
            "INNER JOIN viaje_privado v ON cv.id_viaje_priv = v.id_viaje_priv " +
            "INNER JOIN chofer c ON v.id_chofer = c.id_chofer " +
            "WHERE cv.id_viaje_priv = ?";

        String sqlUpdateControl = "UPDATE control_viaje SET hora_real_llegada = ?, kilometraje_final = ?, gasto_combustible = ?, monto_depreciacion_aplicado = ?, pago_chofer_aplicado = ? WHERE id_control = ?";
        
        String sqlUpdateEstado = esRegular ? 
            "UPDATE viaje_regular SET estado = 'finalizado' WHERE id_viaje_reg = ?" : 
            "UPDATE viaje_privado SET estado = 'finalizado' WHERE id_viaje_priv = ?";
            
        String sqlUpdateBus = "UPDATE bus SET kilometraje_actual = ? WHERE id_bus = ?";

        try (Connection con = config.ConexionDB.getConnection()) {
            con.setAutoCommit(false);

            try {
                int idControl = 0;
                double kmInicial = 0;
                int idBus = 0; 
                double salarioChoferActual = 0;

                try (PreparedStatement psSelect = con.prepareStatement(sqlSelect)) {
                    psSelect.setInt(1, idViaje);
                    try (java.sql.ResultSet rs = psSelect.executeQuery()) {
                        if (rs.next()) {
                            idControl = rs.getInt("id_control");
                            kmInicial = rs.getDouble("kilometraje_inicial");
                            idBus = rs.getInt("id_bus");
                            salarioChoferActual = rs.getDouble("salario_base"); 
                        } else {
                            throw new SQLException("No se encontró el registro de salida o chofer de este viaje.");
                        }
                    }
                }

                double distanciaRecorrida = control.getKilometrajeFinal() - kmInicial;
                if (distanciaRecorrida < 0) distanciaRecorrida = 0; 
                double depreciacionTotal = distanciaRecorrida * costoDepreciacionPorKm;

                try (PreparedStatement psControl = con.prepareStatement(sqlUpdateControl)) {
                    psControl.setTimestamp(1, control.getHoraRealLlegada());
                    psControl.setDouble(2, control.getKilometrajeFinal());
                    psControl.setDouble(3, control.getGastoCombustible());
                    psControl.setDouble(4, depreciacionTotal);
                    psControl.setDouble(5, salarioChoferActual); 
                    psControl.setInt(6, idControl);
                    psControl.executeUpdate();
                }

                try (PreparedStatement psEstado = con.prepareStatement(sqlUpdateEstado)) {
                    psEstado.setInt(1, idViaje);
                    psEstado.executeUpdate();
                }
                
                try (PreparedStatement psBus = con.prepareStatement(sqlUpdateBus)) {
                    psBus.setDouble(1, control.getKilometrajeFinal());
                    psBus.setInt(2, idBus);
                    psBus.executeUpdate();
                }

                con.commit(); 
                return true;

            } catch (SQLException ex) {
                con.rollback(); 
                System.out.println("Error en transacción de fin de viaje: " + ex.getMessage());
                return false;
            }
        } catch (SQLException e) {
            System.out.println("Error de conexión al finalizar viaje: " + e.getMessage());
            return false;
        }
    }
}