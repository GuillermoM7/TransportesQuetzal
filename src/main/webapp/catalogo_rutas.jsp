<%@page import="java.util.List"%>
<%@page import="modelos.ViajeRegular"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    List<Sucursal> listaSucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
    List<ViajeRegular> listaViajes = (List<ViajeRegular>) request.getAttribute("listaViajes");
    
    Integer idFiltro = (Integer) request.getAttribute("sucursalSeleccionada");
    int idSucursalSeleccionada = (idFiltro != null) ? idFiltro : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo de Rutas - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
    <style>
        .filtro-card {
            background-color: #f8f9fa;
            border-left: 5px solid #006A4E;
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container-fluid mt-4 px-4 mb-5">
        
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <h2 class="fw-bold" style="color: #333;"><i class="bi bi-map-fill me-2" style="color: #006A4E;"></i>Explorar Rutas y Viajes</h2>
                <p class="text-muted">Encuentra tu próximo destino. Selecciona una sucursal para ver los viajes programados.</p>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-4">
                <!-- Filtro -->
                <div class="card border-0 shadow-sm filtro-card mb-4 p-3">
                    <form action="CatalogoViajesServlet" method="GET">
                        <label class="form-label fw-bold text-muted"><i class="bi bi-funnel-fill me-1"></i> Filtrar por Sucursal de Salida</label>
                        <div class="input-group">
                            <select class="form-select border-secondary" name="idSucursal" onchange="this.form.submit()">
                                <option value="0" <%= (idSucursalSeleccionada == 0) ? "selected" : "" %>>Mostrar Todas las Rutas</option>
                                <% if(listaSucursales != null) {
                                    for(Sucursal s : listaSucursales) { %>
                                        <option value="<%= s.getIdSucursal() %>" <%= (idSucursalSeleccionada == s.getIdSucursal()) ? "selected" : "" %>>
                                            <%= s.getNombre() %>
                                        </option>
                                <%  } } %>
                            </select>
                        </div>
                    </form>
                </div>

                <!-- Mapa -->
                <div class="card border-0 shadow-sm p-2">
                    <h6 class="fw-bold text-center text-muted mt-2 mb-3">Ubicación de nuestras Sucursales</h6>
                    <jsp:include page="componente_mapa.jsp" />
                </div>
            </div>

                
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                    <table class="table table-hover mb-0 align-middle text-center">
                        <thead class="text-white" style="background-color: #0A3323;">
                            <tr>
                                <th class="py-3">Ruta</th>
                                <th class="py-3">Salida</th>
                                <th class="py-3">Bus</th>
                                <th class="py-3">Disponibilidad</th>
                                <th class="py-3">Precio</th>
                                <th class="py-3">Acción</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (listaViajes != null && !listaViajes.isEmpty()) {
                                for (ViajeRegular v : listaViajes) { 
                                    String salida = v.getFechaHoraSalida().toString().substring(0, 16);
                            %>
                                    <tr>
                                        <td class="py-3 text-start px-4">
                                            <span class="fw-bold text-primary d-block"><%= v.getNombreRuta() %></span>
                                        </td>
                                        
                                        <td class="py-3">
                                            <i class="bi bi-calendar-event d-block text-muted"></i>
                                            <span class="fw-bold"><%= salida %></span>
                                        </td>
                                        
                                        <td class="py-3 text-muted"><i class="bi bi-bus-front-fill me-1"></i><%= v.getPlacaBus() %></td>
                                        
                                        <td class="py-3">
                                            <% if (v.getAsientosDisponibles() > 10) { %>
                                                <span class="badge bg-success"><%= v.getAsientosDisponibles() %> Libres</span>
                                            <% } else if (v.getAsientosDisponibles() > 0) { %>
                                                <span class="badge bg-warning text-dark">¡Solo <%= v.getAsientosDisponibles() %>!</span>
                                            <% } else { %>
                                                <span class="badge bg-danger">Agotado</span>
                                            <% } %>
                                        </td>
                                        
                                        <td class="py-3 fw-bold text-success fs-5">
                                            Q. <%= String.format("%.2f", v.getPrecio()) %>
                                        </td>
                                        
                                        <td class="py-3">
                                            <% if (v.getAsientosDisponibles() > 0) { %>
                                                <a href="ComprarBoletoServlet?idViaje=<%= v.getIdViajeReg() %>" class="btn btn-sm text-white fw-bold px-3" style="background-color: #006A4E;">
                                                    <i class="bi bi-ticket-perforated-fill me-1"></i> Comprar
                                                </a>
                                            <% } else { %>
                                                <button class="btn btn-sm btn-secondary fw-bold px-3" disabled>Agotado</button>
                                            <% } %>
                                        </td>
                                    </tr>
                            <%  }
                            } else { %>
                                <tr>
                                    <td colspan="6" class="py-5 text-muted">
                                        <i class="bi bi-emoji-frown fs-2 d-block mb-2"></i>
                                        No hay viajes programados para esta selección.
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>