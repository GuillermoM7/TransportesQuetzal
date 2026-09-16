package controlador;

import dao.BoletoDAO;
import modelos.Boleto;
import modelos.Usuario;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MisBoletosServlet", urlPatterns = {"/MisBoletosServlet"})
public class MisBoletosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuarioLogueado = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuarioLogueado == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BoletoDAO boletoDAO = new BoletoDAO();
        List<Boleto> historial = boletoDAO.obtenerHistorialPorCliente(usuarioLogueado.getIdUsuario());
        
        request.setAttribute("historialBoletos", historial);
        
        request.getRequestDispatcher("mis_boletos.jsp").forward(request, response);
    }
}