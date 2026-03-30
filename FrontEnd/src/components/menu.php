<?php
// Incluir el CSS de submenús
// echo '<link rel="stylesheet" href="../assets/css/sidebar-submenu.css">';
// ensure session is available so $_SESSION values are readable
if (session_status() !== PHP_SESSION_ACTIVE) {
  session_start();
}

// Determinar base URL de la app (soporta subcarpeta como /VenPOS)
$baseUrl = '/';
$scriptName = $_SERVER['SCRIPT_NAME'] ?? '';
if ($scriptName !== '') {
  $parts = explode('/', trim($scriptName, '/'));
  if (!empty($parts[0]) && strpos($parts[0], '.php') === false) {
    $baseUrl = '/' . $parts[0];
  }
}

$currentRequestPath = parse_url($_SERVER['REQUEST_URI'] ?? '', PHP_URL_PATH);

// URL actual del script, se mantiene por compatibilidad, pero se usa path completo para cada menú
$page = basename($_SERVER['PHP_SELF']);
$menus = $_SESSION["menus"] ?? [];
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

// Normaliza URLs de menu para que funcionen desde cualquier ruta actual
function normalizeMenuUrl($url, $baseUrl = '/')
{
  $url = trim($url ?? '');
  if ($url === '' || strtoupper($url) === 'NULL') {
    return '#';
  }

  // URLs absolutas externas (http:// o https:// o //)
  if (preg_match('#^(https?:)?//#i', $url)) {
    return $url;
  }

  // Si es raíz (/xxx) lo ajusta con base de app
  if (strpos($url, '/') === 0) {
    if ($baseUrl !== '/' && $baseUrl !== '') {
      return rtrim($baseUrl, '/') . '/' . ltrim($url, '/');
    }
    return $url;
  }

  // Ruta relativa
  if ($baseUrl !== '/' && $baseUrl !== '') {
    return rtrim($baseUrl, '/') . '/' . ltrim($url, '/');
  }
  return '/' . ltrim($url, '/');
}

function isMenuItemActive($itemUrl, $currentPath, $baseUrl = '/')
{
  if (empty($itemUrl)) {
    return false;
  }
  $itemPath = parse_url(normalizeMenuUrl($itemUrl, $baseUrl), PHP_URL_PATH);
  $itemPath = rtrim(strtolower($itemPath ?? ''), '/');
  $currentPath = rtrim(strtolower($currentPath ?? ''), '/');
  return $itemPath !== '' && $itemPath === $currentPath;
}

function hasActiveDescendant($menus, $parentId, $currentPath, $baseUrl)
{
  foreach ($menus as $m) {
    if ($m['padre_id'] == $parentId && !empty($m['permisos']['puede_ver'])) {
      if (isMenuItemActive($m['url'] ?? '', $currentPath, $baseUrl)) {
        return true;
      }
      if (hasActiveDescendant($menus, $m['id'], $currentPath, $baseUrl)) {
        return true;
      }
    }
  }
  return false;
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
    <?php
    // Función recursiva para renderizar menús y submenús
    function renderMenu($menus, $parentId = null, $nivel = 0, $currentPath = '', $baseUrl = '/')
    {
      $items = array_filter($menus, function ($m) use ($parentId, $nivel) {
        return ($m['padre_id'] == $parentId || $m['padre_id'] === null) && (int)$m['nivel'] === $nivel && (!empty($m['permisos']['puede_ver']));
      });
      usort($items, function ($a, $b) {
        return ($a['orden'] ?? 0) <=> ($b['orden'] ?? 0);
      });
      foreach ($items as $item) {
        $hasChildren = count(array_filter($menus, function ($m) use ($item) {
          return $m['padre_id'] == $item['id'] && (!empty($m['permisos']['puede_ver']));
        })) > 0;
        $itemUrl = normalizeMenuUrl($item['url'] ?? '', $baseUrl);
        $isActive = isMenuItemActive($item['url'] ?? '', $currentPath, $baseUrl);
        $isOpen = $hasChildren && (hasActiveDescendant($menus, $item['id'], $currentPath, $baseUrl) || $isActive);
        $activeClass = ($isActive || $isOpen) ? 'nav-link active' : 'nav-link';
        $iconClass = ($item['tipo_icono'] === 'symbol') ? 'material-symbols-outlined' : 'material-icons-outlined';
        $liClass = 'nav-item' . ($hasChildren ? ' has-children' : '') . ($isOpen ? ' open' : '');

        echo '<li class="' . $liClass . '"';
        if ($hasChildren) echo ' tabindex="0"';
        echo '>';
        echo '<a class="' . $activeClass . '" href="' . htmlspecialchars($itemUrl) . '?title=' . urlencode($item['nombre'] ?? '') . '"';
        if ($hasChildren) echo ' onclick="event.preventDefault(); this.parentNode.classList.toggle(\'open\');"';
        echo '>';
        echo '<i class="' . $iconClass . '" style="font-size: 24px;">' . htmlspecialchars($item['icono']) . '</i> ';
        echo '<span class="menu-text">' . htmlspecialchars($item['nombre']) . '</span>';
        if ($hasChildren) {
          echo ' <span class="submenu-arrow">&#9654;</span>';
        }
        echo '</a>';
        if ($hasChildren) {
          echo '<ul class="nav flex-column submenu">';
          renderMenu($menus, $item['id'], $nivel + 1, $currentPath, $baseUrl);
          echo '</ul>';
        }
        echo '</li>';
      }
    }
    renderMenu($menus, null, 0, $currentRequestPath, $baseUrl);
    ?>

    <li class="nav-item mt-3 pt-3 border-top">
      <a class="nav-link text-danger" href="" id="mnu_logout">
        <i class="material-symbols-outlined" style="font-size: 24px;">
          logout
        </i> <span class="menu-text">Cerrar Sesión</span>
      </a>
    </li>
  </ul>
</aside>
<div class="sidebar-backdrop" id="sidebarBackdrop"></div>