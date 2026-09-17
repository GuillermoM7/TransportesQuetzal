<%@page import="java.util.List"%>
<%@page import="dtos.ChoferReporteDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<ChoferReporteDTO> lista = (List<ChoferReporteDTO>) request.getAttribute("listaChoferes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte de Choferes - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    <div class="container mt-5 mb-5">
        <div class="mb-4">
            <h3 class="fw-bold" style="color: #333;"><i class="bi bi-person-vcard me-2 text-success"></i> Listado General de Choferes</h3>
            <p class="text-muted mb-0">Rendimiento y estado de licencias del personal asignado a la sucursal.</p>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Licencia</th>
                            <th>Nombre Completo</th>
                            <th>Tipo</th>
                            <th>Vencimiento</th>
                            <th>Estado</th>
                            <th>Viajes Finalizados</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (lista != null && !lista.isEmpty()) { 
                            for (ChoferReporteDTO c : lista) { %>
                                <tr>
                                    <td class="fw-bold py-3"><%= c.getLicencia() %></td>
                                    <td><%= c.getNombreCompleto() %></td>
                                    <td><span class="badge bg-secondary"><%= c.getTipoLicencia() %></span></td>
                                    <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(c.getFechaVencimiento()) %></td>
                                    <td>
                                        <% if ("activo".equalsIgnoreCase(c.getEstado())) { %>
                                            <span class="badge bg-success">ACTIVO</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">INACTIVO</span>
                                        <% } %>
                                    </td>
                                    <td class="fw-bold fs-5 text-primary"><%= c.getTotalViajesRealizados() %></td>
                                </tr>
                        <%  } } else { %>
                            <tr><td colspan="6" class="text-muted py-5">No se encontraron choferes registrados en esta sucursal.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>