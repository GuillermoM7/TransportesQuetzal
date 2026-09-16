<%@page import="java.util.List"%>
<%@page import="modelos.ViajeRegular"%>
<%@page import="modelos.Ruta"%>
<%@page import="modelos.Bus"%>
<%@page import="modelos.Chofer"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null || (usuarioSesion.getRol() != Rol.ADMIN_SIS && usuarioSesion.getRol() != Rol.ADMIN_SUC)) {
        response.sendRedirect("login.jsp?error=Acceso denegado");
        return; 
    }   
    List<ViajeRegular> listaViajes = (List<ViajeRegular>) request.getAttribute("listaViajes");
    List<Ruta> listaRutas = (List<Ruta>) request.getAttribute("listaRutas");
    List<Bus> listaBuses = (List<Bus>) request.getAttribute("listaBuses");
    List<Chofer> listaChoferes = (List<Chofer>) request.getAttribute("listaChoferes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Viajes Regulares - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container-fluid mt-5 px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Control de Viajes Regulares</h3>
            <% if (usuarioSesion.getRol() == Rol.ADMIN_SUC) { %>
                <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalNuevoViaje">
                    <i class="bi bi-calendar-plus-fill me-1"></i> Programar Nuevo Viaje
                </button>
            <% } %>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">No. Viaje</th>
                            <th class="py-3">Destino</th>
                            <th class="py-3">Unidad (Bus)</th>
                            <th class="py-3">Piloto Asignado</th>
                            <th class="py-3">Salida Programada</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaViajes != null && !listaViajes.isEmpty()) {
                            for (ViajeRegular v : listaViajes) {
                                if ("finalizado".equalsIgnoreCase(v.getEstado())) {
                                    continue; 
                                }
                                String salida = v.getFechaHoraSalida() != null ? v.getFechaHoraSalida().toString().substring(0, 16) : "";
                        %>
                                <tr>
                                    <td class="fw-bold py-3 text-muted">#VR-<%= v.getIdViajeReg() %></td>
                                    <td class="py-3 fw-bold text-primary"><i class="bi bi-geo-alt-fill me-1"></i><%= v.getDestinoRuta() %></td>
                                    <td class="py-3"><span class="badge bg-secondary"><i class="bi bi-bus-front me-1"></i>Placa: <%= v.getPlacaBus() %></span></td>
                                    <td class="py-3"><%= v.getNombreChofer() %></td>
                                    <td class="py-3"><i class="bi bi-clock me-1"></i><%= salida %></td>
                                    <td class="py-3">
                                        <% if("programado".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-primary">PROGRAMADO</span>
                                        <% } else if("en_curso".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-warning text-dark">EN CURSO</span>
                                        <% } else { %>
                                            <span class="badge bg-success">FINALIZADO</span>
                                        <% } %>
                                    </td>
                                    <td class="py-3">
                                        <% if (usuarioSesion.getRol() == Rol.ADMIN_SUC) { %>
                                            <% if("programado".equalsIgnoreCase(v.getEstado())) { %>
                                                <form action="ViajeRegularServlet" method="POST" class="m-0 d-inline" onsubmit="return confirm('¿Confirmar salida del bus?');">
                                                    <input type="hidden" name="accion" value="cambiarEstado">
                                                    <input type="hidden" name="idViaje" value="<%= v.getIdViajeReg() %>">
                                                    <input type="hidden" name="nuevoEstado" value="en_curso">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary" title="Iniciar Viaje"><i class="bi bi-play-circle-fill"></i> Iniciar</button>
                                                </form>
                                            <% } else if("en_curso".equalsIgnoreCase(v.getEstado())) { %>
                                                <form action="ViajeRegularServlet" method="POST" class="m-0 d-inline" onsubmit="return confirm('¿Confirmar llegada al destino?');">
                                                    <input type="hidden" name="accion" value="cambiarEstado">
                                                    <input type="hidden" name="idViaje" value="<%= v.getIdViajeReg() %>">
                                                    <input type="hidden" name="nuevoEstado" value="finalizado">
                                                    <button type="submit" class="btn btn-sm btn-outline-success" title="Finalizar Viaje"><i class="bi bi-check-circle-fill"></i> Finalizar</button>
                                                </form>
                                            <% } else { %>
                                                <span class="text-muted small"><i class="bi bi-lock-fill"></i> Completado</span>
                                            <% } %>
                                        <% } else { %>
                                            <span class="text-muted"><i class="bi bi-eye"></i> Lectura</span>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr><td colspan="7" class="text-muted py-5">No hay viajes regulares registrados.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

                    
    <% if (usuarioSesion.getRol() == Rol.ADMIN_SUC) { %>
    <div class="modal fade" id="modalNuevoViaje" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-calendar-event me-2"></i>Programar Itinerario</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="ViajeRegularServlet" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    <div class="modal-body p-4 row g-3">
                        
                        <!-- Ruta -->
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Ruta de Destino</label>
                            <select class="form-select bg-light border-primary" name="idRuta" required>
                                <option value="" disabled selected>Seleccione la ruta...</option>
                                <% if(listaRutas != null && !listaRutas.isEmpty()) {
                                    for(Ruta r : listaRutas) { %>
                                        <option value="<%= r.getIdRuta() %>"><%= r.getNombreDestino() %> - (Q. <%= r.getPrecioBoleto() %>)</option>
                                <%  } } else { %>
                                    <option value="" disabled>No tienes rutas activas configuradas</option>
                                <% } %>
                            </select>
                        </div>
                        
                        <!-- Bus -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Asignar Unidad (Bus)</label>
                            <select class="form-select bg-light" name="idBus" required>
                                <option value="" disabled selected>Seleccione unidad...</option>
                                <% if(listaBuses != null && !listaBuses.isEmpty()) {
                                    for(Bus b : listaBuses) { %>
                                        <option value="<%= b.getIdBus() %>">Placa: <%= b.getPlaca() %> (<%= b.getCapacidad() %> pasajeros)</option>
                                <%  } } else { %>
                                    <option value="" disabled>No tienes buses activos en tu flotilla</option>
                                <% } %>
                            </select>
                        </div>
                        
                        <!-- Cofer -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Piloto Asignado</label>
                            <select class="form-select bg-light" name="idChofer" required>
                                <option value="" disabled selected>Seleccione chofer...</option>
                                <% if(listaChoferes != null && !listaChoferes.isEmpty()) {
                                    for(Chofer c : listaChoferes) { %>
                                        <option value="<%= c.getIdChofer() %>"><%= c.getNombre() %> - (Lic. Tipo <%= c.getTipoLicencia() %>)</option>
                                <%  } } else { %>
                                    <option value="" disabled>No tienes choferes activos disponibles</option>
                                <% } %>
                            </select>
                        </div>
                        
                        <!-- Fecha y hora -->
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Salida</label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraSalida" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Llegada Estimada</label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraLlegada" required>
                        </div>
                        
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #006A4E;">Confirmar Viaje</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>