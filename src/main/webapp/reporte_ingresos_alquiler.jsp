<%@page import="java.util.List"%>
<%@page import="dtos.IngresoAlquilerDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<IngresoAlquilerDTO> lista = (List<IngresoAlquilerDTO>) request.getAttribute("listaAlquileres");
    String fInicio = request.getParameter("fechaInicio") != null ? request.getParameter("fechaInicio") : "";
    String fFin = request.getParameter("fechaFin") != null ? request.getParameter("fechaFin") : "";
    double granTotal = 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ingresos por Alquiler - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container mt-5 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-6">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-cash-stack me-2 text-primary"></i> Ingresos por Viajes Privados</h3>
            </div>
            <div class="col-md-6">
                <form action="ReportesSucursalServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="ingresos_alquiler">
                    <input type="date" name="fechaInicio" class="form-control border-0 me-2" value="<%= fInicio %>" required>
                    <input type="date" name="fechaFin" class="form-control border-0 me-2" value="<%= fFin %>" required>
                    <button type="submit" class="btn btn-primary fw-bold px-4">Filtrar</button>
                    <a href="ReportesSucursalServlet?tipo=ingresos_alquiler" class="btn btn-outline-secondary ms-2" title="Limpiar"><i class="bi bi-arrow-clockwise"></i></a>
                </form>
            </div>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Fecha de Salida</th>
                            <th>Cliente</th>
                            <th>Origen - Destino</th>
                            <th>Bus Asignado</th>
                            <th>Precio Cobrado</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            for (IngresoAlquilerDTO a : lista) { 
                                granTotal += a.getPrecioTotal();
                        %>
                                <tr>
                                    <td class="py-3"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(a.getFechaHoraSalida()) %></td>
                                    <td><i class="bi bi-person me-1"></i> <%= a.getNombreCliente() %></td>
                                    <td class="fw-bold text-muted"><%= a.getOrigen() %> <i class="bi bi-arrow-right mx-1"></i> <%= a.getDestino() %></td>
                                    <td><%= a.getPlacaBus() %></td>
                                    <td class="fw-bold text-success">Q. <%= String.format("%,.2f", a.getPrecioTotal()) %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="5" class="text-muted py-5">No hay alquileres registrados en estas fechas.</td></tr>
                        <% } %>
                    </tbody>
                    <% if (lista != null && !lista.isEmpty()) { %>
                    <tfoot class="bg-light fw-bold fs-5">
                        <tr>
                            <td colspan="4" class="text-end py-3">GRAN TOTAL ALQUILERES:</td>
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