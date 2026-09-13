<%@page import="modelos.Usuario"%>
<%
    Usuario navUsuario = (Usuario) session.getAttribute("usuarioLogueado");
%>
<nav class="navbar shadow-sm py-3" style="background-color: #0A3323;">
    <div class="container-fluid px-4">
        
        <!-- Lado izquierdo -->
        <div class="d-flex align-items-center">
            <span class="fs-4 fw-bold me-3" style="color: #F5B041;">
                <i class="bi bi-bus-front-fill me-2"></i>T. Quetzal
            </span>
            <a href="panel_principal.jsp" class="btn btn-outline-light rounded-circle d-flex align-items-center justify-content-center" style="width: 40px; height: 40px;" title="Volver al Menú Principal">
                <i class="bi bi-house-door-fill fs-5"></i>
            </a>
        </div>
        
        <!-- Lado derecho -->
        <div class="d-flex align-items-center">
            <span class="text-white me-4 fw-bold">
                <i class="bi bi-person-circle me-1"></i> <%= navUsuario != null ? navUsuario.getNombre() : "Usuario" %>
            </span>
            <a href="CerrarSesionServlet" class="btn rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 40px; height: 40px; background-color: #C1121F; color: white;" title="Cerrar Sesión">
                <i class="bi bi-power fs-5"></i>
            </a>
        </div>
        
    </div>
</nav>