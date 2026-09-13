<%@page import="java.util.List"%>
<%@page import="modelos.Chofer"%>
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
    
    List<Chofer> listaChoferes = (List<Chofer>) request.getAttribute("listaChoferes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Choferes - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Control de Choferes</h3>
            <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevoChofer">
                <i class="bi bi-person-plus-fill me-1"></i> Registrar Chofer
            </button>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">Nombre</th>
                            <th class="py-3">Teléfono</th>
                            <th class="py-3">Licencia</th>
                            <th class="py-3">Vencimiento</th>
                            <th class="py-3">Salario Base</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (listaChoferes != null && !listaChoferes.isEmpty()) {
                                for (Chofer c : listaChoferes) { 
                        %>
                                <tr>
                                    <td class="fw-bold py-3"><%= c.getNombre() %></td>
                                    <td class="py-3"><%= c.getTelefono() %></td>
                                    <td class="py-3">
                                        <span class="badge bg-secondary me-1">Tipo <%= c.getTipoLicencia() %></span>
                                        <%= c.getLicencia() %>
                                    </td>
                                    <td class="py-3"><%= c.getFechaVencimiento() %></td>
                                    <td class="py-3 text-success fw-bold">Q. <%= String.format("%.2f", c.getSalarioBase()) %></td>
                                    <td class="py-3">
                                        <% if(c.getEstado() == Estado.ACTIVO) { %>
                                            <span class="badge bg-success">ACTIVO</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">INACTIVO</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3">
                                        <form action="ChoferServlet" method="POST" class="m-0 d-inline">
                                            <input type="hidden" name="accion" value="cambiarEstado">
                                            <input type="hidden" name="idChofer" value="<%= c.getIdChofer() %>">
                                            
                                            <% if(c.getEstado() == Estado.ACTIVO) { %>
                                                <input type="hidden" name="nuevoEstado" value="INACTIVO">
                                                <button type="submit" class="btn btn-sm btn-outline-danger" title="Despedir/Suspender"><i class="bi bi-person-x-fill"></i></button>
                                            <% } else { %>
                                                <input type="hidden" name="nuevoEstado" value="ACTIVO">
                                                <button type="submit" class="btn btn-sm btn-outline-success" title="Recontratar"><i class="bi bi-person-check-fill"></i></button>
                                            <% } %>
                                        </form>
                                    </td>
                                </tr>
                        <%      }
                            } else { 
                        %>
                                <tr>
                                    <td colspan="7" class="text-muted py-5">No hay choferes registrados en su sucursal.</td>
                                </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Formulario -->
    <div class="modal fade" id="modalNuevoChofer" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-vcard me-2"></i>Registrar Nuevo Chofer</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                
                <form action="ChoferServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Nombre Completo</label>
                            <input type="text" class="form-control bg-light" name="nombre" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Número de Licencia</label>
                            <input type="text" class="form-control bg-light" name="licencia" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Tipo de Licencia</label>
                            <select class="form-select bg-light" name="tipoLicencia" required>
                                <option value="" disabled selected>Seleccione tipo...</option>
                                <option value="A">Tipo A (Buses y Pesado)</option>
                                <option value="B">Tipo B (Ligero y Microbuses)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Fecha de Vencimiento</label>
                            <input type="date" class="form-control bg-light" name="fechaVencimiento" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Teléfono de Contacto</label>
                            <input type="text" class="form-control bg-light" name="telefono" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Salario Base (Q)</label>
                            <input type="number" step="0.01" class="form-control bg-light" name="salarioBase" placeholder="Ej. 3500.00" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">URL de Fotografía (Opcional)</label>
                            <input type="text" class="form-control bg-light" name="fotoUrl" placeholder="http://...">
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #006A4E;">Guardar Chofer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>