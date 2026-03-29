<?php
// Middleware simple para verificar rol y sección solicitada
if (session_status() === PHP_SESSION_NONE)
  @session_start();

/**
 * Requiere que la sesión tenga un usuario y que su rol permita acceder a la sección.
 * Si no está autenticado devuelve 401 JSON y finaliza; si no tiene permiso devuelve 403 JSON y finaliza.
 * @param string $section
 * @return bool
 */
function require_section_or_abort(string $section)
{
  header('Content-Type: application/json; charset=utf-8');
  $user = $_SESSION['usuario'] ?? null;
  // Preferir arrays específicos en la sesión: $roles y $menu
  // Si no existen, intentar usar información embebida en el objeto usuario
  $roles = $_SESSION['roles'] ?? ($user['roles'] ?? []);
  $menu = $_SESSION['menu'] ?? $_SESSION['menus'] ?? ($user['menus'] ?? []);
  if (!$user) {
    http_response_code(401);
    echo json_encode(['success' => false, 'error' => 'not_authenticated', 'message' => 'No autenticado']);
    exit;
  }
  // también soportar usuario->rol.nombre_rol
  $role = '';
  if (!empty($user['rol_nombre'])) {
    $role = $user['rol_nombre'];
  } elseif (!empty($user['role'])) {
    $role = $user['role'];
  } elseif (!empty($user['rol']) && is_array($user['rol'])) {
    $role = $user['rol']['nombre_rol'] ?? $user['rol']['nombre'] ?? '';
  }
  $role = strtolower(trim($role));
  // si no se especificó nombre de rol, intentar inferir de id_rol
  if ($role === '' && !empty($user['id_rol'])) {
    $id = (int) $user['id_rol'];
    if ($id === 1)
      $role = 'administrador';
    elseif ($id === 2)
      $role = 'operador';
    // otros mapeos podría añadirse aquí según tabla
  }
  // superuser shortcut
  if ($role === 'administrador')
    return true;

  // check explicit permissions attached to the user's roles (array of strings)
  $permName = 'ver_' . $section;
  $hasRolePerm = false;
  if (!empty($roles) && is_array($roles)) {
    foreach ($roles as $r) {
      if (is_string($r))
        continue;
      if (!is_array($r))
        continue;
      // permisos list inside role record
      $list = [];
      if (!empty($r['permisos']) && is_array($r['permisos'])) {
        $list = $r['permisos'];
      } elseif (!empty($r['permisos_globales']) && is_array($r['permisos_globales'])) {
        $list = $r['permisos_globales'];
      }
      if (in_array('*', $list, true) || in_array($permName, $list, true)) {
        $hasRolePerm = true;
        break;
      }
    }
  }

  // helper para buscar en el menú recursivamente
  $hasMenuPerm = false;
  if (!empty($menu) && is_array($menu)) {
    $target = strtolower($section);
    $search = function ($items) use (&$search, $target, &$hasMenuPerm) {
      foreach ($items as $it) {
        if (!is_array($it))
          continue;
        $name = strtolower($it['nombre'] ?? '');
        $url = strtolower($it['url'] ?? '');
        if (strpos($name, $target) !== false || strpos($url, $target) !== false) {
          // también verificar permiso individual
          $perms = $it['permisos'] ?? [];
          if (is_string($perms))
            $perms = json_decode($perms, true) ?: [];
          if (empty($perms) || !empty($perms['puede_ver']) && (int) $perms['puede_ver'] === 1) {
            $hasMenuPerm = true;
            return true;
          }
        }
        if (!empty($it['children']) && is_array($it['children'])) {
          if ($search($it['children']))
            return true;
        }
      }
      return false;
    };
    $search($menu);
  }

  if (!$hasRolePerm && !$hasMenuPerm) {
    http_response_code(403);
    echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado']);
    exit;
  }
  return true;
}
