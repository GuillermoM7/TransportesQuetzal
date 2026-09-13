package controlador;

import dao.UsuarioDAO;
import dao.SucursalDAO;
import modelos.Usuario;
import modelos.enums.Rol;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UsuarioServlet", urlPatterns = {"/UsuarioServlet"})
public class UsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        UsuarioDAO usuaDao = new UsuarioDAO();
        SucursalDAO sucDao = new SucursalDAO();
        
        request.setAttribute("listaUsuarios", usuaDao.listarTodos());
        request.setAttribute("listaSucursales", sucDao.listarTodos()); 
        
        request.getRequestDispatcher("gestionar_usuarios.jsp").forward(request, response);
    }

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String accion = request.getParameter("accion");
            UsuarioDAO dao = new UsuarioDAO();
            
            if ("registrar".equals(accion)) {
                Usuario nuevoAdmin = new Usuario();
                nuevoAdmin.setDpi(request.getParameter("dpi"));
                nuevoAdmin.setNombre(request.getParameter("nombre"));
                nuevoAdmin.setNit(request.getParameter("nit"));
                nuevoAdmin.setTelefono(request.getParameter("telefono"));
                nuevoAdmin.setDireccion(request.getParameter("direccion"));
                nuevoAdmin.setContrasena(request.getParameter("password"));
                nuevoAdmin.setRol(Rol.ADMIN_SUC); // Recuerda cambiar esto si modificas tu Enum
                
                String idSuc = request.getParameter("idSucursal");
                if (idSuc != null && !idSuc.isEmpty()) {
                    nuevoAdmin.setIdSucursalAsignada(Integer.parseInt(idSuc));
                }
                
                dao.insertarPersonal(nuevoAdmin);
                
            } else if ("cambiarEstado".equals(accion)) {
                int idUsuario = Integer.parseInt(request.getParameter("idUsuario"));
                String nuevoEstado = request.getParameter("nuevoEstado");
                dao.cambiarEstado(idUsuario, nuevoEstado);
            }
            
            response.sendRedirect("UsuarioServlet");
            
        } catch (Exception e) {
            System.out.println("Error crítico en el Servlet: " + e.getMessage());
            response.sendRedirect("UsuarioServlet?error=true");
        }
    }
}