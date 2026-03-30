<?php
// $base = __DIR__ . '/..';
$base = __DIR__;

require '../../utils/auth.php';
require '../../utils/curl.php';

require_login();

$user = getCurrentUser();

$currentPage = $_SERVER['PHP_SELF'] ?? basename(__FILE__);

?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>VenPOS Productos</title>
  <meta name="description" content="VenPOS Listado y Gestion de productos" />
  <!-- Base URL para construir rutas desde JS -->
  <meta name="base-url" content="/VenPOS">

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

  <link rel="stylesheet" href="../../../node_modules/material-icons/css/material-icons.min.css" />
  <link rel="stylesheet" href="../../../node_modules/material-symbols/index.css" />
  <link rel="stylesheet" href="../../../node_modules/animate.css/animate.css" />
  <link rel="stylesheet" href="../../../node_modules/sweetalert2/dist/sweetalert2.css" media="print"
    onload="this.media='all'">
  <link rel="stylesheet" href="../../assets/css/main.css">
  <link rel="stylesheet" href="../../assets/css/sidebar-submenu.css">

  <link rel="stylesheet" href="../../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.css"
    media="print" onload="this.media='all'">
  <link rel="apple-touch-icon" sizes="57x57" href="../../assets/img/icons/apple-icon-57x57.png">
  <link rel="apple-touch-icon" sizes="60x60" href="../../assets/img/icons/apple-icon-60x60.png">
  <link rel="apple-touch-icon" sizes="72x72" href="../../assets/img/icons/apple-icon-72x72.png">
  <link rel="apple-touch-icon" sizes="76x76" href="../../assets/img/icons/apple-icon-76x76.png">
  <link rel="apple-touch-icon" sizes="114x114" href="../../assets/img/icons/apple-icon-114x114.png">
  <link rel="apple-touch-icon" sizes="120x120" href="../../assets/img/icons/apple-icon-120x120.png">
  <link rel="apple-touch-icon" sizes="144x144" href="../../assets/img/icons/apple-icon-144x144.png">
  <link rel="apple-touch-icon" sizes="152x152" href="../../assets/img/icons/apple-icon-152x152.png">
  <link rel="apple-touch-icon" sizes="180x180" href="../../assets/img/icons/apple-icon-180x180.png">
  <link rel="icon" type="image/png" sizes="192x192" href="../../assets/img/icons/android-icon-192x192.png">
  <link rel="icon" type="image/png" sizes="32x32" href="../../assets/img/icons/favicon-32x32.png">
  <link rel="icon" type="image/png" sizes="96x96" href="../../assets/img/icons/favicon-96x96.png">
  <link rel="icon" type="image/png" sizes="16x16" href="../../assets/img/icons/favicon-16x16.png">
  <link rel="manifest" href="../../assets/img/icons/manifest.json">
  <meta name="msapplication-TileColor" content="#ffffff">
  <meta name="msapplication-TileImage" content="../../assets/img/icons/ms-icon-144x144.png">
  <meta name="theme-color" content="#ffffff">

</head>

<body class="h-100 w-100 app-page">

  <!-- Header -->
  <?php include '../../components/header.php'; ?>

  <!-- Sidebar -->
  <?php include '../../components/menu.php'; ?>

  <!-- Main Content -->
  <div class="app-layout">
    <section class="app-main">
      <div class="container-fluid">
        <div class="row">

          <!-- Estadísticas -->
          <section class="filtros-section  " aria-label="Filtros del productos">

            <div id="filtros-container" class="filtros-container">
              <div class="filtros-control">
                <button
                  type="button"
                  id="btn_toggle_filters"
                  class="btn btn-outline-secondary btn-sm"
                  title="Mostrar / ocultar filtros"
                  style="z-index: 16001;">
                  <div class="parent-container">
                    <span class="material-symbols-outlined">filter_list</span>
                  </div>
                </button>
                <button
                  type="button"
                  id="btn_new"
                  class="btn btn-outline-info btn-sm"
                  title="Agregar nuevo producto"
                  style="z-index: 16001;">
                  <div class="parent-container">
                    <span class="material-symbols-outlined">add_circle</span>
                  </div>
                </button>
                <button
                  type="button"
                  id="btn_refresh"
                  class="btn btn-outline-success btn-sm"
                  title="Actualizar lista"
                  style="z-index: 16001;">
                  <div class="parent-container">
                    <span class="material-symbols-outlined">refresh</span>
                  </div>
                </button>
                <button
                  type="button"
                  id="btn_pdf"
                  class="btn btn-outline-danger btn-sm"
                  title="Generar PDF"
                  style="z-index: 16001;">
                  <div class="parent-container">
                    <span class="material-symbols-outlined">picture_as_pdf</span>
                  </div>
                </button>

              </div>
              <div class="filtros-form row gx-3 gy-2 align-items-center">
                <div class="col-12 col-md-4 ">
                  <div class="mb-2">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="filter_search"
                        class="form-label small mb-0">Buscar</label>
                      <input type="search"
                        id="filter_search"
                        class="form-control"
                        placeholder="Codigo, Nombre...">
                    </div>
                  </div>
                </div>

                <div class="col-12 col-md-4">
                  <div class="mb-2 multi-autocomplete">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="categoria_input"
                        class="form-label small mb-0">Categorias</label>
                      <input type="text" id="categoria_input" class="form-control"
                        placeholder="Buscar Categoria..." autocomplete="off" />
                    </div>
                    <input type="hidden" name="categorias_hidden" id="categoria_id" />
                    <div class="autocomplete-list" id="categorias_list"></div>
                  </div>
                </div>

                <div class="col-12 col-md-3">
                  <div class="mb-2 multi-autocomplete">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="marca_input"
                        class="form-label small mb-0">Marca</label>
                      <input type="text" id="marca_input" class="form-control"
                        placeholder="Buscar marca..." autocomplete="off" />
                    </div>
                    <input type="hidden" name="marcas_hidden" id="marca_id" />
                    <div class="autocomplete-list" id="marcas_list"
                      style="max-height:180px;overflow:auto;margin-top:4px;"></div>
                  </div>
                </div>

                <div class="col-12 col-md-4">
                  <div class="mb-2">
                    <label class="form-label small mb-0" for="filter_tipo">Tipo</label>
                    <select id="filter_tipo" class="form-control">
                      <option value="">Todos los tipos</option>
                      <option value="simple">Simple</option>
                      <option value="compuesto">Compuesto</option>

                    </select>
                  </div>
                </div>

                <div class="align-items-end align-self-end d-flex" style="gap:.5rem;">
                  <button
                    type="button"
                    id="btn_apply_filters"
                    class="btn btn-outline-info"
                    title="Aplicar filtros">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">filter_alt</span> Filtrar
                    </div>
                  </button>
                  <button
                    type="button"
                    id="btn_clear_filters"
                    class="btn btn-outline-danger"
                    title="Limpiar filtros">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">filter_alt_off</span> Limpiar
                    </div>
                  </button>
                </div>
              </div>
            </div>
          </section>

          <!-- Gráficos -->
          <section class="tables-section" aria-label="Gráficos de ventas y compras del mes">

            <div class="tables-container">
              <div class="datagrid">
                <table id="tabla_productos">
                  <thead>
                    <tr>
                      <th class="align-middle">Codigo</th>
                      <th class="align-middle">Nombre</th>
                      <th class="align-middle">Tipo</th>
                      <th class="align-middle">Categoría</th>
                      <th class="align-middle">Marca</th>
                      <th class="align-middle">Stock</th>
                      <th class="align-middle">Estado</th>
                      <th class="align-middle">Costo</th>
                      <th class="align-middle">Utilidad Absoluta</th>
                      <th class="align-middle">Margen sobre Ventas</th>
                      <th class="align-middle">Precio</th>
                      <th class="align-middle">Acciones</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <td colspan="11">
                        <div id="paging">
                          <nav id="productos-pagination" aria-label="Paginación productos">
                            <ul class="pagination justify-content-center">
                              <!-- elementos de paginación generados dinámicamente -->
                            </ul>
                          </nav>
                        </div>
                    </tr>
                  </tfoot>
                  <tbody>

                  </tbody>
                </table>
                <div class="skeleton-content">
                  <div class="skeleton skeleton-text" style="height: 3.5rem; width: 90%; margin: 0 auto 0.5rem; align-content: middle; ">
                    <div class="text-primary  text-center " style="font-weight: bold; font-size: 2.25rem;clear: both; height: 100%; display: flex; align-items: center; justify-content: center;">Cargando...</div>
                  </div>
                </div>

              </div>

            </div>

            <div id="productos-page-summary" class="text-center small mt-2" aria-live="polite"></div>
          </section>
        </div>
    </section>
  </div>
  </div>
  </section>
  </div>

  <script src="../../../node_modules/jquery/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../../assets/js/app.js"></script>
  <script src="../../assets/js/utils.js"></script>
  <script src="../../assets/js/validators.js"></script>
  <script src="../../assets/js/inventario/index.js"></script>
  <script src="../../../node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="../../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.concat.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

</body>

</html>