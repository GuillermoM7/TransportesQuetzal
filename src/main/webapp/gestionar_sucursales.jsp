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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
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
                                        <button type="button" class="btn btn-sm btn-outline-primary" 
                                            onclick="abrirModalEditarSucursal(<%= s.getIdSucursal() %>, '<%= s.getNombre() %>', '<%= s.getDireccion() %>', <%= s.getLatitud() %>, <%= s.getLongitud() %>)">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
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
  
    <div class="modal fade" id="modalEditarSucursal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0d6efd;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Sucursal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="SucursalServlet" method="POST">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idSucursal" id="editIdSucursal">
                    <input type="hidden" name="latitud" id="editLatitud">
                    <input type="hidden" name="longitud" id="editLongitud">

                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-5">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-muted">Nombre de la Sucursal</label>
                                <input type="text" class="form-control bg-light" name="nombre" id="editNombre" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-bold text-muted">Dirección</label>
                                <textarea class="form-control bg-light" name="direccion" id="editDireccion" rows="3" required></textarea>
                            </div>
                            <div class="alert alert-info small mt-3">
                                <i class="bi bi-info-circle me-1"></i> Haz clic en el mapa para actualizar la ubicación.
                            </div>
                        </div>
                        <div class="col-md-7">
                            <label class="form-label fw-bold text-muted mb-2">Ubicación en el Mapa</label>
                            <div id="mapaEdicion" style="height: 300px; width: 100%; border-radius: 8px; border: 1px solid #ccc;"></div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary fw-bold px-4">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="modalNuevaSucursal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-building-add me-2"></i>Registrar Sucursal</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                
                <form action="SucursalServlet" method="POST" id="formNuevaSucursal">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <input type="hidden" name="latitud" id="regLatitud">
                    <input type="hidden" name="longitud" id="regLongitud">

                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-5">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-muted">Nombre de la Sucursal</label>
                                <input type="text" class="form-control bg-light" name="nombre" id="regNombre" placeholder="Ej. Quetzaltenango Centro" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-bold text-muted">Dirección</label>
                                <textarea class="form-control bg-light" name="direccion" id="regDireccion" rows="3" placeholder="Dirección exacta de la terminal..." required></textarea>
                            </div>
                            <div class="alert alert-info small mt-3 border-0 bg-opacity-10">
                                <i class="bi bi-geo-alt-fill me-1"></i> Haz clic en el mapa para marcar la ubicación.
                            </div>
                        </div>
                        
                        <div class="col-md-7">
                            <label class="form-label fw-bold text-muted mb-2">Ubicación GPS</label>
                            <div id="mapaRegistro" style="height: 300px; width: 100%; border-radius: 8px; border: 1px solid #dee2e6;"></div>
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

    <script>

        let mapRegistro = null;
        let markerRegistro = null;
        let mapEdicion = null;
        let markerEdicion = null;
        const centroBase = [14.83472, -91.51806]; 

        document.addEventListener("DOMContentLoaded", function() {
            const modalNueva = document.getElementById('modalNuevaSucursal');
            
            if(modalNueva) {
                modalNueva.addEventListener('shown.bs.modal', function () {
                    if (!mapRegistro) {
                        mapRegistro = L.map('mapaRegistro').setView(centroBase, 14);
                        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; OpenStreetMap'
                        }).addTo(mapRegistro);

                        mapRegistro.on('click', function(e) {
                            document.getElementById('regLatitud').value = e.latlng.lat;
                            document.getElementById('regLongitud').value = e.latlng.lng;
                            if (markerRegistro) {
                                markerRegistro.setLatLng(e.latlng);
                            } else {
                                markerRegistro = L.marker(e.latlng).addTo(mapRegistro);
                            }
                        });
                    }
                    setTimeout(() => { mapRegistro.invalidateSize(); }, 250);
                });

                modalNueva.addEventListener('hidden.bs.modal', function () {
                    document.getElementById('formNuevaSucursal').reset();
                    document.getElementById('regLatitud').value = '';
                    document.getElementById('regLongitud').value = '';
                    if (markerRegistro && mapRegistro) {
                        mapRegistro.removeLayer(markerRegistro);
                        markerRegistro = null;
                        mapRegistro.setView(centroBase, 14);
                    }
                });
            }
        });

        function abrirModalEditarSucursal(id, nombre, direccion, lat, lng) {
            document.getElementById('editIdSucursal').value = id;
            document.getElementById('editNombre').value = nombre;
            document.getElementById('editDireccion').value = direccion;
            document.getElementById('editLatitud').value = lat;
            document.getElementById('editLongitud').value = lng;

            let coord = (lat && lng && lat != 0) ? [lat, lng] : centroBase;

            let modalEl = document.getElementById('modalEditarSucursal');
            let modalInstance = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modalInstance.show();

            modalEl.addEventListener('shown.bs.modal', function onShown() {
                if (!mapEdicion) {
                    mapEdicion = L.map('mapaEdicion').setView(coord, 14);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; OpenStreetMap'
                    }).addTo(mapEdicion);

                    mapEdicion.on('click', function(e) {
                        document.getElementById('editLatitud').value = e.latlng.lat;
                        document.getElementById('editLongitud').value = e.latlng.lng;
                        if (markerEdicion) {
                            markerEdicion.setLatLng(e.latlng);
                        } else {
                            markerEdicion = L.marker(e.latlng).addTo(mapEdicion);
                        }
                    });
                } else {
                    mapEdicion.setView(coord, 14);
                }

                if (markerEdicion) {
                    mapEdicion.removeLayer(markerEdicion);
                    markerEdicion = null;
                }
                
                if (lat && lng && lat != 0) {
                    markerEdicion = L.marker(coord).addTo(mapEdicion);
                }

                setTimeout(() => { mapEdicion.invalidateSize(); }, 250);
                modalEl.removeEventListener('shown.bs.modal', onShown);
            });
        }
    </script>                   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>