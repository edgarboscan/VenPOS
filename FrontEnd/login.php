<?php
$base = __DIR__ . '/..';
require './src/utils/auth.php';
require './src/utils/curl.php';

// Destruir la sesión activa al entrar a la página de login
logout1();

$currentPage = $_SERVER['PHP_SELF'] ?? basename(__FILE__);
// Si ya está logueado, redirigir al dashboard

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
    <link rel="apple-touch-icon" sizes="57x57" href="./src/assets/img/icons/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="./src/assets/img/icons/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="./src/assets/img/icons/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="./src/assets/img/icons/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="./src/assets/img/icons/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="./src/assets/img/icons/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="./src/assets/img/icons/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="./src/assets/img/icons/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="./src/assets/img/icons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="./src/assets/img/icons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="./src/assets/img/icons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="./src/assets/img/icons/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="./src/assets/img/icons/favicon-16x16.png">
    <link rel="manifest" href="./src/assets/img/icons/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="./src/assets/img/icons/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">
</head>

<body>

    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div>
                    <img src="./src/assets/img/logos/logo.png" class="img-fluid" alt="VenPos" width="150" height="150" />
                </div>
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