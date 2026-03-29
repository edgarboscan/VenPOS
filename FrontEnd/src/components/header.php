<?php
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

?>


<header class="main-header">

  <div class="parent-container">
    <div class="header-left menu-text">

      <button id="btn_toggle_sidebar" class="hamburger-btn" aria-label="Alternar menú lateral" title="Alternar menú"
        style="background:transparent;border:0;padding:.25rem;">
        <i class="material-symbols-outlined" aria-hidden="true">menu</i>
      </button>

    </div>
    <p class="page-title" style="color: var(--light-color);">Dashboard de Gestión</p>
  </div>

  <div class="user-menu">
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
            <li><a href="#" id="btn_logout" role="menuitem"
                style="display:block;padding:.4rem .5rem;color:red;text-decoration:none;">❌ Cerrar sesión</a></li>
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
    const btnToggle = document.getElementById('btn_toggle_sidebar');
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
    if (btnToggle) {
      btnToggle.addEventListener('click', function(e) {
        e.preventDefault();
        const sidebar = document.querySelector('.sidebar');
        const isMobile = window.innerWidth <= 768;
        if (isMobile) {
          sidebar.classList.toggle('active');
        } else {
          body.classList.toggle('sidebar-collapsed');
        }
      });
    }
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
      const logoutBtn = document.getElementById('btn_logout');
      if (!logoutBtn) return;
      logoutBtn.addEventListener('click', function(ev) {
        ev.preventDefault();
        const doLogout = async () => {
          try {
            const resp = await fetch('../../../backend/public/index.php/api/logout', {
              method: 'POST',
              credentials: 'include',
              headers: {
                'Accept': 'application/json'
              }
            });
            if (resp.ok) {
              try {
                await resp.json();
              } catch (e) {
                /* ignore non-json */
              }
              window.location.href = '../../../index.php';
              return;
            }
            if (resp.status === 401 || resp.status === 403) {
              window.location.href = '../../../index.php';
              return;
            }
            if (typeof Swal !== 'undefined') {
              Swal.fire('Error', 'No se pudo cerrar sesión. Intente de nuevo.', 'error');
            } else {
              alert('No se pudo cerrar sesión. Intente de nuevo.');
            }
          } catch (err) {
            if (typeof Swal !== 'undefined') {
              Swal.fire('Error', 'No se pudo conectar al servidor.', 'error');
            } else {
              alert('No se pudo conectar al servidor.');
            }
          }
        };

        if (typeof Swal !== 'undefined') {
          Swal.fire({
            title: '¿Desea cerrar sesión?',
            text: 'Se le redirigirá a la página de inicio de sesión.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Sí, cerrar sesión',
            cancelButtonText: 'Cancelar',
          }).then((result) => {
            if (result.isConfirmed) doLogout();
          });
        } else {
          if (window.confirm('¿Desea cerrar sesión?')) doLogout();
        }
      });
    })();
  })();
</script>