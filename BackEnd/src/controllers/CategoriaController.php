<?php

namespace App\Controllers;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\Helper;

use PDOException;
use PDO;

/**
 * Controlador para manejar las operaciones relacionadas con las categorías.
 * Actualmente, esta clase está vacía y sirve como un marcador de posición para futuras implementaciones.
 */
class CategoriaController
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

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $page = (int)($_GET['pagina']) === 0 ? 1 : max(1, (int) ($_GET['pagina'] ?? 1));
    $perPage =  (int)($_GET['por_pagina']) === 0 ? 0 : max(1, min(100, (int) ($_GET['por_pagina'] ?? 10)));
    $q = $_GET['q'] ?? $_GET['search'] ?? null;
    $activo = $_GET['activo'] ?? null;

    try {
      $pdo = conectarBaseDatos();

      HelperController::checkAndLogProcedures($pdo, ['sp_categorias_listar_json']);
      $stmt = $pdo->prepare("CALL sp_categorias_listar_json(:search, :activo, :page, :per_page)");
      $stmt->execute([
        ':search' => $q,
        ':activo' => $activo,
        ':page' => $page,
        ':per_page' => $perPage
      ]);
      $categorias = $stmt->fetchAll(PDO::FETCH_ASSOC);
      echo json_encode(['success' => true, 'data' => $categorias]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => 'db_error', 'message' => 'Error al buscar categorías: ' . $e->getMessage()]);
    }
  }
}
