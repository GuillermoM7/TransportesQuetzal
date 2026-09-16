<%@page import="java.util.List"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Ruta"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Sucursal> sucursalesMapa = (List<Sucursal>) request.getAttribute("listaSucursales");
    List<Ruta> rutasMapa = (List<Ruta>) request.getAttribute("listaRutasMapa");
%>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
<style>
    #mapa_sucursales { width: 100%; height: 400px; border-radius: 12px; z-index: 1; border: 1px solid #ddd; }
</style>

<div id="mapa_sucursales"></div>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var map = L.map('mapa_sucursales').setView([14.83472, -91.51805], 8);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap'
        }).addTo(map);

        var iconoSucursal = L.icon({
            iconUrl: 'https://cdn-icons-png.flaticon.com/512/2776/2776067.png', 
            iconSize: [30, 30], iconAnchor: [15, 30], popupAnchor: [0, -30]
        });

        //Sucursales
        <% 
        if (sucursalesMapa != null) {
            for (Sucursal s : sucursalesMapa) {
                String latStr = String.valueOf(s.getLatitud());
                if (!latStr.equals("null") && !latStr.equals("0.0")) { 
        %>
                    L.marker([<%= s.getLatitud() %>, <%= s.getLongitud() %>], {icon: iconoSucursal})
                     .addTo(map)
                     .bindPopup("<b>Sucursal: <%= s.getNombre() != null ? s.getNombre().replace("\"", "'") : "Sin nombre" %></b>");
        <% 
                }
            }
        } 
        %>

        //Lineas
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
                    L.polyline(coordenadas, {color: '#d97706', weight: 4, opacity: 0.8})
                     .addTo(map);
        <%
                }
            }
        }
        %>
    });
</script>