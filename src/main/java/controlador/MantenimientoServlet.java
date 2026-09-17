package controlador;

import dao.MantenimientoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import modelos.Mantenimiento;

@WebServlet(name = "MantenimientoServlet", urlPatterns = {"/MantenimientoServlet"})
public class MantenimientoServlet extends HttpServlet {

@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String accion = request.getParameter("accion");
        
        if ("registrar".equals(accion)) {
            try {
                Mantenimiento mant = new Mantenimiento();
                mant.setIdBus(Integer.parseInt(request.getParameter("idBus")));
                mant.setMontoManoDeObra(Double.parseDouble(request.getParameter("manoObra")));
                mant.setMontoRepuesto(Double.parseDouble(request.getParameter("repuestos")));
                
                String fechaStr = request.getParameter("fechaMantenimiento");
                mant.setFechaMantenimiento(java.sql.Date.valueOf(fechaStr));
                
                MantenimientoDAO dao = new MantenimientoDAO();
                boolean exito = dao.registrarMantenimiento(mant);
                
                if (exito) {

                    response.sendRedirect("BusServlet?msg=mantenimientoRegistrado");
                } else {
                    response.sendRedirect("BusServlet?error=db");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("BusServlet?error=formato");
            }
        }
    }
}
