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
        
        String nombre = request.getParameter("nombre");
        String direccion = request.getParameter("direccion");
        
        Sucursal nuevaSucursal = new Sucursal();
        nuevaSucursal.setNombre(nombre);
        nuevaSucursal.setDireccion(direccion);
        
        SucursalDAO dao = new SucursalDAO();
        if (dao.insertar(nuevaSucursal)) {
            response.sendRedirect("SucursalServlet?mensaje=exito");
        } else {
            response.sendRedirect("SucursalServlet?mensaje=error");
        }
    }
}