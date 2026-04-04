class LoginManager {
  /**
   *
   */

  constructor() {
    this.card = document.querySelector(".login-card");
    this.notice = document.querySelector(".notice");
    this.eye = document.querySelector(".eye");
    this.pass = document.getElementById("password");

    this.BASE_URL =
      document.querySelector('meta[name="base-url"]')?.content || "";

    const URL =
      window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
    this.BASE_URL = URL;
    this.CSRF_TOKEN = null;

    this.form = $("#loginForm");
    this.noticeArea = $(".notice");
    this.verificationArea = $("#verificationArea");
    this.CSRF_TOKEN = null;
    this.init();
  }

  async init() {
    // Cargar configuraciones de seguridad y generales
    await Utils.getAll_Config(this.BASE_URL);
    this.initEventListeners();
  }

  async fetchCsrfToken() {
    if (this.CSRF_TOKEN) return this.CSRF_TOKEN;
    try {
      const url =
        window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
      const resp = await fetch(
        url + "/backend/public/index.php/api/csrf-token",
        { credentials: "include" },
      );
      if (!resp.ok) {
        this.showNotice(
          "error",
          `Error al obtener token CSRF: ${resp.status} ${resp.statusText}`,
          5000,
        );
        console.warn(
          "Failed to fetch CSRF token:",
          resp.status,
          resp.statusText,
        );
        swaal.fire({
          icon: "error",

          title: "Error de autenticación",
          text: `Failed to fetch CSRF token: ${resp.status} ${resp.statusText}`,
        });
        return null;
      }
      const j = await resp.json();
      CSRF_TOKEN = j.token || null;
      return CSRF_TOKEN;
    } catch (e) {
      return null;
    }
  }

  async handleLogin() {
    const username = $("#username").val();
    const password = $("#password").val();

    if (username.length > 0 && username.includes("@")) {
      const emailValidation = Validators.validateEmail(username);
      if (!emailValidation.isValid) {
        this.showNotice("error", emailValidation.message, 6000);
        return;
      }
    }

    // const errors = this.verifyPassword(password);

    // if (errors.length > 0) {
    //   this.showNotice("error", errors.join("<br>"), 6000);
    //   return;
    // }

    this.showNotice("", "");
    this.card.classList.remove("error", "success");
    this.card.classList.add("loading");
    const submitBtn = document.getElementById("submitBtn");
    submitBtn.disabled = true;

    // small loading notice
    this.showNotice("info", "Comprobando credenciales…", 0);

    try {
      // small artificial delay to show animation
      await new Promise((res) => setTimeout(res, 300));

      // Simple validation
      if (!username || !password)
        throw new Error("Completa usuario y contraseña");
      const url =
        window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
      // Enviar credenciales al backend (contraseña en texto; backend verifica bcrypt)
      const token = await this.fetchCsrfToken();
      const resp = await fetch(url + "/backend/public/index.php/api/login", {
        method: "POST",
        credentials: "include",
        headers: {
          "Content-Type": "application/json",
          ...(token ? { "X-CSRF-Token": token } : {}),
        },
        body: JSON.stringify({ username: username, password: password }),
      });

      let data = await resp.json();

      // la API ahora devuelve su contenido principal en la propiedad "resultado".
      // ese campo puede ser una cadena JSON o ya un objeto. si existe lo usamos
      // como nuestro objeto de trabajo, sustituyendo a la respuesta anterior.
      if (data && data.resultado) {
        try {
          data =
            typeof data.resultado === "string" ?
              JSON.parse(data.resultado)
            : data.resultado;
        } catch (e) {
          // si falla el parseo dejamos data como estaba; más adelante fallará
          console.warn("No se pudo parsear data.resultado", e);
        }
      }

      // Manejo específico de códigos HTTP
      if (resp.status === 403) {
        throw new Error(data.mensaje || "Cuenta bloqueada");
      }

      // Si el backend indica que el usuario requiere verificación (p.ej. 2FA o verificación adicional)
      if (data.requiere_verificacion) {
        this.card.classList.remove("loading");
        this.card.classList.add("error");
        this.showNotice(
          "warn",
          data.mensaje || "Usuario requiere verificación",
          8000,
        );
        submitBtn.disabled = false;
        // se puede mostrar interfaz específica si viene en data, ej.: renderVerification
        if (typeof renderVerification === "function") {
          renderVerification(data, user);
        }
        return;
      }

      // éxito si el estado viene marcado y/o si está presente un usuario
      const isSuccess =
        data &&
        (data.estado === "exito" ||
          (data.usuario && Object.keys(data.usuario).length));

      if (isSuccess) {
        console.log("login response data", data);
        /* guardar información de sesión para que el resto de la aplicación
           pueda reconstruir el menú rápido y saber quién está logueado */
        try {
          sessionStorage.setItem("usuario", JSON.stringify(data.usuario));
          if (data.acceso) {
            console.log("storing acceso in sessionStorage", data.acceso);
            sessionStorage.setItem("acceso", JSON.stringify(data.acceso));
            if (data.acceso.menus) {
              sessionStorage.setItem(
                "menus",
                JSON.stringify(data.acceso.menus),
              );
            }
            if (data.acceso.roles) {
              sessionStorage.setItem(
                "roles",
                JSON.stringify(data.acceso.roles),
              );
            }
          } else {
            console.log("no acceso field present on login response");
          }
        } catch (e) {
          console.warn("No se pudo almacenar sesión", e);
        }

        this.card.classList.remove("loading");
        this.card.classList.add("success");
        this.showNotice(
          "success",
          "¡Autenticación correcta! Redirigiendo...",
          1200,
        );

        const overlay = document.createElement("div");
        overlay.className = "page-overlay success";
        overlay.innerHTML = `<div class="center"><h2>¡Ingreso exitoso!</h2></div>`;
        document.body.appendChild(overlay);
        requestAnimationFrame(() => {
          document.body.classList.add("page-exit");
          overlay.classList.add("visible");
        });

        // esperar un poco para simular redirección
        setTimeout(() => {
          if (data.redirect) {
            window.location.href = data.redirect;
          } else {
            window.location.href = "src/pages/home.php?title=Home";
          }
        }, 700);
      } else {
        // intentar extraer mensaje de error de varios lugares
        let msg = "Usuario o contraseña incorrectos";
        if (data && data.mensaje) msg = data.mensaje;
        if (data && data.error) {
          msg =
            typeof data.error === "string" ?
              data.error
            : JSON.stringify(data.error);
        }
        throw new Error(msg);
      }
    } catch (err) {
      this.card.classList.remove("loading");
      this.card.classList.add("error");
      this.showNotice("error", err.message || "Error de autenticación", 5000);
      setTimeout(() => this.card.classList.remove("error"), 600);
    } finally {
      submitBtn.disabled = false;
    }
  }

  verifyPassword(password) {
    let errors = [];
    Utils.seguridad.forEach((config) => {
      if (config.nombre === "longitud_minima_password" && config.valor > "0") {
        if (password.length < parseInt(config.valor)) {
          errors.push(
            `✅ La contraseña debe tener al menos ${parseInt(config.valor)} caracteres.`,
          );
        }
      } else if (
        config.nombre === "requiere_mayusculas" &&
        config.valor !== "0"
      ) {
        if (!/[A-Z]/.test(password)) {
          errors.push(
            "✅ La contraseña debe contener al menos una letra mayúscula.",
          );
        }
      } else if (
        config.nombre === "requiere_minusculas" &&
        config.valor !== "0"
      ) {
        if (!/[a-z]/.test(password)) {
          errors.push(
            "✅ La contraseña debe contener al menos una letra minúscula.",
          );
        }
      } else if (config.nombre === "requiere_numeros" && config.valor !== "0") {
        if (!/[0-9]/.test(password)) {
          errors.push("✅ La contraseña debe contener al menos un número.");
        }
      } else if (
        config.nombre === "requiere_simbolos" &&
        config.valor !== "0"
      ) {
        if (!/[!@#$%^&*]/.test(password)) {
          errors.push("✅ La contraseña debe contener al menos un símbolo.");
        }
      }
    });
    return errors;
  }

  // Helper to show notices with styles and ARIA
  showNotice(type, message, timeout = 4000) {
    if (!this.notice) return;
    this.notice.className = "notice" + (type ? " notice--" + type : "");
    // role for critical messages
    if (type === "error" || type === "warn")
      this.notice.setAttribute("role", "alert");
    else this.notice.setAttribute("role", "status");
    const icon =
      {
        success: "✅",
        error: "⚠️",
        info: "ℹ️",
        warn: "⚠️",
      }[type] || "";

    // spinner for info/loading
    if (type === "info" && /cargando|comprobando|esperando/i.test(message)) {
      this.notice.innerHTML = `<span class="notice__icon"><span class="spinner"></span></span><span class="notice__text">${message}</span>`;
    } else {
      this.notice.innerHTML = `<span class="notice__icon">${icon}</span><span class="notice__text">${message}</span>`;
    }

    if (timeout > 0) {
      clearTimeout(this.notice._timeout);
      this.notice._timeout = setTimeout(() => {
        if (this.notice) {
          this.notice.className = "notice";
          this.notice.innerHTML = "";
          this.notice.removeAttribute("role");
        }
      }, timeout);
    }
  }

  initEventListeners() {
    if (this.eye && this.pass) {
      this.eye.addEventListener("click", () => {
        const type =
          this.pass.getAttribute("type") === "password" ? "text" : "password";
        this.pass.setAttribute("type", type);
        this.eye.innerHTML =
          type === "password" ?
            '<span class="material-symbols-outlined">visibility</span>'
          : '<span class="material-symbols-outlined">visibility_off</span>';
      });
    }

    this.form.on("submit", (e) => {
      e.preventDefault();
      this.handleLogin();
    });
  }
}
// Inicializar la aplicación cuando el DOM esté listo
$(document).ready(function () {
  // Inicializar Material Design
  if (typeof $.fn.bootstrapMaterialDesign !== "undefined") {
    $("body").bootstrapMaterialDesign();
  }

  // Crear instancia del gestor del formulario
  window.loginManager = new LoginManager();
});
