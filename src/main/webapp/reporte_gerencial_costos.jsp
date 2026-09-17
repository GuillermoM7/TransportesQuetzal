<%@page import="java.util.List"%>
<%@page import="modelos.Sucursal"%>
<%@page import="dtos.GananciaReporteDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<GananciaReporteDTO> lista = (List<GananciaReporteDTO>) request.getAttribute("listaFinanciera");
    List<Sucursal> sucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
    
    String fIni = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "";
    String fFin = request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "";
    String sucSelec = request.getParameter("idSucursal") != null ? request.getParameter("idSucursal") : "Todas";
    
    double tComb = 0, tTall = 0, tDepr = 0, tChof = 0, granTotalCostos = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Costos Operativos - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid px-5 mt-5 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-5">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-tools me-2 text-danger"></i> Reporte de Costos Operativos</h3>
                <p class="text-muted mb-0">Desglose de gastos por sucursal y categoría.</p>
            </div>
            <div class="col-md-7">
                <form action="ReportesAdminServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="costos">
                    <select name="idSucursal" class="form-select border-0 me-2">
                        <option value="Todas">Todas las sucursales</option>
                        <% if(sucursales != null) { for(Sucursal s : sucursales) { %>
                            <option value="<%= s.getIdSucursal() %>" <%= String.valueOf(s.getIdSucursal()).equals(sucSelec) ? "selected" : "" %>><%= s.getNombre() %></option>
                        <% } } %>
                    </select>
                    <input type="date" name="fechaInicio" class="form-control border-0 me-2" value="<%= fIni %>">
                    <input type="date" name="fechaFin" class="form-control border-0 me-2" value="<%= fFin %>">
                    <button type="submit" class="btn btn-danger fw-bold px-4">Filtrar</button>
                    <a href="ReportesAdminServlet?tipo=costos" class="btn btn-outline-secondary ms-2" title="Limpiar"><i class="bi bi-arrow-clockwise"></i></a>
                </form>
            </div>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #721c24;">
                        <tr>
                            <th class="py-3">Sucursal</th>
                            <th>Gasto en Combustible</th>
                            <th>Mantenimiento (Taller/Repuestos)</th>
                            <th>Depreciación Acumulada</th>
                            <th>Pago a Choferes</th>
                            <th class="bg-danger text-white">TOTAL COSTOS</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            for (GananciaReporteDTO g : lista) { 
                                tComb += g.getCostoCombustible();
                                tTall += g.getCostoTaller();
                                tDepr += g.getCostoDepreciacion();
                                tChof += g.getPagoChoferes();
                                granTotalCostos += g.getTotalCostos();
                        %>
                                <tr>
                                    <td class="fw-bold py-3"><%= g.getNombreSucursal() %></td>
                                    <td>Q. <%= String.format("%,.2f", g.getCostoCombustible()) %></td>
                                    <td>Q. <%= String.format("%,.2f", g.getCostoTaller()) %></td>
                                    <td>Q. <%= String.format("%,.2f", g.getCostoDepreciacion()) %></td>
                                    <td>Q. <%= String.format("%,.2f", g.getPagoChoferes()) %></td>
                                    <td class="fw-bold text-danger fs-6">Q. <%= String.format("%,.2f", g.getTotalCostos()) %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="6" class="text-muted py-5">No hay costos registrados.</td></tr>
                        <% } %>
                    </tbody>
                    <% if (lista != null && !lista.isEmpty()) { %>
                    <tfoot class="bg-light fw-bold">
                        <tr>
                            <td class="text-end py-3">TOTALES POR CATEGORÍA:</td>
                            <td class="py-3">Q. <%= String.format("%,.2f", tComb) %></td>
                            <td class="py-3">Q. <%= String.format("%,.2f", tTall) %></td>
                            <td class="py-3">Q. <%= String.format("%,.2f", tDepr) %></td>
                            <td class="py-3">Q. <%= String.format("%,.2f", tChof) %></td>
                            <td class="bg-danger text-white fs-5 py-3">Q. <%= String.format("%,.2f", granTotalCostos) %></td>
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