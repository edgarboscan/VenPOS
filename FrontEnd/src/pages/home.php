<?php
// $base = __DIR__ . '/..';
$base = __DIR__;

require '../utils/auth.php';
require '../utils/curl.php';

require_login();

$user = getCurrentUser();

$currentPage = $_SERVER['PHP_SELF'] ?? basename(__FILE__);

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

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <link rel="stylesheet" href="../../node_modules/material-icons/css/material-icons.min.css" />
    <link rel="stylesheet" href="../../node_modules/material-symbols/index.css" />
    <link rel="stylesheet" href="../../node_modules/animate.css/animate.css" />
    <link rel="stylesheet" href="../../node_modules/sweetalert2/dist/sweetalert2.css" media="print"
        onload="this.media='all'">
    <link rel="stylesheet" href="../assets/css/main.css">
    <link rel="stylesheet" href="../assets/css/sidebar-submenu.css">
    <link rel="stylesheet" href="../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.css"
        media="print" onload="this.media='all'">

    <link rel="apple-touch-icon" sizes="57x57" href="../assets/img/icons/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="../assets/img/icons/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="../assets/img/icons/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="../assets/img/icons/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="../assets/img/icons/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="../assets/img/icons/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="../assets/img/icons/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="../assets/img/icons/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="../assets/img/icons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="../assets/img/icons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../assets/img/icons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="../assets/img/icons/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../assets/img/icons/favicon-16x16.png">
    <link rel="manifest" href="../assets/img/icons/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="../assets/img/icons/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">

</head>

<body class="h-100 w-100 app-page">

    <!-- Header -->
    <?php include '../components/header.php'; ?>

    <!-- Sidebar -->
    <?php include '../components/menu.php'; ?>

    <!-- Main Content -->
    <div class="app-layout">
        <section class="app-main">
            <div class="container-fluid">
                <div class="row">

                    <!-- Estadísticas -->
                    <section class="stats-section" aria-label="Estadísticas de compras y ventas del día">
                        <div class="stats-container">
                            <div class="stat-card stat-card-sales" aria-label="Ventas Totales Mes">
                                <div class="real-content" style="display: none;">
                                    <h3 id="vTotal"><?= number_format($infoStat['ventas_totales'] ?? 0, 0, ',', '.') ?></h3>
                                    <p>Ventas Total (MES)</p>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-text" style="height: 2.5rem; width: 80%; margin: 0 auto 0.5rem;"></div>
                                    <div class="skeleton skeleton-text" style="width: 60%; margin: 0 auto;"></div>
                                </div>
                            </div>

                            <div class="stat-card stat-card-purchases" aria-label="Compras totales Mes">

                                <div class="real-content" style="display: none;">
                                    <h3 id="cTotal"><?= number_format($infoStat['compras_totales'] ?? 0, 0, ',', '.') ?></h3>
                                    <p>Compras Total (MES)</p>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-text" style="height: 2.5rem; width: 80%; margin: 0 auto 0.5rem;"></div>
                                    <div class="skeleton skeleton-text" style="width: 60%; margin: 0 auto;"></div>
                                </div>
                            </div>

                            <div class="stat-card stat-card-stock" aria-label="Stock de productos">
                                <div class="real-content" style="display: none;">
                                    <h3 id="sTotal"><?= number_format($infoStat['stock_total'] ?? 0, 0, ',', '.') ?></h3>
                                    <p>Stock de Productos</p>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-text" style="height: 2.5rem; width: 80%; margin: 0 auto 0.5rem;"></div>
                                    <div class="skeleton skeleton-text" style="width: 60%; margin: 0 auto;"></div>
                                </div>
                            </div>

                            <div class="stat-card stat-card-alerts" aria-label="Alertas de reabastecimiento">
                                <div class="real-content" style="display: none;">
                                    <h3 id="aReabastecimiento"><?= $infoStat['alertas_reabastecimiento'] ?? 0 ?></h3>
                                    <p>Alertas</p>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-text" style="height: 2.5rem; width: 80%; margin: 0 auto 0.5rem;"></div>
                                    <div class="skeleton skeleton-text" style="width: 60%; margin: 0 auto;"></div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- Gráficos -->
                    <section class="charts-section" aria-label="Gráficos de ventas y compras del mes">
                        <div class="charts-container">
                            <div class="chart-card one" aria-label="Gráfico de Ventas del Mes">
                                <h4>Ventas del Mes</h4>
                                <div class="d-flex justify-content-end mb-2">
                                    <button class="btn btn-sm btn-outline-secondary export-pdf-btn" data-chart="ventasChart"><i class="fas fa-file-pdf"></i> PDF</button>
                                </div>
                                <div class="real-content" style="display: none;">
                                    <canvas id="ventasChart"></canvas>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-chart"></div>
                                </div>
                            </div>
                            <div class="chart-card two" aria-label="Gráfico de Compras del Mes">
                                <h4>Compras del Mes</h4>
                                <div class="d-flex justify-content-end mb-2">
                                    <button class="btn btn-sm btn-outline-secondary export-pdf-btn" data-chart="ventasChart"><i class="fas fa-file-pdf"></i> PDF</button>
                                </div>
                                <div class="real-content" style="display: none;">
                                    <canvas id="comprasChart"></canvas>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-chart"></div>
                                </div>
                            </div>

                            <div class="chart-card three" aria-label="Pedidos de compras pendiente del mes">
                                <h4>Pedidos de Compras Pendientes</h4>
                                <div class="d-flex justify-content-end mb-2">
                                    <button class="btn btn-sm btn-outline-secondary export-pdf-btn" data-chart="ventasChart"><i class="fas fa-file-pdf"></i> PDF</button>
                                </div>
                                <div class="real-content" style="display: none;">
                                    <canvas id="pedidosChart"></canvas>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-chart"></div>
                                </div>
                            </div>

                            <div class="chart-card four" aria-label="Estado de inventario del mes">
                                <h4>Estado de Inventario</h4>
                                <div class="real-content" style="display: none;">
                                    <canvas id="inventarioChart"></canvas>
                                </div>
                                <div class="skeleton-content">
                                    <div class="skeleton skeleton-chart"></div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </section>
    </div>

    <script src="../../node_modules/jquery/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="../assets/js/app.js"></script>
    <script src="../assets/js/utils.js"></script>
    <script src="../assets/js/validators.js"></script>
    <script src="../assets/js/home.js"></script>
    <script src="../../node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.concat.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>


    <div id="spinner-carga" hidden aria-hidden="true"
        style="position: fixed;top: 0;left: 0;width: 100vw;height: 100vh;background: rgba(255,255,255,0.7);z-index: 9999;display:flex;align-items:center;justify-content:center;">
        <div class="spinner-border text-primary" role="status" style="width:4rem;height:4rem"><span
                class="sr-only">Cargando...</span></div>
    </div>


</body>

</html>