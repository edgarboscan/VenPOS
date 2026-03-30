<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\Helper;
// load composer autoload if present (optional)
if (file_exists(__DIR__ . '/../vendor/autoload.php')) {
  require __DIR__ . '/../vendor/autoload.php';
}

// load .env if vlucas/phpdotenv is available (look in project root)
if (class_exists('Dotenv\\Dotenv')) {
  try {
    // Intentar cargar .env en la raíz del backend
    $rootEnv = __DIR__ . '/..';
    if (file_exists($rootEnv . '/.env')) {
      $dotenv = Dotenv\Dotenv::createImmutable($rootEnv);
      $dotenv->load();
    } elseif (file_exists(__DIR__ . '/.env')) {
      // fallback: .env dentro de config/
      $dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
      $dotenv->load();
    }
  } catch (Exception $e) {
    // ignore dotenv load failures; fallback to environment variables
  }
}

define('FECHA_HOY', date("Y-m-d"));
define('DIRECTORIO', './imagenes/');

function obtenerImagen($imagen)
{
  $imagen = str_replace('data:image/png;base64,', '', $imagen);
  $imagen = str_replace('data:image/jpeg;base64,', '', $imagen);
  $imagen = str_replace(' ', '+', $imagen);
  $data = base64_decode($imagen);
  $file = DIRECTORIO . uniqid() . '.png';


  $insertar = file_put_contents($file, $data);
  return $file;
}

function selectQuery($sentencia)
{
  $bd = conectarBaseDatos();
  $respuesta = $bd->query($sentencia);
  return $respuesta->fetchAll();
}

function selectPrepare($sentencia, $parametros = [])
{
  $bd = conectarBaseDatos();
  $respuesta = $bd->prepare($sentencia);
  $respuesta->execute($parametros);
  return $respuesta->fetchAll();
}

function insertar($sentencia, $parametros)
{
  $bd = conectarBaseDatos();
  $respuesta = $bd->prepare($sentencia);
  return $respuesta->execute($parametros);
}

function eliminar($sentencia, $id)
{
  $bd = conectarBaseDatos();
  $respuesta = $bd->prepare($sentencia);
  return $respuesta->execute([$id]);
}

function editar($sentencia, $parametros)
{
  $bd = conectarBaseDatos();
  $respuesta = $bd->prepare($sentencia);
  return $respuesta->execute($parametros);
}

function conectarBaseDatos()
{
  $host = $_ENV['DB_HOST'] ?? getenv('DB_HOST') ?? '127.0.0.1';
  $db = $_ENV['DB_NAME'] ?? getenv('DB_NAME') ?? '';
  $user = $_ENV['DB_USER'] ?? getenv('DB_USER') ?? 'root';
  $pass = $_ENV['DB_PASSWORD'] ?? getenv('DB_PASSWORD') ?? '';
  $charset = $_ENV['DB_CHARSET'] ?? getenv('DB_CHARSET') ?? 'utf8mb4';
  $port = $_ENV['DB_PORT'] ?? getenv('DB_PORT') ?? '3306';


  mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
  $options = [
    \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
    \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_OBJ,
    \PDO::ATTR_EMULATE_PREPARES => false,
  ];

  $dsn = "mysql:host=$host;dbname=$db;charset=$charset;port=$port";

  try {
    $pdo = new \PDO($dsn, $user, $pass, $options);
    setAppUser($pdo);
    return $pdo;
  } catch (\PDOException $e) {
    // Re-throw the exception so callers can decide how to handle it
    throw new \PDOException($e->getMessage(), (int) $e->getCode());
  }
}

function setAppUser($pdo = null)
{
  if (isset($_SESSION['usuario_id'])) {
    Helper::checkAndLogProcedures($pdo, ['call ven_pos.sp_cambiar_empresa_contexto']);
    $stmt = $pdo->prepare("call ven_pos.sp_cambiar_empresa_contexto(?, ?)");
    $stmt->execute([$_SESSION['usuario_id'], $_SESSION['empresa_id']]);
  } else {
    // Usuario no autenticado (ej. proceso batch)
    $pdo->exec("SET @app_user_id = NULL, @app_user_name = 'sistema'");
  }
}
