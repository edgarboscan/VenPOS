<?php

namespace App\Controllers;

use App\Controllers\DashboardController;


class ConfigController
{
  public static function get()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(HelperController::class)) {
      $maybe = __DIR__ . '/HelperController.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $incluir_privada = max(1, (int) ($_GET['incluir_privada'] ?? 1));
    $filtro_clave = $_GET['filtro_clave'] ?? null;

    require_once __DIR__ . '/../../config/db.php';

    try {

      $bd = conectarBaseDatos();
      $stmt = $bd->prepare('CALL sp_get_configuracion_sistema(?, ?)');
      $stmt->bindParam(1, $incluir_privada, \PDO::PARAM_INT);
      $stmt->bindParam(2, $filtro_clave);

      $stmt->execute();
      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
      echo json_encode($rows);
    } catch (\Exception $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }
}
