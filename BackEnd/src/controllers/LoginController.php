<?php

namespace App\Controllers;

use App\Models\Usuario;
use PDOException;
use PDO;

session_start();


class LoginController
{
  public static function login()
  {
    header('Content-Type: application/json; charset=utf-8');

    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input) || empty($input['username']) || empty($input['password'])) {
      http_response_code(400);
      echo json_encode(['mensaje' => 'username and password required', 'success' => false]);
      return;
    }

    $username = $input['username'];
    $password = $input['password'];

    // El procedimiento ahora devuelve los datos del usuario (incluyendo password_hash bcrypt)
    try {
      $result = Usuario::loginWithProcedure($username);

      if (!is_array($result) || empty($result)) {
        http_response_code(401);
        echo json_encode(['mensaje' => 'Usuario no encontrado', 'success' => false]);
        return;
      }

      // El SP puede devolver la información dentro de 'datos_usuario' o 'usuario'
      $datos = json_decode($result['resultado'], true);


      $user = $datos['datos_usuario'] ?? $result['usuario'] ?? $result;
      // $user = $result['datos_usuario'] ?? $result['usuario'] ?? $result;

      // Normalizar $user: puede venir como JSON string o stdClass desde el SP
      if (is_string($user)) {
        $maybe = json_decode($user, true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($maybe)) {
          $user = $maybe;
        }
      } elseif (is_object($user)) {
        $user = (array) $user;
      }

      $resultado = json_decode($user['resultado'], true);
      // Depuración: verificar password (se registra solo si config 'debug' está activo)
      $menus = $resultado['acceso']['menus'] ?? [];
      $roles = $resultado['acceso']['roles'] ?? [];
      $empresas = $resultado['acceso']['empresas'] ?? [];

      $verified = false;
      $user_hash = is_array($user) ? ($resultado['seguridad']['password_hash'] ?? null) : null;
      if (!empty($user_hash)) {
        $verified = password_verify($password, $user_hash);
      }
      // cargar config para decidir si loggear
      $cfg = [];
      $cfgFile = __DIR__ . '/../../config/config.php';
      if (file_exists($cfgFile))
        $cfg = include $cfgFile;
      $isDebug = !empty($cfg['debug']);
      if ($isDebug) {
        $remote = $_SERVER['REMOTE_ADDR'] ?? '';
        $hid = is_array($user) ? (isset($user['id_usuario']) ? $user['id_usuario'] : (isset($user['id']) ? $user['id'] : 'n/a')) : 'n/a';
        error_log(sprintf("DEBUG_LOGIN user=%s id=%s verified=%s remote=%s hash_prefix=%s", $username, $hid, $verified ? '1' : '0', $remote, substr($user_hash ?? '', 0, 60)));
      }

      // Si la cuenta está bloqueada
      if (isset($user['bloqueado']) && (int) $user['bloqueado'] === 1) {
        http_response_code(403);
        echo json_encode(['mensaje' => 'Cuenta bloqueada', 'success' => false]);
        return;
      }
      //para mantener compatibilidad con el formato anterior del SP
      // Verificar que exista el hash y validar con password_verify (bcrypt)
      if (empty($resultado['seguridad']['password_hash']) || !$verified) {
        // Intentos o políticas de seguridad pueden manejarse aquí (actualizar DB si es necesario)
        http_response_code(401);
        // Proveer información útil pero genérica
        $remaining = null;
        if (isset($result['politicas_seguridad']['max_intentos']) && isset($user['intentos_fallidos'])) {
          $remaining = (int) $result['politicas_seguridad']['max_intentos'] - (int) $user['intentos_fallidos'];
        }
        $msg = 'Credenciales inválidas';
        if ($remaining !== null)
          $msg .= ", intentos restantes: {$remaining}";

        echo json_encode(['mensaje' => $msg, 'success' => false]);
        return;
      }

      // Si requiere verificación adicional (ej. 2FA), devolver esa señal al cliente
      if (!empty($result['requiere_verificacion'])) {
        echo json_encode(['mensaje' => 'Usuario encontrado, requiere verificación de contraseña', 'success' => true, 'datos_usuario' => $user, 'politicas_seguridad' => $result['politicas_seguridad'] ?? null, 'requiere_verificacion' => true]);
        return;
      }

      // Login exitoso: crear sesión y construir respuesta estándar
      // Crear/asegurar sesión
      if (session_status() !== PHP_SESSION_ACTIVE) {
        // configurar cookies de sesión
        $secure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || (!empty($cfg['force_secure_cookies']));
        session_set_cookie_params([
          'httponly' => true,
          'samesite' => 'Lax',
          'secure' => $secure,
        ]);
        session_start();
      }
      // Guardar información mínima del usuario en sesión
      // usamos la variable $user ya normalizada arriba (puede venir de datos.usuario
      // o directamente de $result según el SP)
      $cfgFile = __DIR__ . '/../../config/config.php';
      if (file_exists($cfgFile))
        $cfg = include $cfgFile;

      $_SESSION['APP'] = $cfg["app_name"];
      $_SESSION['usuario'] = $user;
      $_SESSION['menus'] = $menus ?? [];
      $_SESSION['roles'] = $roles ?? [];
      $_SESSION['empresas'] = $empresas ?? [];

      $_SESSION['auth'] = true;
      $_SESSION['start'] = time();
      $_SESSION['expire'] = $_SESSION['start'] + (40 * 60);

      $configuracion_sistema = \App\Models\Usuario::getConfiguracionSistema() ?? null;
      $_SESSION['configuracion_sistema'] = $configuracion_sistema;
      // si el SP no devolvió nombre de rol, recuperarlo desde la tabla roles usando el id_rol
      if (empty($_SESSION['usuario']['rol_nombre']) && !empty($_SESSION['usuario']['id_rol'])) {
        try {
          $maybeDb = __DIR__ . '/../../config/db.php';
          if (file_exists($maybeDb))
            require_once $maybeDb;
          if (function_exists('conectarBaseDatos')) {
            $pdo = conectarBaseDatos();
            $stmt = $pdo->prepare('SELECT nombre_rol,nivel_prioridad FROM roles WHERE id_rol=:id LIMIT 1');
            $stmt->execute(['id' => $_SESSION['usuario']['id_rol']]);
            $row = $stmt->fetch(2);
            if ($row) {
              $_SESSION['usuario']['rol_nombre'] = $row['nombre_rol'];
              $_SESSION['usuario']['nivel_prioridad'] = $row['nivel_prioridad'];
            }
          }
        } catch (\Exception $e) {
          // silencioso si falla
        }
      }

      // Login exitoso: construir respuesta estándar
      $out = [
        'mensaje' => 'Login exitoso',
        'success' => true,
        'usuario' => $user,
        'acceso' => $result['acceso'] ?? null,
        'timestamp' => date('Y-m-d H:i:s'),
        'session_id' => bin2hex(random_bytes(16)),
        'configuracion_sistema' => $result['configuracion_sistema'] ?? null,
      ];

      echo json_encode($out);
      return;
    } catch (\Exception $e) {
      // En desarrollo devolvemos el JSON de ejemplo si hay fallo con la BD
      $sample = [
        "mensaje" => "Login exitoso",
        "success" => true,
        "usuario" => [
          "rol" => [
            "id_rol" => 1,
            "permisos" => [["modulo" => "obras", "permiso" => "CRUD"]],
            "nombre_rol" => "Administrador",
            "descripcion" => "Acceso total al sistema",
            "nivel_prioridad" => 1
          ],
          "email" => "edgarboscan@gmail.com",
          "telefono" => "04246853071",
          "username" => "eboscan",
          "id_usuario" => 1,
          "estadisticas" => [
            "obras_asignadas" => 0,
            "pagos_procesados_mes" => 0,
            "gastos_registrados_mes" => 0,
            "atenciones_realizadas_mes" => 0
          ],
          "preferencias" => [
            "tema" => "claro",
            "idioma" => "es",
            "notificaciones" => true,
            "items_por_pagina" => 25
          ],
          "acceso_rapido" => null,
          "ultimo_acceso" => "2026-02-24 11:14:27.000000",
          "fecha_registro" => "2026-02-24 10:35:03.000000",
          "nombre_completo" => "Edgar Boscan"
        ],
        // sample accesos for debugging
        "acceso" => [
          "menus" => [],
          "roles" => []
        ],
        "timestamp" => "2026-02-24 11:14:27.000000",
        "session_id" => "82f83b76-1193-11f1-bf01-d8cb8aee3803",
        "permisos_especiales" => [
          "puede_ver_reportes" => true,
          "puede_aprobar_gastos" => 1,
          "puede_gestionar_usuarios" => 1
        ],
        "configuracion_sistema" => [
          "entorno" => "produccion",
          "version" => "1.0.0",
          "session_timeout" => 3600,
          "max_intentos_login" => 5
        ]
      ];

      echo json_encode($sample);
      return;
    }
  }

  public static function changePassword()
  {
    header('Content-Type: application/json; charset=utf-8');
    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input) || empty($input['username']) || empty($input['new_password'])) {
      http_response_code(400);
      echo json_encode(['mensaje' => 'username and new_password required', 'success' => false]);
      return;
    }

    // Validar CSRF token
    $maybe = __DIR__ . '/../../src/helpers/csrf.php';
    if (file_exists($maybe))
      require_once $maybe;
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    $csrf = $headers['X-CSRF-Token'] ?? $headers['x-csrf-token'] ?? ($input['csrf_token'] ?? $_SESSION['csrf_token'] || null);
    if (!function_exists('csrf_validate_token') || !csrf_validate_token($csrf)) {
      http_response_code(403);
      echo json_encode(['mensaje' => 'CSRF token invalid', 'success' => false]);
      return;
    }
    $username = isset($input['username']) ? $input['username'] : null;
    $new = isset($input['new_password']) ? $input['new_password'] : null;
    $old = isset($input['old_password']) ? $input['old_password'] : null;

    $hash = password_hash($new, PASSWORD_BCRYPT, ['cost' => 10]);

    $ok = \App\Models\Usuario::updatePassword($username, $hash, $hash_old);
    if ($ok) {
      echo json_encode(['mensaje' => 'Contraseña actualizada', 'success' => true]);
      return;
    }

    http_response_code(500);
    echo json_encode(['mensaje' => 'No se pudo actualizar la contraseña', 'success' => false]);
  }

  public static function verify()
  {
    header('Content-Type: application/json; charset=utf-8');
    $input = json_decode(file_get_contents('php://input'), true);

    // Validar CSRF token
    $maybe = __DIR__ . '/../../src/helpers/csrf.php';
    if (file_exists($maybe))
      require_once $maybe;
    $headers = function_exists('getallheaders') ? getallheaders() : [];
    $csrf = $headers['X-CSRF-Token'] ?? $headers['x-csrf-token'] ?? ($input['csrf_token'] ?? null);
    if (!function_exists('csrf_validate_token') || !csrf_validate_token($csrf)) {
      http_response_code(403);
      echo json_encode(['mensaje' => 'CSRF token invalid', 'success' => false]);
      return;
    }

    if (!is_array($input) || empty($input['username']) || empty($input['code'])) {
      http_response_code(400);
      echo json_encode(['mensaje' => 'username and code required', 'success' => false]);
      return;
    }

    // En este ejemplo simplificado aceptamos código '123456' como válido.
    if ($input['code'] === '123456') {
      echo json_encode(['mensaje' => 'Verificación correcta', 'success' => true]);
      return;
    }

    http_response_code(401);
    echo json_encode(['mensaje' => 'Código inválido', 'success' => false]);
  }

  public static function logout()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (session_status() !== PHP_SESSION_ACTIVE) {
      session_start();
    }
    // Clear session data
    $_SESSION = [];
    // Remove session cookie if used
    if (ini_get('session.use_cookies')) {
      $params = session_get_cookie_params();
      setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
    }

    @session_unset();
    @session_destroy();
    echo json_encode(['mensaje' => 'Logout exitoso', 'success' => true]);




    return;
  }

  // Método de depuración para ver exactamente lo que devuelve el SP
  public static function debug()
  {
    header('Content-Type: application/json; charset=utf-8');
    $input = json_decode(file_get_contents('php://input'), true);
    if (!is_array($input) || empty($input['username'])) {
      http_response_code(400);
      echo json_encode(['mensaje' => 'username required', 'success' => false]);
      return;
    }
    $username = $input['username'];
    try {
      $result = \App\Models\Usuario::loginWithProcedure($username);
      echo json_encode(['debug' => true, 'remote_addr' => $_SERVER['REMOTE_ADDR'] ?? null, 'result' => $result]);
      return;
    } catch (\Exception $e) {
      http_response_code(500);
      echo json_encode(['mensaje' => 'error', 'error' => $e->getMessage()]);
      return;
    }
  }

  public static function verificaSession()
  {
    header('Content-Type: application/json; charset=utf-8');

    $cfgFile = __DIR__ . '/../../config/config.php';
    if (file_exists($cfgFile))
      $cfg = include $cfgFile;

    $app_name = $cfg["app_name"];

    if ($_SESSION['APP'] !== $app_name) {
      session_destroy();
      header("Location: ../../../index.php");
      echo json_encode([
        'logueado' => false,
        'msj' => 'Sesión de Usuario Expirada'
      ]);
    }


    if (isset($_SESSION['expire']) && time() > $_SESSION['expire']) {
      session_destroy();
      header("Location: ../../../index.php");
      echo json_encode([
        'logueado' => false,
        'msj' => 'Sesión de Usuario Expirada'
      ]);
    }

    $csrf = $_SESSION['csrf_token'];
    $maybe = __DIR__ . '/../helpers/csrf.php';

    if (file_exists($maybe))
      require_once $maybe;
    if (!function_exists('csrf_validate_token') || !csrf_validate_token($csrf)) {
      http_response_code(403);
      echo json_encode(['mensaje' => 'CSRF token invalid', 'success' => false]);
      return;
    }


    $resp = json_encode([
      'success' => isset($_SESSION['usuario']),
      'logueado' => isset($_SESSION['usuario']),
      'usuario' =>
      json_decode($_SESSION['usuario']['resultado']),
      'configuracion_sistema' =>
      json_decode(json_encode($_SESSION['configuracion_sistema']))

    ]);
    echo $resp;
  }
}
