<?php

namespace App\Controllers;

class Helper
{
  /**
   * Garantiza que la sesión esté disponible y que el usuario tenga permiso para ver una sección.
   * @param string $section
   * @return bool
   */
  public static function authorizeSection(string $section)
  {
    if (session_status() === PHP_SESSION_NONE)
      @session_start();
    $user = $_SESSION['usuario'] ?? null;
    // Preferir arrays específicos en la sesión: $roles y $menu
    $roles = $_SESSION['roles'] ?? ($user['roles'] ?? []);
    $menu = $_SESSION['menu'] ?? $_SESSION['menus'] ?? ($user['menus'] ?? []);
    if (!$user)
      return false;
    // el rol puede venir directamente o como subobjeto
    $role = '';
    if (!empty($user['rol_nombre'])) {
      $role = $user['rol_nombre'];
    } elseif (!empty($user['role'])) {
      $role = $user['role'];
    } elseif (!empty($user['rol']) && is_array($user['rol'])) {
      $role = $user['rol']['nombre_rol'] ?? $user['rol']['nombre'] ?? '';
    }
    $role = strtolower(trim($role));
    // si aún no conocemos el rol, inferir desde id_rol
    if ($role === '' && !empty($user['id_rol'])) {
      $id = (int) $user['id_rol'];
      if ($id === 1) {
        $role = 'administrador';
      } elseif ($id === 2) {
        $role = 'operador';
      }
    }

    // superuser bypass
    if ($role === 'super administrador')
      return true;

    // check explicit permisos in roles array
    $permName = 'ver_' . $section;
    $hasRolePerm = false;
    if (!empty($roles) && is_array($roles)) {
      foreach ($roles as $r) {
        // si el rol se almacena como string, saltarlo
        if (is_string($r))
          continue;
        if (!is_array($r))
          continue;
        $list = [];
        if (!empty($r['permisos']) && is_array($r['permisos'])) {
          $list = $r['permisos'];
        } elseif (!empty($r['permisos_globales']) && is_array($r['permisos_globales'])) {
          $list = $r['permisos_globales'];
        } elseif (!empty($r['permisos_globles']) && is_array($r['permisos_globles'])) {
          // compatibilidad con typo en datos históricos
          $list = $r['permisos_globles'];
        }
        if (in_array('*', $list, true) || in_array($permName, $list, true)) {
          $hasRolePerm = true;
          break;
        }
      }
    }

    // attempt menu-based permission check
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
            $perms = $it['permisos'] ?? [];
            if (is_string($perms))
              $perms = json_decode($perms, true) ?: [];
            if (empty($perms) || (!empty($perms['puede_ver']) && (int) $perms['puede_ver'] === 1)) {
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

    return $hasRolePerm || $hasMenuPerm;
  }
  /**
   * Comprueba y registra procedimientos almacenados faltantes.
   * @param \PDO $pdo
   * @param array $procedures
   * @return void
   */
  public static function checkAndLogProcedures($pdo, array $procedures)
  {
    if (!($pdo instanceof \PDO))
      return;
    $missing = [];
    foreach ($procedures as $name) {
      try {
        $stmt = $pdo->prepare("SHOW PROCEDURE STATUS WHERE Db = DATABASE() AND Name = :name");
        $stmt->execute(['name' => $name]);
        $row = $stmt->fetch(2);
        if (!$row)
          $missing[] = $name;
      } catch (\Exception $e) {
        // Si falla la comprobación, registrar y continuar
        error_log("DashboardController: fallo comprobando procedimiento {$name}: " . $e->getMessage());
      }
    }
    if (!empty($missing)) {
      $msg = sprintf("[%s] DashboardController: procedimientos faltantes: %s (remote=%s)", date('c'), implode(', ', $missing), $_SERVER['REMOTE_ADDR'] ?? 'cli');
      error_log($msg);
      $logDir = __DIR__ . '/../../logs';
      if (!is_dir($logDir))
        @mkdir($logDir, 0755, true);
      @file_put_contents($logDir . '/missing_sp.log', $msg . PHP_EOL, FILE_APPEND | LOCK_EX);
    }
  }



  /**
   * Devuelve todo el JSON producido por sp_dashboard_json.
   * Parámetros: p_fecha_inicio,p_fecha_fin,p_top_limite
   */
  public static function json()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!self::authorizeSection('dashboard')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }
    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $inicio = $_GET['p_fecha_inicio'] ?? $_GET['fecha_inicio'] ?? null;
    $fin = $_GET['p_fecha_fin'] ?? $_GET['fecha_fin'] ?? null;
    $top = $_GET['p_top_limite'] ?? $_GET['top_limite'] ?? 10;

    try {
      $pdo = conectarBaseDatos();
      self::checkAndLogProcedures($pdo, ['sp_dashboard_json']);
      $stmt = $pdo->prepare('CALL sp_dashboard_json(:inicio,:fin,:top)');
      $stmt->execute(['inicio' => $inicio, 'fin' => $fin, 'top' => $top]);
      $row = $stmt->fetch(2);
      if ($row && isset($row['dashboard_data'])) {
        $data = json_decode($row['dashboard_data'], true);
        if (json_last_error() === JSON_ERROR_NONE) {
          // debugging: registrar en log el contenido recibido para seguimiento
          error_log("Dashboard json payload: " . json_encode($data));
          if (isset($data['top_enfermedades'])) {
            error_log("Top enfermedades count: " . count($data['top_enfermedades']));
          } else {
            error_log("Top enfermedades not present in payload");
          }
          // registrar tendencias de KPIs para facilitar depuración
          if (!empty($data['kpis']) && is_array($data['kpis'])) {
            foreach ($data['kpis'] as $k => $v) {
              if (is_array($v) && isset($v['trend'])) {
                error_log("KPI trend $k = " . $v['trend']);
              }
            }
          }
          // agregar metadatos al retorno para facil inspección en frontend
          if (!isset($data['meta']) || !is_array($data['meta'])) {
            $data['meta'] = [];
          }
          $data['meta']['top_enfermedades_count'] =
            isset($data['top_enfermedades']) && is_array($data['top_enfermedades'])
            ? count($data['top_enfermedades'])
            : 0;
          echo json_encode($data);
          return;
        }
      }
      // fallback empty structure
      error_log("Dashboard json fallback activated, sp returned nothing");
      echo json_encode(['kpis' => [], 'top_medicos' => [], 'top_enfermedades' => [], 'alertas_stock_bajo' => []]);
    } catch (\Exception $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }
}
