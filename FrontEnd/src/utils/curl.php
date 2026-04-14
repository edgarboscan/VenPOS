<?php
function api_request($endpoint, $method = 'GET', $data = null)
{
  $base_url = 'http://localhost/VenPOS/backend/public/index.php/api/';
  $ch = curl_init($base_url . $endpoint);

  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

  // Pasar token de sesión
  if (isset($_SESSION['token'])) {
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
      'Authorization: Bearer ' . $_SESSION['token'],
      'Content-Type: application/json'
    ]);
  }

  if ($method === 'POST') {
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
  } elseif ($method === 'PUT') {
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PUT');
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
  } elseif ($method === 'DELETE') {
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'DELETE');
  }

  $response = curl_exec($ch);
  $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  curl_close($ch);

  return ['code' => $http_code, 'data' => json_decode($response, true)];
}
