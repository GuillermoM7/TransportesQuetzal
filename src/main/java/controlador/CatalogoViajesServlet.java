package controlador;

import dao.SucursalDAO;
import dao.ViajeRegularDAO;
import modelos.Sucursal;
import modelos.Usuario;
import modelos.ViajeRegular;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CatalogoViajesServlet", urlPatterns = {"/CatalogoViajesServlet"})
public class CatalogoViajesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        SucursalDAO sucursalDAO = new SucursalDAO();
        ViajeRegularDAO viajeDAO = new ViajeRegularDAO();

        List<Sucursal> listaSucursales = sucursalDAO.listarTodos();
        request.setAttribute("listaSucursales", listaSucursales);

        int idSucursalFiltro = 0; 
        String sucursalParam = request.getParameter("idSucursal");
        
        if (sucursalParam != null && !sucursalParam.isEmpty()) {
            idSucursalFiltro = Integer.parseInt(sucursalParam);
        }
        
        request.setAttribute("sucursalSeleccionada", idSucursalFiltro);

        List<ViajeRegular> listaViajes = viajeDAO.listarViajesDisponiblesPorSucursal(idSucursalFiltro);
        request.setAttribute("listaViajes", listaViajes);
        
        dao.RutaDAO rutaDAO = new dao.RutaDAO();
        request.setAttribute("listaRutasMapa", rutaDAO.listarRutasParaMapa(idSucursalFiltro));

        request.getRequestDispatcher("catalogo_rutas.jsp").forward(request, response);
    }
}