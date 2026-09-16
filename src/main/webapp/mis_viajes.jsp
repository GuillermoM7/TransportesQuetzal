<%@page import="java.util.List"%>
<%@page import="modelos.ViajePrivado"%>
<%@page import="modelos.Sucursal"%>
<%@page import="modelos.Usuario"%>
<%@page import="modelos.enums.Rol"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuarioLogueado");
    
    List<ViajePrivado> misViajes = (List<ViajePrivado>) request.getAttribute("misViajes");
    List<Sucursal> listaSucursales = (List<Sucursal>) request.getAttribute("listaSucursales");
    
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Mis Viajes - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
    <style>
        .billetera-card {
            background: linear-gradient(135deg, #0A3323 0%, #006A4E 100%);
            color: white;
            border-radius: 15px;
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        
        <!-- Alertas -->
        <% if ("solicitado".equals(msg)) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> Solicitud enviada correctamente. Pronto un administrador la cotizará.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("pagado".equals(msg)) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-wallet2 me-2"></i> ¡Pago realizado con éxito! Tu viaje ha sido programado.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("SaldoInsuficiente".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Saldo insuficiente.</strong> Recarga tu cartera para poder pagar este viaje.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        
        <div class="row align-items-center mb-4">
            <div class="col-md-7">
                <h2 class="fw-bold" style="color: #333;">Mis Viajes Privados</h2>
                <p class="text-muted">Solicita, cotiza y gestiona tus viajes exclusivos.</p>
                <button class="btn text-white fw-bold shadow-sm px-4 py-2" style="background-color: #006A4E; border-radius: 8px;" data-bs-toggle="modal" data-bs-target="#modalSolicitarViaje">
                    <i class="bi bi-car-front-fill me-1"></i> Solicitar Nuevo Viaje
                </button>
            </div>
            <div class="col-md-5">
                <div class="card border-0 shadow-sm billetera-card p-4 text-end">
                    <p class="mb-1 text-light"><i class="bi bi-wallet2 me-2"></i>Saldo en Cartera Digital</p>
                    <h2 class="fw-bold mb-0">Q. <%= String.format("%.2f", usuarioSesion.getSaldoCartera()) %></h2>
                </div>
            </div>
        </div>

        <!-- Tabla 1-->
        <h5 class="fw-bold text-warning mb-3" style="color: #d97706 !important;"><i class="bi bi-hourglass-split me-2"></i>Solicitudes en Revisión</h5>
        <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover mb-0 align-middle text-center">
                <thead class="bg-light text-muted">
                    <tr>
                        <th>Sucursal</th>
                        <th>Destino</th>
                        <th>Salida Solicitada</th>
                        <th>Pasajeros</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% boolean haySolicitados = false;
                       if (misViajes != null) {
                           for (ViajePrivado v : misViajes) { 
                               if ("solicitado".equalsIgnoreCase(v.getEstado())) { 
                                   haySolicitados = true;
                    %>
                    <tr>
                        <td class="py-3 fw-bold text-muted"><%= v.getNombreCliente() %></td>
                        <td class="py-3 text-primary fw-bold"><%= v.getDestino() %></td>
                        <td class="py-3"><i class="bi bi-clock me-1"></i><%= v.getFechaHoraSalida().toString().substring(0, 16) %></td>
                        <td class="py-3"><%= v.getCantidadPasajeros() %> pax</td>
                        <td class="py-3"><span class="badge bg-warning text-dark">En Revisión</span></td>
                    </tr>
                    <%      } 
                           } 
                       } 
                       if (!haySolicitados) { %>
                        <tr><td colspan="5" class="text-muted py-4">No tienes solicitudes pendientes.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Tabla 2 -->
        <h5 class="fw-bold text-success mb-3"><i class="bi bi-cash-coin me-2"></i>Cotizaciones Listas para Pago</h5>
        <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover mb-0 align-middle text-center">
                <thead class="bg-light text-muted">
                    <tr>
                        <th>Sucursal</th>
                        <th>Ruta</th>
                        <th>Fechas</th>
                        <th>Bus Asignado</th>
                        <th>Costo Total</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
                    <% boolean hayCotizados = false;
                       if (misViajes != null) {
                           for (ViajePrivado v : misViajes) { 
                               if ("cotizado".equalsIgnoreCase(v.getEstado())) { 
                                   hayCotizados = true;
                    %>
                    <tr>
                        <td class="py-3 fw-bold"><i class="bi bi-building me-1 text-primary"></i><%= v.getNombreCliente() %></td>
                        <td class="py-3 text-start">
                            <small class="d-block"><strong>De:</strong> <%= v.getOrigen() %></small>
                            <small class="d-block"><strong>A:</strong> <%= v.getDestino() %></small>
                        </td>
                        <td class="py-3">
                            <small class="d-block"><i class="bi bi-calendar-check me-1"></i><%= v.getFechaHoraSalida().toString().substring(0, 16) %></small>
                        </td>
                        <td class="py-3"><span class="badge bg-secondary"><%= v.getPlacaBus() %></span></td>
                        <td class="py-3 fw-bold text-success fs-5">Q. <%= String.format("%.2f", v.getPrecioEstimado()) %></td>
                        <td class="py-3">
                            <form action="MisViajesServlet" method="POST" onsubmit="return confirm('¿Confirmar pago por Q.<%= String.format("%.2f", v.getPrecioEstimado()) %> usando tu Cartera Digital?');">
                                <input type="hidden" name="accion" value="pagar">
                                <input type="hidden" name="idViaje" value="<%= v.getIdViajePriv() %>">
                                <input type="hidden" name="monto" value="<%= v.getPrecioEstimado() %>">
                                <button type="submit" class="btn btn-success fw-bold"><i class="bi bi-credit-card-fill me-1"></i> Pagar Ahora</button>
                            </form>
                        </td>
                    </tr>
                    <%      } 
                           } 
                       } 
                       if (!hayCotizados) { %>
                        <tr><td colspan="6" class="text-muted py-4">No tienes cotizaciones pendientes de pago.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Tabla 3 -->
        <h5 class="fw-bold text-primary mb-3"><i class="bi bi-signpost-2-fill me-2"></i>Mis Viajes Programados</h5>
        <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover mb-0 align-middle text-center">
                <thead class="text-white" style="background-color: #0A3323;">
                    <tr>
                        <th>ID Viaje</th>
                        <th>Destino</th>
                        <th>Salida</th>
                        <th>Bus y Piloto</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% boolean hayActivos = false;
                       if (misViajes != null) {
                           for (ViajePrivado v : misViajes) { 
                               if ("pagado".equalsIgnoreCase(v.getEstado()) || "en_curso".equalsIgnoreCase(v.getEstado())) { 
                                   hayActivos = true;
                    %>
                    <tr>
                        <td class="py-3 fw-bold text-muted">#VP-<%= v.getIdViajePriv() %></td>
                        <td class="py-3 text-primary fw-bold"><%= v.getDestino() %></td>
                        <td class="py-3"><i class="bi bi-clock me-1"></i><%= v.getFechaHoraSalida().toString().substring(0, 16) %></td>
                        <td class="py-3 text-start">
                            <small class="d-block"><strong>Bus:</strong> <%= v.getPlacaBus() %></small>
                            <small class="d-block"><strong>Piloto:</strong> <%= v.getNombreChofer() %></small>
                        </td>
                        <td class="py-3">
                            <% if("pagado".equalsIgnoreCase(v.getEstado())) { %>
                                <span class="badge bg-success">Listo para salir</span>
                            <% } else { %>
                                <span class="badge bg-primary">Viaje en Curso</span>
                            <% } %>
                        </td>
                    </tr>
                    <%      } 
                           } 
                       } 
                       if (!hayActivos) { %>
                        <tr><td colspan="5" class="text-muted py-4">No tienes viajes activos por el momento.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>


    <div class="modal fade" id="modalSolicitarViaje" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header text-white" style="background-color: #0A3323;">
                    <h5 class="modal-title fw-bold"><i class="bi bi-car-front-fill me-2"></i>Solicitar Cotización de Viaje</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="MisViajesServlet" method="POST">
                    <input type="hidden" name="accion" value="solicitar">
                    <div class="modal-body p-4 row g-3">
                        
                        <div class="col-md-12">
                            <label class="form-label fw-bold text-muted">Sucursal que atenderá el viaje</label>
                            <select class="form-select bg-light border-primary" name="idSucursal" required>
                                <option value="" disabled selected>Seleccione la sucursal más cercana...</option>
                                <% if(listaSucursales != null) {
                                    for(Sucursal s : listaSucursales) { %>
                                        <option value="<%= s.getIdSucursal() %>"><%= s.getNombre() %> (<%= s.getDireccion() %>)</option>
                                <%  } } %>
                            </select>
                        </div>
                        
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Lugar de Origen</label>
                            <input type="text" class="form-control bg-light" name="origen" placeholder="Ej: Zona 1, Ciudad" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Lugar de Destino</label>
                            <input type="text" class="form-control bg-light" name="destino" placeholder="Ej: Puerto San José" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Salida</label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraSalida" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-muted">Fecha y Hora de Retorno <small>(Opcional)</small></label>
                            <input type="datetime-local" class="form-control bg-light" name="fechaHoraRetorno">
                        </div>

                        <div class="col-md-4">
                            <label class="form-label fw-bold text-muted">Cantidad Pasajeros</label>
                            <input type="number" class="form-control bg-light" name="cantidadPasajeros" min="1" required>
                        </div>
                        
                        <div class="col-md-8 pt-4">
                            <small class="text-muted d-block mt-2"><i class="bi bi-info-circle me-1"></i> Una vez enviada la solicitud, un administrador la evaluará y te enviará el costo exacto a tu bandeja para que puedas pagarlo con tu Cartera Digital.</small>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary fw-bold" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn text-white fw-bold px-4" style="background-color: #006A4E;">Enviar Solicitud</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>