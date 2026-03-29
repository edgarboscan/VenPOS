<?php
// Rutas del API (delegar a controladores)
// Acepta URIs que contengan '/api/login' para ser tolerante a prefijos de proyecto
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
// CSRF token endpoint (GET)
if ($_SERVER['REQUEST_METHOD'] === 'GET' && strpos($uri, '/api/csrf-token') !== false) {
  // provide a token associated to the session
  $maybe = __DIR__ . '/../src/helpers/csrf.php';
  if (file_exists($maybe))
    require_once $maybe;
  if (function_exists('csrf_get_token')) {
    $t = csrf_get_token();
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['token' => $t]);
    exit;
  }
}
if ($_SERVER['REQUEST_METHOD'] === 'POST' && strpos($uri, '/api/login/change-password') !== false) {
  if (!class_exists('\App\\Controllers\\LoginController')) {
    $maybe = __DIR__ . '/../src/controllers/LoginController.php';
    if (file_exists($maybe))
      require_once $maybe;
  }
  \App\Controllers\LoginController::changePassword();
  exit;
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && strpos($uri, '/api/login/verify') !== false) {
  if (!class_exists('\App\\Controllers\\LoginController')) {
    $maybe = __DIR__ . '/../src/controllers/LoginController.php';
    if (file_exists($maybe))
      require_once $maybe;
  }
  \App\Controllers\LoginController::verify();
  exit;
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST' && strpos($uri, '/api/login') !== false) {
  // Usar el controlador de login
  if (!class_exists('\App\\Controllers\\LoginController')) {
    // Si el autoload no está presente, intentar require manual
    $maybe = __DIR__ . '/../src/controllers/LoginController.php';
    if (file_exists($maybe)) {
      require_once $maybe;
    }
  }

  \App\Controllers\LoginController::login();
  exit;
}

// Ruta de logout por API (destruye la sesión)
if (
  (
    $_SERVER['REQUEST_METHOD'] === 'POST' || $_SERVER['REQUEST_METHOD'] === 'GET'
  ) && strpos($uri, '/api/logout') !== false
) {
  // log para diagnóstico
  error_log(sprintf("API_LOG: %s %s", $_SERVER['REQUEST_METHOD'], $uri));
  if (!class_exists('\App\\Controllers\\LoginController')) {
    $maybe = __DIR__ . '/../src/controllers/LoginController.php';
    if (file_exists($maybe))
      require_once $maybe;
  }
  \App\Controllers\LoginController::logout();
  exit;
}

// Ruta de depuración: devuelve lo que devuelve el procedimiento almacenado para un usuario
if ($_SERVER['REQUEST_METHOD'] === 'POST' && strpos($uri, '/api/login/debug') !== false) {
  if (!in_array($_SERVER['REMOTE_ADDR'], ['127.0.0.1', '::1'])) {
    http_response_code(403);
    echo json_encode(['mensaje' => 'Debug solo permitido desde localhost']);
    exit;
  }
  if (!class_exists('\App\\Controllers\\LoginController')) {
    $maybe = __DIR__ . '/../src/controllers/LoginController.php';
    if (file_exists($maybe))
      require_once $maybe;
  }
  \App\Controllers\LoginController::debug();
  exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'GET' && strpos($uri, '/api/login/verificaSession') !== false) {
  \App\Controllers\LoginController::verificaSession();
  exit;
}

// Puedes añadir aquí otras rutas si lo deseas


if (strpos($uri, '/api/getConfig') !== false) {
  if (session_status() === PHP_SESSION_NONE) {
    @session_start();
  }
  header('Content-Type: application/json; charset=utf-8');
  $resp = json_encode(['configuracion_sistema' => $_SESSION['configuracion_sistema'] ?? null]);
  if (
    json_decode($resp)->configuracion_sistema  === null
  ) {
    \App\Controllers\ConfigController::get();
    exit;
  }
  echo $resp;
  exit;
}


if (strpos($uri, '/api/usuarios') !== false) {


  if ($_SERVER['REQUEST_METHOD'] === 'GET' && strpos($uri, '/api/usuarios/perfil') !== false) {
    \App\Controllers\LoginController::verificaSession();
    exit;
  }

  if ($_SERVER['REQUEST_METHOD'] === 'GET' && strpos($uri, '/api/usuarios/roles') !== false) {
    \App\Controllers\UsuariosController::listarRoles();
    exit;
  }
  if ($_SERVER['REQUEST_METHOD'] === 'GET' && strpos($uri, '/api/usuarios/obtenerBy') !== false) {
    \App\Controllers\UsuariosController::obtenerBy();
    exit;
  }

  if ($_SERVER['REQUEST_METHOD'] === 'POST' && strpos($uri, '/api/usuarios/cambiar-contrasena') !== false) {
    \App\Controllers\LoginController::changePassword();
    exit;
  }


  if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    \App\Controllers\UsuariosController::eliminarRegistro();
    exit;
  }

  if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    \App\Controllers\UsuariosController::listar();
    exit;
  }

  if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    \App\Controllers\UsuariosController::guardar();
    exit;
  }
}
