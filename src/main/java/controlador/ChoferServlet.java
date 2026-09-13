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
        
        try {
            String accion = request.getParameter("accion");
            ChoferDAO dao = new ChoferDAO();
            
            if ("registrar".equals(accion)) {
                Chofer nuevoChofer = new Chofer();
                HttpSession sesion = request.getSession();
                Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
                
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
            }
            
            response.sendRedirect("ChoferServlet");
            
        } catch (Exception e) {
            System.out.println("Error en ChoferServlet: " + e.getMessage());
            response.sendRedirect("ChoferServlet?error=true");
        }
    }
}