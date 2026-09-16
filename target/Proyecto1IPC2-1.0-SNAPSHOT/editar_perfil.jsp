<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Perfil - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-8"> 
                
                <% if ("exito".equals(msg)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm text-center">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>¡Perfil Actualizado!</strong> Tus datos se guardaron correctamente.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card border-0 shadow-sm p-4" style="border-radius: 15px;">
                    <h3 class="fw-bold text-center mb-4" style="color: #0A3323;">
                        <i class="bi bi-person-lines-fill me-2" style="color: #006A4E;"></i>Mis Datos Personales
                    </h3>

                    <form action="EditarPerfilServlet" method="POST">
                        
                        <div class="row mb-3">
                            <div class="col-md-7">
                                <label class="form-label fw-bold text-muted">Nombre Completo</label>
                                <input type="text" class="form-control" name="nombre" value="<%= usuario.getNombre() != null ? usuario.getNombre() : "" %>" required>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label fw-bold text-muted">DPI</label>
                                <input type="text" class="form-control" name="dpi" value="<%= usuario.getDpi() != null ? usuario.getDpi() : "" %>">
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-muted">NIT</label>
                                <input type="text" class="form-control" name="nit" value="<%= usuario.getNit() != null ? usuario.getNit() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold text-muted">Teléfono</label>
                                <input type="text" class="form-control" name="telefono" value="<%= usuario.getTelefono() != null ? usuario.getTelefono() : "" %>">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Dirección de Residencia</label>
                            <input type="text" class="form-control" name="direccion" value="<%= usuario.getDireccion() != null ? usuario.getDireccion() : "" %>">
                        </div>

                        <hr class="my-4">

                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">
                                <i class="bi bi-shield-lock me-1"></i>Cambiar Contraseña
                            </label>
                            <input type="password" class="form-control" name="contrasena" placeholder="Déjalo en blanco para mantener tu clave actual">
                            <div class="form-text">Si no deseas cambiarla, no escribas nada aquí.</div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-3 fs-5" style="background-color: #006A4E; border: none;">
                            <i class="bi bi-save me-2"></i> Guardar Cambios
                        </button>
                    </form>
                </div>
                
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>