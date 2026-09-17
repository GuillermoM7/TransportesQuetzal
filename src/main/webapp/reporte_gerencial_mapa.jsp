<%@page import="java.util.List"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Ruta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Sucursal> sucursalesMapa = (List<Sucursal>) request.getAttribute("listaSucursales");
    List<Ruta> rutasMapa = (List<Ruta>) request.getAttribute("listaRutasMapa");
    Integer idFiltro = (Integer) request.getAttribute("sucursalSeleccionada");
    int idSucursalSeleccionada = (idFiltro != null) ? idFiltro : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mapa de Rutas - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <style>
        #mapa_sucursales { width: 100%; height: 600px; border-radius: 12px; z-index: 1; border: 1px solid #dee2e6; }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />
    
    <div class="container-fluid px-5 mt-4 mb-5">
        <div class="row align-items-center mb-4">
            <div class="col-md-7">
                <h3 class="fw-bold" style="color: #333;"><i class="bi bi-geo-alt-fill me-2 text-info"></i> Mapa de Operaciones y Rutas</h3>
                <p class="text-muted mb-0">Visualización geográfica de la red de conexiones.</p>
            </div>
            <div class="col-md-5">
                <form action="ReportesAdminServlet" method="GET" class="d-flex shadow-sm rounded bg-white p-2">
                    <input type="hidden" name="tipo" value="mapa_rutas">
                    <select name="idSucursal" class="form-select border-0 me-2" onchange="this.form.submit()">
                        <option value="Todas" <%= (idSucursalSeleccionada == 0) ? "selected" : "" %>>Mostrar Red Completa (Todas las rutas)</option>
                        <% if(sucursalesMapa != null) {
                            for(Sucursal s : sucursalesMapa) { %>
                                <option value="<%= s.getIdSucursal() %>" <%= (idSucursalSeleccionada == s.getIdSucursal()) ? "selected" : "" %>>
                                    Rutas desde <%= s.getNombre() %>
                                </option>
                        <%  } } %>
                    </select>
                </form>
            </div>
        </div>

        <div class="card border-0 shadow-sm p-2">
            <div id="mapa_sucursales"></div>
        </div>
    </div>

    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var map = L.map('mapa_sucursales').setView([14.83472, -91.51805], 8);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '© OpenStreetMap'
            }).addTo(map);

            var iconoSucursal = L.icon({
                iconUrl: 'https://cdn-icons-png.flaticon.com/512/2776/2776067.png', 
                iconSize: [35, 35], iconAnchor: [17, 35], popupAnchor: [0, -35]
            });

            <% 
            if (sucursalesMapa != null) {
                for (Sucursal s : sucursalesMapa) {
                    String latStr = String.valueOf(s.getLatitud());
                    if (!latStr.equals("null") && !latStr.equals("0.0")) { 
            %>
                        L.marker([<%= s.getLatitud() %>, <%= s.getLongitud() %>], {icon: iconoSucursal})
                         .addTo(map)
                         .bindPopup("<div class='text-center'><b><%= s.getNombre() != null ? s.getNombre().replace("\"", "'") : "Sin nombre" %></b><br><small class='text-muted'>Terminal</small></div>");
            <% 
                    }
                }
            } 
            %>

            <%
            if (rutasMapa != null) {
                for (Ruta r : rutasMapa) {
                    String latOriStr = String.valueOf(r.getLatOrigen());
                    String latDesStr = String.valueOf(r.getLatDestino());
                    if (!latOriStr.equals("null") && !latOriStr.equals("0.0") && !latDesStr.equals("null") && !latDesStr.equals("0.0")) {
            %>
                        var coordenadas = [
                            [<%= r.getLatOrigen() %>, <%= r.getLonOrigen() %>],
                            [<%= r.getLatDestino() %>, <%= r.getLonDestino() %>]
                        ];

                        L.polyline(coordenadas, {
                            color: '#006A4E', 
                            weight: 3, 
                            opacity: 0.7,
                            dashArray: '10, 10' 
                        })
                        .addTo(map)
                        .bindTooltip("Ruta hacia <%= r.getNombreDestino() != null ? r.getNombreDestino().replace("\"", "'") : "Destino" %>", {sticky: true});
            <%
                    }
                }
            }
            %>
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>