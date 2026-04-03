<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$user = $_SESSION['usuario'] ?? null;
$isLogged = !empty($user);

// determinar nombre de rol viendo posibles estructuras
$roleName = '';
if (!empty($user['rol_nombre'])) {
  $roleName = $user['rol_nombre'];
} elseif (!empty($user['role'])) {
  $roleName = $user['role'];
} elseif (!empty($user['rol']) && is_array($user['rol'])) {
  $roleName = $user['rol']['nombre_rol'] ?? $user['rol']['nombre'] ?? '';
}
$roleName = strtolower($roleName);
$showSettings = in_array($roleName, ['administrador', 'operador', 'auditor', 'supervisor', 'recursos humanos']);
$displayName = htmlspecialchars(trim(($user['nombre'] ?? '') . ' ' . ($user['apellido'] ?? '')) ?: ($user['username'] ?? 'Usuario'));
$logoSrc = htmlspecialchars($user['img_url'] ?? '../assets/img/logo.png');
if ($roleName === "") {
  if (
    isset($user['resultado'])
  ) {
    $resultado =
      json_decode($user['resultado']);

    $usr = $resultado->usuario;
    $nombre_completo = $usr->nombre . ' ' . $usr->apellido;
    $roleName = $resultado->acceso->roles[0]->nombre;
    $logoSrc = htmlspecialchars(
      $usr->img_url ?? '../assets/img/logo.png'
    );
  }
}
$pageName = $nombre = isset($_GET['title']) ? ' - ' . $_GET['title'] : '';
// $pageName = $nombre = "";

// $part = explode('/', $currentPage);
// $part =  array_slice($part, 0, -1);
// $folder = end($part);
// $pageName = htmlspecialchars(ucfirst(basename($_SERVER['PHP_SELF'], '.php')));
// if ($pageName === 'Index') {
//   $pageName = $folder;
// }
?>


<header class="main-header">

  <div class="parent-container">
    <button class="hamburger-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
    <p class="page-title hide-text" style="color: var(--light-color);">&nbsp;VenPos<?= $pageName ?></p>
  </div>



  <div class="user-menu">
    <button id="darkModeToggle" class="btn btn-sm" style="background: rgba(255,255,255,0.2); border: none; color: white; border-radius: 30px; padding: 5px 12px;">
      <i class="fas fa-moon"></i>
      <!-- <span class="mode-text">Modo Oscuro</span> -->
    </button>
    <div class="dropdown d-inline-block" id="notificationsDropdown">
      <button class="btn btn-sm position-relative" type="button" data-bs-toggle="dropdown" aria-expanded="false" style="background: rgba(255,255,255,0.2); border: none; color: white; border-radius: 30px; padding: 5px 12px;">
        <i class="fas fa-bell"></i>
        <span id="notifBadge" class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem; display: none;">0</span>
      </button>
      <ul class="dropdown-menu dropdown-menu-end" style="min-width: 280px; max-height: 400px; overflow-y: auto;">
        <li>
          <h6 class="dropdown-header">Notificaciones</h6>
        </li>
        <li>
          <hr class="dropdown-divider">
        </li>
        <li id="notificationsList">
          <div class="text-center p-3 text-muted">Cargando...</div>
        </li>
      </ul>
    </div>
    <div class="nav-logo d-flex align-items-center" style="position:relative;gap:.6rem;">
      <button id="header_logo_btn" aria-haspopup="true" aria-expanded="false" title="Opciones usuario"
        style="background:transparent;border:0;padding:0;cursor:pointer;color:inherit;">
        <img src="<?= $logoSrc ?>" alt="Logo"
          style="width:36px;height:36px;object-fit:cover;border-radius:4px;border:1px solid rgba(255,255,255,0.15);box-shadow:0 1px 3px rgba(0,0,0,.25);" />
      </button>

      <div id="header_logo_menu" role="menu" aria-label="Opciones usuario" hidden
        style="position:absolute;right:0;top:calc(100% + .5rem);min-width:240px;background:#fff;color:#111;border-radius:6px;box-shadow:0 8px 20px rgba(0,0,0,.2);padding:.5rem;z-index:1050;">
        <?php if ($isLogged): ?>
          <div
            style="padding:.25rem .5rem;border-bottom:1px solid rgba(0,0,0,.05);margin-bottom:.5rem;text-align:left;display:flex;gap:.5rem;align-items:center;">
            <img src="<?= $logoSrc ?>" alt="avatar"
              style="width:42px;height:42px;border-radius:6px;object-fit:cover;border:1px solid rgba(0,0,0,.06);">
            <div>
              <strong style="display:block"><?= $displayName ?></strong>
              <small style="color:rgba(0,0,0,.6);"><?= htmlspecialchars($roleName ?? '') ?></small>
            </div>
          </div>

          <ul style="list-style:none;margin:0;padding:0;">
            <?php if ($showSettings): ?>
              <li><a href="./setting.php" role="menuitem"
                  style="display:block;padding:.4rem .5rem;color:inherit;text-decoration:none;">⚙️ Configuración</a></li>
              </li>
            <?php endif; ?>
            <li><a href="./perfil.php" role="menuitem"
                style="display:block;padding:.4rem .5rem;color:inherit;text-decoration:none;">👤 Perfil</a></li>
            <li><a href="./cambiar_password.php" role="menuitem"
                style="display:block;padding:.4rem .5rem;color:inherit;text-decoration:none;">🔒 Cambiar contraseña</a></li>
            <li><a id="btn_logout" role="menuitem"
                style="display:block;padding:.4rem .5rem;color:red;text-decoration:none;cursor: pointer;">❌ Cerrar sesión</a></li>
          </ul>
        <?php else: ?>
          <div style="padding:.25rem .5rem;text-align:left;">No autenticado</div>
          <a href="../../../index.php" role="menuitem"
            style="display:block;padding:.4rem .5rem;color:inherit;text-decoration:none;">Iniciar sesión</a>
        <?php endif; ?>


      </div>
    </div>
  </div>
</header>

<script>
  (function() {
    const btn = document.getElementById('header_logo_btn');
    const menu = document.getElementById('header_logo_menu');


    const body = document.body;
    if (!btn || !menu) return;
    btn.addEventListener('click', function(e) {
      e.stopPropagation();
      const isHidden = menu.hasAttribute('hidden');
      if (isHidden) {
        menu.removeAttribute('hidden');
        btn.setAttribute('aria-expanded', 'true');
      } else {
        menu.setAttribute('hidden', '');
        btn.setAttribute('aria-expanded', 'false');
      }
    });

    document.addEventListener('click', function(e) {
      if (!menu.contains(e.target) && !btn.contains(e.target)) {
        menu.setAttribute('hidden', '');
        btn.setAttribute('aria-expanded', 'false');
      }
    });

    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        menu.setAttribute('hidden', '');
        btn.setAttribute('aria-expanded', 'false');
      }
    });


    // logout confirmation: usar SweetAlert2 si está disponible, sino fallback a confirm()
    (function() {

    })();
  })();
</script>