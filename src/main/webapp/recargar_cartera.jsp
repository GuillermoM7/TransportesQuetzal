<%@page import="modelos.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuarioLogueado");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return; 
    }
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Recargar Cartera - Transportes Quetzal</title>
    <jsp:include page="head.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="navbar.jsp" />

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                
                <% if ("exito".equals(msg)) { %>
                    <div class="alert alert-success alert-dismissible fade show shadow-sm text-center">
                        <i class="bi bi-check-circle-fill me-2"></i><strong>¡Recarga exitosa!</strong> Tu saldo ha sido actualizado.
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <div class="card border-0 shadow-sm p-4" style="border-radius: 15px;">
                    <h3 class="fw-bold text-center mb-4" style="color: #0A3323;">
                        <i class="bi bi-wallet2 me-2" style="color: #006A4E;"></i>Cartera Digital
                    </h3>
                    
                    <div class="bg-light p-4 rounded text-center mb-4 border">
                        <p class="text-muted mb-1">Saldo Actual Disponible</p>
                        <h2 class="text-success fw-bold mb-0">Q. <%= String.format("%.2f", usuario.getSaldoCartera()) %></h2>
                    </div>

                    <form action="RecargarCarteraServlet" method="POST">
                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted">Monto a Recargar (Q.)</label>
                            <div class="input-group input-group-lg">
                                <span class="input-group-text bg-white border-end-0 text-success fw-bold">Q.</span>
                                <input type="number" class="form-control border-start-0" name="montoRecarga" 
                                       step="0.01" min="1" placeholder="0.00" required>
                            </div>
                        </div>

                        <div class="mb-4 text-muted small text-center">
                            <i class="bi bi-shield-lock-fill text-success me-1"></i> Transacción simulada y encriptada.
                        </div>

                        <button type="submit" class="btn btn-primary w-100 fw-bold py-3 fs-5" style="background-color: #006A4E; border: none;">
                            <i class="bi bi-cash-coin me-2"></i> Confirmar Recarga
                        </button>
                    </form>
                </div>
                
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>