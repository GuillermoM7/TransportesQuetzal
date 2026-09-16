package controlador;

import dao.SucursalDAO;
import dao.ViajePrivadoDAO;
import modelos.Usuario;
import modelos.ViajePrivado;
import java.io.IOException;
import java.sql.Timestamp;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MisViajesServlet", urlPatterns = {"/MisViajesServlet"})
public class MisViajesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
             
        ViajePrivadoDAO vpDao = new ViajePrivadoDAO();
        SucursalDAO sucDao = new SucursalDAO();
        
        request.setAttribute("misViajes", vpDao.listarPorCliente(usuario.getIdUsuario()));
        request.setAttribute("listaSucursales", sucDao.listarTodos());
        
        request.getRequestDispatcher("mis_viajes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        if (usuario == null) return;
        
        try {
            String accion = request.getParameter("accion");
            ViajePrivadoDAO dao = new ViajePrivadoDAO();
            
            if ("solicitar".equals(accion)) {
                ViajePrivado nuevo = new ViajePrivado();
                nuevo.setIdSucursal(Integer.parseInt(request.getParameter("idSucursal")));
                nuevo.setIdUsuarioCliente(usuario.getIdUsuario());
                nuevo.setOrigen(request.getParameter("origen"));
                nuevo.setDestino(request.getParameter("destino"));
                nuevo.setCantidadPasajeros(Integer.parseInt(request.getParameter("cantidadPasajeros")));
                String salidaStr = request.getParameter("fechaHoraSalida").replace("T", " ") + ":00";
                nuevo.setFechaHoraSalida(Timestamp.valueOf(salidaStr));
                
                String retornoStr = request.getParameter("fechaHoraRetorno");
                if (retornoStr != null && !retornoStr.isEmpty()) {
                    nuevo.setFechaHoraRetorno(Timestamp.valueOf(retornoStr.replace("T", " ") + ":00"));
                }
                
                dao.insertar(nuevo);
                response.sendRedirect("MisViajesServlet?msg=solicitado");
                
            } else if ("pagar".equals(accion)) {
                int idViaje = Integer.parseInt(request.getParameter("idViaje"));
                double monto = Double.parseDouble(request.getParameter("monto"));
                
                boolean pagado = dao.pagarViaje(idViaje, usuario.getIdUsuario(), monto);
                
                if (pagado) {
                    usuario.setSaldoCartera(usuario.getSaldoCartera() - monto);
                    sesion.setAttribute("usuarioLogueado", usuario);
                    
                    response.sendRedirect("MisViajesServlet?msg=pagado");
                } else {
                    response.sendRedirect("MisViajesServlet?error=SaldoInsuficiente");
                }
            }
        } catch (Exception e) {
            response.sendRedirect("MisViajesServlet?error=true");
        }
    }
}