<%@page import="modelos.enums.Rol"%>
<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null || usuario.getRol() != Rol.ADMIN_SIS) {
        response.sendRedirect("login.jsp");
        return; 
    }

    Double montoActual = (Double) request.getAttribute("montoDepreciacion");
    if (montoActual == null) montoActual = 0.0;
    
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Configuración Global - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                
                <% if ("exito".equals(msg)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm text-center">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>¡Configuración Actualizada!</strong> El costo de depreciación ha sido modificado.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card border-0 shadow-sm p-4" style="border-radius: 15px;">
                    <h3 class="fw-bold text-center mb-4" style="color: #0A3323;">
                        <i class="bi bi-gear-fill me-2" style="color: #006A4E;"></i>Parámetros del Sistema
                    </h3>
                    
                    <div class="alert alert-info border-0 bg-opacity-10 mb-4">
                        <i class="bi bi-info-circle-fill me-2"></i>
                        Este valor determina el costo operativo que se calculará automáticamente al finalizar cada viaje. 
                        <strong>Los viajes ya finalizados no se verán afectados.</strong>
                    </div>

                    <form action="ConfiguracionAdminServlet" method="POST">
                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">Depreciación de Bus por Kilómetro (Q.)</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-white text-success fw-bold border-end-0">Q.</span>
                                <input type="number" class="form-control border-start-0" name="montoDepreciacion" 
                                       step="0.01" min="0" value="<%= String.format("%.2f", montoActual) %>" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-3 fs-5" style="background-color: #006A4E; border: none;">
                            <i class="bi bi-save me-2"></i> Guardar Configuración
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>