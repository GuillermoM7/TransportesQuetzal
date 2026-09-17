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
                                                <button type="button" class="btn btn-sm btn-outline-primary" title="Iniciar Viaje" onclick="abrirModalSalida(<%= v.getIdViajeReg() %>, 'regular', <%= v.getKilometrajeBus() %>)">
                                                    <i class="bi bi-play-circle-fill"></i> Iniciar
                                                </button>
                                                    
                                                <button type="button" class="btn btn-sm btn-outline-warning ms-1" title="Editar Fechas" onclick="abrirModalEditarViajeReg(<%= v.getIdViajeReg() %>, '<%= v.getFechaHoraSalida().toString().replace(" ", "T").substring(0, 16) %>', '<%= v.getFechaHoraLlegadaEstimada().toString().replace(" ", "T").substring(0, 16) %>')">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>
                                            
                                                <form action="ViajeRegularServlet" method="POST" class="m-0 d-inline ms-1" onsubmit="return confirm('¿Estás seguro de eliminar este viaje programado? Esta acción no se puede deshacer.');">
                                                    <input type="hidden" name="accion" value="eliminar">
                                                    <input type="hidden" name="idViaje" value="<%= v.getIdViajeReg() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Eliminar Viaje"><i class="bi bi-trash-fill"></i></button>
                                                </form>
                                            <% } else if("en_curso".equalsIgnoreCase(v.getEstado())) { %>
                                                <button type="button" class="btn btn-sm btn-outline-success" title="Finalizar Viaje" onclick="abrirModalLlegada(<%= v.getIdViajeReg() %>, 'regular', <%= v.getKilometrajeInicial() %>)">
                                                    <i class="bi bi-check-circle-fill"></i> Finalizar
                                                </button>
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

    <div class="modal fade" id="modalIniciarViaje" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-play-circle-fill me-2"></i>Registrar Salida de Viaje</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="IniciarViajeServlet" method="POST">
                    <div class="modal-body p-4">
                        <div class="alert alert-warning border-0 bg-opacity-10 small mb-4">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <strong>ATENCIÓN:</strong> Una vez registrada la salida, estos datos no podrán ser modificados. El estado del viaje cambiará automáticamente.
                        </div>
                        
                        <input type="hidden" name="idViaje" id="modalIdViaje">
                        <input type="hidden" name="tipoViaje" id="modalTipoViaje">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Hora Real de Salida</label>
                            <input type="datetime-local" class="form-control bg-light" name="horaRealSalida" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Kilometraje Inicial del Bus</label>
                            <div class="mb-2 text-primary small fw-bold">
                                <i class="bi bi-speedometer2 me-1"></i> Kilometraje actual registrado: <span id="displayKmActual">0</span> Km
                            </div>
                            
                            <div class="input-group">
                                <input type="number" class="form-control bg-light" name="kilometrajeInicial" id="inputKmInicial" step="0.01" required>
                                <span class="input-group-text fw-bold">Km</span>
                            </div>
                            <div class="form-text">No puedes ingresar un valor menor al kilometraje actual.</div>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary fw-bold px-4" style="background-color: #0d6efd;">Confirmar Salida</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
                            
    <div class="modal fade" id="modalFinalizarViaje" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-flag-fill me-2"></i>Registrar Llegada y Costos</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="FinalizarViajeServlet" method="POST">
                <div class="modal-body p-4">
                        <div class="alert alert-info border-0 bg-opacity-10 small mb-4">
                            <i class="bi bi-calculator me-2"></i>
                            El sistema calculará automáticamente la depreciación del bus utilizando el kilometraje registrado en este momento.
                        </div>
                        
                        <input type="hidden" name="idViaje" id="modalLlegadaIdViaje">
                        <input type="hidden" name="tipoViaje" id="modalLlegadaTipoViaje">

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Hora Real de Llegada</label>
                            <input type="datetime-local" class="form-control bg-light" name="horaRealLlegada" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Kilometraje Final del Bus</label>

                            <div class="mb-2 text-primary small fw-bold">
                                <i class="bi bi-geo-alt-fill me-1"></i> Kilometraje al salir: <span id="displayKmInicialLlegada">0</span> Km
                            </div>
                            
                            <div class="input-group">

                                <input type="number" class="form-control bg-light" name="kilometrajeFinal" id="inputKmFinal" step="0.01" required>
                                <span class="input-group-text fw-bold">Km</span>
                            </div>
                            <div class="form-text text-danger small">Debe ser mayor o igual al kilometraje de salida.</div>
                        </div> 

                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted">Gasto Total en Combustible</label>
                            <div class="input-group">
                                <span class="input-group-text fw-bold text-success">Q.</span>
                                <input type="number" class="form-control bg-light" name="gastoCombustible" step="0.01" min="0" placeholder="Ej: 450.00" required>
                            </div>
                        </div>
                    </div> 
                    
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold px-4">Finalizar Viaje</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
                            
    <div class="modal fade" id="modalEditarViajeReg" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white bg-warning">
                    <h5 class="modal-title fw-bold text-dark"><i class="bi bi-pencil-square me-2"></i>Editar Fechas del Viaje</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="ViajeRegularServlet" method="POST">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idViaje" id="editRegIdViaje">
                    
                    <div class="modal-body p-4 row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Salida</label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraSalida" id="editRegSalida" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Llegada Estimada</label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraLlegada" id="editRegLlegada" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark px-4">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>                        
    
    <% } %> 

    <script>
        function abrirModalSalida(idViaje, tipo, kmActual) {
            document.getElementById('modalIdViaje').value = idViaje;
            document.getElementById('modalTipoViaje').value = tipo;
            document.getElementById('displayKmActual').innerText = kmActual;
            
            let inputKm = document.getElementById('inputKmInicial');
            inputKm.min = kmActual;
            inputKm.value = kmActual; 
            
            var myModal = new bootstrap.Modal(document.getElementById('modalIniciarViaje'));
            myModal.show();
        }
        
        function abrirModalLlegada(idViaje, tipo, kmInicial) {
            document.getElementById('modalLlegadaIdViaje').value = idViaje;
            document.getElementById('modalLlegadaTipoViaje').value = tipo;           
            document.getElementById('displayKmInicialLlegada').innerText = kmInicial;
            
            let inputKmFinal = document.getElementById('inputKmFinal');
            inputKmFinal.min = kmInicial;
            inputKmFinal.value = ""; 
            
            var myModal = new bootstrap.Modal(document.getElementById('modalFinalizarViaje'));
            myModal.show();
        }
        
        function abrirModalEditarViajeReg(id, salida, llegada) {
            document.getElementById('editRegIdViaje').value = id;
            document.getElementById('editRegSalida').value = salida;
            document.getElementById('editRegLlegada').value = llegada;
            
            var myModal = new bootstrap.Modal(document.getElementById('modalEditarViajeReg'));
            myModal.show();
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>