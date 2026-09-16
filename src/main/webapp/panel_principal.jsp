<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp?error=Debe iniciar sesion primero");
        return; 
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Control - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
    <style>
        .sidebar {
            min-height: 100vh;
            background-color: #0A3323; 
        }
        .nav-link {
            color: #e0e0e0;
            border-radius: 5px;
            margin-bottom: 5px;
            transition: 0.3s;
        }
        .nav-link:hover {
            background-color: #006A4E;
            color: #F5B041;
        }
        .seccion-titulo {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #8da099;
            margin-top: 15px;
            margin-bottom: 5px;
            padding-left: 15px;
        }
    </style>
</head>
<body class="bg-light">

<div class="d-flex">
    <div class="sidebar p-3 d-flex flex-column" style="width: 280px;">
        <a href="panel_principal.jsp" class="d-flex align-items-center mb-4 text-decoration-none" style="color: #F5B041;">
            <i class="bi bi-bus-front-fill fs-3 me-2"></i>
            <span class="fs-4 fw-bold">T. Quetzal</span>
        </a>
        
        <!-- Opciones -->
        <ul class="nav flex-column mb-auto">
            <li class="seccion-titulo">Servicios</li>
            <li><a href="CatalogoViajesServlet" class="nav-link"><i class="bi bi-ticket-perforated me-2"></i> Comprar Boletos</a></li>
            <li><a href="MisViajesServlet" class="nav-link"><i class="bi bi-car-front me-2"></i> Alquiler Privado</a></li>
            
            <% if (usuario.getRol() == Rol.ADMIN_SUC || usuario.getRol() == Rol.ADMIN_SIS) { %>
                <li class="seccion-titulo mt-3">Gestión de Sucursal</li>
                <li><a href="BusServlet" class="nav-link"><i class="bi bi-tools me-2"></i> Buses y Mantenimiento</a></li>
                <li><a href="ChoferServlet" class="nav-link"><i class="bi bi-person-badge me-2"></i> Choferes</a></li>
                <li><a href="ViajeRegularServlet" class="nav-link"><i class="bi bi-calendar-event me-2"></i> Control de viajes regulares</a></li>
                <li><a href="ViajePrivadoServlet" class="nav-link"><i class="bi bi-calendar-event me-2"></i> Control de viajes privados</a></li>
                <% if (usuario.getRol() == Rol.ADMIN_SUC) { %>
                <li><a href="RutaServlet" class="nav-link"><i class="bi bi-map me-2"></i> Rutas y Viajes</a></li>
                <li><a href="#" class="nav-link"><i class="bi bi-file-earmark-bar-graph me-2"></i> Reportes Locales</a></li>
                <% } %>
            <% } %>

            <% if (usuario.getRol() == Rol.ADMIN_SIS) { %>
                <li class="seccion-titulo mt-3" style="color: #e06666;">Admin Global</li>
                <li><a href="SucursalServlet" class="nav-link"><i class="bi bi-building me-2"></i> Sucursales</a></li>
                <li><a href="UsuarioServlet" class="nav-link"><i class="bi bi-people me-2"></i> Usuarios</a></li>
                <li><a href="#" class="nav-link"><i class="bi bi-gear me-2"></i> Configuración</a></li>
                <li><a href="#" class="nav-link"><i class="bi bi-graph-up-arrow me-2"></i> Reportes Globales</a></li>
            <% } %>
        </ul>
    </div>


    <div class="flex-grow-1">       
        <!-- Barra superior -->
        <nav class="navbar navbar-expand-lg bg-white shadow-sm px-4 py-3 mb-4">
            <div class="container-fluid">
                <span class="navbar-brand mb-0 h4 text-muted">Tablero Principal</span>
                
                <div class="d-flex align-items-center">
                    <div class="me-4 text-end">
                        <small class="text-muted d-block" style="line-height: 1;">Mi Billetera</small>
                        <span class="fw-bold fs-5" style="color: #006A4E;">Q. <%= String.format("%.2f", usuario.getSaldoCartera()) %></span>
                    </div>
                    
                    <!-- opciones personales --> 
                    <div class="dropdown">
                        <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle fs-3 me-2" style="color: #F5B041;"></i>
                            <strong><%= usuario.getNombre() %></strong> 
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow">
                            <li><a class="dropdown-item" href="#">Mi Perfil</a></li>
                            <li><a class="dropdown-item" href="#">Recargar Saldo</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger fw-bold" href="CerrarSesionServlet">Cerrar Sesión</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </nav>
                       

        <!-- Espacio en blanco -->
        <div class="container-fluid px-4">
            <h3 class="fw-bold mb-4">Bienvenido, <%= usuario.getNombre() %></h3>
            
            <div class="card border-0 shadow-sm" style="border-radius: 10px;">
                <div class="card-body p-5 text-center text-muted">
                    <i class="bi bi-layout-text-window-reverse display-1 mb-3 opacity-50"></i>
                    <h5>Selecciona una opción del menú lateral para comenzar.</h5>
                </div>
            </div>
        </div>
        
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>