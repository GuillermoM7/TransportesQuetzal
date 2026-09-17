package controlador;

import dao.ReportesAdminDAO;
import dao.SucursalDAO;
import dtos.GananciaReporteDTO;
import dtos.RutaDemandadaDTO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import modelos.Usuario;
import modelos.enums.Rol;

@WebServlet(name = "ReportesAdminServlet", urlPatterns = {"/ReportesAdminServlet"})
public class ReportesAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        
        if (usuario == null || usuario.getRol() != Rol.ADMIN_SIS) {
            response.sendRedirect("login.jsp?error=Acceso Denegado");
            return;
        }

        String tipo = request.getParameter("tipo");
        ReportesAdminDAO dao = new ReportesAdminDAO();
        
        String fIni = request.getParameter("fechaInicio");
        String fFin = request.getParameter("fechaFin");

        if (tipo == null) {
            response.sendRedirect("panel_admin_sistema.jsp");
            return;
        }

        switch (tipo) {
            case "ganancias":
            case "costos":
                String idSuc = request.getParameter("idSucursal");
                List<GananciaReporteDTO> listaFinanciera = dao.reporteFinancieroSucursales(fIni, fFin, idSuc);
                request.setAttribute("listaFinanciera", listaFinanciera);
                
                SucursalDAO sucDao = new SucursalDAO();
                request.setAttribute("listaSucursales", sucDao.listarTodos());
                
                if (tipo.equals("ganancias")) {
                    request.getRequestDispatcher("reporte_gerencial_ganacias.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("reporte_gerencial_costos.jsp").forward(request, response);
                }
                break;
                
            case "rutas":
                List<RutaDemandadaDTO> listaRutas = dao.reporteRutasDemandadas(fIni, fFin);
                request.setAttribute("listaRutas", listaRutas);
                request.getRequestDispatcher("reporte_gerencial_rutas.jsp").forward(request, response);
                break;
                
            case "mapa_rutas":
                String sucFiltroStr = request.getParameter("idSucursal");
                int idSucursalFiltro = 0;
                
                if (sucFiltroStr != null && !sucFiltroStr.isEmpty() && !sucFiltroStr.equals("Todas")) {
                    idSucursalFiltro = Integer.parseInt(sucFiltroStr);
                }

                SucursalDAO sDao = new SucursalDAO();
                request.setAttribute("listaSucursales", sDao.listarTodos());
                request.setAttribute("sucursalSeleccionada", idSucursalFiltro);
                dao.RutaDAO rDao = new dao.RutaDAO();
                request.setAttribute("listaRutasMapa", rDao.listarRutasParaMapa(idSucursalFiltro));

                request.getRequestDispatcher("reporte_gerencial_mapa.jsp").forward(request, response);
                break;    
                
            default:
                response.sendRedirect("panel_admin_sistema.jsp");
                break;
        }
    }
}