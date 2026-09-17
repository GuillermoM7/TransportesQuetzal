package controlador;

import dao.ConfiguracionDAO;
import modelos.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelos.enums.Rol; 

@WebServlet(name = "ConfiguracionAdminServlet", urlPatterns = {"/ConfiguracionAdminServlet"})
public class ConfiguracionAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null || usuario.getRol() != Rol.ADMIN_SIS) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        ConfiguracionDAO configDAO = new ConfiguracionDAO();
        double montoActual = configDAO.obtenerMontoDepreciacion();
        
        request.setAttribute("montoDepreciacion", montoActual);
        request.getRequestDispatcher("configuracion_admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null || usuario.getRol() != Rol.ADMIN_SIS) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            double nuevoMonto = Double.parseDouble(request.getParameter("montoDepreciacion"));
            
            ConfiguracionDAO configDAO = new ConfiguracionDAO();
            boolean exito = configDAO.actualizarMontoDepreciacion(nuevoMonto);
            
            if (exito) {
                response.sendRedirect("ConfiguracionAdminServlet?msg=exito");
            } else {
                response.sendRedirect("ConfiguracionAdminServlet?error=db");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("ConfiguracionAdminServlet?error=formato");
        }
    }
}