package controlador;

import dao.ChoferDAO;
import modelos.Chofer;
import modelos.enums.Rol;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date; 
import modelos.Usuario;

@WebServlet(name = "ChoferServlet", urlPatterns = {"/ChoferServlet"})
public class ChoferServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        ChoferDAO dao = new ChoferDAO();
        List<Chofer> listaChoferes;
        
        if (usuario.getRol() == Rol.ADMIN_SUC) {
            listaChoferes = dao.listarPorSucursal(usuario.getIdSucursalAsignada());
        } else {
            listaChoferes = dao.listarTodos();
        }
        
        request.setAttribute("listaChoferes", listaChoferes);
        request.getRequestDispatcher("gestionar_choferes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario.getRol() == Rol.ADMIN_SIS || usuario.getRol() == Rol.CLIENTE) {
            response.sendRedirect("gestionar_choferes.jsp?error=AccionNoPermitida");
            return;
            }
        
        try {
            String accion = request.getParameter("accion");
            ChoferDAO dao = new ChoferDAO();
            
            if ("registrar".equals(accion)) {
                Chofer nuevoChofer = new Chofer();
                
                nuevoChofer.setIdSucursal(usuario.getIdSucursalAsignada());                
                nuevoChofer.setNombre(request.getParameter("nombre"));
                nuevoChofer.setLicencia(request.getParameter("licencia"));
                nuevoChofer.setTipoLicencia(request.getParameter("tipoLicencia"));               
                String fechaTexto = request.getParameter("fechaVencimiento");
                nuevoChofer.setFechaVencimiento(Date.valueOf(fechaTexto));                
                nuevoChofer.setTelefono(request.getParameter("telefono"));
                nuevoChofer.setSalarioBase(Double.parseDouble(request.getParameter("salarioBase")));
                nuevoChofer.setFoto(request.getParameter("fotoUrl")); 
                
                dao.insertar(nuevoChofer);
                
            } else if ("cambiarEstado".equals(accion)) {
                int idChofer = Integer.parseInt(request.getParameter("idChofer"));
                String nuevoEstado = request.getParameter("nuevoEstado");
                dao.cambiarEstado(idChofer, nuevoEstado);
                
            }else if("actualizar".equals(accion)){
                try {
                    Chofer chofer = new Chofer();
                    chofer.setIdChofer(Integer.parseInt(request.getParameter("idChofer")));
                    chofer.setNombre(request.getParameter("nombre"));
                    chofer.setLicencia(request.getParameter("licencia"));
                    chofer.setTipoLicencia(request.getParameter("tipoLicencia"));              
                    String fechaStr = request.getParameter("fechaVencimiento");
                    chofer.setFechaVencimiento(java.sql.Date.valueOf(fechaStr));               
                    chofer.setTelefono(request.getParameter("telefono"));
                    chofer.setSalarioBase(Double.parseDouble(request.getParameter("salarioBase")));
                    chofer.setFoto(request.getParameter("fotoUrl"));
                
                    boolean exito = dao.actualizar(chofer);
                
                    if (exito) {
                        response.sendRedirect("ChoferServlet?msg=choferActualizado"); 
                        return;
                    } else {
                        response.sendRedirect("ChoferServlet?error=db");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("ChoferServlet?error=formato");
                    return;
                }
            }
            
            response.sendRedirect("ChoferServlet");
            
        } catch (Exception e) {
            System.out.println("Error en ChoferServlet: " + e.getMessage());
            response.sendRedirect("ChoferServlet?error=true");
        }
    }
}