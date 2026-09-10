<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Transportes Quetzal - Registro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <div class="container-fluid min-vh-100">
        <div class="row min-vh-100">
            
            <!-- Mitad izquierda -->
            <div class="col-md-5 d-none d-md-flex flex-column justify-content-center align-items-center px-5" style="background-color: #0a192f;">
                <h1 class="fw-bold display-5 mb-3 text-center" style="color: #ff9900;">Transportes Quetzal</h1>
                <p class="lead fs-5 mb-5 text-center" style="color: #ffffff;">Únete a nuestra plataforma y gestiona tus viajes de forma rápida y segura por toda Guatemala.</p>
                <img src="https://via.placeholder.com/500x350?text=Logo+Transportes+Quetzal" alt="Transportes Quetzal" class="img-fluid rounded shadow-sm">
            </div>

            <!-- Mitad derecha -->
            <div class="col-md-7 d-flex justify-content-center align-items-center py-4">
                <div class="card p-4 shadow-lg border-0" style="width: 100%; max-width: 650px; border-radius: 10px; background-color: #F8F9FA;">
                    
                    <h4 class="text-center mb-4 fw-bold" style="color: #333333;">Crear Cuenta Nueva</h4>
                    
                    <form action="RegistroServlet" method="POST" id="formRegistro">
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label class="form-label fw-bold">Nombre Completo</label>
                                <input type="text" class="form-control" name="nombre" placeholder="Ej. Juan Pérez" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">DPI</label>
                                <input type="text" class="form-control" id="dpiRegistro" name="dpi" placeholder="Tus13 dígitos" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">NIT</label>
                                <input type="text" class="form-control" name="nit" placeholder="Opcional">
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Teléfono</label>
                                <input type="text" class="form-control" name="telefono" placeholder="Ej. 44556677" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Dirección</label>
                                <input type="text" class="form-control" name="direccion" placeholder="Tu domicilio" required>
                            </div>
                            
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Contraseña</label>
                                <input type="password" class="form-control" id="pass1" name="password" required>
                            </div>
                            
                            <div class="col-md-6 mb-4">
                                <label class="form-label fw-bold">Confirmar Contraseña</label>
                                <input type="password" class="form-control" id="pass2" required>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn text-white btn-lg w-100 fw-bold mb-3" style="background-color: #0a192f; border: none;">Registrar mi cuenta</button>
                        
                        <div class="text-center">
                            <a href="login.jsp" class="text-decoration-none fw-bold" style="color: #000000;">¿Ya tienes cuenta? Inicia sesión aquí</a>
                        </div>
                    </form>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Validacion -->
    <script>
        document.getElementById('formRegistro').addEventListener('submit', function(event) {
            const dpi = document.getElementById('dpiRegistro').value;
            const pass1 = document.getElementById('pass1').value;
            const pass2 = document.getElementById('pass2').value;
            
            if (!/^\d+$/.test(dpi)) {
                event.preventDefault(); 
                alert('El DPI debe contener únicamente números.');
                return;
            }
            
            if (pass1 !== pass2) {
                event.preventDefault();
                alert('Las contraseñas no coinciden. Verifíquelas e intente de nuevo.');
            }
        });
    </script>
</body>
</html>