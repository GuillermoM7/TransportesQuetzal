<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-white">

    <div class="container-fluid vh-100">
        <div class="row h-100">
            
            <!-- Mitad izquierda -->
            <div class="col-md-6 d-none d-md-flex flex-column justify-content-center align-items-center px-5" style="background-color: #0a192f;">
                <h1 class="fw-bold display-4 mb-3" style="color: #ff9900;">Transportes Quetzal</h1>
                <p class="lead fs-4 mb-5 text-center" style="color: #ffffff;">Gestiona tus rutas y viajes privados, compra tus boletos y viaja seguro por toda Guatemala.</p>
                <img src="https://via.placeholder.com/500x350?text=Imagen+Estacion+de+Bus" alt="Estación de Bus" class="img-fluid rounded shadow-sm">
            </div>

            <!-- Mitad derecha -->
            <div class="col-md-6 d-flex justify-content-center align-items-center">
                <div class="card p-4 shadow-lg border-0" style="width: 100%; max-width: 420px; border-radius: 10px; background-color: #f8f9fa;">
                    

                    <h4 class="text-center mb-4 fw-bold" style="color: #333333;">Inicio de sesión</h4>
                    
                    <form action="LoginServlet" method="POST" id="formLogin">
                        <div class="mb-3">
                            <input type="text" class="form-control form-control-lg" id="dpi" name="dpi" placeholder="Número de DPI" required>
                        </div>
                        
                        <div class="mb-3">
                            <input type="password" class="form-control form-control-lg" id="password" name="password" placeholder="Contraseña" required>
                        </div>
                        
                        <button type="submit" class="btn text-white btn-lg w-100 fw-bold mb-3" style="background-color: #ff9900; border: none;">Iniciar sesión</button>
                        
                        <div class="text-center mb-3">
                            <a href="#" class="text-decoration-none" style="color: #0a192f;">¿Olvidaste tu contraseña?</a>
                        </div>
                    </form>
                    
                    <hr class="my-3">
                    
                    <div class="text-center mt-2">
                        <a href="registro.jsp" class="btn text-white btn-lg fw-bold px-4" style="background-color: #0a192f; border: none;">Crear nueva cuenta</a>
                    </div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Validacion -->
    <script>
        document.getElementById('formLogin').addEventListener('submit', function(event) {
            const dpi = document.getElementById('dpi').value;
            if (!/^\d+$/.test(dpi)) {
                event.preventDefault(); 
                alert('El DPI debe contener únicamente números.');
            }
        });
    </script>
</body>
</html>