<?php
// $base = __DIR__ . '/..';
$base = __DIR__;

require '../../utils/auth.php';
require '../../utils/curl.php';

require_login();

$user = getCurrentUser();


?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>VenPOS Productos</title>
  <meta name="description" content="VenPOS Formulario de Productos" />
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
          <section class="header-section" aria-label="Header del productos">

            <div id="header-container" class="header-container">
              <div class="wrapper d-flex justify-content-between align-items-center">
                <div class="header-control one">
                  <h1 class="header-title">Ficha Producto</h1>
                </div>

                <div class="header-control two">
                  <button
                    type="button"
                    id="btn_add_producto"
                    class="btn btn-outline-success btn-sm"
                    title="Agregar nuevo producto"
                    style="z-index: 16001;">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">add</span>&nbsp;Agregar
                    </div>
                  </button>
                  <button
                    type="button"
                    id="btn_cancelar"
                    class="btn btn-outline-danger btn-sm"
                    title="Cancelar edición"
                    style="z-index: 16001;">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">cancel</span>&nbsp;Cancelar
                    </div>
                  </button>
                  <button
                    type="button"
                    id="btn_regresar"
                    class="btn btn-outline-secondary btn-sm"
                    title="Regresar a la lista"
                    style="z-index: 16001;">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">door_back</span>&nbsp;Regresar
                    </div>
                  </button>
                </div>

          </section>

          <section class="card-section mt-4" aria-label="Form Productos">
            <div class="card-container">
              <div class="header-form row gx-3 gy-2 align-items-center">
                <div class="col-12 col-md-2 ">
                  <div class="mb-2">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="tCodigo"
                        class="form-label small mb-0">Codigo</label>
                      <input type="text"
                        id="tCodigo"
                        class="form-control"
                        placeholder="Ingrese el codigo" autocomplete="off" required />
                    </div>
                  </div>
                </div>

                <div class="col-12 col-md-4 ">
                  <div class="mb-2">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="tNombre"
                        class="form-label small mb-0">Nombre</label>
                      <input type="text"
                        id="tNombre"
                        class="form-control"
                        placeholder="Ingrese el nombre   " autocomplete="off" required />
                    </div>
                  </div>
                </div>

                <div class="col-12 col-md-5 ">
                  <div class="mb-2">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="tDescripcion"
                        class="form-label small mb-0">Descripcion</label>
                      <input type="text"
                        id="tDescripcion"
                        class="form-control"
                        placeholder="Ingrese la descripcion " autocomplete="off" required />
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
                    <label class="form-label small mb-0" for="cTipo">Tipo</label>
                    <select id="cTipo" class="form-control">
                      <option value="">Todos los tipos</option>
                      <option value="simple">Simple</option>
                      <option value="compuesto">Compuesto</option>

                    </select>
                  </div>
                </div>

                <div class="col-12 col-md-3">
                  <div class="mb-2 multi-autocomplete">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="unidad_input"
                        class="form-label small mb-0">Unidad de Medida</label>
                      <input type="text" id="unidad_input" class="form-control"
                        placeholder="Buscar unidad de medida..." autocomplete="off" />
                    </div>
                    <input type="hidden" name="unidades_hidden" id="unidad_id" />
                    <div class="autocomplete-list" id="unidades_list"
                      style="max-height:180px;overflow:auto;margin-top:4px;"></div>
                  </div>
                </div>

                <div class="col-12 col-md-2 ">
                  <div class="mb-2">
                    <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
                      <label for="tStock"
                        class="form-label small mb-0">Stock Minimo</label>
                      <input type="text"
                        id="tStockMinimo"
                        class="form-control"
                        placeholder="Ingrese la Stock Minimo " autocomplete="off" required />
                    </div>
                  </div>
                </div>


                <div class="col-12 col-md-2">
                  <div class="parent-container">

                    <div class="checkbox-container align-content-start">
                      <div class="checkbox-wrapper">
                        <input class="checkbox" id="checkboxProductoActivo" type="checkbox" />
                        <label class="checkbox-label" for="checkboxPro  ductoActivo">
                          <div class="checkbox-flip">
                            <div class="checkbox-front">
                              <svg
                                fill="white"
                                height="16"
                                width="16"
                                viewBox="0 0 24 24"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                  d="M18 6L12 12L18 18L17 19L11 13L5 19L4 18L10 12L4 6L5 5L11 11L17 5L18 6Z"
                                  class="icon-path" />
                              </svg>
                            </div>
                            <div class="checkbox-back">
                              <svg
                                fill="white"
                                height="16"
                                width="16"
                                viewBox="0 0 24 24"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                  d="M9 19l-7-7 1.41-1.41L9 16.17l11.29-11.3L22 6l-13 13z"
                                  class="icon-path"></path>
                              </svg>
                            </div>
                          </div>
                        </label>
                      </div>
                    </div>
                    <h5 id="lblProductoActivo">Activo</h5>
                  </div>
                </div>

                <div class="col-12 col-md-4">
                  <div class="parent-container">

                    <div class="checkbox-container align-content-start">
                      <div class="checkbox-wrapper">
                        <input class="checkbox" id="checkboxInventario" type="checkbox" />
                        <label class="checkbox-label" for="checkboxInventario">
                          <div class="checkbox-flip">
                            <div class="checkbox-front">
                              <svg
                                fill="white"
                                height="16"
                                width="16"
                                viewBox="0 0 24 24"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                  d="M18 6L12 12L18 18L17 19L11 13L5 19L4 18L10 12L4 6L5 5L11 11L17 5L18 6Z"
                                  class="icon-path" />
                              </svg>
                            </div>
                            <div class="checkbox-back">
                              <svg
                                fill="white"
                                height="16"
                                width="16"
                                viewBox="0 0 24 24"
                                xmlns="http://www.w3.org/2000/svg">
                                <path
                                  d="M9 19l-7-7 1.41-1.41L9 16.17l11.29-11.3L22 6l-13 13z"
                                  class="icon-path"></path>
                              </svg>
                            </div>
                          </div>
                        </label>
                      </div>
                    </div>
                    <h5 id="lblInventario">Maneja Inventario</h5>
                  </div>
                </div>

                <div class="align-items-end align-self-end d-flex" style="gap:.5rem;">
                  <button
                    type="button"
                    id="btn_grabar"
                    class="btn btn-outline-info"
                    title="Grabar producto">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">save</span>&nbsp;Grabar
                    </div>
                  </button>
                  <button
                    type="button"
                    id="btn_cancelar"
                    class="btn btn-danger"
                    title="Cancelar edición">
                    <div class="parent-container">
                      <span class="material-symbols-outlined">close</span>&nbsp;Cancelar
                    </div>
                  </button>
                </div>
              </div>
            </div>
          </section>

          <section class="card-section mt-4" aria-label="Tabla de codigos y precios">
            <div class="card-container">
              <div class="card">
                <div class="card-header">
                  <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <h5 class="mb-0">Codigos</h5>
                    <button id="btn_add_Codigos" class="btn btn-outline-primary btn-sm">
                      <div class="parent-container">
                        <span class="material-symbols-outlined">add</span> Agregar Codigo
                      </div>
                    </button>
                  </div>
                </div>
                <div class="card-body p-0">
                  <div class="tables-container">
                    <div class="datagrid">
                      <table id="tabla_codigos" class="table table-striped table-hover" style="width:100%">
                        <thead>
                          <tr>
                            <th class="align-middle">Tipo</th>
                            <th class="align-middle">Codigo</th>
                            <th class="align-middle">Estado</th>
                            <th class="align-middle">Acciones</th>
                          </tr>
                        </thead>

                        <tbody>

                        </tbody>
                      </table>
                      <div id="skCodigos" class="skeleton-content">
                        <div class="skeleton skeleton-text" style="height: 3.5rem; width: 90%; margin: 0 auto 0.5rem; align-content: middle; ">
                          <div class="text-primary  text-center " style="font-weight: bold; font-size: 2.25rem;clear: both; height: 100%; display: flex; align-items: center; justify-content: center;">Cargando...</div>
                        </div>
                      </div>

                    </div>

                  </div>
                </div>
              </div>

            </div>
            <div class="card-container">  
              <div class="card">
                <div class="card-header">
                  <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
                    <h5 class="mb-0">Precios</h5>
                    <button id="btn_add_Precios"
                      class="btn btn-outline-primary btn-sm">
                      <div class="parent-container">
                        <span class="material-symbols-outlined">add</span> Agregar Precio
                      </div>
                    </button>
                  </div>
                </div>
                <div class="card-body p-0">
                  <div class="tables-container">
                    <div class="datagrid">
                      <table id="tabla_precios" class="table table-striped table-hover" style="width:100%">
                        <thead>
                          <tr>
                            <th class="align-middle">Costo</th>
                            <th class="align-middle">% Utilidad</th>
                            <th class="align-middle">Precio</th>
                            <th class="align-middle">Oferta</th>
                            <th class="align-middle">Oferta Validad</th>

                            <th class="align-middle">Incidencia en Ventas</th>
                            <th class="align-middle">Estado</th>

                            <th class="align-middle">Acciones</th>
                          </tr>
                        </thead>
                        <tbody>

                        </tbody>
                      </table>
                      <div id="skPrecios" class="skeleton-content">
                        <div class="skeleton skeleton-text" style="height: 3.5rem; width: 90%; margin: 0 auto 0.5rem; align-content: middle; ">
                          <div class="text-primary  text-center " style="font-weight: bold; font-size: 2.25rem;clear: both; height: 100%; display: flex; align-items: center; justify-content: center;">Cargando...</div>
                        </div>
                      </div>

                    </div>

                  </div>
                </div>
              </div>
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
  <script src="../../assets/js/inventario/productos.js"></script>
  <script src="../../../node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="../../../node_modules/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.concat.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

</body>

</html>