<%@page import="java.util.List"%>
<%@page import="modelos.ViajeRegular"%>
<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    
    ViajeRegular viaje = (ViajeRegular) request.getAttribute("viaje");
    List<Integer> ocupados = (List<Integer>) request.getAttribute("asientosOcupados");
    String error = request.getParameter("error");
    
    if (viaje == null) {
        response.sendRedirect("CatalogoViajesServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Comprar Boleto - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
    <style>
        .bus-layout {
            display: grid;
            grid-template-columns: repeat(4, 50px); 
            justify-content: center;
            gap: 12px;
            background-color: #f8f9fa;
            padding: 30px;
            border-radius: 20px;
            border: 3px solid #dee2e6;
        }
        
        .bus-layout > button:nth-child(4n+3) {
            margin-left: 25px;
        }

        .asiento {
            width: 50px;
            height: 50px; 
            border-radius: 8px;
            font-weight: bold;
            font-size: 1.1rem;
            border: none;
            transition: all 0.2s ease;
        }

        .asiento-libre {
            background-color: #198754;
            color: white;
            cursor: pointer;
        }
        
        .asiento-libre:hover {
            background-color: #146c43;
            transform: scale(1.05);
        }

        .asiento-ocupado {
            background-color: #adb5bd;
            color: #495057;
            cursor: not-allowed;
            opacity: 0.7;
        }

        .asiento-seleccionado {
            background-color: #0d6efd !important;
            color: white !important;
            box-shadow: 0 0 10px rgba(13, 110, 253, 0.5);
            transform: scale(1.1);
        }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <% if ("saldoInsuficiente".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm">
                <i class="bi bi-x-circle-fill me-2"></i> <strong>Saldo insuficiente.</strong> Tu Cartera Digital no tiene fondos suficientes.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm p-4">
                    <h4 class="fw-bold text-center mb-4" style="color: #0A3323;">Selecciona tus Asientos</h4>
                    
                    <div class="d-flex justify-content-center mb-4 gap-4 text-muted fw-bold">
                        <span><div class="d-inline-block rounded me-1" style="width:15px; height:15px; background-color:#198754;"></div> Libre</span>
                        <span><div class="d-inline-block rounded me-1" style="width:15px; height:15px; background-color:#adb5bd;"></div> Ocupado</span>
                        <span><div class="d-inline-block rounded me-1" style="width:15px; height:15px; background-color:#0d6efd;"></div> Seleccionado</span>
                    </div>

                    <div class="bus-layout mx-auto">
                        <% 
                            int capacidad = viaje.getAsientosDisponibles(); 
                            for (int i = 1; i <= capacidad; i++) {
                                boolean estaOcupado = (ocupados != null && ocupados.contains(i));
                        %>
                                <button type="button" 
                                        class="asiento <%= estaOcupado ? "asiento-ocupado" : "asiento-libre" %>" 
                                        id="btnAsiento_<%= i %>"
                                        <%= estaOcupado ? "disabled" : "onclick='seleccionarAsiento(" + i + ")'" %>>
                                    <%= i %>
                                </button>
                        <%  } %>
                    </div>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="card border-0 shadow-sm p-4">
                    <h4 class="fw-bold mb-4" style="color: #0A3323;">Detalles de la Compra</h4>
                    
                    <div class="bg-light p-3 rounded mb-4 border">
                        <p class="mb-2 text-muted">Ruta:</p>
                        <h5 class="fw-bold text-primary"><%= viaje.getNombreRuta() %></h5>
                        <hr>
                        <p class="mb-2"><strong>Precio Unitario:</strong> Q. <%= String.format("%.2f", viaje.getPrecio()) %></p>
                        <p class="mb-0 fs-4"><strong>Total a Pagar:</strong> <span class="text-success fw-bold" id="displayTotal">Q. 0.00</span></p>
                    </div>

                    <form action="ComprarBoletoServlet" method="POST" id="formCompra">
                        <input type="hidden" name="idViaje" value="<%= viaje.getIdViajeReg() %>">
                        <input type="hidden" name="precioBoleto" value="<%= viaje.getPrecio() %>">
                        <input type="hidden" name="asientoSeleccionado" id="inputAsiento" required>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">Asientos Elegidos</label>
                            <input type="text" class="form-control bg-white fs-5 fw-bold text-primary" id="displayAsiento" placeholder="Ninguno" readonly>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">Fecha Manual de Compra</label>
                            <input type="datetime-local" class="form-control border-primary" name="fechaCompraManual" id="fechaManual" required onchange="validarFormulario()">
                        </div>

                        <button type="submit" class="btn btn-success w-100 fw-bold py-3 fs-5" id="btnComprar" disabled>
                            <i class="bi bi-credit-card-fill me-2"></i> Pagar Q. 0.00
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        let asientosSeleccionados = [];
        const precioBase = <%= viaje.getPrecio() %>;

        function seleccionarAsiento(numero) {
            let btn = document.getElementById('btnAsiento_' + numero);
            let indice = asientosSeleccionados.indexOf(numero);

            if (indice === -1) {
                asientosSeleccionados.push(numero);
                btn.classList.add('asiento-seleccionado');
                btn.classList.remove('asiento-libre');
            } else {
                asientosSeleccionados.splice(indice, 1);
                btn.classList.remove('asiento-seleccionado');
                btn.classList.add('asiento-libre');
            }
            
            asientosSeleccionados.sort((a, b) => a - b);
            
            actualizarFormulario();
        }

        function actualizarFormulario() {
            let cant = asientosSeleccionados.length;
            let total = cant * precioBase;
            
            document.getElementById('inputAsiento').value = asientosSeleccionados.join(',');
            document.getElementById('displayAsiento').value = cant > 0 ? asientosSeleccionados.join(', ') : "Ninguno";
            
            document.getElementById('displayTotal').innerText = "Q. " + total.toFixed(2);
            document.getElementById('btnComprar').innerHTML = `<i class="bi bi-credit-card-fill me-2"></i> Pagar Q. ${total.toFixed(2)}`;
            
            validarFormulario();
        }

        function validarFormulario() {
            let fecha = document.getElementById('fechaManual').value;
            let btn = document.getElementById('btnComprar');
            
            if (asientosSeleccionados.length > 0 && fecha !== "") {
                btn.disabled = false;
            } else {
                btn.disabled = true;
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>