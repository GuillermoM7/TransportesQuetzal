<%@page import="java.util.List"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || usuario.getRol() != Rol.ADMIN_SIS) {
        response.sendRedirect("login.jsp?error=Acceso denegado");
        return; 
    }    
    List<Sucursal> listaSucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Gestión de Sucursales - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Control de Sucursales</h3>
            <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevaSucursal">
                <i class="bi bi-plus-circle me-1"></i> Nueva Sucursal
            </button>
        </div>
        
        <!-- Tabla -->
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">ID</th>
                            <th class="py-3">Nombre de Sucursal</th>
                            <th class="py-3">Dirección Exacta</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (listaSucursales != null && !listaSucursales.isEmpty()) {
                                for (Sucursal s : listaSucursales) { 
                        %>
                                <tr>
                                    <td class="fw-bold py-3"><%= s.getIdSucursal() %></td>
                                    <td class="py-3"><%= s.getNombre() %></td>
                                    <td class="py-3"><%= s.getDireccion() %></td>
                                    <td class="py-3">
                                        <button class="btn btn-sm btn-outline-primary" title="Editar"><i class="bi bi-pencil-square"></i></button>
                                    </td>
                                </tr>
                        <%      }
                            } else { 
                        %>
                                <tr>
                                    <td colspan="4" class="text-muted py-5">No hay sucursales registradas en el sistema.</td>
                                </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Formularioo -->
    <div class="modal fade" id="modalNuevaSucursal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-building-add me-2"></i>Registrar Sucursal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                
                <form action="SucursalServlet" method="POST">
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Nombre de la Sucursal</label>
                            <input type="text" class="form-control bg-light" name="nombre" placeholder="Ej. Quetzaltenango Centro" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">Dirección</label>
                            <textarea class="form-control bg-light" name="direccion" rows="3" placeholder="Dirección exacta de la terminal..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #C1121F;">Guardar Sucursal</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>