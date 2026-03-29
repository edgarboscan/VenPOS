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
    <link rel="stylesheet" href="../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.css"
        media="print" onload="this.media='all'">
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
                    <section class="stats-section" aria-label="Estadísticas de compras y ventas del día">

                        <div class="stats-container">
                            <div class="stat-card" aria-label="Ventas Totales Mes" style="background-color: var(--color-programada-light);">

                                <h3 id="vTotal"><?= $ifoStat['ventas_totales'] ?? 0 ?></h3>
                                <p>Ventas Total (MES)</p>
                            </div>

                            <div class="stat-card" style="background-color: var(--color-en-curso-light);" aria-label="Compras totales Mes">
                                <h3 id="cTotal"><?= $ifoStat['compras_totales'] ?? 0 ?></h3>
                                <p>Compras Total (MES)</p>
                            </div>

                            <div class="stat-card" style="background-color: var(--color-omitida-light);" aria-label="Stock de productos">
                                <h3 id="sTotal"><?= $ifoStat['stock_total'] ?? 0 ?></h3>
                                <p>Stock de Productos</p>
                            </div>

                            <div class="stat-card" style="background-color: var(--color-emergencia-light  );" aria-label="Alertas de reabastecimiento">
                                <h3 id="aReabastecimiento"><?= $ifoStat['alertas_reabastecimiento'] ?? 0 ?></h3>
                                <p>Alertas</p>
                            </div>

                        </div>
                        <div class="stats-body">
                            <div class="parent">
                                <div class="div1">
                                    <div class="stats-chart" aria-label="Gráfica de ventas y compras del mes">
                                        <canvas id="ventasComprasChart" aria-hidden="true"></canvas>
                                    </div>
                                </div>
                                <div class="div2">
                                    <div class="stats-chart" aria-label="Gráfica de ventas por producto del mes Top 5">
                                        <canvas id="topProductosChart" aria-hidden="true"></canvas>
                                    </div>
                                </div>
                                <div class="div3">
                                    <table class="table caption-top">
                                        <caption>List of users</caption>
                                        <thead>
                                            <tr>
                                                <th scope="col">#</th>
                                                <th scope="col">First</th>
                                                <th scope="col">Last</th>
                                                <th scope="col">Handle</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <th scope="row">1</th>
                                                <td>Mark</td>
                                                <td>Otto</td>
                                                <td>@mdo</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">2</th>
                                                <td>Jacob</td>
                                                <td>Thornton</td>
                                                <td>@fat</td>
                                            </tr>
                                            <tr>
                                                <th scope="row">3</th>
                                                <td>Larry</td>
                                                <td>the Bird</td>
                                                <td>@twitter</td>
                                            </tr>
                                        </tbody>
                                    </table>/div>
                                    <div class="div4">4</div>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.concat.min.js"></script>

</body>

</html>