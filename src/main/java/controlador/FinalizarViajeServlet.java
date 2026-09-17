package controlador;

import dao.ConfiguracionDAO;
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

@WebServlet(name = "FinalizarViajeServlet", urlPatterns = {"/FinalizarViajeServlet"})
public class FinalizarViajeServlet extends HttpServlet {

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
        String urlRedireccion = "regular".equalsIgnoreCase(tipoViaje) ? "ViajeRegularServlet" : "ViajePrivadosServlet";
        
        try {
            int idViaje = Integer.parseInt(request.getParameter("idViaje"));
            double kilometrajeFinal = Double.parseDouble(request.getParameter("kilometrajeFinal"));
            double gastoCombustible = Double.parseDouble(request.getParameter("gastoCombustible"));
            
            String fechaManualStr = request.getParameter("horaRealLlegada").replace("T", " ") + ":00";
            Timestamp horaLlegada = Timestamp.valueOf(fechaManualStr);
            
            ControlViaje control = new ControlViaje();
            control.setHoraRealLlegada(horaLlegada);
            control.setKilometrajeFinal(kilometrajeFinal);
            control.setGastoCombustible(gastoCombustible);
            
            if ("regular".equalsIgnoreCase(tipoViaje)) {
                control.setIdViajeReg(idViaje);
            } else {
                control.setIdViajePriv(idViaje);
            }
            
            ConfiguracionDAO configDAO = new ConfiguracionDAO();
            double costoDepreciacion = configDAO.obtenerMontoDepreciacion();
            
            ControlViajeDAO dao = new ControlViajeDAO();
            boolean exito = dao.finalizarViajeSeguro(control, tipoViaje, costoDepreciacion);
            
            if (exito) {
                response.sendRedirect(urlRedireccion + "?msg=llegadaRegistrada");
            } else {
                response.sendRedirect(urlRedireccion + "?error=db");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(urlRedireccion + "?error=formato");
        }
    }
}