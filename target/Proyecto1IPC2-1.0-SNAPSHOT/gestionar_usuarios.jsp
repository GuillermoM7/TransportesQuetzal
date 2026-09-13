<%@page import="java.util.List"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.enums.Rol"%>
<%@page import="modelos.enums.Estado"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null || usuarioSesion.getRol() != Rol.ADMIN_SIS) {
        response.sendRedirect("login.jsp?error=Acceso denegado");
        return; 
    }    
    List<Usuario> listaUsuarios = (List<Usuario>) request.getAttribute("listaUsuarios");
    List<Sucursal> listaSucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Usuarios - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">

    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Control de Usuarios y Administradores</h3>
            <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevoAdmin">
                <i class="bi bi-person-plus-fill me-1"></i> + Nuevo Admin. de Sucursal
            </button>
        </div>
        
        <!-- Tabla 1-->
        <h5 class="fw-bold mb-3" style="color: #0A3323;">
            <i class="bi bi-person-badge me-2"></i>Administradores de Sucursal
        </h5>
        <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">DPI</th>
                            <th class="py-3">Nombre</th>
                            <th class="py-3">ID Sucursal</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Activar/Inactivar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            boolean hayAdmins = false;
                            if (listaUsuarios != null) {
                                for (Usuario u : listaUsuarios) { 
                                    if (u.getRol() != Rol.CLIENTE) {
                                        hayAdmins = true;
                        %>
                                    <tr>
                                        <td class="fw-bold py-3"><%= u.getDpi() %></td>
                                        <td class="py-3"><%= u.getNombre() %></td>
                                        <td class="py-3"><span class="badge bg-warning text-dark">Sucursal <%= u.getIdSucursalAsignada() %></span></td>
                                        <td class="py-3">
                                            <% if(u.getEstado() == Estado.ACTIVO) { %>
                                                <span class="badge bg-success">ACTIVO</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">INACTIVO</span>
                                            <% } %>
                                        </td>
                                        <td class="py-3">
                                            <form action="UsuarioServlet" method="POST" class="m-0 d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstado">
                                                <input type="hidden" name="idUsuario" value="<%= u.getIdUsuario() %>">
                                                
                                                <% if(u.getEstado() == Estado.ACTIVO) { %>
                                                    <input type="hidden" name="nuevoEstado" value="INACTIVO">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Desactivar Admin"><i class="bi bi-person-x-fill"></i></button>
                                                <% } else { %>
                                                    <input type="hidden" name="nuevoEstado" value="ACTIVO">
                                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Activar Admin"><i class="bi bi-person-check-fill"></i></button>
                                                <% } %>
                                            </form>
                                        </td>
                                    </tr>
                        <%          }
                                }
                            }
                            if (!hayAdmins) { 
                        %>
                                <tr><td colspan="5" class="text-muted py-4">No hay administradores registrados.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Tabla 2 -->
        <h5 class="fw-bold mb-3 text-primary">
            <i class="bi bi-people me-2"></i>Clientes Registrados
        </h5>
        <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #005580;">
                        <tr>
                            <th class="py-3">DPI</th>
                            <th class="py-3">Nombre</th>
                            <th class="py-3">Teléfono</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Activar/Desactivar</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            boolean hayClientes = false;
                            if (listaUsuarios != null) {
                                for (Usuario u : listaUsuarios) { 
                                    if (u.getRol() == Rol.CLIENTE) {
                                        hayClientes = true;
                        %>
                                    <tr>
                                        <td class="fw-bold py-3"><%= u.getDpi() %></td>
                                        <td class="py-3"><%= u.getNombre() %></td>
                                        <td class="py-3"><%= u.getTelefono() %></td>
                                        <td class="py-3">
                                            <% if(u.getEstado() == Estado.ACTIVO) { %>
                                                <span class="badge bg-success">ACTIVO</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">DESACTIVADO</span>
                                            <% } %>
                                        </td>
                                        <td class="py-3">
                                            <form action="UsuarioServlet" method="POST" class="m-0 d-inline">
                                                <input type="hidden" name="accion" value="cambiarEstado">
                                                <input type="hidden" name="idUsuario" value="<%= u.getIdUsuario() %>">
                                                
                                                <% if(u.getEstado() == Estado.ACTIVO) { %>
                                                    <input type="hidden" name="nuevoEstado" value="INACTIVO">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Bloquear Cliente"><i class="bi bi-slash-circle"></i></button>
                                                <% } else { %>
                                                    <input type="hidden" name="nuevoEstado" value="ACTIVO">
                                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Desbloquear Cliente"><i class="bi bi-check-circle"></i></button>
                                                <% } %>
                                            </form>
                                        </td>
                                    </tr>
                        <%          }
                                }
                            }
                            if (!hayClientes) { 
                        %>
                                <tr><td colspan="5" class="text-muted py-4">No hay clientes registrados en el sistema.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Formulario para añadir nuevo admin. id:modalNuevoAdmin -->
    <div class="modal fade" id="modalNuevoAdmin" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-person-badge me-2"></i>Registrar Administrador de Sucursal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                
                <form action="UsuarioServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">DPI</label>
                            <input type="text" class="form-control bg-light" name="dpi" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">NIT</label>
                            <input type="text" class="form-control bg-light" name="nit" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Nombre Completo</label>
                            <input type="text" class="form-control bg-light" name="nombre" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Teléfono</label>
                            <input type="text" class="form-control bg-light" name="telefono" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Contraseña Provisional</label>
                            <input type="password" class="form-control bg-light" name="password" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Dirección</label>
                            <input type="text" class="form-control bg-light" name="direccion" required>
                        </div>
                        
                        <div class="col-md-12 mt-4">
                            <label class="form-label fw-bold text-primary">Asignar a Sucursal</label>
                            <select class="form-select border-primary" name="idSucursal" required>
                                <option value="" disabled selected>Seleccione una sucursal...</option>
                                <% if (listaSucursales != null) {
                                    for (Sucursal s : listaSucursales) { %>
                                        <option value="<%= s.getIdSucursal() %>"><%= s.getNombre() %> - <%= s.getDireccion() %></option>
                                <%  } 
                                } %>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #006A4E;">Guardar Administrador</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>