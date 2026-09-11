package controlador;

import dao.UsuarioDAO;
import modelos.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroServlet", urlPatterns = {"/RegistroServlet"})
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dpi = request.getParameter("dpi");
        String nombre = request.getParameter("nombre");
        String nit = request.getParameter("nit");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String contrasena = request.getParameter("password");
        
        Usuario nuevoCliente = new Usuario();
        nuevoCliente.setDpi(dpi);
        nuevoCliente.setNombre(nombre);
        nuevoCliente.setNit(nit);
        nuevoCliente.setTelefono(telefono);
        nuevoCliente.setDireccion(direccion);
        nuevoCliente.setContrasena(contrasena);
        
        UsuarioDAO dao = new UsuarioDAO();
        if (dao.insertar(nuevoCliente)) {
            response.sendRedirect("login.jsp?mensaje=exito");
        } else {
            response.sendRedirect("registro.jsp?mensaje=error");
        }
    }
}