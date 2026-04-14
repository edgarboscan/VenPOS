<?php
$base = __DIR__ . '/../..';
require '../../utils/auth.php';
require '../../utils/curl.php';

require_login();

$user = getCurrentUser();
$currentPage = $_SERVER['PHP_SELF'] ?? basename(__FILE__);

// Obtener empresa actual (de sesión o primera disponible)
$empresa_id =
  $_SESSION['empresas'][0]['id'] ?? null;
if (!$empresa_id && isset($user['empresas']) && count($user['empresas']) > 0) {
  $empresa_id = $user['empresas'][0]['id'];
  $_SESSION['empresa_id'] = $empresa_id;
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
  <title>VenPOS - Punto de Venta</title>
  <meta name="description" content="Sistema de Punto de Venta" />
  <meta name="base-url" content="/VenPOS">
  <meta name="empresa-id" content="<?= $empresa_id ?>">

  <!-- CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <link rel="stylesheet" href="../../assets/css/main.css">
  <link rel="stylesheet" href="../../assets/css/sidebar-submenu.css">
  <link rel="stylesheet" href="../../assets/css/pos.css">
  <link rel="stylesheet" href="../../../node_modules/material-icons/css/material-icons.min.css" />
  <link rel="stylesheet" href="../../../node_modules/material-symbols/index.css" />
  <link rel="stylesheet" href="../../../node_modules/animate.css/animate.css" />

  <!-- Favicons -->
  <link rel="apple-touch-icon" sizes="57x57" href="../../assets/img/icons/apple-icon-57x57.png">
  <link rel="icon" type="image/png" sizes="32x32" href="../../assets/img/icons/favicon-32x32.png">
  <link rel="manifest" href="../../assets/img/icons/manifest.json">
</head>

<body class="app-page">

  <!-- Header -->
  <?php include '../../components/header.php'; ?>

  <!-- Sidebar -->
  <?php include '../../components/menu.php'; ?>

  <!-- Main POS Content -->
  <div class="app-layout">
    <main class="app-main">
      <div class="pos-layout">
        <div class="pos-container">

          <!-- Panel Izquierdo: Productos -->
          <div class="pos-products-panel">
            <div class="pos-search-bar">
              <div class="pos-search-input">
                <input type="text"
                  id="searchProduct"
                  placeholder="Buscar por código o nombre..."
                  autocomplete="off"
                  autofocus>
              </div>
            </div>
            <div class="pos-products-grid" id="productsGrid">
              <div class="text-center p-5">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">Cargando productos...</span>
                </div>
                <p class="mt-2 text-muted">Cargando productos...</p>
              </div>
            </div>
          </div>

          <!-- Panel Derecho: Carrito -->
          <div class="pos-cart-panel">
            <div class="cart-header">
              <h4><span class="material-symbols-outlined">shopping_cart</span> Carrito de Ventas</h4>
              <button id="clearCartBtn" class="btn btn-sm btn-light" title="Limpiar carrito">
                <span class="material-symbols-outlined">delete_sweep</span>
              </button>
            </div>

            <div class="cart-items" id="cartItems">
              <div class="text-center p-5 text-muted">
                <span class="material-symbols-outlined" style="font-size: 48px;">shopping_cart</span>
                <p>Carrito vacío</p>
              </div>
            </div>

            <div class="cart-totals">
              <div class="total-line">
                <span>Subtotal:</span>
                <span id="subtotal">$0.00</span>
              </div>
              <div class="total-line">
                <span>IVA (16%):</span>
                <span id="tax">$0.00</span>
              </div>
              <div class="total-line total">
                <span><strong>TOTAL:</strong></span>
                <span id="total"><strong>$0.00</strong></span>
              </div>

              <div class="cart-actions">
                <button id="checkoutBtn" class="btn-checkout">
                  <span class="material-symbols-outlined">payments</span> Cobrar
                </button>
                <button id="clearCartBtn2" class="btn-clear">
                  <span class="material-symbols-outlined">delete</span> Limpiar
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>

  <!-- Modal: Selección de Cliente -->
  <div class="modal fade" id="clientModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content client-modal">
        <div class="modal-header">
          <h5 class="modal-title">
            <span class="material-symbols-outlined">person</span> Seleccionar Cliente
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="client-search">
            <input type="text"
              id="searchClient"
              class="form-control"
              placeholder="Buscar por nombre, cédula o teléfono..."
              autocomplete="off">
          </div>
          <div class="client-list" id="clientList">
            <div class="text-center p-3 text-muted">Escriba para buscar clientes...</div>
          </div>
          <hr>
          <button id="newClientBtn" class="btn btn-outline-primary w-100">
            <span class="material-symbols-outlined">person_add</span> Nuevo Cliente (Venta al contado)
          </button>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" id="confirmClientBtn" class="btn btn-primary" disabled>
            Continuar con Venta al Crédito
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Forma de Pago -->
  <div class="modal fade" id="paymentModal" tabindex="-1" data-bs-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">
            <span class="material-symbols-outlined">payments</span> Finalizar Venta
          </h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label class="form-label">Cliente</label>
            <p id="selectedClientName" class="form-control-plaintext fw-bold"></p>
          </div>
          <div class="mb-3">
            <label class="form-label">Total a Pagar</label>
            <p id="paymentTotal" class="form-control-plaintext h3 text-primary"></p>
          </div>
          <div class="mb-3">
            <label class="form-label">Forma de Pago</label>
            <select id="paymentMethod" class="form-select">
              <option value="EFECTIVO">Efectivo</option>
              <option value="TARJETA_CREDITO">Tarjeta de Crédito</option>
              <option value="TARJETA_DEBITO">Tarjeta de Débito</option>
              <option value="TRANSFERENCIA">Transferencia Bancaria</option>
              <option value="OTRO">Otro</option>
            </select>
          </div>
          <div class="mb-3" id="cashAmountGroup" style="display: none;">
            <label class="form-label">Monto Recibido</label>
            <input type="number" id="cashAmount" class="form-control" placeholder="0.00" step="0.01">
            <div class="mt-2">
              <span>Cambio: </span>
              <strong id="changeAmount">$0.00</strong>
            </div>
          </div>
          <div class="alert alert-info" id="creditInfo" style="display: none;">
            <span class="material-symbols-outlined">info</span>
            Esta venta se registrará a crédito. El cliente deberá pagar posteriormente.
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" id="confirmPaymentBtn" class="btn btn-success">
            Confirmar Venta
          </button>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal: Nuevo Cliente Rápido -->
  <div class="modal fade" id="newClientModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">Nuevo Cliente</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <form id="newClientForm">
            <div class="mb-2">
              <label class="form-label">Tipo Documento</label>
              <select id="newClientDocType" class="form-select">
                <option value="CEDULA">Cédula</option>
                <option value="RUC">RUC</option>
                <option value="PASAPORTE">Pasaporte</option>
              </select>
            </div>
            <div class="mb-2">
              <label class="form-label">Número Documento</label>
              <input type="text" id="newClientDocNumber" class="form-control" required>
            </div>
            <div class="mb-2">
              <label class="form-label">Nombre</label>
              <input type="text" id="newClientName" class="form-control" required>
            </div>
            <div class="mb-2">
              <label class="form-label">Teléfono</label>
              <input type="text" id="newClientPhone" class="form-control">
            </div>
            <div class="mb-2">
              <label class="form-label">Email</label>
              <input type="email" id="newClientEmail" class="form-control">
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
          <button type="button" id="saveNewClientBtn" class="btn btn-primary">Guardar y Usar</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="../../../node_modules/jquery/dist/jquery.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="../../assets/js/utils.js"></script>
  <script src="../../assets/js/app.js"></script>
  <script src="../../assets/js/pos/pos.js"></script>
  <script src="../../../node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>

  <div id="spinner-carga" style="position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(255,255,255,0.7); z-index: 9999; display: none; align-items: center; justify-content: center;">
    <div class="spinner-border text-primary" role="status" style="width: 4rem; height: 4rem;">
      <span class="visually-hidden">Cargando...</span>
    </div>
  </div>

</body>

</html>