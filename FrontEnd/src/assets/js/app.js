$(document).ready(function () {
  // Configuración inicial
  // Variables globales
  const BASE_URL =
    document.querySelector('meta[name="base-url"]')?.content || "";

  const URL = window.location.href.includes(BASE_URL) ? BASE_URL : "";

  // Corrección: URL completa para verificar sesión
  const interBase = URL + "/backend/public/index.php/api/login/verificaSession";

  const URL_LOGOUT = URL + "/backend/public/index.php/api/logout";

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
        "Cierre de sesión fallido",
        "No se pudo cerrar sesión. Intente de nuevo.\nSi el problema persiste, contacte al soporte.",
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

    const toggleBtn = document.getElementById("sidebarToggle");
    const backdrop = document.getElementById("sidebarBackdrop");

    const body = document.body;

    // Cargar estado guardado
    const savedState = localStorage.getItem("sidebarCollapsed");
    if (savedState === "true") {
      body.classList.add("sidebar-collapsed");
    } else if (savedState === "false") {
      body.classList.remove("sidebar-collapsed");
    }

    // Modo oscuro
    const darkModeToggle = document.getElementById("darkModeToggle");
    const darkModeSaved = localStorage.getItem("darkMode");
    if (darkModeSaved === "true") {
      document.body.classList.add("dark-mode");
      updateDarkModeButton(true);
    }
    if (darkModeToggle) {
      darkModeToggle.addEventListener("click", () => {
        const isDark = document.body.classList.toggle("dark-mode");
        localStorage.setItem("darkMode", isDark);
        updateDarkModeButton(isDark);
      });
    }
    function updateDarkModeButton(isDark) {
      const icon = darkModeToggle.querySelector("i");
      // const text = darkModeToggle.querySelector(".mode-text");
      if (isDark) {
        icon.className = "fas fa-sun";
        // text.textContent = "Modo Claro";
      } else {
        icon.className = "fas fa-moon";
        // text.textContent = "Modo Oscuro";
      }
    }

    // Notificaciones
    let notifications = []; // almacenará las notificaciones
    function loadNotifications() {
      // Simular petición AJAX
      // Puedes reemplazar por fetch('/api/notificaciones.php')
      setTimeout(() => {
        notifications = [
          {
            id: 1,
            title: "Stock crítico: Producto A",
            time: "Hace 5 minutos",
            type: "danger",
          },
          {
            id: 2,
            title: "Nueva venta registrada #1001",
            time: "Hace 1 hora",
            type: "info",
          },
          {
            id: 3,
            title: "Alerta de reabastecimiento",
            time: "Hace 2 horas",
            type: "warning",
          },
        ];
        renderNotifications();
      }, 1000);
    }

    function renderNotifications() {
      const container = document.getElementById("notificationsList");
      const badge = document.getElementById("notifBadge");
      if (!container) return;

      if (notifications.length === 0) {
        container.innerHTML =
          '<div class="text-center p-3 text-muted">Sin notificaciones</div>';
        badge.style.display = "none";
        return;
      }

      badge.textContent = notifications.length;
      badge.style.display = "inline-block";

      container.innerHTML = notifications
        .map(
          (notif) => `
        <li class="dropdown-item notification-item">
            <div class="notif-title">${notif.title}</div>
            <div class="notif-time"><i class="far fa-clock"></i> ${notif.time}</div>
        </li>
    `,
        )
        .join("");

      // Añadir opción "Ver todas" al final
      const liAll = document.createElement("li");
      liAll.innerHTML =
        '<hr class="dropdown-divider"><a class="dropdown-item text-center" href="notificaciones.php">Ver todas</a>';
      container.parentElement.appendChild(liAll);
    }

    // Cargar notificaciones cada 30 segundos
    loadNotifications();
    setInterval(loadNotifications, 30000);

    // Atajos de teclado
    document.addEventListener("keydown", (e) => {
      // Alt + H -> Home
      if (e.altKey && e.key === "h") {
        e.preventDefault();
        window.location.href = "home.php";
      }
      // Alt + V -> Ventas (si existe)
      if (e.altKey && e.key === "v") {
        e.preventDefault();
        window.location.href = "ventas.php";
      }
      // Alt + C -> Compras
      if (e.altKey && e.key === "c") {
        e.preventDefault();
        window.location.href = "compras.php";
      }
      // Alt + P -> Perfil
      if (e.altKey && e.key === "p") {
        e.preventDefault();
        window.location.href = "perfil.php";
      }
      // Esc -> Cerrar modal o dropdown
      if (e.key === "Escape") {
        // Cerrar cualquier modal de Bootstrap
        const modals = document.querySelectorAll(".modal.show");
        modals.forEach((modal) => {
          const instance = bootstrap.Modal.getInstance(modal);
          instance.hide();
        });
        // Cerrar menú de usuario si está abierto
        const userMenu = document.getElementById("header_logo_menu");
        if (userMenu && !userMenu.hidden) {
          userMenu.setAttribute("hidden", "");
        }
      }
    });

    function isMobile() {
      return window.innerWidth <= 768;
    }

    function closeMobileMenu() {
      if (isMobile()) {
        body.classList.remove("mobile-menu-open");
      }
    }

    function openMobileMenu() {
      if (isMobile()) {
        body.classList.add("mobile-menu-open");
      }
    }

    function toggleDesktopCollapse() {
      if (!isMobile()) {
        body.classList.toggle("sidebar-collapsed");
        localStorage.setItem(
          "sidebarCollapsed",
          body.classList.contains("sidebar-collapsed"),
        );
      }
    }

    // Evento del botón hamburguesa
    if (toggleBtn) {
      toggleBtn.addEventListener("click", function (e) {
        e.preventDefault();
        if (isMobile()) {
          if (body.classList.contains("mobile-menu-open")) {
            closeMobileMenu();
          } else {
            openMobileMenu();
          }
        } else {
          toggleDesktopCollapse();
        }
      });
    }

    // Cerrar menú al hacer clic en el backdrop
    if (backdrop) {
      backdrop.addEventListener("click", closeMobileMenu);
    }

    // Cerrar menú al redimensionar a escritorio
    window.addEventListener("resize", function () {
      if (!isMobile() && body.classList.contains("mobile-menu-open")) {
        body.classList.remove("mobile-menu-open");
      }
      if (!isMobile()) {
        const saved = localStorage.getItem("sidebarCollapsed");
        if (saved === "true") {
          body.classList.add("sidebar-collapsed");
        } else {
          body.classList.remove("sidebar-collapsed");
        }
      }
    });

    // Restaurar estado en desktop
    if (!isMobile()) {
      const saved = localStorage.getItem("sidebarCollapsed");
      if (saved === "true") {
        body.classList.add("sidebar-collapsed");
      }
    }

    // Eventos que reinician el temporizador de inactividad
    // Mejora: Añadir eventos táctiles para móviles
    $(document).on(
      "mousemove keydown click scroll touchstart touchmove",
      reiniciarTemporizador,
    );

    const logoutBtn = document.getElementById("btn_logout");
    const logoutmnuBtn = document.getElementById("mnu_logout");
    if (!logoutBtn) return;
    logoutBtn.addEventListener("click", function (ev) {
      ev.preventDefault();
      logoutOn();
    });

    logoutmnuBtn.addEventListener("click", function (ev) {
      ev.preventDefault();
      logoutOn();
    });
  }

  function logoutOn() {
    if (typeof Swal !== "undefined") {
      Swal.fire({
        title: "¿Desea cerrar sesión?",
        text: "Se le redirigirá a la página de inicio de sesión.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Sí, cerrar sesión",
        cancelButtonText: "Cancelar",
      }).then((result) => {
        if (result.isConfirmed) Logout();
      });
    } else {
      if (window.confirm("¿Desea cerrar sesión?")) Logout();
    }
  }

  // Nuevo: Limpiar intervalos al salir de la página para evitar fugas de memoria
  $(window).on("beforeunload", function () {
    clearTimeout(timeoutInactividad);
    clearInterval(intervaloVerificacion);
  });

  window.addEventListener("beforeunload", function () {
    // Petición síncrona (no recomendada) o fetch con keepalive
    navigator.sendBeacon("logout.php");
  });

  // Iniciar la aplicación
  inicializarAplicacion();
});
