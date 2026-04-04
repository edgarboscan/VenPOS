<?php

namespace App\Controllers;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\Helper;

use PDOException;
use PDO;

/**
 * Controlador para manejar el inventario en el sistema.
 * Proporciona métodos para listar los productos en el inventario con soporte para paginación y filtros.
 */
class InventarioController
{
  //============================ Area Productos ============================ 

  /**
   * Método para manejar solicitudes GET a /api/inventario
   * Actualmente devuelve un mensaje de que el método no está implementado y carga la configuración de la base de datos si existe.
   */
  public static function get_listado()
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
    $empresa_id = $_SESSION['empresas'][0]['id'] ?? null;
    $categoria_id = $_GET['categoria_id'] ?? null;
    $marca_id = $_GET['marca_id'] ?? null;
    $tipo = $_GET['tipo'] ?? null;

    if ($empresa_id === null) {
      http_response_code(400);
      echo json_encode(['success' => false, 'error' => 'missing_empresa_id', 'message' => 'Falta el ID de la empresa en la sesión']);
      return;
    }

    try {
      $pdo = conectarBaseDatos();
      // no hay stored procedure definido en la base original, pero dejamos el
      // chequeo para que se registre si se agrega en el futuro
      HelperController::checkAndLogProcedures($pdo, ['sp_productos_con_precios_json']);


      $stmt = $pdo->prepare(
        "CALL sp_productos_con_precios_json(:empresa_id, :search, :categoria_id,:marca_id,:tipo_producto,:pagina,:por_pagina, @p_mensaje, @p_codigo_resultado)"
      );

      $stmt->execute([
        'empresa_id' => $empresa_id,
        'search' => "$q",
        'categoria_id' => $categoria_id,
        'marca_id' => $marca_id,
        'tipo_producto' => $tipo,
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

  /**
   * Método para manejar solicitudes GET a /api/inventario/chkExiste
   * Verifica si un producto existe en el inventario basado en su ID o código.
   */
  public static function chkExiste()
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

    $id = $_GET['id'] ?? null;
    $codigo = $_GET['codigo'] ?? null;

    try {
      $pdo = conectarBaseDatos();
      HelperController::checkAndLogProcedures($pdo, ['sp_producto_existe']);
      $stmt = $pdo->prepare("CALL sp_producto_existe(:id, :codigo)");
      $stmt->execute([
        ':id' => $id,
        ':codigo' => $codigo
      ]);

      $result = $stmt->fetch(PDO::FETCH_ASSOC);
      $result = json_decode($result['result'], true);

      echo json_encode([
        'success' => true,
        'exists' => isset($result['exists']) ? (bool) $result['exists'] : false,
        'message' => ((isset($result['exists']) && $result['exists']) ? 'El producto ya existe' : 'El producto no existe'),
        'data' => isset($result['data']) ? $result['data'] : null,
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => 'db_error', 'message' => 'Error al verificar existencia del producto: ' . $e->getMessage()]);
    }
  }

  /**
   * Método para manejar solicitudes POST a /api/inventario
   * Actualmente devuelve un mensaje de que el método no está implementado.
   */
  public static function guardar()
  {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success' => false, 'message' => 'Método guardar no implementado']);
  }
  /**
   * Método para manejar solicitudes DELETE a /api/inventario
   * Actualmente devuelve un mensaje de que el método no está implementado.
   */

  public static function eliminar()
  {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success' => false, 'message' => 'Método eliminar no implementado']);
  }

  public static function actualizar()
  {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success' => false, 'message' => 'Método actualizar no implementado']);
  }


  //============================ Area Codigos ============================ 

  /**
   * Método para manejar solicitudes GET a /api/inventario/chkCodigoExiste
   * Verifica si un codigo existe en el inventario basado en su ID o código.
   */
  public static function chkCodigoExiste()
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

    $id = $_GET['id'] ?? null;
    $codigo = $_GET['codigo'] ?? null;


    if ($id === null && $codigo === null) {
      http_response_code(400);
      echo json_encode(['success' => false, 'error' => 'missing_parameters', 'message' => 'Falta el ID o el código para verificar']);
      return;
    }

    try {
      $pdo = conectarBaseDatos();
      HelperController::checkAndLogProcedures($pdo, ['sp_codigo_producto_existe']);
      $stmt = $pdo->prepare("CALL sp_codigo_producto_existe(:id, :codigo)");
      $stmt->execute([
        ':id' => $id,
        ':codigo' => $codigo
      ]);

      $result = $stmt->fetch(PDO::FETCH_ASSOC);
      $result = json_decode($result['result'], true);

      echo json_encode([
        'success' => true,
        'exists' => isset($result['exists']) ? (bool) $result['exists'] : false,
        'message' => ((isset($result['exists']) && $result['exists']) ? 'El codigo ya existe' : 'El codigo no existe'),
        'data' => isset($result['data']) ? $result['data'] : null,
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => 'db_error', 'message' => 'Error al verificar existencia del codigo: ' . $e->getMessage()]);
    }
  }

  public static function guardarCodigo()
  {
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['success' => false, 'message' => 'Método guardarCodigo no implementado']);
  }

  public static function eliminarCodigo()
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

    $id = $_GET['id'] ?? null;


    if ($id === null && $codigo === null || $producto_id === null || $tipo_codigo === null) {
      http_response_code(400);
      echo json_encode(['success' => false, 'error' => 'missing_parameters', 'message' => 'Falta el ID o el código para eliminar']);
      return;
    }
  }

  public static function actualizarCodigo()
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

    $input = json_decode(file_get_contents('php://input'), true);
    if ($input) {
      $id = $input['id'] ?? null;
      $codigo = $input['codigo'] ?? null;
      $tipo_codigo = $input['tipo_codigo'] ?? null;
      $activo = $input['activo'] ?? null;
    } else {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => 'db_error', 'message' => 'Error al procesar la solicitud: no se pudo parsear el JSON de entrada']);
      return;
    }

    if ($id === null && $codigo === null || $tipo_codigo === null) {
      http_response_code(400);
      echo json_encode(['success' => false, 'error' => 'missing_parameters', 'message' => 'Falta el ID o el código para eliminar']);
      return;
    }

    try {
      $pdo = conectarBaseDatos();
      HelperController::checkAndLogProcedures($pdo, ['sp_codigo_producto_actualizar_json']);
      $stmt = $pdo->prepare("CALL sp_codigo_producto_actualizar_json(:id,  :tipo_codigo, :codigo, :activo)");
      $stmt->execute([
        ':id' => $id,
        ':tipo_codigo' => $tipo_codigo,
        ':codigo' => $codigo,
        ':activo' => $activo
      ]);

      echo json_encode([
        'success' => true,
        'message' => 'Código actualizado exitosamente'
      ]);
      exit;
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => 'db_error', 'message' => 'Error al actualizar el código: ' . $e->getMessage()]);
    }
  }
}
