<%@page import="java.util.List"%>
<%@page import="modelos.Boleto"%>
<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    List<Boleto> historial = (List<Boleto>) request.getAttribute("historialBoletos");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Boletos - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h2 class="fw-bold" style="color: #0A3323;">
                    <i class="bi bi-ticket-detailed-fill me-2" style="color: #006A4E;"></i>Mis Boletos
                </h2>
                <p class="text-muted">Historial completo de tus compras, ordenado de la más reciente a la más antigua.</p>
            </div>
        </div>

        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle text-center">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">No. Boleto</th>
                            <th class="py-3 text-start">Ruta</th>
                            <th class="py-3">Fecha de Compra</th>
                            <th class="py-3">Salida del Viaje</th>
                            <th class="py-3">Bus / Asiento</th>
                            <th class="py-3">Total Pagado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (historial != null && !historial.isEmpty()) {
                            for (Boleto b : historial) { 
                                String fechaCompra = b.getFechaCompra() != null ? b.getFechaCompra().toString().substring(0, 16) : "N/A";
                                String fechaSalida = b.getFechaHoraSalida() != null ? b.getFechaHoraSalida().toString().substring(0, 16) : "N/A";
                        %>
                                <tr>
                                    <td class="py-3 fw-bold text-muted">#<%= String.format("%05d", b.getIdBoleto()) %></td>
                                    
                                    <td class="py-3 text-start px-3">
                                        <span class="fw-bold text-primary d-block"><%= b.getNombreRuta() %></span>
                                    </td>
                                    
                                    <td class="py-3 text-muted">
                                        <i class="bi bi-cart-check me-1"></i><%= fechaCompra %>
                                    </td>
                                    
                                    <td class="py-3 fw-bold">
                                        <i class="bi bi-calendar-event text-danger me-1"></i><%= fechaSalida %>
                                    </td>
                                    
                                    <td class="py-3">
                                        <span class="badge bg-secondary mb-1">Bus: <%= b.getPlacaBus() %></span><br>
                                        <span class="badge bg-success">Asiento: <%= b.getNumeroAsiento() %></span>
                                    </td>
                                    
                                    <td class="py-3 fw-bold text-success">
                                        Q. <%= String.format("%.2f", b.getPrecioPagado()) %>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="6" class="py-5 text-muted">
                                    <i class="bi bi-receipt fs-2 d-block mb-2"></i>
                                    Aún no has comprado ningún boleto. <br>
                                    <a href="CatalogoViajesServlet" class="btn btn-outline-primary mt-3">Explorar Rutas</a>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>