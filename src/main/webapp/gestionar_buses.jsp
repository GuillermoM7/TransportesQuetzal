<%@page import="java.util.List"%>
<%@page import="modelos.Bus"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page import="modelos.enums.Estado"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null || (usuarioSesion.getRol() != Rol.ADMIN_SIS && usuarioSesion.getRol() != Rol.ADMIN_SUC)) {
        response.sendRedirect("login.jsp?error=Acceso denegado");
        return; 
    }
    
    List<Bus> listaBuses = (List<Bus>) request.getAttribute("listaBuses");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Flota - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Control de Flota de Buses</h3>
            <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevoBus">
                <i class="bi bi-bus-front me-1"></i> Registrar Nuevo Bus
            </button>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Placa</th>
                            <th class="py-3">Marca y Modelo</th>
                            <th class="py-3">Año</th>
                            <th class="py-3">Capacidad</th>
                            <th class="py-3">Kilometraje</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (listaBuses != null && !listaBuses.isEmpty()) {
                                for (Bus b : listaBuses) { 
                        %>
                                <tr>
                                    <td class="fw-bold py-3"><%= b.getPlaca() %></td>
                                    <td class="py-3"><%= b.getMarca() %> <%= b.getModelo() %></td>
                                    <td class="py-3"><%= b.getAnio() %></td>
                                    <td class="py-3"><span class="badge bg-info text-dark"><%= b.getCapacidad() %> pasajeros</span></td>
                                    <td class="py-3"><%= String.format("%.2f", b.getKilometraje()) %> km</td>
                                    <td class="py-3">
                                        <% if(b.getEstado() == Estado.ACTIVO) { %>
                                            <span class="badge bg-success">ACTIVO</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">INACTIVO</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3">
                                        <form action="BusServlet" method="POST" class="m-0 d-inline">
                                            <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="idBus" value="<%= b.getIdBus() %>">
                                            
                                            <% if(b.getEstado() == Estado.ACTIVO) { %>
                                                <input type="hidden" name="nuevoEstado" value="INACTIVO">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Dar de Baja"><i class="bi bi-x-circle-fill"></i></button>
                                            <% } else { %>
                                                <input type="hidden" name="nuevoEstado" value="ACTIVO">
                                                <button type="submit" class="btn btn-sm btn-outline-success" title="Reactivar"><i class="bi bi-check-circle-fill"></i></button>
                                            <% } %>
                                        </form>
                                    </td>
                                </tr>
                        <%      }
                            } else { 
                        %>
                                <tr>
                                    <td colspan="7" class="text-muted py-5">No hay buses registrados en su sucursal.</td>
                                </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Formulario -->
    <div class="modal fade" id="modalNuevoBus" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-bus-front me-2"></i>Registrar Unidad</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                
                <form action="BusServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Placa</label>
                            <input type="text" class="form-control bg-light" name="placa" placeholder="Ej. C123ABC" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Capacidad (Pasajeros)</label>
                            <input type="number" class="form-control bg-light" name="capacidad" min="10" max="80" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Marca</label>
                            <input type="text" class="form-control bg-light" name="marca" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Modelo</label>
                            <input type="text" class="form-control bg-light" name="modelo" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Año</label>
                            <input type="number" class="form-control bg-light" name="anio" min="1990" max="2027" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Kilometraje Actual</label>
                            <input type="number" step="0.01" class="form-control bg-light" name="kilometraje" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">URL de la Foto (Opcional)</label>
                            <input type="text" class="form-control bg-light" name="foto" placeholder="http://...">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #006A4E;">Guardar Bus</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>