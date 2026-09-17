package controlador;

import dao.BusDAO;
import dao.ChoferDAO;
import dao.RutaDAO;
import dao.ViajeRegularDAO;
import modelos.Bus;
import modelos.Chofer;
import modelos.Ruta;
import modelos.Usuario;
import modelos.ViajeRegular;
import modelos.enums.Estado; 
import modelos.enums.Rol;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ViajeRegularServlet", urlPatterns = {"/ViajeRegularServlet"})
public class ViajeRegularServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        ViajeRegularDAO vrDao = new ViajeRegularDAO();
        
        if (usuario.getRol() == Rol.ADMIN_SUC) {
            int idSuc = usuario.getIdSucursalAsignada();
            
            request.setAttribute("listaViajes", vrDao.listarPorSucursalOrigen(idSuc));
            
            List<Ruta> misRutasActivas = new ArrayList<>();
            for (Ruta r : new RutaDAO().listarTodos()) {
                if (r.getIdSucursalOrigen() == idSuc && "activo".equalsIgnoreCase(r.getEstado())) {
                    misRutasActivas.add(r);
                }
            }
            request.setAttribute("listaRutas", misRutasActivas);
            
            List<Bus> misBusesActivos = new ArrayList<>();
            for (Bus b : new BusDAO().listarPorSucursal(idSuc)) {
                if (b.getEstado() == Estado.ACTIVO) {
                    misBusesActivos.add(b);
                }
            }
            request.setAttribute("listaBuses", misBusesActivos);
            
            List<Chofer> misChoferesActivos = new ArrayList<>();
            for (Chofer c : new ChoferDAO().listarPorSucursal(idSuc)) {
                if (c.getEstado() == Estado.ACTIVO) { 
                    misChoferesActivos.add(c);
                }
            }
            request.setAttribute("listaChoferes", misChoferesActivos);
            
        } else {
            
            request.setAttribute("listaViajes", vrDao.listarTodos());
        }
        
        request.getRequestDispatcher("gestionar_viajes_regulares.jsp").forward(request, response);
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
            ViajeRegularDAO dao = new ViajeRegularDAO();
            
            if ("registrar".equals(accion)) {
                ViajeRegular nuevoViaje = new ViajeRegular();
                
                nuevoViaje.setIdRuta(Integer.parseInt(request.getParameter("idRuta")));
                nuevoViaje.setIdBus(Integer.parseInt(request.getParameter("idBus")));
                nuevoViaje.setIdChofer(Integer.parseInt(request.getParameter("idChofer")));
                
                String salidaStr = request.getParameter("fechaHoraSalida").replace("T", " ") + ":00";
                String llegadaStr = request.getParameter("fechaHoraLlegada").replace("T", " ") + ":00";
                
                nuevoViaje.setFechaHoraSalida(Timestamp.valueOf(salidaStr));
                nuevoViaje.setFechaHoraLlegadaEstimada(Timestamp.valueOf(llegadaStr));
                
                dao.insertar(nuevoViaje);
                
            } else if ("cambiarEstado".equals(accion)) {
                int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                String nuevoEstado = request.getParameter("nuevoEstado"); 
                dao.cambiarEstado(idViaje, nuevoEstado);
 
            } else if ("actualizar".equals(accion)) {
                try {
                    int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                    
                    String salidaStr = request.getParameter("fechaHoraSalida").replace("T", " ") + ":00";
                    String llegadaStr = request.getParameter("fechaHoraLlegada").replace("T", " ") + ":00";
                    
                    java.sql.Timestamp nuevaSalida = java.sql.Timestamp.valueOf(salidaStr);
                    java.sql.Timestamp nuevaLlegada = java.sql.Timestamp.valueOf(llegadaStr);
                    
                    boolean exito = dao.actualizarFechasViaje(idViaje, nuevaSalida, nuevaLlegada);
                    
                    if (exito) {
                        response.sendRedirect("ViajeRegularServlet?msg=viajeActualizado");
                        return;
                    } else {
                        response.sendRedirect("ViajeRegularServlet?error=estadoNoPermitido");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("ViajeRegularServlet?error=formato");
                    return;
                }
                
            } else if ("eliminar".equals(accion)) {
                try {
                    int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                    boolean exito = dao.eliminarViaje(idViaje);
                    
                    if (exito) {
                        response.sendRedirect("ViajeRegularServlet?msg=viajeEliminado");
                        return;
                    } else {
                        response.sendRedirect("ViajeRegularServlet?error=noSePudoEliminar");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("ViajeRegularServlet?error=true");
                    return;
                }
            }
            
            response.sendRedirect("ViajeRegularServlet");
            
        } catch (Exception e) {
            System.out.println("Error en ViajeRegularServlet: " + e.getMessage());
            response.sendRedirect("ViajeRegularServlet?error=true");
        }
    }
}