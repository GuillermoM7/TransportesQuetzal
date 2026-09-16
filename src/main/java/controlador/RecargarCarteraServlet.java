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

@WebServlet(name = "RecargarCarteraServlet", urlPatterns = {"/RecargarCarteraServlet"})
public class RecargarCarteraServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (request.getSession().getAttribute("usuarioLogueado") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("recargar_cartera.jsp").forward(request, response);
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
        
        try {
            double monto = Double.parseDouble(request.getParameter("montoRecarga"));
            
            if (monto > 0) {
                UsuarioDAO dao = new UsuarioDAO();
                boolean exito = dao.agregarSaldo(usuario.getIdUsuario(), monto);
                
                if (exito) {
                    usuario.setSaldoCartera(usuario.getSaldoCartera() + monto);
                    sesion.setAttribute("usuarioLogueado", usuario);
                    
                    response.sendRedirect("RecargarCarteraServlet?msg=exito");
                } else {
                    response.sendRedirect("RecargarCarteraServlet?error=db");
                }
            } else {
                response.sendRedirect("RecargarCarteraServlet?error=invalido");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("RecargarCarteraServlet?error=formato");
        }
    }
}