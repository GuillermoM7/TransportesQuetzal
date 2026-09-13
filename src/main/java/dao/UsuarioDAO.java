package dao;

import config.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelos.Usuario;

public class UsuarioDAO implements MantenimientoAcceso<Usuario>{
    

    @Override
    public boolean insertar(Usuario usuario) {
                String sql = "INSERT INTO usuario (rol, nombre, nit, dpi, telefono, direccion, contrasena, saldo_cartera, estado) VALUES ('CLIENTE', ?, ?, ?, ?, ?, ?, 0.0, 'ACTIVO')";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, usuario.getNombre());
            ps.setString(2, usuario.getNit());
            ps.setString(3, usuario.getDpi());
            ps.setString(4, usuario.getTelefono());
            ps.setString(5, usuario.getDireccion());
            ps.setString(6, usuario.getContrasena());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al registrar cliente: " + e.getMessage());
            return false;
        }
    }

    
    @Override
    public boolean actualizar(Usuario objeto) {
        return false;
    }

    
    @Override
    public List<Usuario> listarTodos() {
        List<Usuario> listaUsuarios = new ArrayList<>();
        String sql = "SELECT * FROM usuario WHERE rol != 'ADMIN_SIS'";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("id_usuario"));
                u.setDpi(rs.getString("dpi"));
                u.setNombre(rs.getString("nombre"));
                u.setTelefono(rs.getString("telefono"));
                u.setRol(modelos.enums.Rol.valueOf(rs.getString("rol").toUpperCase()));
                u.setEstado(modelos.enums.Estado.valueOf(rs.getString("estado").toUpperCase()));
                
                int idSucursal = rs.getInt("id_sucursal_asignada");
                if (!rs.wasNull()) {
                    u.setIdSucursalAsignada(idSucursal);
                }             
                listaUsuarios.add(u);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
        }
        return listaUsuarios;
    }

    
    @Override
    public Usuario obtener(Object id) {       
        return null;       
    }
    
    
    public Usuario validarLogin(String dpi, String contrasena) {
        Usuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE dpi = ? AND contrasena = ? AND estado = 'ACTIVO'";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, dpi);
            ps.setString(2, contrasena);
            
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setDpi(rs.getString("dpi"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setNit(rs.getString("nit"));
                    usuario.setTelefono(rs.getString("telefono"));
                    usuario.setDireccion(rs.getString("direccion"));
                    usuario.setContrasena(rs.getString("contrasena"));
                    usuario.setSaldoCartera(rs.getDouble("saldo_cartera"));
                    usuario.setRol(modelos.enums.Rol.valueOf(rs.getString("rol").toUpperCase()));
                    usuario.setEstado(modelos.enums.Estado.valueOf(rs.getString("estado").toUpperCase()));
                    
                    int idSucursal = rs.getInt("id_sucursal_asignada");
                    if (!rs.wasNull()) {
                        usuario.setIdSucursalAsignada(idSucursal);
                    }
                }
            }
        } catch (java.sql.SQLException e) {
            System.out.println("Error en login: " + e.getMessage());
        }
        return usuario;
    }
    

    public boolean insertarPersonal(Usuario usuario) {
        String sql = "INSERT INTO usuario (id_sucursal_asignada, rol, nombre, nit, dpi, telefono, direccion, contrasena, saldo_cartera, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0.0, 'ACTIVO')";
        
        try (Connection con = config.ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, usuario.getIdSucursalAsignada());
            ps.setString(2, usuario.getRol().name());
            ps.setString(3, usuario.getNombre());
            ps.setString(4, usuario.getNit());
            ps.setString(5, usuario.getDpi());
            ps.setString(6, usuario.getTelefono());
            ps.setString(7, usuario.getDireccion());
            ps.setString(8, usuario.getContrasena());
         
            return ps.executeUpdate() > 0;
            
        } catch (java.sql.SQLException e) {
            System.out.println("Error al registrar personal: " + e.getMessage());
            return false;
        }
    }
    
    
    public boolean cambiarEstado(int idUsuario, String nuevoEstado) {
        String sql = "UPDATE usuario SET estado = ? WHERE id_usuario = ?";
        
        try (Connection con = ConexionDB.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {           
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Error al cambiar estado: " + e.getMessage());
            return false;
        }
    }
}