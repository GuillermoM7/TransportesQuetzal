package controlador;

import dao.BusDAO;
import modelos.Bus;
import modelos.Usuario;
import modelos.enums.Rol;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "BusServlet", urlPatterns = {"/BusServlet"})
public class BusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        BusDAO dao = new BusDAO();
        List<Bus> listaBuses;
        
        if (usuario.getRol() == Rol.ADMIN_SUC) {
            listaBuses = dao.listarPorSucursal(usuario.getIdSucursalAsignada());
        } else {
            listaBuses = dao.listarTodos();
        }
        
        request.setAttribute("listaBuses", listaBuses);
        request.getRequestDispatcher("gestionar_buses.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario.getRol() == Rol.ADMIN_SIS || usuario.getRol() == Rol.CLIENTE) {
            response.sendRedirect("panel_principal.jsp?error=AccionNoPermitida");
            return;
            }
        
        try {
            String accion = request.getParameter("accion");
            BusDAO dao = new BusDAO();
            
            if ("registrar".equals(accion)) {
                Bus nuevoBus = new Bus();
                
                nuevoBus.setIdSucursal(usuario.getIdSucursalAsignada());
                nuevoBus.setPlaca(request.getParameter("placa"));
                nuevoBus.setMarca(request.getParameter("marca"));
                nuevoBus.setModelo(request.getParameter("modelo"));
                nuevoBus.setAnio(Integer.parseInt(request.getParameter("anio")));
                nuevoBus.setCapacidad(Integer.parseInt(request.getParameter("capacidad")));
                nuevoBus.setKilometraje(Double.parseDouble(request.getParameter("kilometraje")));
                nuevoBus.setFoto(request.getParameter("foto"));
                
                dao.insertar(nuevoBus);
                
            } else if ("cambiarEstado".equals(accion)) {
                int idBus = Integer.parseInt(request.getParameter("idBus"));
                String nuevoEstado = request.getParameter("nuevoEstado");
                dao.cambiarEstado(idBus, nuevoEstado);
                
            } else if ("actualizar".equals(accion)){
                try {
                    Bus bus = new Bus();
                    bus.setIdBus(Integer.parseInt(request.getParameter("idBus")));
                    bus.setPlaca(request.getParameter("placa"));
                    bus.setMarca(request.getParameter("marca"));
                    bus.setModelo(request.getParameter("modelo"));
                    bus.setAnio(Integer.parseInt(request.getParameter("anio")));
                    bus.setCapacidad(Integer.parseInt(request.getParameter("capacidadPasajeros")));
                    bus.setFoto(request.getParameter("fotoUrl")); 
                
                    boolean exito = dao.actualizar(bus);
                
                    if (exito) {
                        response.sendRedirect("BusServlet?msg=busActualizado");
                        return;
                    } else {
                        response.sendRedirect("BusServlet?error=db");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("BusServlet?error=formato");
                    return;
                }
            }
            
            response.sendRedirect("BusServlet");
            
        } catch (Exception e) {
            System.out.println("Error en BusServlet: " + e.getMessage());
            response.sendRedirect("BusServlet?error=true");
        }
    }
}