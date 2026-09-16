package controlador;

import dao.UsuarioDAO;
import modelos.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "EditarPerfilServlet", urlPatterns = {"/EditarPerfilServlet"})
public class EditarPerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (request.getSession().getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("editar_perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String nombre = request.getParameter("nombre");
        String nit = request.getParameter("nit");
        String dpi = request.getParameter("dpi");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String contrasena = request.getParameter("contrasena");
        
        UsuarioDAO dao = new UsuarioDAO();
        boolean exito = dao.actualizarPerfil(usuario.getIdUsuario(), nombre, nit, dpi, telefono, direccion, contrasena);
        
        if (exito) {
            usuario.setNombre(nombre);
            usuario.setNit(nit);
            usuario.setDpi(dpi);
            usuario.setTelefono(telefono);
            usuario.setDireccion(direccion);
            
            sesion.setAttribute("usuarioLogueado", usuario);
            response.sendRedirect("EditarPerfilServlet?msg=exito");
        } else {
            response.sendRedirect("EditarPerfilServlet?error=db");
        }
    }
}