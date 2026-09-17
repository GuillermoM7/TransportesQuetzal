package controlador;

import dao.BusDAO;
import dao.ChoferDAO;
import dao.ViajePrivadoDAO;
import modelos.Bus;
import modelos.Chofer;
import modelos.Usuario;
import modelos.enums.Estado;
import modelos.enums.Rol;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelos.ViajePrivado;

@WebServlet(name = "ViajePrivadoServlet", urlPatterns = {"/ViajePrivadoServlet"})
public class ViajePrivadoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        ViajePrivadoDAO vpDao = new ViajePrivadoDAO();
        
        if (usuario.getRol() == Rol.ADMIN_SUC) {
            int idSuc = usuario.getIdSucursalAsignada();
            
            request.setAttribute("listaViajesPrivados", vpDao.listarPorSucursal(idSuc));
            
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
            request.setAttribute("listaViajesPrivados", vpDao.listarTodos());
        }
        
        request.getRequestDispatcher("gestionar_viajes_privados.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
                
        try {
            String accion = request.getParameter("accion");
            ViajePrivadoDAO dao = new ViajePrivadoDAO();
            
            if ("cotizar".equals(accion)) {
                int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                int idBus = Integer.parseInt(request.getParameter("idBus"));
                int idChofer = Integer.parseInt(request.getParameter("idChofer"));
                double precioEstimado = Double.parseDouble(request.getParameter("precioEstimado"));
                
                dao.cotizarViaje(idViaje, idBus, idChofer, precioEstimado);
                
            } else if ("iniciar".equals(accion)) {
                int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                int idChofer = Integer.parseInt(request.getParameter("idChofer"));
                dao.iniciarViaje(idViaje, idChofer);
                
            } else if ("cambiarEstado".equals(accion)) {
                int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                String nuevoEstado = request.getParameter("nuevoEstado"); 
                dao.cambiarEstado(idViaje, nuevoEstado);

            } else if ("actualizar".equals(accion)) {
                try {
                    ViajePrivado v = new ViajePrivado();
                    v.setIdViajePriv(Integer.parseInt(request.getParameter("idViaje")));
                    v.setOrigen(request.getParameter("origen"));
                    v.setDestino(request.getParameter("destino"));
                    v.setCantidadPasajeros(Integer.parseInt(request.getParameter("pasajeros")));
                    v.setPrecioEstimado(Double.parseDouble(request.getParameter("precio")));
                    String salidaStr = request.getParameter("fechaSalida").replace("T", " ") + ":00";
                    String retornoStr = request.getParameter("fechaRetorno").replace("T", " ") + ":00";
                    v.setFechaHoraSalida(java.sql.Timestamp.valueOf(salidaStr));
                    v.setFechaHoraRetorno(java.sql.Timestamp.valueOf(retornoStr));                   
                    boolean exito = dao.actualizarViajePrivado(v);
                    
                    if (exito) {
                        response.sendRedirect("ViajePrivadoServlet?msg=viajeActualizado");
                        return;
                    } else {
                        response.sendRedirect("ViajePrivadoServlet?error=estadoNoPermitido");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("ViajePrivadoServlet?error=formato");
                    return;
                }
                

            } else if ("eliminar".equals(accion)) {
                try {
                    int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                    boolean exito = dao.eliminarViajePrivado(idViaje);
                    
                    if (exito) {
                        response.sendRedirect("ViajePrivadoServlet?msg=viajeEliminado");
                        return;
                    } else {
                        response.sendRedirect("ViajePrivadoServlet?error=noSePudoEliminar");
                        return;
                    }
                } catch (Exception e) {
                    response.sendRedirect("ViajePrivadoServlet?error=true");
                    return;
                }
            }
            
            response.sendRedirect("ViajePrivadoServlet");
            
        } catch (Exception e) {
            System.out.println("Error en ViajePrivadoServlet: " + e.getMessage());
            response.sendRedirect("ViajePrivadoServlet?error=true");
        }
    }
}