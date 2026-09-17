<%@page import="java.util.List"%>
<%@page import="dtos.IngresosBoletosDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<IngresosBoletosDTO> lista = (List<IngresosBoletosDTO>) request.getAttribute("listaIngresosBoletos");
    String fInicio = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "";
    String fFin = request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "";
    double granTotal = 0;
    int totalBoletos = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ingresos por Boletos - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container mt-5 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-ticket-perforated me-2 text-warning"></i> Ingresos por Venta de Boletos</h3>
            </div>
            <div class="col-md-6">
                <form action="ReportesSucursalServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="ingresos_boletos">
                    <input type="date" name="fechaInicio" class="form-control border-0 me-2" value="<%= fInicio %>" required title="Fecha de inicio">
                    <input type="date" name="fechaFin" class="form-control border-0 me-2" value="<%= fFin %>" required title="Fecha fin">
                    <button type="submit" class="btn btn-primary fw-bold px-4">Filtrar</button>
                    <a href="ReportesSucursalServlet?tipo=ingresos_boletos" class="btn btn-outline-secondary ms-2" title="Limpiar Filtros"><i class="bi bi-arrow-clockwise"></i></a>
                </form>
            </div>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Fecha de Salida</th>
                            <th>Ruta (Origen - Destino)</th>
                            <th>Bus Asignado</th>
                            <th>Boletos Vendidos</th>
                            <th>Ingreso Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            for (IngresosBoletosDTO b : lista) { 
                                granTotal += b.getIngresoTotal();
                                totalBoletos += b.getCantidadBoletosVendidos();
                        %>
                                <tr>
                                    <td class="py-3"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(b.getFechaHoraSalida()) %></td>
                                    <td class="fw-bold"><%= b.getOrigen() %> <i class="bi bi-arrow-right mx-1"></i> <%= b.getDestino() %></td>
                                    <td><%= b.getPlacaBus() %></td>
                                    <td><span class="badge bg-primary fs-6"><%= b.getCantidadBoletosVendidos() %></span></td>
                                    <td class="fw-bold text-success">Q. <%= String.format("%,.2f", b.getIngresoTotal()) %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="5" class="text-muted py-5">No hay ventas registradas en las fechas seleccionadas.</td></tr>
                        <% } %>
                    </tbody>
                    <% if (lista != null && !lista.isEmpty()) { %>
                    <tfoot class="bg-light fw-bold fs-5">
                        <tr>
                            <td colspan="3" class="text-end py-3">GRAN TOTAL:</td>
                            <td class="text-primary py-3"><%= totalBoletos %> boletos</td>
                            <td class="text-success py-3">Q. <%= String.format("%,.2f", granTotal) %></td>
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