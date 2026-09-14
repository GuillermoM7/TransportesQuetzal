package controlador;

import dao.RutaDAO;
import dao.SucursalDAO;
import modelos.Ruta;
import modelos.Usuario;
import modelos.enums.Rol;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

@WebServlet(name = "RutaServlet", urlPatterns = {"/RutaServlet"})
public class RutaServlet extends HttpServlet {

@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null || usuario.getRol() == Rol.ADMIN_SIS) {
            response.sendRedirect("panel_principal.jsp?error=AccesoDenegado");
            return;
        }
        
        RutaDAO rDao = new RutaDAO();
        SucursalDAO sDao = new SucursalDAO();
        
        List<Ruta> misRutas = new java.util.ArrayList<>();
        for (Ruta r : rDao.listarTodos()) {
            if (r.getIdSucursalOrigen() == usuario.getIdSucursalAsignada()) {
                misRutas.add(r);
            }
        }
        
        request.setAttribute("listaRutas", misRutas);
        request.setAttribute("listaSucursales", sDao.listarTodos());
        request.getRequestDispatcher("gestionar_rutas.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null || usuario.getRol() == Rol.ADMIN_SIS) {
            response.sendRedirect("panel_principal.jsp?error=AccionNoPermitida");
            return;
        }
        
        try {
            String accion = request.getParameter("accion");
            RutaDAO dao = new RutaDAO();
            
            if ("registrar".equals(accion)) {
                Ruta nuevaRuta = new Ruta();
                nuevaRuta.setIdSucursalOrigen(usuario.getIdSucursalAsignada());
                nuevaRuta.setIdSucursalDestino(Integer.parseInt(request.getParameter("idDestino")));
                nuevaRuta.setDistanciaKm(Double.parseDouble(request.getParameter("distancia")));
                nuevaRuta.setPrecioBoleto(Double.parseDouble(request.getParameter("precio")));
                
                dao.insertar(nuevaRuta);
                
            } else if ("cambiarEstado".equals(accion)) {
                dao.cambiarEstado(Integer.parseInt(request.getParameter("idRuta")), request.getParameter("nuevoEstado"));
                
            } else if ("eliminar".equals(accion)) {
                if (!dao.eliminar(Integer.parseInt(request.getParameter("idRuta")))) {
                    response.sendRedirect("RutaServlet?error=EnUso");
                    return;
                }
            }
            response.sendRedirect("RutaServlet");
            
        } catch (Exception e) {
            response.sendRedirect("RutaServlet?error=true");
        }
    }
}