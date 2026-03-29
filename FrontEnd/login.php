<?php
session_start();


// Si ya está logueado, redirigir al dashboard
if (isset($_SESSION['user_id'])) {
    header('Location: index.php');
    exit;
}


?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>VenPOS Login</title>
    <meta name="description" content="VenPOS Login" />
    <!-- Base URL para construir rutas desde JS -->
    <meta name="base-url" content="/VenPOS">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="./src/assets/css/login.css" rel="stylesheet">
    <link rel="stylesheet" href="./node_modules/material-icons/css/material-icons.min.css" />
    <link rel="stylesheet" href="./node_modules/material-symbols/index.css" />
    <link rel="stylesheet" href="./node_modules/animate.css/animate.css" />
    <link rel="stylesheet" href="./node_modules/sweetalert2/dist/sweetalert2.css" media="print"
        onload="this.media='all'">
</head>

<body>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="hospital-logo">
                    <span class="material-symbols-outlined" style="font-size: 64px;">
                        point_of_sale
                    </span>
                </div>
                <h1>VenPOS</h1>
                <p>Point of Sale ONLINE</p>
            </div>
            <div class="login-body">
                <form id="loginForm" method="POST" novalidate>
                    <div class="form-group">
                        <label for="username" class="form-label"><i class="fas fa-user me-2"></i>Usuario</label>
                        <div class="field">
                            <input type="text" class="form-control" id="username" name="username"
                                placeholder="Ingresa tu nombre de usuario o email" required autofocus>
                        </div>
                        <div class="invalid-feedback">
                            Por favor ingresa tu nombre de usuario
                        </div>
                    </div>

                    <div class="form-group position-relative">
                        <label for="password" class="form-label"><i class="fas fa-lock me-2"></i>Contraseña</label>
                        <div class="field">

                            <input type="password" class="form-control" id="password" name="password"
                                placeholder="Ingresa tu contraseña" required></input>


                            <button type="button" class="eye" aria-label="Mostrar contraseña">
                                <span class="material-symbols-outlined">visibility</span>
                            </button>
                        </div>
                        <div class="invalid-feedback">
                            Por favor ingresa tu contraseña
                        </div>
                    </div>

                    <button id="submitBtn" type="submit" class="btn btn-login">
                        <div class="parent-container">
                            <span class="material-symbols-outlined">login</span> &nbsp Iniciar Sesión
                        </div>
                    </button>

                </form>

                <div class="notice" aria-live="polite">

                </div>
                <div id="verificationArea" aria-live="polite"></div>
                <div class="footer-text">
                    <div class="parent-container">
                        <p class="mb-1 d-flex align-items-center gap-2">
                            <i class="material-symbols-outlined me-1">
                                encrypted
                            </i>
                            Sistema seguro con encriptación de datos
                        </p>
                    </div>
                    <div class="parent-container">
                        <p class="mb-0 d-flex align-items-center gap-2">
                            <i class="material-symbols-outlined">
                                flutter_dash
                            </i>
                            IngBOS - Diseño de Software
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="./node_modules/jquery/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="./src/assets/js/utils.js"></script>
    <script src="./src/assets/js/validators.js"></script>
    <script src="./src/assets/js/login.js"></script>
    <script src="./node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>


</body>

</html>