<?php

namespace App\Models;

use PDOException;
use PDO;

class Usuario
{
  // Llama al procedimiento almacenado `sp_login_usuario`
  // El SP ahora recibe SOLO el usuario/email y devuelve los datos del usuario
  public static function loginWithProcedure(string $username)
  {
    // cargar helpers de DB
    require_once __DIR__ . '/../../config/db.php';

    $bd = conectarBaseDatos();

    // El procedimiento almacenado acepta solo el parámetro de usuario/email
    $stmt = $bd->prepare('CALL sp_login(:u)');
    $stmt->bindParam(':u', $username);
    $stmt->execute();

    // Obtener primer resultado (se asume que el SP devuelve una fila/JSON)
    $res = $stmt->fetch(\PDO::FETCH_ASSOC);

    return $res ?: null;
  }

  // Obtener las políticas de contraseña desde la tabla `politicas_password`
  public static function getPasswordPolicy(int $id = 1)
  {
    require_once __DIR__ . '/../../config/db.php';
    $bd = conectarBaseDatos();
    $stmt = $bd->prepare('SELECT * FROM politicas_password WHERE id_politica = :id LIMIT 1');
    $stmt->bindParam(':id', $id, \PDO::PARAM_INT);
    $stmt->execute();
    $res = $stmt->fetch(\PDO::FETCH_ASSOC);
    return $res ?: null;
  }

  // Actualizar la contraseña del usuario (intenta varios nombres de tabla comunes)
  public static function updatePassword(string $username, string $passwordHash)
  {
    require_once __DIR__ . '/../../config/db.php';
    $bd = conectarBaseDatos();

    try {
      $sql = "UPDATE `usuarios` SET `password` = :h WHERE (`email` = :u OR `email` = :m)";
      $stmt = $bd->prepare($sql);
      $stmt->bindParam(':h', $passwordHash);
      $stmt->bindParam(':u', $username);
      $stmt->bindParam(':m', $username);
      $stmt->execute();
      $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
      if ($stmt->rowCount() > 0) {
        return true;
      } else {
        return false;
      }
    } catch (PDOException $e) {
      http_response_code(500);
      return false;
    }
  }

  public static function getConfiguracionSistema(int $incluir_privada = 1, string $filtro_clave = null)
  {
    require_once __DIR__ . '/../../config/db.php';
    $bd = conectarBaseDatos();
    $stmt = $bd->prepare('CALL sp_get_configuracion_sistema(?, ?)');
    $stmt->bindParam(1, $incluir_privada, \PDO::PARAM_INT);
    $stmt->bindParam(2, $filtro_clave);

    $stmt->execute();
    $resp = [];
    while ($row = $stmt->fetch(\PDO::FETCH_ASSOC)) {
      $resp[] = $row;
    }

    return $resp;
  }
}
