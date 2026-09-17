<%@page import="java.util.List"%>
<%@page import="dtos.RutaDemandadaDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<RutaDemandadaDTO> lista = (List<RutaDemandadaDTO>) request.getAttribute("listaRutas");
    String fIni = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "";
    String fFin = request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "";
    int totalBoletosGlobal = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Rutas Demandadas - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container mt-5 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-signpost-split me-2 text-warning"></i> Rutas Más Demandadas</h3>
                <p class="text-muted mb-0">Ranking de rutas basado en la venta de boletos.</p>
            </div>
            <div class="col-md-6">
                <form action="ReportesAdminServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="rutas">
                    <input type="date" name="fechaInicio" class="form-control border-0 me-2" value="<%= fIni %>">
                    <input type="date" name="fechaFin" class="form-control border-0 me-2" value="<%= fFin %>">
                    <button type="submit" class="btn btn-warning text-dark fw-bold px-4">Filtrar</button>
                    <a href="ReportesAdminServlet?tipo=rutas" class="btn btn-outline-secondary ms-2" title="Limpiar"><i class="bi bi-arrow-clockwise"></i></a>
                </form>
            </div>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Ranking</th>
                            <th>Ruta (Origen <i class="bi bi-arrow-right mx-1"></i> Destino)</th>
                            <th>Total Boletos Vendidos</th>
                            <th>Total Ingresos Generados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            int ranking = 1;
                            for (RutaDemandadaDTO r : lista) { 
                                totalBoletosGlobal += r.getBoletosVendidos();
                        %>
                                <tr>
                                    <td class="fw-bold py-3 text-muted">#<%= ranking++ %></td>
                                    <td class="fw-bold fs-6 text-primary"><%= r.getOrigen() %> <i class="bi bi-arrow-right mx-2 text-dark"></i> <%= r.getDestino() %></td>
                                    <td><span class="badge bg-warning text-dark fs-6"><%= r.getBoletosVendidos() %></span></td>
                                    <td class="fw-bold text-success">Q. <%= String.format("%,.2f", r.getTotalIngresos()) %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="4" class="text-muted py-5">No hay ventas registradas en el sistema.</td></tr>
                        <% } %>
                    </tbody>
                    <% if (lista != null && !lista.isEmpty()) { %>
                    <tfoot class="bg-light fw-bold fs-5">
                        <tr>
                            <td colspan="2" class="text-end py-3">TOTAL GLOBAL BOLETOS:</td>
                            <td class="text-primary py-3"><%= totalBoletosGlobal %></td>
                            <td></td>
                        </tr>
                    </tfoot>
                    <% } %>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>