<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Transportes Quetzal - Inicio</title>
    <jsp:include page="head.jsp" />
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 106, 78, 0.75), rgba(10, 51, 35, 0.9)), 
                        url('https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=2069&auto=format&fit=crop') no-repeat center center;
            background-size: cover;
            height: 75vh;
        }
    </style>
</head>
<body class="bg-light">

    <!-- Barra superior -->
    <nav class="navbar navbar-expand-lg navbar-dark shadow-sm py-3" style="background-color: #006A4E;">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4" href="index.jsp" style="color: #F5B041;">Transportes Quetzal</a>
            <div class="d-flex">
                <a href="login.jsp" class="btn fw-bold text-white px-4" style="background-color: #C1121F;">Iniciar Sesión</a>
            </div>
        </div>
    </nav>

    <!-- Titulo -->
    <div class="hero-section d-flex align-items-center text-center">
        <div class="container">
            <h1 class="display-3 fw-bold mb-3" style="color: #F5B041;">El clic que te lleva por toda Guatemala</h1>
            <p class="lead fs-3 text-white mb-5">Somos la red de transporte más segura. Viaja con comodidad y puntualidad.</p>
            <a href="login.jsp" class="btn btn-lg fw-bold text-white px-5 py-3 shadow" style="background-color: #0A3323; border: 2px solid #F5B041;">Adquiere tus boletos aquí</a>
        </div>
    </div>

    <!-- Parte pendiente -->
    <div class="container my-5 pt-4">
        <div class="text-center mb-5">
            <h2 class="fw-bold" style="color: #006A4E;">Nuestras Sucursales</h2>
            <p class="text-muted fs-5">Encuentra la terminal más cercana a ti en nuestro mapa interactivo.</p>
        </div>
        
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card shadow-sm border-0">
                    <div class="card-body p-0">
                        <div class="bg-secondary text-white d-flex justify-content-center align-items-center" style="height: 400px; border-radius: 5px;">
                            <span class="fs-4 fw-light">[ Espacio reservado para el mapa ]</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>