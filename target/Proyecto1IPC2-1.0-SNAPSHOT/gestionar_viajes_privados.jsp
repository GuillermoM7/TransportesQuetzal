<%@page import="java.util.List"%>
<%@page import="modelos.ViajePrivado"%>
<%@page import="modelos.Bus"%>
<%@page import="modelos.Chofer"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuarioSesion == null) {
        response.sendRedirect("login.jsp");
        return; 
    }    
    List<ViajePrivado> listaViajes = (List<ViajePrivado>) request.getAttribute("listaViajesPrivados");
    List<Bus> listaBuses = (List<Bus>) request.getAttribute("listaBuses");
    List<Chofer> listaChoferes = (List<Chofer>) request.getAttribute("listaChoferes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Viajes Privados - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container-fluid mt-5 px-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold" style="color: #333;">Bandeja de Viajes Privados</h3>
        </div>
        
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="text-white" style="background-color: #0A3323;">
                        <tr>
                            <th class="py-3">No. Solicitud</th>
                            <th class="py-3">Cliente</th>
                            <th class="py-3">Ruta Solicitada</th>
                            <th class="py-3">Salida</th>
                            <th class="py-3">Pasajeros</th>
                            <th class="py-3">Cotización (Q)</th>
                            <th class="py-3">Estado</th>
                            <th class="py-3">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaViajes != null && !listaViajes.isEmpty()) {
                            for (ViajePrivado v : listaViajes) { 
                                if ("finalizado".equalsIgnoreCase(v.getEstado())) { continue; }
                                String salida = v.getFechaHoraSalida() != null ? v.getFechaHoraSalida().toString().substring(0, 16) : "";
                        %>
                                <tr>
                                    <td class="fw-bold py-3 text-muted">#VP-<%= v.getIdViajePriv() %></td>
                                    <td class="py-3 fw-bold"><i class="bi bi-person-fill me-1"></i><%= v.getNombreCliente() %></td>
                                    <td class="py-3 text-primary">
                                        <small><strong>De:</strong> <%= v.getOrigen() %></small><br>
                                        <small><strong>A:</strong> <%= v.getDestino() %></small>
                                    </td>
                                    <td class="py-3"><i class="bi bi-clock me-1"></i><%= salida %></td>
                                    <td class="py-3"><span class="badge bg-info text-dark"><%= v.getCantidadPasajeros() %> Personas</span></td>
                                    
                                    <td class="py-3 fw-bold text-success">
                                        <%= v.getPrecioEstimado() > 0 ? "Q. " + String.format("%.2f", v.getPrecioEstimado()) : "Pendiente" %>
                                    </td>
                                    
                                    <td class="py-3">
                                        <% if("solicitado".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-danger">NUEVA SOLICITUD</span>
                                        <% } else if("cotizado".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split me-1"></i>ESPERANDO PAGO</span>
                                        <% } else if("pagado".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-success"><i class="bi bi-wallet2 me-1"></i>PAGADO</span>
                                        <% } else if("en_curso".equalsIgnoreCase(v.getEstado())) { %>
                                            <span class="badge bg-primary">EN RUTA</span>
                                        <% } %>
                                    </td>
                                    
                                    <td class="py-3">
                                        <% if (usuarioSesion.getRol() == Rol.ADMIN_SUC) { %>
                                            <% if("solicitado".equalsIgnoreCase(v.getEstado())) { %>
                                                <button type="button" class="btn btn-sm btn-outline-primary fw-bold" onclick="abrirModalCotizacion(<%= v.getIdViajePriv() %>)">
                                                    <i class="bi bi-calculator me-1"></i> Cotizar
                                                </button>
                                            <% } else if("cotizado".equalsIgnoreCase(v.getEstado())) { %>
                                                <span class="text-muted small">Falta pago del cliente</span>
                                            <% } else if("pagado".equalsIgnoreCase(v.getEstado())) { %>
                                                <button type="button" class="btn btn-sm btn-outline-primary" title="Iniciar Viaje" onclick="abrirModalSalida(<%= v.getIdViajePriv() %>, 'privado', <%= v.getKilometrajeBus() %>,)">
                                                    <i class="bi bi-play-circle-fill"></i> Iniciar
                                                </button>
                                            <% } else if("en_curso".equalsIgnoreCase(v.getEstado())) { %>
                                                <button type="button" class="btn btn-sm btn-outline-success" title="Finalizar Viaje" onclick="abrirModalLlegada(<%= v.getIdViajePriv()%>, 'privado', <%= v.getKilometrajeInicial() %>)">
                                                    <i class="bi bi-check-circle-fill"></i> Finalizar
                                                </button>
                                            <% } %>
                                        <% } else { %>
                                            <span class="text-muted"><i class="bi bi-eye"></i> Lectura</span>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr><td colspan="8" class="text-muted py-5">No hay solicitudes de viajes privados pendientes.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>


    <% if (usuarioSesion.getRol() == Rol.ADMIN_SUC) { %>
    <div class="modal fade" id="modalCotizacion" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-clipboard-check me-2"></i>Asignar Recursos y Cotizar</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="ViajePrivadoServlet" method="POST">
                    <input type="hidden" name="accion" value="cotizar">
                    <input type="hidden" name="idViaje" id="inputModalIdViaje" value="">
                    
                    <div class="modal-body p-4 row g-3">
                        <div class="col-12 text-center mb-2">
                            <small class="text-muted">El sistema calculará un precio base según el tamaño del bus, pero puedes modificarlo libremente antes de confirmar.</small>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label fw-bold text-muted">Asignar Bus</label>
                            <select class="form-select bg-light border-primary" name="idBus" id="selectBus" required onchange="calcularCotizacionAutomatica()">
                                <option value="" data-capacidad="0" disabled selected>Seleccione el bus a enviar...</option>
                                <% if(listaBuses != null) {
                                    for(Bus b : listaBuses) { %>
                                        <option value="<%= b.getIdBus() %>" data-capacidad="<%= b.getCapacidad() %>">
                                            Placa: <%= b.getPlaca() %> (Capacidad: <%= b.getCapacidad() %> Personas)
                                        </option>
                                <%  } } %>
                            </select>
                        </div>
                        
                        <div class="col-12">
                            <label class="form-label fw-bold text-muted">Asignar Piloto</label>
                            <select class="form-select bg-light" name="idChofer" required>
                                <option value="" disabled selected>Seleccione el piloto...</option>
                                <% if(listaChoferes != null) {
                                    for(Chofer c : listaChoferes) { %>
                                        <option value="<%= c.getIdChofer() %>"><%= c.getNombre() %> - (Lic. <%= c.getTipoLicencia() %>)</option>
                                <%  } } %>
                            </select>
                        </div>
                        
                        <div class="col-12 mt-4">
                            <label class="form-label fw-bold text-success"><i class="bi bi-cash-coin me-1"></i>Precio a Cobrar (Q)</label>
                            <input type="number" step="0.01" class="form-control form-control-lg bg-light text-success fw-bold" 
                                   name="precioEstimado" id="inputPrecioEstimado" required>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="submit" class="btn text-white fw-bold px-4 w-100" style="background-color: #006A4E;">Confirmar Viaje</button>
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

    <script>
        
        const COSTO_POR_ASIENTO = 40.00;

        function abrirModalCotizacion(idViaje) {
            document.getElementById('inputModalIdViaje').value = idViaje;
            document.getElementById('selectBus').selectedIndex = 0;
            document.getElementById('inputPrecioEstimado').value = '';

            var myModal = new bootstrap.Modal(document.getElementById('modalCotizacion'));
            myModal.show();
        }

        function calcularCotizacionAutomatica() {
            var select = document.getElementById('selectBus');
            var opcionSeleccionada = select.options[select.selectedIndex];
            
            var capacidadBus = parseInt(opcionSeleccionada.getAttribute('data-capacidad'));
            
            if (capacidadBus > 0) {
                var totalEstimado = capacidadBus * COSTO_POR_ASIENTO;
                document.getElementById('inputPrecioEstimado').value = totalEstimado.toFixed(2);
            }
        }
        
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
    </script>
    <% } %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>