package controlador;

import dao.ControlViajeDAO;
import modelos.ControlViaje;
import modelos.Usuario;
import modelos.enums.Rol;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "IniciarViajeServlet", urlPatterns = {"/IniciarViajeServlet"})
public class IniciarViajeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null || usuario.getRol() != Rol.ADMIN_SUC) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String tipoViaje = request.getParameter("tipoViaje"); 

        String urlRedireccion = "regular".equalsIgnoreCase(tipoViaje) ? "ViajeRegularServlet" : "ViajePrivadoServlet"; 
        
        try {
            int idViaje = Integer.parseInt(request.getParameter("idViaje"));
            double kilometraje = Double.parseDouble(request.getParameter("kilometrajeInicial"));
            
            String fechaManualStr = request.getParameter("horaRealSalida").replace("T", " ") + ":00";
            Timestamp horaSalida = Timestamp.valueOf(fechaManualStr);
            
            ControlViaje control = new ControlViaje();
            control.setHoraRealSalida(horaSalida);
            control.setKilometrajeInicial(kilometraje);
            
            if ("regular".equalsIgnoreCase(tipoViaje)) {
                control.setIdViajeReg(idViaje);
            } else {
                control.setIdViajePriv(idViaje);
            }
            
            ControlViajeDAO dao = new ControlViajeDAO();
            boolean exito = dao.iniciarViajeSeguro(control, tipoViaje);
            
            if (exito) {
                response.sendRedirect(urlRedireccion + "?msg=salidaRegistrada");
            } else {
                response.sendRedirect(urlRedireccion + "?error=db");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(urlRedireccion + "?error=formato");
        }
    }
}