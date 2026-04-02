/* Archivo: index.js
 * Descripción: Este archivo contiene la lógica principal para la gestión del inventario, incluyendo la carga de productos, renderizado de la tabla y manejo de eventos.
 * Autor: Ing. Edgar Boscan
 * Fecha: 31/03/2026
 */
class InventarioManager {
  /* Constructor de la clase, inicializa las propiedades y carga los productos. */
  constructor() {
    this.BASE_URL =
      document.querySelector('meta[name="base-url"]')?.content || "";

    const URL =
      window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
    this.BASE_URL = URL;

    this.interBase = this.BASE_URL + "/backend/public/index.php/api/inventario";

    this.URL_SEARCH_CATEGORIAS =
      this.BASE_URL + "/backend/public/index.php/api/categorias/search";

    this.URL_SEARCH_MARCAS =
      this.BASE_URL + "/backend/public/index.php/api/marcas/search";

    this.URL_FORM_PRODUCTO = this.BASE_URL + "/inventario/productos.php";

    this.productos = [];

    this.canEdit = true;

    this.canDelete = true;

    this.containerFilter = null;

    this.init();
  }

  /* Inicializa la aplicación, cargando configuraciones y productos. */
  async init() {
    this.addEventListeners();

    await Utils.getAll_Config(this.BASE_URL);

    this.loadProductos();
  }

  /* Agrega los event listeners a los elementos de la página. */
  addEventListeners() {
    // Ejemplo: Agregar un evento de clic a un botón

    this.containerFilter = document.getElementById("filtros-container");

    document
      .getElementById("logoutBtn")
      ?.addEventListener("click", async () => {
        const confirmed = await Utils.showSwallConfirm(
          "¿Cerrar sesión?",
          "¿Estás seguro de que deseas cerrar sesión?",
        );
        if (confirmed) {
          await Logout();
        }
      });

    document
      .getElementById("btn_apply_filters")
      ?.addEventListener("click", () => {
        this.loadProductos(1);
      });

    document
      .getElementById("filter_search")
      ?.addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          this.loadProductos(1);
        }
      });

    document
      .getElementById("categoria_input")
      ?.addEventListener("change", (e) => {
        if (e.srcElement.value.toString().length <= 0) {
          document.getElementById("categoria_id").value = "";
        }
      });

    document
      .getElementById("btn_clear_filters")
      ?.addEventListener("click", () => {
        document.getElementById("filter_search").value = "";
        document.getElementById("categoria_id").value = "";
        document.getElementById("categoria_input").value = "";
        document.getElementById("marca_id").value = "";
        document.getElementById("marca_input").value = "";
        document.getElementById("filter_tipo").value = "";
        this.loadProductos(1);
      });

    document
      .getElementById("btn_toggle_filters")
      .addEventListener("click", () => {
        if (!this.containerFilter) return;

        const btn = document.getElementById("btn_toggle_filters");
        if (!btn) return;

        const minMargin = 15; // margen mínimo entre botón y contenido
        const targetHeight = btn.offsetHeight + minMargin;

        const iconSpan = btn.querySelector(".material-symbols-outlined");

        if (this.containerFilter.classList.contains("collapsed")) {
          this.containerFilter.classList.remove("collapsed");
          this.containerFilter.style.height = "";
          this.containerFilter.style.overflow = "";
          if (iconSpan) {
            iconSpan.textContent = "keyboard_double_arrow_down";
            iconSpan.classList.remove("rotated");
          }
        } else {
          // ocultar contenido excepto el mismo botón y márgenes mínimos
          this.containerFilter.classList.add("collapsed");
          this.containerFilter.style.height = `${targetHeight}px`;
          this.containerFilter.style.overflow = "hidden";
          if (iconSpan) {
            iconSpan.textContent = "keyboard_double_arrow_right";
            iconSpan.classList.add("rotated");
          }
        }
      });

    Utils.attachAutocomplete(
      "categoria_input",
      "categorias_hidden",
      "categorias_list",
      this.URL_SEARCH_CATEGORIAS,
      (it) => it.nombre,
    );

    Utils.attachAutocomplete(
      "marca_input",
      "marcas_hidden",
      "marcas_list",
      this.URL_SEARCH_MARCAS,
      (it) => it.nombre,
    );
  }

  /*
   * Carga los productos desde el backend y renderiza la tabla.
   * @param {number} page - Número de página para la paginación (opcional, por defecto 1).
   */
  async loadProductos(page = 1) {
    try {
      Utils.showSpinner();

      const params = new URLSearchParams();
      params.set("pagina", page);
      params.set("por_pagina", parseInt(Utils.paginacion?.por_pagina) || 10);
      const fieldMap = [
        ["filter_search", "search"],
        ["categoria_id", "categoria_id"],
        ["marca_id", "marca_id"],
        ["filter_tipo", "tipo"],
      ];

      fieldMap.forEach(([id, name]) => {
        const el = document.getElementById(id);
        if (el && el.value) params.set(name, el.value);
      });

      const res = await fetch(this.interBase + "?" + params.toString(), {
        credentials: "include",
      });

      const data = await res.json();
      const success = data.success;
      const datos = JSON.parse(data.data[0].result).data;
      const pagination = JSON.parse(data.data[0].result).pagination;

      this.renderTable(datos || [], pagination.total || 0, page);
    } catch (error) {
      console.error("Error al cargar productos:", error);
    } finally {
      Utils.hideSpinner();
      document.querySelectorAll(".skeleton-content").forEach((skel) => {
        skel.style.display = "none";
      });
      document.querySelectorAll(".real-content").forEach((real) => {
        real.style.display = "block";
      });
    }
  }

  /**
   * Renderiza la tabla de productos y la paginación.
   * @param {Array} rows - Array de objetos con los datos de los productos.
   * Cada objeto debe tener las propiedades: id, codigo, nombre, tipo, categoria, marca, stock, stock_minimo, maneja_inventario, precio_compra, precio_venta, utilidad_absoluta, marjen_sobre_ventas.
   * @param {number} total - Total de productos para la paginación.
   * @param {number} currentPage - Página actual para la paginación.
   */
  renderTable(rows, total, currentPage) {
    const tbody = document.querySelector("#tabla_productos tbody");
    const pagerUl = document.querySelector("#productos-pagination ul");
    if (!tbody) return;

    // guardamos los datos para usos posteriores (por ejemplo abrir modales)
    if (Array.isArray(rows)) {
      inventarioManager.productos = rows;
    }

    if (!Array.isArray(rows) || rows.length === 0) {
      tbody.innerHTML = `<tr><td colspan="11" class="text-center text-muted">No hay registros.</td></tr>`;
    } else {
      tbody.innerHTML = rows
        .map((r) => {
          const id = r.id || "";
          const badgeStock = obtenerBadgeInventario(
            r.stock_actual,
            r.stock_minimo,
            r.maneja_inventario,
          );
          const badgeTipo = obtenerBadgeTipo(r.tipo);

          const btns = [];

          if (inventarioManager.canEdit)
            btns.push(
              `<button class="btn btn-sm btn-warning btn-edit round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">edit</i></button>`,
            );

          if (inventarioManager.canDelete)
            btns.push(
              `<button class="btn btn-sm btn-danger btn-delete round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">delete</i></button>`,
            );
          return `
        <tr data-id="${id}"">
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Cédula"><code>${r.codigo || ""}</code></td>
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Nombre">${Utils.escapeHtml(r.nombre) || ""}</td>
          <td class="align-middle" data-label="Tipo">${badgeTipo}</td>
          <td class="align-middle" data-label="Categoría">${Utils.escapeHtml(r.categoria) || ""}</td>
          <td class="align-middle" data-label="Marca">${Utils.escapeHtml(r.marca) || ""}</td>
          <td class="align-middle" data-label="Stock" style="text-align: right;">${Utils.formatNumbers(r.stock, 2)}</td>
          <td class="align-middle" data-label="Stock">${badgeStock}</td>
          <td class="align-middle" data-label="Precio de Compra" style="text-align: right;">${Utils.formatNumbers(r.precio_compra, 2) || ""}</td>

          <td class="align-middle" data-label="Utilidad Absoluta" style="text-align: right;">${Utils.formatNumbers(r.utilidad_absoluta, 2) || ""}</td>
          <td class="align-middle" data-label="Margen sobre Ventas" style="text-align: right;">${Utils.formatNumbers(r.margen_sobre_venta, 2) || ""}</td>
          <td class="align-middle" data-label="Precio de Venta" style="text-align: right;">${Utils.formatNumbers(r.precio_venta, 2) || ""}</td>
          <td>
            <div class="btn-group btn-group-sm" 
              role="group" aria-label="Acciones de Medicos">
              ${btns.join("")}
            </div>
          </td>
        </tr>`;
        })
        .join("");
    }
    // paginación con botones (primero, anterior, siguiente, último) y resumen
    const perPage = parseInt(Utils.paginacion[0].valor) || 10;
    const pages = Math.max(1, Math.ceil(total / perPage));
    pagerUl.innerHTML = "";

    const makeLi = (label, p, disabled, active) => {
      const li = document.createElement("li");
      li.className =
        "page-item" + (disabled ? " disabled" : "") + (active ? " active" : "");
      const a = document.createElement("a");
      a.href = "#";
      a.className = "page-link";
      a.textContent = label;
      a.addEventListener("click", (ev) => {
        ev.preventDefault();
        if (!disabled) {
          const pageNum = Number(p) || 1;
          currentPage = pageNum;
          inventarioManager.loadProductos(currentPage);
        }
      });
      li.appendChild(a);
      return li;
    };

    // botón "Primero"
    pagerUl.appendChild(makeLi("««", 1, currentPage === 1, false));
    // botón Anterior
    pagerUl.appendChild(
      makeLi("«", Math.max(1, currentPage - 1), currentPage === 1, false),
    );
    const windowSize = 5;
    let start = Math.max(1, currentPage - Math.floor(windowSize / 2));
    let end = Math.min(pages, start + windowSize - 1);
    if (end - start + 1 < windowSize) start = Math.max(1, end - windowSize + 1);
    for (let i = start; i <= end; i++)
      pagerUl.appendChild(makeLi(String(i), i, false, i === currentPage));
    // botón Siguiente
    pagerUl.appendChild(
      makeLi(
        "»",
        Math.min(pages, currentPage + 1),
        currentPage === pages,
        false,
      ),
    );
    // botón "Último"
    pagerUl.appendChild(makeLi("»»", pages, currentPage === pages, false));

    // resumen de página
    const summary = document.getElementById("productos-page-summary");
    if (summary) {
      summary.innerHTML = `Página <strong>${currentPage}</strong> de <strong>${pages}</strong> - Total <strong>${total}</strong> `;
    }
    tbody.querySelectorAll(".btn-edit").forEach((b) =>
      b.addEventListener("click", (e) => {
        const miObjeto = this.productos.find(
          (p) => p.id == b.getAttribute("data-id"),
        );
        const jsonString = JSON.stringify(miObjeto);
        const urlSegura = encodeURIComponent(jsonString);
        window.location.href = `productos.php?title=Editar Producto&datos=${urlSegura}`;
      }),
    );

    // borrar
    tbody
      .querySelectorAll(".btn-delete")
      .forEach((b) =>
        b.addEventListener("click", (e) =>
          deleteProducto(b.getAttribute("data-id")),
        ),
      );
  }
}

/**
 * Genera un badge HTML con colores que indica el estado del inventario.
 * @param {number} stockActual - Cantidad actual en inventario.
 * @param {number} stockMinimo - Cantidad mínima permitida (stock mínimo).
 * @param {boolean} manejaInventario - True si el producto maneja inventario, False en caso contrario.
 * @returns {string} - Cadena HTML del badge.
 */
function obtenerBadgeInventario(stockActual, stockMinimo, manejaInventario) {
  let icon = "";
  let color = "secondary";
  let estado = "Sin inventario";
  if (!manejaInventario) {
    return '<span class="badge badge-secondary">Sin inventario</span>';
  }

  // Convertir a números por si vienen como string
  const stock = Number(stockActual);
  const minimo = Number(stockMinimo);

  if (stock <= 0) {
    icons = "close";
    color = "danger";
    estado = "Agotado";
    // return `<span class="badge badge-danger">Agotado</span>`;
  } else if (stock <= minimo) {
    icons = "warning";
    color = "warning";
    estado = "Stock bajo";

    // return `<span class="badge badge-warning">Stock bajo - ${stock} Unidades</span>`;
  } else {
    icons = "check";
    color = "success";
    estado = "Stock suficiente";
    // return `<span class="badge badge-success">Stock suficiente - ${minimo} Unidades</span>`;
  }

  return `<span class=\"badge bg-${color}\"><i class=\"material-symbols-rounded 
    align-middle\" style=\"font-size:16px;vertical-align:middle;\">${icons}</i> ${Utils.escapeHtml(estado)}</span>`;
}

/**
 * Genera un badge HTML con colores que indica el estado del inventario.
 * @param {string} tipo - El tipo de producto.
 * @returns {string} - Cadena HTML del badge.
 */
function obtenerBadgeTipo(tipo) {
  switch (tipo) {
    case "simple":
      return `<span class="badge bg-primary">Simple</span>`;
    case "compuesto":
      return `<span class="badge bg-info">Compuesto</span>`;
    default:
      return `<span class="badge bg-secondary">Desconocido</span>`;
  }
}

async function deleteProducto(id) {
  const resp = Utils.showSwallConfirm(
    "¿Eliminar producto?",
    "¿Estás seguro de que deseas eliminar este producto?",
  ).then(async (confirmed) => {
    if (confirmed) {
      try {
        Utils.showSpinner();
        const res = await fetch(`${inventarioManager.interBase}/${id}`, {
          method: "DELETE",
          credentials: "include",
        });
        const data = await res.json();
        const success = JSON.parse(data[0].result).status === "success";
        if (success) {
          Utils.showToast("Producto eliminado correctamente.", "success");
          // Actualizar la tabla o realizar otras acciones necesarias
        } else {
          Utils.showToast("Error al eliminar el producto.", "error");
        }
      } catch (error) {
        console.error("Error al eliminar el producto:", error);
        Utils.showToast("Error al eliminar el producto.", "error");
      } finally {
        Utils.hideSpinner();
      }
    }
  });
}

// Inicializar la aplicación cuando el DOM esté listo
$(document).ready(function () {
  // Inicializar Material Design
  if (typeof $.fn.bootstrapMaterialDesign !== "undefined") {
    $("body").bootstrapMaterialDesign();
  }

  // Crear instancia del gestor del formulario
  window.inventarioManager = new InventarioManager();
});
