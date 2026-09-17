<%@page import="java.util.List"%>
<%@page import="dtos.DepreciacionReporteDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<DepreciacionReporteDTO> lista = (List<DepreciacionReporteDTO>) request.getAttribute("listaDepreciacion");
    Double tasa = (Double) request.getAttribute("tasaDepreciacion");
    double granTotal = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte Depreciación - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container mt-5 mb-5">
        <div class="mb-4">
            <h3 class="fw-bold" style="color: #333;"><i class="bi bi-graph-down-arrow me-2 text-danger"></i> Reporte de Depreciación por Bus</h3>
            <p class="text-muted mb-0">Tasa actual aplicada: <b>Q. <%= String.format("%,.2f", tasa) %> por kilómetro.</b></p>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Placa del Bus</th>
                            <th>Kilómetros Recorridos (Histórico)</th>
                            <th>Costo Depreciación / Km</th>
                            <th>Total Depreciación Acumulada</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            for (DepreciacionReporteDTO d : lista) { 
                                granTotal += d.getDepreciacionAcumuladaTotal();
                        %>
                                <tr>
                                    <td class="fw-bold py-3 text-primary"><%= d.getPlacaBus() %></td>
                                    <td><%= String.format("%,.2f", d.getTotalKilometrosRecorridos()) %> km</td>
                                    <td>Q. <%= String.format("%,.2f", d.getDepreciacionPorKm()) %></td>
                                    <td class="fw-bold text-danger">Q. <%= String.format("%,.2f", d.getDepreciacionAcumuladaTotal()) %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="4" class="text-muted py-5">No hay datos de viajes finalizados para calcular depreciación.</td></tr>
                        <% } %>
                    </tbody>
                    <% if (lista != null && !lista.isEmpty()) { %>
                    <tfoot class="bg-light fw-bold fs-5">
                        <tr>
                            <td colspan="3" class="text-end py-3">GRAN TOTAL DEPRECIACIÓN DE FLOTA:</td>
                            <td class="text-danger py-3">Q. <%= String.format("%,.2f", granTotal) %></td>
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