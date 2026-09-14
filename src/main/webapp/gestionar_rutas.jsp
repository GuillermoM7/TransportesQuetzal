<%@page import="java.util.List"%>
<%@page import="modelos.Ruta"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null || usuarioSesion.getRol() == Rol.ADMIN_SIS) {
        response.sendRedirect("login.jsp?error=Acceso denegado");
        return; 
    }
    List<Ruta> listaRutas = (List<Ruta>) request.getAttribute("listaRutas");
    List<Sucursal> listaSucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Rutas - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">

        <% if ("EnUso".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <strong><i class="bi bi-exclamation-triangle-fill me-2"></i>No se puede eliminar la ruta.</strong> 
                Esta ruta ya tiene viajes históricos registrados. Por seguridad, solo puedes desactivarla.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Mis Rutas de Salida</h3>
            <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevaRuta">
                <i class="bi bi-signpost-split-fill me-1"></i> Crear Nueva Ruta
            </button>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">ID Ruta</th>
                            <th class="py-3">Destino</th>
                            <th class="py-3">Direccion Destino</th>
                            <th class="py-3">Distancia</th>
                            <th class="py-3">Tarifa (Q)</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaRutas != null && !listaRutas.isEmpty()) {
                            for (Ruta r : listaRutas) { %>
                                <tr>
                                    <td class="fw-bold py-3">RT-<%= r.getIdRuta() %></td>
                                    <td class="py-3 text-primary fw-bold">
                                        <i class="bi bi-geo-alt-fill me-1"></i> <%= r.getNombreDestino() %>
                                        <br>
                                        <small class="text-muted fw-normal"><i class="bi bi-signpost me-1"></i><%= r.getDireccionDestino() %></small>
                                    </td>
                                    <td class="fw-bold py-3">RT-<%= r.getIdRuta() %></td>
                                    <td class="py-3"><%= r.getDistanciaKm() %> km</td>
                                    <td class="py-3 text-success fw-bold">Q. <%= String.format("%.2f", r.getPrecioBoleto()) %></td>
                                    <td class="py-3">
                                        <% if("activo".equalsIgnoreCase(r.getEstado())) { %>
                                            <span class="badge bg-success">ACTIVA</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">INACTIVA</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3">
                                        <!-- Cambiar estado -->
                                        <form action="RutaServlet" method="POST" class="m-0 d-inline">
                                            <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="idRuta" value="<%= r.getIdRuta() %>">
                                            <input type="hidden" name="nuevoEstado" value="<%= "activo".equalsIgnoreCase(r.getEstado()) ? "inactivo" : "activo" %>">
                                            <button type="submit" class="btn btn-sm <%= "activo".equalsIgnoreCase(r.getEstado()) ? "btn-outline-warning" : "btn-outline-success" %> me-1" title="Alternar Estado">
                                                <i class="bi bi-arrow-repeat"></i>
                                            </button>
                                        </form>
                                        <!-- Eluminar -->
                                        <form action="RutaServlet" method="POST" class="m-0 d-inline" onsubmit="return confirm('¿Estás seguro de eliminar esta ruta físicamente?');">
                                            <input type="hidden" name="accion" value="eliminar">
                                            <input type="hidden" name="idRuta" value="<%= r.getIdRuta() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar Definitivamente">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr><td colspan="6" class="text-muted py-5">No has configurado ninguna ruta de salida desde tu sucursal.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Ruta nueva -->
    <div class="modal fade" id="modalNuevaRuta" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold">Aperturar Nueva Ruta</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="RutaServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold text-muted">Sucursal de Destino</label>
                            <select class="form-select border-primary bg-light" name="idDestino" required>
                                <option value="" disabled selected>Seleccione la sucursal destino</option>
                                <% if (listaSucursales != null) {
                                    for (Sucursal s : listaSucursales) { 
                                        if (s.getIdSucursal() != usuarioSesion.getIdSucursalAsignada()) { %>
                                            <option value="<%= s.getIdSucursal() %>"><%= s.getNombre() %> - <%=s.getDireccion()%></option>
                                <%      }
                                    } 
                                } %>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-bold text-muted">Distancia Estimada (Km)</label>
                            <input type="number" step="0.01" class="form-control bg-light" name="distancia" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-bold text-muted">Precio del Boleto (Q)</label>
                            <input type="number" step="0.01" class="form-control bg-light" name="precio" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="submit" class="btn text-white fw-bold px-4 w-100" style="background-color: #006A4E;">Confirmar Ruta</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>