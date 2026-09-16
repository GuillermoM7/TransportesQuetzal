package controlador;

import dao.BoletoDAO;
import dao.ViajeRegularDAO;
import modelos.Boleto;
import modelos.Usuario;
import modelos.ViajeRegular;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ComprarBoletoServlet", urlPatterns = {"/ComprarBoletoServlet"})
public class ComprarBoletoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Usuario usuario = (Usuario) request.getSession().getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int idViaje = Integer.parseInt(request.getParameter("idViaje"));
            
            ViajeRegularDAO viajeDAO = new ViajeRegularDAO();
            BoletoDAO boletoDAO = new BoletoDAO();
            
            ViajeRegular viaje = viajeDAO.obtenerDetallesParaCompra(idViaje);
            
            List<Integer> asientosOcupados = boletoDAO.obtenerAsientosOcupados(idViaje);
            
            request.setAttribute("viaje", viaje);
            request.setAttribute("asientosOcupados", asientosOcupados);
            
            request.getRequestDispatcher("comprar_boleto.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("CatalogoViajesServlet"); 
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession sesion = request.getSession();
        Usuario usuario = (Usuario) sesion.getAttribute("usuarioLogueado");
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            int idViaje = Integer.parseInt(request.getParameter("idViaje"));
            String asientosParam = request.getParameter("asientoSeleccionado"); 
            String[] arregloAsientos = asientosParam.split(",");
            
            double precioPorBoleto = Double.parseDouble(request.getParameter("precioBoleto"));
            
            String fechaManualStr = request.getParameter("fechaCompraManual").replace("T", " ") + ":00";
            Timestamp fechaCompra = Timestamp.valueOf(fechaManualStr);
            
            java.util.ArrayList<Boleto> boletosAComprar = new java.util.ArrayList<>();
            
            for(String asStr : arregloAsientos) {
                int numAsiento = Integer.parseInt(asStr.trim());
                Boleto boleto = new Boleto();
                boleto.setIdViajeReg(idViaje);
                boleto.setIdUsuarioCliente(usuario.getIdUsuario());
                boleto.setNumeroAsiento(numAsiento);
                boleto.setPrecioPagado(precioPorBoleto);
                boleto.setFechaCompra(fechaCompra);
                boletosAComprar.add(boleto);
            }
            
            BoletoDAO dao = new BoletoDAO();
            boolean exito = dao.registrarCompraSegura(boletosAComprar);
            
            if (exito) {
                double granTotal = precioPorBoleto * boletosAComprar.size();
                usuario.setSaldoCartera(usuario.getSaldoCartera() - granTotal);
                sesion.setAttribute("usuarioLogueado", usuario);
                
                response.sendRedirect("CatalogoViajesServlet?msg=compraExitosa");
            } else {
                response.sendRedirect("ComprarBoletoServlet?idViaje=" + idViaje + "&error=saldoInsuficiente");
            }
            
        } catch (Exception e) {
            response.sendRedirect("CatalogoViajesServlet?error=procesamiento");
        }
    }
}