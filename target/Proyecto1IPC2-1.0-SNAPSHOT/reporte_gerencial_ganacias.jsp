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
    
    double sumaIngresos = 0, sumaCostos = 0, sumaGanancias = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Ganancias - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid px-5 mt-5 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-5">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-cash-coin me-2 text-success"></i> Reporte de Ganancias Netas</h3>
                <p class="text-muted mb-0">Consolidado financiero por sucursal ordenado alfabéticamente.</p>
            </div>
            <div class="col-md-7">
                <form action="ReportesAdminServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="ganancias">
                    <select name="idSucursal" class="form-select border-0 me-2">
                        <option value="Todas">Todas las sucursales</option>
                        <% if(sucursales != null) { for(Sucursal s : sucursales) { %>
                            <option value="<%= s.getIdSucursal() %>" <%= String.valueOf(s.getIdSucursal()).equals(sucSelec) ? "selected" : "" %>><%= s.getNombre() %></option>
                        <% } } %>
                    </select>
                    <input type="date" name="fechaInicio" class="form-control border-0 me-2" value="<%= fIni %>" title="Fecha de inicio">
                    <input type="date" name="fechaFin" class="form-control border-0 me-2" value="<%= fFin %>" title="Fecha fin">
                    <button type="submit" class="btn btn-success fw-bold px-4">Filtrar</button>
                    <a href="ReportesAdminServlet?tipo=ganancias" class="btn btn-outline-secondary ms-2" title="Limpiar Filtros"><i class="bi bi-arrow-clockwise"></i></a>
                </form>
            </div>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 text-center align-middle">
                        <thead class="text-white" style="background-color: #0A3323;">
                            <tr>
                                <th class="py-3">Sucursal</th>
                                <th>Ingresos Boletos</th>
                                <th>Ingresos Alquiler</th>
                                <th class="bg-primary text-white">TOTAL INGRESOS</th>
                                <th>Costos (Comb/Tall/Depr/Chofer)</th>
                                <th class="bg-danger text-white">TOTAL COSTOS</th>
                                <th class="bg-success text-white">GANANCIA NETA</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (lista != null && !lista.isEmpty()) { 
                                for (GananciaReporteDTO g : lista) { 
                                    sumaIngresos += g.getTotalIngresos();
                                    sumaCostos += g.getTotalCostos();
                                    sumaGanancias += g.getGananciaNeta();
                            %>
                                    <tr>
                                        <td class="fw-bold py-3"><%= g.getNombreSucursal() %></td>
                                        <td>Q. <%= String.format("%,.2f", g.getIngresosBoletos()) %></td>
                                        <td>Q. <%= String.format("%,.2f", g.getIngresosAlquiler()) %></td>
                                        <td class="fw-bold text-primary">Q. <%= String.format("%,.2f", g.getTotalIngresos()) %></td>
                                        <td class="small text-muted">
                                            Comb: Q.<%= String.format("%,.2f", g.getCostoCombustible()) %> <br>
                                            Tall: Q.<%= String.format("%,.2f", g.getCostoTaller()) %> <br>
                                            Depr: Q.<%= String.format("%,.2f", g.getCostoDepreciacion()) %> <br>
                                            Chof: Q.<%= String.format("%,.2f", g.getPagoChoferes()) %>
                                        </td>
                                        <td class="fw-bold text-danger">Q. <%= String.format("%,.2f", g.getTotalCostos()) %></td>
                                        <td class="fw-bold fs-5 text-success">Q. <%= String.format("%,.2f", g.getGananciaNeta()) %></td>
                                    </tr>
                            <%  } } else { %>
                                <tr><td colspan="7" class="text-muted py-5">No hay registros financieros para los filtros aplicados.</td></tr>
                            <% } %>
                        </tbody>
                        <% if (lista != null && !lista.isEmpty()) { %>
                        <tfoot class="bg-light fw-bold fs-5">
                            <tr>
                                <td colspan="3" class="text-end py-3">GRAN TOTAL SISTEMA:</td>
                                <td class="text-primary py-3">Q. <%= String.format("%,.2f", sumaIngresos) %></td>
                                <td></td>
                                <td class="text-danger py-3">Q. <%= String.format("%,.2f", sumaCostos) %></td>
                                <td class="text-success py-3">Q. <%= String.format("%,.2f", sumaGanancias) %></td>
                            </tr>
                        </tfoot>
                        <% } %>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>