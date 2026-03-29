/**
 * Utils helper class with common UI and formatting utilities.
 *
 * Los métodos son estáticos y pueden usarse sin instanciar la clase.
 */
class Utils {
  /**
   * Evita que una función se ejecute demasiado seguido.
   * Ejecuta `fn` sólo cuando han pasado `wait` milisegundos desde la última llamada.
   *
   * @param {Function} fn - Función a ejecutar.
   * @param {number} [wait=300] - Tiempo de espera en ms.
   */
  static debounce(fn, wait = 300) {
    let t = null;
    const self = this;
    return function (...args) {
      if (t) clearTimeout(t);
      t = setTimeout(() => {
        try {
          return fn.apply(self, args);
        } catch (e) {
          console.error("debounce wrapper error", e);
        }
      }, wait);
    };
  }

  /**
   * Muestra el spinner de carga si existe en el DOM.
   * Busca los ids "spinner-carga" o "spinner" y los muestra.
   * Se usa para indicar que la aplicación está esperando una respuesta.
   */
  static showSpinner() {
    try {
      const el =
        document.getElementById("spinner-carga") ||
        document.getElementById("spinner");
      if (el) {
        el.fadeIn();
        el.style.display = "block";
      }
    } catch (e) {}
  }

  /**
   * Crea o devuelve el contenedor donde se muestran los toasts.
   *
   * Este contenedor se inserta en <body> y se posiciona por encima del resto
   * del contenido para que los toasts siempre sean visibles.
   */
  static ensureToastContainer() {
    let container = document.getElementById("toast-container");
    if (!container) {
      container = document.createElement("div");
      container.id = "toast-container";
      container.style.cssText =
        "position:fixed;top:4rem;right:1rem;z-index:20000;display:flex;flex-direction:column;gap:0.5rem;";
      document.body.appendChild(container);
    }
    return container;
  }

  /**
   * Oculta el spinner de carga si existe.
   *
   * Uso típico: llamar después de completar una petición asíncrona.
   */
  static hideSpinner() {
    try {
      const el =
        document.getElementById("spinner-carga") ||
        document.getElementById("spinner");
      if (el) el.style.display = "none";
    } catch (e) {}
  }

  /**
   * Muestra un toast breve (auto-dismiss) en pantalla.
   *
   * @param {string} message - Texto a mostrar en el toast.
   * @param {"success"|"warning"|"danger"|"error"|string} [type="success"] - Tipo de toast.
   */
  static showToast(message, type = "success") {
    const container = this.ensureToastContainer();
    const toast = document.createElement("div");
    toast.textContent = message;
    // basic styling + initial transform for slide-up effect
    toast.style.cssText =
      "min-width:220px;padding:0.5rem 1rem;border-radius:.25rem;color:#fff;opacity:0;transform:translateY(-20px);box-shadow:0 2px 6px rgba(0,0,0,.2);transition:opacity .3s,transform .3s;";
    switch (type) {
      case "success":
        toast.style.backgroundColor = "#28a745";
        break;
      case "danger":
      case "error":
        toast.style.backgroundColor = "#dc3545";
        break;
      case "warning":
        toast.style.backgroundColor = "#ffc107";
        toast.style.color = "#000";
        break;
      default:
        toast.style.backgroundColor = "#17a2b8"; // info/other
    }
    container.appendChild(toast);
    // animate in (slide up + fade)
    requestAnimationFrame(() => {
      toast.style.opacity = "1";
      toast.style.transform = "translateY(0)";
    });
    // auto dismiss (1.5s)
    setTimeout(() => {
      toast.style.opacity = "0";
      toast.style.transform = "translateY(-20px)";
      setTimeout(() => container.removeChild(toast), 300);
    }, 1500);
  }

  // custom confirmation box that avoids using SweetAlert2 directly and
  // displays a fixed overlay above everything else. Returns a promise
  // resolved with true/false. The overlay is appended to <body> and
  // includes its own backdrop so it is always visible, even when another
  // Swal modal is open.
  static customSwalConfirm(title, text) {
    return new Promise((resolve) => {
      console.log("customSwalConfirm creating overlay", title, text);

      // backdrop
      const backdrop = document.createElement("div");
      backdrop.style.cssText =
        "position:fixed;top:0;left:0;width:100%;height:100%;" +
        "background:rgba(0,0,0,0.4);z-index:30000;";
      document.body.appendChild(backdrop);

      // dialog with animation class
      const confirmDiv = document.createElement("div");
      confirmDiv.style.cssText =
        "position:fixed;top:50%;left:50%;transform:translate(-50%,-50%) scale(0.8);" +
        "min-width:300px;padding:1rem;" +
        "background:#fff;border-radius:.25rem;z-index:30001;" +
        "opacity:0;transition:opacity .25s,transform .25s;";

      confirmDiv.innerHTML =
        `<div style=\"text-align:center;\"><i class=\"material-icons\" style=\"font-size:48px;color:#2196f3;\">help_outline</i></div>` +
        `<h2 style=\"margin-top:0;text-align:center;\">${title}</h2>` +
        `<div style=\"margin:1rem 0;text-align:center;\">${text}</div>` +
        `<div style=\"display:flex;justify-content:flex-end;gap:.5rem;\">` +
        `<button class=\"btn btn-primary\">Quitar</button>` +
        `<button class=\"btn btn-light\">Cancelar</button>` +
        `</div>`;
      document.body.appendChild(confirmDiv);

      // trigger animation
      requestAnimationFrame(() => {
        confirmDiv.style.opacity = "1";
        confirmDiv.style.transform = "translate(-50%,-50%) scale(1)";
      });

      const cleanUp = () => {
        backdrop.remove();
        confirmDiv.remove();
      };

      confirmDiv.querySelector(".btn-primary").addEventListener("click", () => {
        console.log("customSwalConfirm confirmed");
        cleanUp();
        resolve(true);
      });
      confirmDiv.querySelector(".btn-light").addEventListener("click", () => {
        console.log("customSwalConfirm cancelled");
        cleanUp();
        resolve(false);
      });
    });
  }

  /**
   * Formatea una fecha/hora para mostrarla en el formato local del usuario.
   *
   * @param {string|number|Date} dt - Fecha a formatear.
   * @returns {string} Cadena de fecha y hora formateada o cadena vacía si es inválido.
   */
  static formatDate(dt, witchHour = true) {
    if (!dt) return "";
    const d = new Date(dt);
    if (witchHour) {
      return d.toLocaleString(undefined, {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      });
    } else {
      return d.toLocaleString(undefined, {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
      });
    }
  }

  /**
   * Escapa caracteres especiales para renderizar texto seguro en HTML.
   * Evita inyecciones de HTML/JS al mostrar datos del usuario.
   *
   * @param {any} str - Texto de entrada.
   * @returns {string} Texto escapado listo para inyectar en el DOM.
   */
  static escapeHtml(str) {
    if (str == null) return "";
    return String(str)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#39;")
      .replace(/`/g, "&#96;")
      .trim();
  }

  /**
   * Devuelve la hora local (HH:MM:SS) de una fecha dada.
   *
   * @param {string|number|Date} dt - Fecha a partir de la cual obtener la hora.
   * @returns {string} Hora formateada o cadena vacía si no se suministra fecha.
   */
  static getTime(dt) {
    if (!dt) return "";
    const d = new Date(dt);
    return d.toLocaleTimeString();
  }

  /**
   * Maneja respuestas de autenticación/autorization HTTP.
   *
   * - Para 401 redirige al login.
   * - Para 403 muestra un Swal con mensaje de acceso denegado.
   *
   * @param {{status:number}} res - Objeto de respuesta (fetch/axios) que contiene el código HTTP.
   * @returns {boolean} true si el acceso está autorizado, false si se redirige o se muestra un error.
   */
  static handleAuth(res) {
    console.log("handleAuth status", res.status);
    if (res.status === 401) {
      console.warn("handleAuth: redirigiendo por 401");
      location.href = "../../../frontend/index.html";
      return false;
    }
    if (res.status === 403) {
      console.warn("handleAuth: acceso denegado 403");
      Swal.fire(
        "Acceso denegado",
        "No tienes permiso para ver esto.",
        "warning",
      );
      return false;
    }
    return true;
  }

  /**
   * Actualiza el elemento QRCode con un nuevo valor.
   *
   * @param {string} textValue - Texto que se codificará en el QR.
   */
  static updateQRCode(textValue) {
    var qrcode = new QRCode("qr_code", {
      text: textValue,
      width: 128,
      height: 128,
      colorDark: "#000000",
      colorLight: "#ffffff",
      correctLevel: QRCode.CorrectLevel.H,
    });
  }

  /**
   * Carga una imagen remota y devuelve su representación data URL.
   *
   * @param {string} url - URL de la imagen.
   * @returns {Promise<string|null>} Data URL de la imagen o null si falla la carga.
   */
  static async getImageDataUrl(url) {
    try {
      const res = await fetch(url, { cache: "no-cache" });
      if (!res.ok) throw new Error("No se pudo cargar imagen: " + res.status);
      const blob = await res.blob();
      return await new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result);
        reader.onerror = reject;
        reader.readAsDataURL(blob);
      });
    } catch (err) {
      console.warn("getImageDataUrl:", err);
      return null;
    }
  }

  /**
   * Formatea un número como moneda en formato US (USD).
   *
   * @param {number} v - Valor numérico a formatear.
   * @returns {string} Valor formateado como moneda.
   */
  static formatCurrency(v) {
    const formattedCurrency = new Intl.NumberFormat("en-US", {
      style: "currency",
      currency: "USD",
      currencySign: "accounting",
    }).format(v);
    return formattedCurrency;
  }

  /**
   * Formatea un número con ceros a la izquierda y número fijo de decimales.
   *
   * @param {number} v - Valor numérico a formatear.
   * @param {number} d - Cantidad de decimales.
   * @returns {string} Número formateado.
   */
  static formatNumbers(v, d) {
    const formattedUS = new Intl.NumberFormat("en-US", {
      minimumIntegerDigits: 1,
      minimumFractionDigits: d,
    }).format(v);
    return formattedUS;
  }

  /**
   * Muestra un modal de error usando SweetAlert2 con estilo predefinido.
   *
   * @param {string} title - Título del modal.
   * @param {string} mensaje - Mensaje a mostrar en el cuerpo.
   */
  static showSwallError(title, mensaje) {
    Swal.fire({
      title: "<strong>" + title + "</strong>",
      html:
        '<h1 class="text-gradient"><strong>¡UPS..!</strong></h1><p class="mt-3">' +
        mensaje +
        "</p>",
      allowOutsideClick: false,
      confirmButtonColor: "#ff0000",
      backdrop: "rgba(61, 63, 66, 0.73)",
      showClass: {
        popup: `
      animate__animated
      animate__fadeInUp
      animate__faster
    `,
      },
      hideClass: {
        popup: `
      animate__animated
      animate__fadeOutDown
      animate__faster
    `,
      },
      icon: "error",
    });
  }

  /**
   * Muestra un modal SweetAlert2 auto-cerrable (toast-like) con icono.
   *
   * @param {string} icons - Nombre del icono (por ejemplo: "success", "warning").
   * @param {string} title - Título del modal.
   * @param {string} mensaje - Mensaje a mostrar.
   * @param {number} [time=1500] - Tiempo en ms antes de cerrar automáticamente.
   */
  static async showSwalSB(icons, title, mensaje, time = 1500) {
    await Swal.fire({
      title: "<strong>" + title + "</strong>",
      icon: icons,
      html:
        '<h5 class="text-gradient"><p class="mt-3">' + mensaje + "</h1></p>",
      allowOutsideClick: false,
      timer: time,
      showConfirmButton: false,
      backdrop: "rgba(61, 63, 66, 0.73)",
      showClass: {
        popup: `
      animate__animated
      animate__fadeInUp
      animate__faster
    `,
      },
      hideClass: {
        popup: `
      animate__animated
      animate__fadeOutDown
      animate__faster
    `,
      },
    });
  }

  /**
   * Muestra un modal SweetAlert2 estándar con icono.
   *
   * @param {string} icons - Nombre del icono (por ejemplo: "success", "error").
   * @param {string} title - Título del modal.
   * @param {string} mensaje - Mensaje a mostrar.
   */
  static showSwal(icons, title, mensaje) {
    Swal.fire({
      title: "<strong>" + title + "</strong>",
      html:
        '<h1 class="text-gradient"><strong>¡UPS..!</strong></h1><p class="mt-3">' +
        mensaje +
        "</p>",
      allowOutsideClick: false,
      backdrop: "rgba(61, 63, 66, 0.73)",
      showClass: {
        popup: `
      animate__animated
      animate__fadeInUp
      animate__faster
    `,
      },
      hideClass: {
        popup: `
      animate__animated
      animate__fadeOutDown
      animate__faster
    `,
      },
      icon: icons,
    });
  }

  /**
   * Obtiene todas las configuraciones de la API y las transforma en un arreglo usable.
   *
   * @param {string} [BASE_URL] - URL base donde está el backend (por defecto ".." ).
   * @returns {Promise<Array>} Arreglo de configuraciones desnormalizadas.
   */
  static async getAllConfig(BASE_URL) {
    try {
      var resp = await fetch(
        (BASE_URL || "..") + "/backend/public/index.php/api/getConfig",
      );
      var items = await resp.json();
      var configuracion = [];
      items.configuracion_sistema.forEach((it) => {
        const grupo = JSON.parse(it.configuracion_completa).grupos;
        // const info = grupo.api.info;
        const info = Object.values(grupo)[0].info;
        // info.configuracion = grupo.api.configuraciones;
        info.configuracion = Object.values(grupo)[0].configuraciones;

        configuracion.push(info);
      });

      return configuracion;
    } catch (error) {
      this.showSwalSB(
        "error",
        "Error de configuración",
        "No se pudo cargar la configuración.",
        2000,
      );
      return null;
    }
  }

  /**
   * Obtiene una configuración específica (por grupo) desde la API.
   *
   * @param {string} [BASE_URL] - URL base donde está el backend.
   * @param {string} grupo - Nombre del grupo de configuración a obtener.
   * @returns {Promise<any>} Configuración del grupo especificado o null si no existe.
   */
  static async getConfig(BASE_URL, grupo) {
    try {
      var resp = await fetch(
        (BASE_URL || "..") + "/backend/public/index.php/api/getConfig",
      );
      var items = await resp.json();
      var resp = [];
      if (!items) return null;
      if (items.configuracion_sistema !== undefined) {
        items.configuracion_sistema.forEach((it) => {
          const grp = JSON.parse(it.configuracion_completa).grupos;
          // const info = grupo.api.info;
          if (Object.keys(grp)[0] === grupo) {
            resp = grp[grupo]["configuraciones"];
            return;
          }
        });
      } else {
        items.forEach((it) => {
          const grp = JSON.parse(it.configuracion_completa).grupos;
          // const info = grupo.api.info;
          if (Object.keys(grp)[0] === grupo) {
            resp =
              grp[grupo] !== undefined ? grp[grupo]["configuraciones"] : null;
            return;
          }
        });
      }

      return resp;
    } catch (error) {
      this.showSwalSB(
        "error",
        "Error de configuración",
        "No se pudo cargar la configuración.",
        2000,
      );
      return null;
    }
  }

  /**
   * Busca en un arreglo de objetos la entrada cuyo campo `nombre` coincide con `q`.
   *
   * @param {Array<{nombre:string,valor:any}>} array - Arreglo de objetos con propiedades `nombre` y `valor`.
   * @param {string} q - Texto a buscar en la propiedad `nombre`.
   * @returns {any} Valor asociado al nombre encontrado o null si no se encuentra.
   */
  static findInArray(array, q) {
    var resp = null;
    array.forEach((it) => {
      if (it.nombre === q) {
        resp = it.valor;
        return;
      }
    });
    return resp;
  }

  /**
   * Capitaliza la primera letra de una cadena.
   *
   * @param {string} string - Texto a capitalizar.
   * @returns {string} Texto con la primera letra en mayúscula.
   */
  static capitalizeFirstLetter(string) {
    if (!string) return string; // Handle empty or null strings
    return string.charAt(0).toUpperCase() + string.slice(1);
  }
}
