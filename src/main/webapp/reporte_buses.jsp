<%@page import="java.util.List"%>
<%@page import="dtos.BusReporteDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<BusReporteDTO> lista = (List<BusReporteDTO>) request.getAttribute("listaBuses");
    String filtroActual = (String) request.getAttribute("filtroActual");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Flota - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold" style="color: #333;">
                    <i class="bi bi-file-earmark-bar-graph me-2 text-primary"></i>
                    Listado General de Buses
                </h3>
                <p class="text-muted mb-0">Visión global del estado operativo y asignaciones de la flota.</p>
            </div>
            
            <form action="ReportesSucursalServlet" method="GET" class="d-flex shadow-sm rounded">
                <input type="hidden" name="tipo" value="buses">
                <select name="estado" class="form-select border-0 bg-white" style="border-radius: 8px 0 0 8px; cursor: pointer;">
                    <option value="Todos" <%= "Todos".equals(filtroActual) ? "selected" : "" %>>Todos los estados</option>
                    <option value="activo" <%= "activo".equals(filtroActual) ? "selected" : "" %>>Solo Activos</option>
                    <option value="inactivo" <%= "inactivo".equals(filtroActual) ? "selected" : "" %>>Solo Inactivos/Taller</option>
                </select>
                <button type="submit" class="btn btn-primary fw-bold" style="border-radius: 0 8px 8px 0;">Filtrar</button>
            </form>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 text-center align-middle">
                        <thead class="text-white" style="background-color: #0A3323;">
                            <tr>
                                <th class="py-3">Placa</th>
                                <th>Marca / Modelo</th>
                                <th>Capacidad</th>
                                <th>Estado</th>
                                <th>Chofer en Curso</th>
                                <th>Km Actual</th>
                                <th>Viajes Finalizados</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (lista != null && !lista.isEmpty()) { 
                                for (BusReporteDTO b : lista) { %>
                                    <tr>
                                        <td class="fw-bold py-3"><%= b.getPlaca() %></td>
                                        <td><%= b.getMarca() %> <%= b.getModelo() %></td>
                                        <td><span class="badge bg-info text-dark"><%= b.getCapacidad() %> pax</span></td>
                                        <td>
                                            <% if ("activo".equalsIgnoreCase(b.getEstadoOperativo())) { %>
                                                <span class="badge bg-success">ACTIVO</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">INACTIVO</span>
                                            <% } %>
                                        </td>
                                        <td class="text-muted fw-semibold">
                                            <%= "Ninguno asignado".equals(b.getChoferAsignadoActual()) ? 
                                                "<i>Disponible</i>" : "<i class='bi bi-person-fill text-primary me-1'></i>" + b.getChoferAsignadoActual() %>
                                        </td>
                                        <td><%= String.format("%,.2f", b.getKilometrajeActual()) %> km</td>
                                        <td class="fw-bold fs-5"><%= b.getTotalViajesRealizados() %></td>
                                    </tr>
                            <%  } 
                               } else { %>
                                <tr>
                                    <td colspan="7" class="text-muted py-5">
                                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                                        No se encontraron buses con los filtros aplicados.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <% if (lista != null && !lista.isEmpty()) { %>
            <div class="card-footer bg-white text-end py-3 text-muted small border-top-0">
                Total de unidades mostradas: <b><%= lista.size() %></b> | 
                Reporte generado el: <%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(new java.util.Date()) %>
            </div>
            <% } %>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>