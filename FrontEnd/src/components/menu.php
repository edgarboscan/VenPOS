<?php
// ensure session is available so $_SESSION values are readable
if (session_status() !== PHP_SESSION_ACTIVE) {
  session_start();
}
$page = basename($_SERVER['PHP_SELF']);
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
<aside class="sidebar">
  <div class="sidebar-header">
    <span class="menu-text">
      <h5>
        <div class="parent-container">
          <span class="material-symbols-outlined"
            style="font-size: 48;color: var(--primary-color); ">
            point_of_sale
          </span>&nbsp Menú Principal
        </div>
      </h5>
    </span>
  </div>
  <ul class="nav flex-column sidebar-menu">
    <li class="nav-item">
      <a class="<?php echo ($page == 'home.php') ? 'nav-link active' : 'nav-link'; ?>" href="#">
        <i class="material-symbols-outlined" style="font-size: 24px;">
          home
        </i> <span class="menu-text">Home</span>
      </a>
    </li>

    <li class="nav-item mt-3 pt-3 border-top">
      <a class="nav-link text-danger" href="logout.php">
        <i class="material-symbols-outlined" style="font-size: 24px;">
          logout
        </i> <span class="menu-text">Cerrar Sesión</span>
      </a>
    </li>
  </ul>
</aside>