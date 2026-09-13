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

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        //Validacion del usuariuo
        String dpi = request.getParameter("dpi");
        String contrasena = request.getParameter("password");
        UsuarioDAO dao = new UsuarioDAO();
        Usuario usuarioValidado = dao.validarLogin(dpi, contrasena);
        
        //Crear sesion y dirigir al panel
        HttpSession sesion = request.getSession();
        sesion.setAttribute("usuarioLogueado", usuarioValidado);       
        response.sendRedirect("panel_principal.jsp");
    }
}