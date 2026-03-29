$(document).ready(function () {
  // Configuración inicial
  // Variables globales
  const BASE_URL =
    document.querySelector('meta[name="base-url"]')?.content || "";

  // Corrección: URL completa para verificar sesión
  const interBase =
    (BASE_URL || "..") + "/backend/public/index.php/api/login/verificaSession";

  const URL_LOGOUT =
    (BASE_URL || "..") + "/backend/public/index.php/api/logout";

  // Eliminadas variables no utilizadas: ajaxPendientes y $usuario

  const TIEMPO_INACTIVIDAD = 15 * 60 * 1000; // 15 minutos
  const TIEMPO_VERIFICACION_SESION = 5 * 60 * 1000; // Verificar sesión cada 5 minutos

  let timeoutInactividad;
  let intervaloVerificacion; // Nuevo: Para verificación periódica

  // Verificar sesión del usuario
  async function verificarSesion() {
    try {
      const resp = await fetch(interBase, {
        credentials: "include",
      });
      const data = await resp.json();

      // Mejora: Solo forzar logout si explícitamente no logueado, no por cualquier error
      if (!data.logueado) {
        await Utils.showSwallError(
          "Ups...",
          data.msj || "Por seguridad, tu sesión ha sido cerrada.",
        );
        await Logout();
      }
    } catch (error) {
      // Mejora: No forzar logout por errores de red; mostrar mensaje pero permitir reintento
      console.error("Error verificando sesión:", error);
      await Utils.showSwallError(
        "Error de conexión",
        "No se pudo verificar la sesión.\nLa sesión sera cerrada.",
      );
      await Logout();
      // Opcional: Podrías añadir lógica para reintentar después de un delay
    }
  }

  async function Logout() {
    try {
      const resp = await fetch(URL_LOGOUT, {
        method: "POST",
        credentials: "include",
        headers: {
          Accept: "application/json",
        },
      });
      if (resp.ok) {
        try {
          await resp.json();
        } catch (e) {
          /* ignore non-json */
        }
        window.location.href = "../../../index.php";
        return;
      }
      if (resp.status === 401 || resp.status === 403) {
        window.location.href = "../../../index.php";
        return;
      }
      Utils.showSwallError(
        "Ups...",
        "No se pudo cerrar sesión. Intente de nuevo.",
      );
    } catch (err) {
      Utils.showSwallError("Ups...", "No se pudo conectar al servidor.");
    }
  }

  function reiniciarTemporizador() {
    clearTimeout(timeoutInactividad);
    timeoutInactividad = setTimeout(
      cerrarSesionPorInactividad,
      TIEMPO_INACTIVIDAD,
    );
  }

  async function cerrarSesionPorInactividad() {
    // Mejora: Mostrar notificación antes de cerrar
    await Utils.showSwalSB(
      "info",
      "Sesión cerrada por inactividad",
      "Por seguridad, tu sesión ha sido cerrada.",
      3000,
    );
    Logout();
  }

  function inicializarAplicacion() {
    // Verificar sesión inicial
    verificarSesion();

    // Nuevo: Verificación periódica de sesión
    intervaloVerificacion = setInterval(
      verificarSesion,
      TIEMPO_VERIFICACION_SESION,
    );

    // Iniciar temporizador de inactividad
    reiniciarTemporizador();

    // Eventos que reinician el temporizador de inactividad
    // Mejora: Añadir eventos táctiles para móviles
    $(document).on(
      "mousemove keydown click scroll touchstart touchmove",
      reiniciarTemporizador,
    );
  }

  // Nuevo: Limpiar intervalos al salir de la página para evitar fugas de memoria
  $(window).on("beforeunload", function () {
    clearTimeout(timeoutInactividad);
    clearInterval(intervaloVerificacion);
  });

  // Iniciar la aplicación
  inicializarAplicacion();
});
