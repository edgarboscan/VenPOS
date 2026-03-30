<?php

namespace App\Controllers;

error_reporting(E_ALL);
ini_set('display_errors', 1);

use App\Controllers\Helper;
use PDOException;
use PDO;

class UsuariosController
{
  /**
   * Devuelve lista de alergias para los autocompletes y otras búsquedas.
   * GET params aceptados:
   *   - q / search  : texto de búsqueda (se aplica a nombre o descripción)
   * Se retorna un array JSON de filas con columnas como `id`, `nombre`,
   * `descripcion`, etc.
   */
  public static function listar()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(Helper::class)) {
      $maybe = __DIR__ . '../helpers/Helper.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    // permiso de intervenciones para mantener compatibilidad con modal
    if (!Helper::authorizeSection('ver')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;
    $page = isset($_GET['pagina']) ? (int)($_GET['pagina']) === 0 ? 1 : max(1, (int) ($_GET['pagina'] ?? 1)) : 1;
    $perPage = isset($_GET['por_pagina']) ?  (int)($_GET['por_pagina']) === 0 ? 0 : max(1, min(100, (int) ($_GET['por_pagina'] ?? 10))) : 10;
    $q = $_GET['q'] ?? $_GET['search'] ?? null;
    $activo = $_GET['activo'] ?? $_GET['activo'] ?? null;
    $rol = $_GET['rol'] ?? null;
    if ($q !== null && !is_string($q)) {
      $q = (string) $q;
    }


    try {
      $pdo = conectarBaseDatos();
      // no hay stored procedure definido en la base original, pero dejamos el
      // chequeo para que se registre si se agrega en el futuro
      Helper::checkAndLogProcedures($pdo, ['sp_usuarios_listar']);


      $stmt = $pdo->prepare(
        "CALL sp_usuarios_listar(:search, :activo, :rol, :pagina,:por_pagina, @p_total_registros, @p_mensaje, @p_codigo_resultado)"
      );
      $stmt->execute([
        'search' => $q,
        'activo' => $activo,
        'rol' => $rol,
        'pagina' => $page,
        'por_pagina' => $perPage
      ]);

      $rows = $stmt->fetchAll(\PDO::FETCH_ASSOC);
      $stmt->closeCursor();
      $outStmt = $pdo->query('select @p_total_registros, @p_mensaje, @p_codigo_resultado;');
      $out = $outStmt->fetch(\PDO::FETCH_ASSOC);
      $code = isset($out['@p_codigo_resultado']) ? (int) $out['@p_codigo_resultado'] : 500;
      $msg = $out['@mensaje'] ?? null;
      $p_total_registros = isset(
        $out['@p_total_registros']
      ) ? (int)
      $out['@p_total_registros'] : null;
      $status = ($code >= 200 && $code < 300) ? 'success' : 'error';
      echo json_encode([
        'success' => $code === 200 ? true : false,
        'data' => $rows,
        'total' => $p_total_registros,
        'msg' => $msg,
        'status' => $status,
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }

  /**
   * Devuelve lista de roles de usuarios para los autocompletes y otras búsquedas.
   * GET params aceptados:
   *   - q / search  : texto de búsqueda (se aplica a nombre o descripción)
   * Se retorna un array JSON de filas con columnas como `id`, `nombre`,
   * `descripcion`, etc.
   */
  public static function listarRoles()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(Helper::class)) {
      $maybe = __DIR__ . '../helpers/Helper.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    // permiso de intervenciones para mantener compatibilidad con modal
    if (!Helper::authorizeSection('usuarios')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;
    $page = isset($_GET['pagina']) ? (int)($_GET['pagina']) === 0 ? 1 : max(1, (int) ($_GET['pagina'] ?? 1)) : 1;
    $perPage = isset($_GET['por_pagina']) ?  (int)($_GET['por_pagina']) === 0 ? 0 : max(1, min(100, (int) ($_GET['por_pagina'] ?? 10))) : 10;
    $search = $_GET['q'] ?? $_GET['search'] ?? null;
    if ($search !== null && !is_string($search)) {
      $search = (string) $search;
    }

    $activa = $_GET['activa'] ?? null;


    try {
      $pdo = conectarBaseDatos();
      // no hay stored procedure definido en la base original, pero dejamos el
      // chequeo para que se registre si se agrega en el futuro
      Helper::checkAndLogProcedures($pdo, ['sp_roles_list']);


      $stmt = $pdo->prepare(
        "CALL sp_roles_list(:search, :activa, :pagina,:por_pagina, @p_total_registros, @p_mensaje, @p_codigo_resultado)"
      );
      $stmt->execute([
        'search' => "$search",
        'activa' => $activa,
        'pagina' => $page,
        'por_pagina' => $perPage
      ]);

      $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
      $stmt->closeCursor();

      $outStmt = $pdo->query('select@p_total_registros, @p_mensaje, @p_codigo_resultado;');
      $out = $outStmt->fetch(\PDO::FETCH_ASSOC);
      $code = isset($out['@p_codigo_resultado']) ? (int) $out['@p_codigo_resultado'] : 500;
      $msg = $out['@mensaje'] ?? null;
      $p_total_registros = isset(
        $out['@p_total_registros']
      ) ? (int)
      $out['@p_total_registros'] : null;
      $status = ($code >= 200 && $code < 300) ? 'success' : 'error';
      echo json_encode([
        'success' => $code === 200 ? true : false,
        'data' => $rows,
        'total' => $p_total_registros,
        'msg' => $msg,
        'status' => $status,
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['success' => false, 'error' => $e->getMessage()]);
    }
  }


  /**
   * Guarda una categoria (creación o edición según si se incluye un ID).
   * Se espera un JSON en el body con los campos:
   * - id (opcional para edición)
   * - nombre
   * - descripcion
   * -color
   * El procedimiento almacenado `sp_crear_categoria` se encarga de la creación, y `sp_actualizar_categoria` de la edición. Ambos procedimientos deben retornar un mensaje y código de resultado que se incluirán en la respuesta JSON. El método también verifica que el usuario tenga permisos para gestionar especiliddes, esta es una forma de mantener consistencia con los permisos definidos en el sistema.
   *  
   * 
   * @return void
   */
  public static function guardar()
  {
    header('Content-Type: application/json; chartset=utf-8');
    if (!class_exists(Helper::class)) {
      $maybe = __DIR__ . '../helpers/Helper.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    if (!Helper::authorizeSection('especialidades')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
      http_response_code(400);
      echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
      return;
    }
    $id = $input['id'] ?? null; // para saber si es creación o edición
    $cedula = $input['cedula'] ?? null; // para saber si es creación o edición
    $nombre = $input['nombre'] ?? null;
    $apellido = $input['apellido'] ?? null;
    $password = $input['password'] ?? null;
    $telefono = $input['telefono'] ?? null;
    $email = $input['email'] ?? null;
    $img_url = $input['img_url'] ?? null;
    $activo = $input['activo'] ?? 0;
    $rol_id = $input['rol_id'] ?? null;
    $rol_id = is_array($rol_id) ? json_encode($rol_id) : $rol_id; // Converir a cadena si es un array
    $userId = null;
    if (session_status() === PHP_SESSION_NONE) {
      @session_start();
    }
    $resultado = $_SESSION['usuario']['resultado'] ?? null;
    $usuario = (json_decode($resultado))->usuario;
    if (empty($usuario->id)) {
      http_response_code(500);
      echo json_encode(['status' => 'error', 'message' => 'Usuario no identificado en sesión']);
      return;
    }
    $userId = $usuario->id;

    if (!$cedula || !$apellido || !$apellido || !$email || !$rol_id || !$userId) {
      http_response_code(400);
      echo json_encode(['success' => false, 'message' => 'Faltan campos requeridos']);
      return;
    }

    try {
      $pdo = conectarBaseDatos();

      $isEdit = $id !== null;

      $sql = "";
      if ($isEdit) {
        if ($id) {
          Helper::checkAndLogProcedures($pdo, ['sp_usuarios_update']);
          // Verificar que el paciente exista antes de intentar actualizar
          $checkStmt = $pdo->prepare('SELECT COUNT(*) FROM usuarios WHERE id = :id');
          $checkStmt->execute(['id' => $id]);
          if ($checkStmt->fetchColumn() == 0) {
            http_response_code(404);
            echo json_encode(['status' => 'error', 'message' => 'especialidad no encontrado para actualización']);
            return;
          }
        }

        $stmt = $pdo->prepare(
          'CALL sp_usuarios_update(:id, :cedula, :nombre, :apellido, null, :telefono, :email, :img_url, :activo, :rol, :user_id, @p_mensaje, @p_codigo_resultado)'
        );

        $stmt->execute([
          'id' => $id,
          'cedula' => $cedula,
          'nombre' => $nombre,
          'apellido' => $apellido,
          'telefono' => $telefono,
          'email' => $email,
          'img_url' => $img_url,
          'activo' => $activo,
          'rol' => $rol_id,
          'user_id' => $userId
        ]);
        $sql = 'SELECT @p_id_generado, @p_mensaje, @p_codigo_resultado;';
      } else {

        if (!$password) {
          http_response_code(400);
          echo json_encode(['success' => false, 'message' => 'Faltan campos requeridos']);
          return;
        }

        $hash = password_hash($password, PASSWORD_BCRYPT);

        Helper::checkAndLogProcedures($pdo, ['sp_usuarios_create']);
        $stmt = $pdo->prepare(
          'CALL sp_usuarios_create(:cedula, :nombre, :apellido, :password, :telefono, :email, :img_url, :activo, :rol, :user_id, @p_id_generado, @p_mensaje, @p_codigo_resultado)'
        );
        $stmt->execute([
          'cedula' => $cedula,
          'nombre' => $nombre,
          'apellido' => $apellido,
          'password' => $hash,
          'telefono' => $telefono,
          'email' => $email,
          'img_url' => $img_url,
          'activo' => $activo,
          'rol' => $rol_id,
          'user_id' => $userId
        ]);

        $sql = 'SELECT @p_id_generado, @p_mensaje, @p_codigo_resultado;';
      }
      $stmt->closeCursor();
      // Obtener mensaje y código de resultado del procedimiento
      $outputStmt = $pdo->query($sql);
      $out = $outputStmt->fetch(PDO::FETCH_ASSOC);

      $code = isset($out['@p_codigo_resultado']) ? (int) $out['@p_codigo_resultado'] : 500;
      $msg = $out['@p_mensaje'] ?? 'Operación completada';
      $int = isset($out['p_id_generado']) ||  $out['@p_id_generado'] ?? '0';

      $status = ($code >= 200 && $code < 300) ? 'success' : 'error';

      echo json_encode([
        'status' => $status,
        'message' => $msg,
        'code' => $code,
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
  }


  /**
   * Obtiene un insumo por su ID, codigo.
   * Parámetros de consulta: id, codigo
   * Si se proporcionan múltiples parámetros, se ejecutarán todos y se devolverán los resultados en un solo objeto JSON.
   */
  public static function obtenerBy()
  {
    header('Content-Type: application/json; charset=utf-8');
    // autorización genérica mediante sección "insumos" en Dashboard
    if (!class_exists(Helper::class)) {
      $maybe = __DIR__ . '/../helpers/Helper.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    if (!Helper::authorizeSection('insumos')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $id = $_GET['id'] ?? null;
    $cedula = $_GET['cedula'] ?? null;
    $email = $_GET['email'] ?? null;

    // Validar que al menos un parámetro de búsqueda esté presente
    if (!$cedula  && !$id && !$email) {
      http_response_code(400);
      echo json_encode([
        'success' => false,
        'error' => 'missing_parameter',
        'message' => 'Falta parámetro de búsqueda'
      ]);
      return;
    }

    try {
      $pdo = conectarBaseDatos();
      $resultados = [];
      $errores = [];
      $codigo_general = 200; // Código por defecto exitoso
      $mensajes = [];

      // Array para almacenar los procedimientos a ejecutar
      $procedimientos = [];

      // Determinar qué procedimientos ejecutar basado en los parámetros
      if ($email !== null) {
        $procedimientos[] = [
          'nombre' => 'sp_usuario_get_by_email',
          'parametro' => $email,
          'tipo' => 'email',
          'activa' => isset($email) ? !($email === "null") : false
        ];
      }

      if ($cedula !== null) {
        $procedimientos[] = [
          'nombre' => 'sp_usuario_get_by_cedula',
          'parametro' => $cedula,
          'tipo' => 'cedula',
          'activa' => isset($cedula) ? !($cedula === "null") : false
        ];
      }

      if ($id !== null) {
        $procedimientos[] = [
          'nombre' => 'sp_usuario_get_by_id',
          'parametro' => $id,
          'tipo' => 'id',
          'activa' => isset($id) ?
            !($id === "null")  : false
        ];
      }

      // Verificar que todos los procedimientos existen antes de ejecutar
      $nombres_procedimientos = array_column($procedimientos, 'nombre');
      Helper::checkAndLogProcedures($pdo, $nombres_procedimientos);

      // Ejecutar cada procedimiento
      foreach ($procedimientos as $proc) {
        try {
          if (!$proc['activa']) {
            break;
          }
          // Preparar la llamada al procedimiento
          $sql = "CALL {$proc['nombre']}(:q, @msj_{$proc['tipo']}, @codigo_{$proc['tipo']})";
          $stmt = $pdo->prepare($sql);
          $stmt->execute(['q' => $proc['parametro']]);

          // Obtener los resultados
          $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
          $stmt->closeCursor();

          // Obtener los parámetros de salida específicos para este procedimiento
          $outStmt = $pdo->query("SELECT @msj_{$proc['tipo']} as msj, @codigo_{$proc['tipo']} as codigo");
          $out = $outStmt->fetch(PDO::FETCH_ASSOC);

          $codigo_proc = isset($out['codigo']) ? (int) $out['codigo'] : 500;
          $mensaje_proc = isset($out['msj']) ? $out['msj'] : null;

          // Almacenar resultados
          $resultados[$proc['tipo']] = [
            'parametro_busqueda' => $proc['parametro'],
            'data' => $rows,
            'codigo' => $codigo_proc,
            'mensaje' => $mensaje_proc
          ];

          // Si algún procedimiento falla, cambiar el código general
          if ($codigo_proc !== 200) {
            $codigo_general = 400; // Código de error general
            $errores[] = [
              'tipo' => $proc['tipo'],
              'codigo' => $codigo_proc,
              'mensaje' => $mensaje_proc
            ];
          } else {
            $codigo_general = $codigo_proc; //
          }

          $mensajes[] = $mensaje_proc;
        } catch (PDOException $e) {
          $codigo_general = 500;
          $errores[] = [
            'tipo' => $proc['tipo'],
            'error' => 'Error ejecutando procedimiento: ' . $e->getMessage()
          ];
        }
      }

      // Construir respuesta
      $respuesta = [
        'success' => $codigo_general === 200 ? true : false,
        'error' => empty($errores) ? null : 'one_or_more_errors',
        'resultados' => $resultados,
        'mensajes' => array_filter($mensajes), // Eliminar nulls
        'status' => $codigo_general === 200 ? 'success' : 'error'
      ];

      // Si hay errores, incluirlos en la respuesta
      if (!empty($errores)) {
        $respuesta['errores'] = $errores;
      }

      // Si no se encontraron resultados en ningún procedimiento
      $total_resultados = array_sum(array_map(function ($r) {
        return count($r['data']);
      }, $resultados));

      if ($total_resultados === 0) {
        $respuesta['message'] = 'No se encontraron resultados para los criterios de búsqueda';
      }

      echo json_encode($respuesta);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode([
        'success' => false,
        'error' => 'database_error',
        'message' => 'Error al ejecutar las consultas: ' . $e->getMessage()
      ]);
    }
  }
  /**
   * Elimina un ussario dado su ID. Se espera un JSON en el body con el campo `id` de la enfermedad a eliminar. El procedimiento almacenado `sp_enfermedades_delete` se encargará de la eliminación y debe retornar un mensaje y código de resultado que se incluirán en la respuesta JSON. El método también verifica que el usuario tenga permisos para gestionar enfermedades, esta es una forma de mantener consistencia con los permisos definidos en el sistema.
   * Se espera un JSON en el body con los campos:
   * - id (opcional para edición)
   */
  public static function eliminarRegistro()
  {
    header('Content-Type: application/json; charset=utf-8');
    if (!class_exists(Helper::class)) {
      $maybe = __DIR__ . '/../helpers/Helper.php';
      if (file_exists($maybe)) {
        require_once $maybe;
      }
    }
    if (!Helper::authorizeSection('usurios')) {
      http_response_code(403);
      echo json_encode(['success' => false, 'error' => 'access_denied', 'message' => 'Acceso denegado por rol']);
      return;
    }

    $maybeDb = __DIR__ . '/../../config/db.php';
    if (file_exists($maybeDb))
      require_once $maybeDb;

    $input = json_decode(file_get_contents('php://input'), true);
    if (!$input) {
      http_response_code(400);
      echo json_encode(['success' => false, 'message' => 'Datos inválidos']);
      return;
    }
    $id = $input['id'] ?? null;

    $userId = null;
    if (session_status() === PHP_SESSION_NONE) {
      @session_start();
    }
    $resultado = $_SESSION['usuario']['resultado'] ?? null;
    $usuario = (json_decode($resultado))->usuario;
    if (empty($usuario->id)) {
      http_response_code(500);
      echo json_encode(['status' => 'error', 'message' => 'Usuario no identificado en sesión']);
      return;
    }
    $userId = $usuario->id;

    if (!$id || !$userId) {
      http_response_code(400);
      echo json_encode(['success' => false, 'message' => 'Falta el ID del enfermedad a eliminar']);
      return;
    }

    try {
      $pdo = conectarBaseDatos();
      Helper::checkAndLogProcedures($pdo, ['sp_usuarios_eliminar']);
      $stmt = $pdo->prepare('CALL sp_usuarios_eliminar(:id, :id_usuario, @p_mensaje, @p_codigo_resultado)');
      $stmt->execute(['id' => $id, 'id_usuario' => $userId]);

      $stmt->closeCursor();
      // Obtener mensaje y código de resultado del procedimiento
      $outputStmt = $pdo->query('SELECT @p_mensaje AS mensaje, @p_codigo_resultado AS codigo_resultado;');

      $out = $outputStmt->fetch(PDO::FETCH_ASSOC);

      $code = isset($out['codigo_resultado']) ? (int) $out['codigo_resultado'] : 500;
      $msg = $out['mensaje'] ?? 'Operación completada';

      $status = ($code >= 200 && $code < 300) ? 'success' : 'error';

      echo json_encode([
        'success' => $code === 200,
        'message' => $msg,
        'code' => $code,
        'status' => $status
      ]);
    } catch (PDOException $e) {
      http_response_code(500);
      echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
    }
  }
}
