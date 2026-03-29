<?php
$base = __DIR__ . '/..';
require '../utils/auth.php';
require '../utils/curl.php';

require_login();
$user = getCurrentUser();

$currentPage = $_SERVER['PHP_SELF'] ?? basename(__FILE__);


// Verificar si el producto existe y está activo

//$pS = $stmtS->fetch();
?>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>VenPOS Home</title>
    <meta name="description" content="VenPOS Home" />
    <!-- Base URL para construir rutas desde JS -->
    <meta name="base-url" content="/VenPOS">

    <meta name="base-url" content="/VenPOS">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="../../node_modules/material-icons/css/material-icons.min.css" />
    <link rel="stylesheet" href="../../node_modules/material-symbols/index.css" />
    <link rel="stylesheet" href="../../node_modules/animate.css/animate.css" />
    <link rel="stylesheet" href="../../node_modules/sweetalert2/dist/sweetalert2.css" media="print"
        onload="this.media='all'">
    <link rel="stylesheet" href="../assets/css/main.css">
</head>

<body class="h-100 w-100 app-page">

    <!-- Header -->

    <?php include '../components/header.php'; ?>

    <!-- Sidebar -->

    <?php include '../components/menu.php'; ?>

    <!-- Main Content -->
    <div class="app-layout">
        <main class="full-box">
            <section class="app-main">
                <div class="container-fluid">
                    <!-- Estadísticas -->
                    <section class="stats-section"  aria-label="Estadísticas de compras y ventas del día">

                        <div class="stats-container">
                            <div class=" stat-card" aria-label="Número de intervenciones programadas hoy" style="background-color: var(--color-programada-light);">
                            <!-- <span class="material-icons" style="font-size: 48px;">event_available</span> -->
                            <h3 id="programadas"><?= $ifoStat['Programada'] ?? 0 ?></h3>
                            <p>Programadas</p>
                        </div>
                        <div class="stat-card" style="background-color: var(--color-en-curso-light);">
                            <!-- <span class="material-icons" style="font-size: 48px;">play_circle</span> -->
                            <h3 id="en-curso"><?= $ifoStat['En curso'] ?? 0 ?></h3>
                            <p>En curso</p>
                        </div>



                        <div class="stat-card" style="background-color: var(--color-omitida-light);" aria-label="Número de intervenciones omitidas hoy">
                            <!-- <span class="material-icons" style="font-size: 48px;">skip_next</span> -->
                            <h3 id="omitidas"><?= $ifoStat['Omitida'] ?? 0 ?></h3>
                            <p>Omitidas</p>
                        </div>
                        <div class="stat-card" style="background-color: var(--color-emergencia-light  );" aria-label="Número de intervenciones de emergencia hoy">
                            <!-- <span class="material-icons" style="font-size: 48px;">emergency</span> -->
                            <h3 id="emergencias"><?= $ifoStat['Emergencia'] ?? 0 ?></h3>
                            <p>Emergencias</p>
                        </div>
                        <div class="stat-card" style="background-color: var(--color-cancelada-light);" aria-label="Número de intervenciones canceladas hoy">
                            <!-- <span class="material-icons" style="font-size: 48px;">cancel</span> -->
                            <h3 id="canceladas"><?= $ifoStat['Cancelada'] ?? 0 ?></h3>
                            <p>Canceladas</p>
                        </div>
                        <div class="stat-card" style="background-color: var(--color-realizada-light);" aria-label="Número de intervenciones realizadas hoy">
                            <!-- <span class="material-icons" style="font-size: 48px;">check_circle</span> -->
                            <h3 id="realizadas"><?= $ifoStat['Realizada'] ?? 0 ?></h3>
                            <p>Realizadas</p>
                        </div>
                </div>
            </section>
    </div>
    </section>
    </main>
    </div>
    <script src="../../node_modules/jquery/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script src="../assets/js/utils.js"></script>
    <script src="../assets/js/validators.js"></script>
    <script src="../assets/js/home.js"></script>
    <script src="../../node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>

</body>

</html>