<?php
session_start();

function is_logged_in()
{
    return !empty($_SESSION['usuario']);
}

function require_login()
{
    if (!is_logged_in()) {
        echo "<script> window.location.href = '../../index.html'; </script>";
        exit();
    }
}


function getCurrentUser()
{
    if (!is_logged_in())
        return null;
    return $_SESSION['usuario'];
}


/**
 * Busca recursivamente un menú por su URL en la estructura de menús del usuario.
 * Intenta comparar por coincidencia exacta y por basename (sin parámetros).
 */
function find_menu_by_url(array $menus, string $url)
{
    $normalize = function ($u) {
        $u = trim((string) $u);
        $u = preg_replace('#\?.*$#', '', $u); // quitar query
        $u = ltrim($u, './');
        return $u;
    };
    $target = $normalize($url);
    foreach ($menus as $m) {
        $mu = $m['url'] ?? '';
        if ($normalize($mu) === $target)
            return $m;
        // compare basename
        $base = basename(parse_url($mu, PHP_URL_PATH) ?: '');
        if ($base && $base === basename($target))
            return $m;
        // children
        if (!empty($m['children']) && is_array($m['children'])) {
            $found = find_menu_by_url($m['children'], $url);
            if ($found)
                return $found;
        }
    }
    return null;
}


function logout()
{
    session_unset();
    session_destroy();
    header('Location: index.html');
    exit();
}
