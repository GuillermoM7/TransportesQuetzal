package controlador;

import dao.SucursalDAO;
import modelos.Sucursal;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SucursalServlet", urlPatterns = {"/SucursalServlet"})
public class SucursalServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        SucursalDAO dao = new SucursalDAO();
        List<Sucursal> lista = dao.listarTodos();
        
        request.setAttribute("listaSucursales", lista);
        
        request.getRequestDispatcher("gestionar_sucursales.jsp").forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String accion = request.getParameter("accion");
        if ("registrar".equals(accion)) {
            try {
                Sucursal nuevaSucursal = new Sucursal();
                nuevaSucursal.setNombre(request.getParameter("nombre"));
                nuevaSucursal.setDireccion(request.getParameter("direccion"));
                    
                String latStr = request.getParameter("latitud");
                String lngStr = request.getParameter("longitud");
                    
                double lat = (latStr != null && !latStr.isEmpty()) ? Double.parseDouble(latStr) : 0.0;
                double lng = (lngStr != null && !lngStr.isEmpty()) ? Double.parseDouble(lngStr) : 0.0;
                    
                nuevaSucursal.setLatitud(lat);
                nuevaSucursal.setLongitud(lng);
                    
                SucursalDAO dao = new SucursalDAO();
                boolean exito = dao.insertar(nuevaSucursal);
                    
                if (exito) {
                    response.sendRedirect("SucursalServlet?msg=sucursalRegistrada");
                    return; 
                } else {
                    response.sendRedirect("SucursalServlet?error=db");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("SucursalServlet?error=formato");
                return;
            }
        } else if ("actualizar".equals(accion)) {
            try {
                Sucursal sucursal = new Sucursal();
                sucursal.setIdSucursal(Integer.parseInt(request.getParameter("idSucursal")));
                sucursal.setNombre(request.getParameter("nombre"));
                sucursal.setDireccion(request.getParameter("direccion"));
                
                String latStr = request.getParameter("latitud");
                String lngStr = request.getParameter("longitud");
                
                double lat = (latStr != null && !latStr.isEmpty()) ? Double.parseDouble(latStr) : 0.0;
                double lng = (lngStr != null && !lngStr.isEmpty()) ? Double.parseDouble(lngStr) : 0.0;
                
                sucursal.setLatitud(lat);
                sucursal.setLongitud(lng);
                
                SucursalDAO dao = new SucursalDAO();
                boolean exito = dao.actualizar(sucursal);
                
                if (exito) {
                    response.sendRedirect("SucursalServlet?msg=sucursalActualizada");
                    return;
                } else {
                    response.sendRedirect("SucursalServlet?error=db");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("SucursalServlet?error=formato");
                return;
            }
        }
   }
}    