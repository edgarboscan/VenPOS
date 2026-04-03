<?php

namespace App\Controllers;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\Helper;

use PDOException;
use PDO;

class UnidadMedidaController
{

  public static function search()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(HelperController::class)) {
      $maybe = __DIR__ . '/HelperController.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    // permiso de intervenciones para mantener compatibilidad con modal
    if (!HelperController::authorizeSection('ver')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;
    $page = (int)($_GET['pagina']) === 0 ? 1 : max(1, (int) ($_GET['pagina'] ?? 1));
    $perPage =  (int)($_GET['por_pagina']) === 0 ? 0 : max(1, min(100, (int) ($_GET['por_pagina'] ?? 10)));
    $q = $_GET['q'] ?? $_GET['search'] ?? null;

    $activo = $_GET['activo'] ?? null;



    try {
      $pdo = conectarBaseDatos();
      // no hay stored procedure definido en la base original, pero dejamos el
      // chequeo para que se registre si se agrega en el futuro
      HelperController::checkAndLogProcedures($pdo, ['sp_unidades_medida_listar_json']);


      $stmt = $pdo->prepare(
        "CALL sp_unidades_medida_listar_json(:search, :activo, :pagina,:por_pagina, @p_mensaje, @p_codigo_resultado)"
      );

      $stmt->execute([
        'search' => "$q",
        'activo' => $activo,
        'pagina' => $page,
        'por_pagina' => $perPage
      ]);

      $unidades = $stmt->fetchAll(\PDO::FETCH_ASSOC);

      $stmt->closeCursor();

      $outputStmt = $pdo->query("select  @p_mensaje, @p_codigo_resultado;");
      $out = $outputStmt->fetch(PDO::FETCH_ASSOC);


      $code = isset($out['@p_codigo_resultado']) ? (int) $out['@p_codigo_resultado'] : 500;
      $msg = $out['@p_mensaje'] ?? 'Operación completada';

      $status = ($code >= 200 && $code < 300) ? true : false;

      echo json_encode(['success' => $status, 'data' => $unidades, 'message' => $msg]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }

  /**
   * Método para manejar solicitudes GET a /api/medidas
   * Devuelve un listado de unidades de medida con paginación y filtros opcionales.
   */
  public static function get_listMedidas()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(HelperController::class)) {
      $maybe = __DIR__ . '/HelperController.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    // permiso de intervenciones para mantener compatibilidad con modal
    if (!HelperController::authorizeSection('ver')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;
    $page = (int)($_GET['pagina']) === 0 ? 1 : max(1, (int) ($_GET['pagina'] ?? 1));
    $perPage =  (int)($_GET['por_pagina']) === 0 ? 0 : max(1, min(100, (int) ($_GET['por_pagina'] ?? 10)));
    $q = $_GET['q'] ?? $_GET['search'] ?? null;

    $activo = $_GET['activo'] ?? null;



    try {
      $pdo = conectarBaseDatos();
      // no hay stored procedure definido en la base original, pero dejamos el
      // chequeo para que se registre si se agrega en el futuro
      HelperController::checkAndLogProcedures($pdo, ['sp_unidades_medida_listar_json']);


      $stmt = $pdo->prepare(
        "CALL sp_unidades_medida_listar_json(:search, :activo, :pagina,:por_pagina, @p_mensaje, @p_codigo_resultado)"
      );

      $stmt->execute([
        'search' => "$q",
        'activo' => $activo,
        'pagina' => $page,
        'por_pagina' => $perPage
      ]);

      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);

      $stmt->closeCursor();

      $outputStmt = $pdo->query("select  @p_mensaje, @p_codigo_resultado;");
      $out = $outputStmt->fetch(PDO::FETCH_ASSOC);


      $code = isset($out['@p_codigo_resultado']) ? (int) $out['@p_codigo_resultado'] : 500;
      $msg = $out['@p_mensaje'] ?? 'Operación completada';

      $status = ($code >= 200 && $code < 300) ? true : false;

      echo json_encode([
        'success' => $status,
        'message' => $msg,
        'data' => $rows,
        'pagination' => [
          'current_page' => $page,
          'per_page' => $perPage,
          'total' => (int) ($out['total'] ?? 0),
          'pages' => (int) ($out['pages'] ?? 0)
        ]
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }
}
