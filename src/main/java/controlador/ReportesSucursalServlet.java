package controlador;

import dao.ConfiguracionDAO;
import dao.ReportesDAO;
import dtos.BusReporteDTO;
import dtos.ChoferReporteDTO;
import dtos.DepreciacionReporteDTO;
import dtos.IngresoAlquilerDTO;
import dtos.IngresosBoletosDTO;
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

@WebServlet(name = "ReportesSucursalServlet", urlPatterns = {"/ReportesSucursalServlet"})
public class ReportesSucursalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        

        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        

        if (usuario == null || usuario.getRol() == Rol.CLIENTE || usuario.getRol() == Rol.ADMIN_SIS) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idSucursal = usuario.getIdSucursalAsignada();
        String tipo = request.getParameter("tipo");
        ReportesDAO reportesDAO = new ReportesDAO();
        
        if (tipo == null) {
            response.sendRedirect("panel_principal.jsp");
            return;
        }


        switch (tipo) {
            case "buses":
                String filtroEstado = request.getParameter("estado");
                List<BusReporteDTO> listaBuses = reportesDAO.reporteGeneralBuses(idSucursal, filtroEstado);
                request.setAttribute("listaBuses", listaBuses);
                request.setAttribute("filtroActual", filtroEstado != null ? filtroEstado : "Todos");
                request.getRequestDispatcher("reporte_buses.jsp").forward(request, response);
                break;
                
            case "choferes":
                List<ChoferReporteDTO> listaChoferes = reportesDAO.reporteGeneralChoferes(idSucursal);
                request.setAttribute("listaChoferes", listaChoferes);
                request.getRequestDispatcher("reporte_choferes.jsp").forward(request, response);
                break;
                
            case "depreciacion":
                ConfiguracionDAO configDAO = new ConfiguracionDAO(); 
                double depreciacionPorKm = configDAO.obtenerMontoDepreciacion();
                
                List<DepreciacionReporteDTO> listaDepreciacion = reportesDAO.reporteDepreciacion(idSucursal, depreciacionPorKm);
                request.setAttribute("listaDepreciacion", listaDepreciacion);
                request.setAttribute("tasaDepreciacion", depreciacionPorKm);
                request.getRequestDispatcher("reporte_depreciacion.jsp").forward(request, response);
                break;
                            
            case "ingresos_boletos":
                String fInicioBol = request.getParameter("fechaInicio");
                String fFinBol = request.getParameter("fechaFin");
                String filtroRuta = request.getParameter("idRuta");
                String filtroBus = request.getParameter("idBus");
                
                List<IngresosBoletosDTO> listaIngresosBol = reportesDAO.reporteIngresosBoletos(idSucursal, fInicioBol, fFinBol, filtroRuta, filtroBus);
                request.setAttribute("listaIngresosBoletos", listaIngresosBol);
                
                request.getRequestDispatcher("reporte_ingresos_boletos.jsp").forward(request, response);
                break;
                
            case "ingresos_alquiler":
                String fInicioAlq = request.getParameter("fechaInicio");
                String fFinAlq = request.getParameter("fechaFin");
                
                List<IngresoAlquilerDTO> listaAlquiler = reportesDAO.reporteIngresosAlquiler(idSucursal, fInicioAlq, fFinAlq);
                request.setAttribute("listaAlquileres", listaAlquiler);
                
                request.getRequestDispatcher("reporte_ingresos_alquiler.jsp").forward(request, response);
                break;    
                
            default:
                response.sendRedirect("panel_admin_sucursal.jsp");
                break;
        }
    }
}