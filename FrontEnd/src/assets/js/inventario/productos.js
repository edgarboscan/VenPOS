/**Archivo: productos.js
 * Descripción: Este archivo contiene la lógica principal para el formulario de productos, incluyendo la adición y edición de productos, carga de codigos y precios.
 * Autor: Ing. Edgar Boscan
 * Fecha: 31/03/2026
 */
class ProductosManager {
  constructor() {
    this.BASE_URL =
      document.querySelector('meta[name="base-url"]')?.content || "";

    const URL =
      window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
    this.BASE_URL = URL;

    this.interBase = this.BASE_URL + "/backend/public/index.php/api/inventario";

    this.URL_SEARCH_CATEGORIAS =
      this.BASE_URL + "/backend/public/index.php/api/categorias/search";

    this.URL_SEARCH_UNIDADES =
      this.BASE_URL + "/backend/public/index.php/api/unidad-medida/search";

    this.URL_SEARCH_MARCAS =
      this.BASE_URL + "/backend/public/index.php/api/marcas/search";

    this.producto = null;
    this.codigos = [];
    this.jCodigos = [];
    this.precios = [];
    this.jPrecios = [];

    this.canEdit = true;
    this.canDelete = true;

    this.codigo = document.getElementById("tCodigo");
    this.nombre = document.getElementById("tNombre");
    this.descripcion = document.getElementById("tDescripcion");
    this.categoria_id = document.getElementById("categoria_id");
    this.categoria_input = document.getElementById("categoria_input");
    this.marca_id = document.getElementById("marca_id");
    this.marca_input = document.getElementById("marca_input");
    this.unidad_medida_input = document.getElementById("unidad_input");
    this.unidad_medida_id = document.getElementById("unidad_id");
    this.stock_minimo = document.getElementById("tStockMinimo");
    this.checkboxActivo = document.getElementById("checkboxActivo");
    this.checkboxInventario = document.getElementById("checkboxInventario");
    this.cTipo = document.getElementById("cTipo");
    this.lblActivo = document.getElementById("lblActivo");
    this.btnAddCodigo = document.getElementById("btn_add_Codigos");
    this.btnAddPrecio = document.getElementById("btn_add_Precios");

    this.init();
  }
  async init() {
    this.addEventListeners();

    await Utils.getAll_Config(this.BASE_URL);

    this.loadProductoData();
  }

  addEventListeners() {
    Utils.attachAutocomplete(
      "marca_input",
      "marcas_hidden",
      "marcas_list",
      this.URL_SEARCH_MARCAS,
      (it) => it.nombre,
    );

    Utils.attachAutocomplete(
      "categoria_input",
      "categorias_hidden",
      "categorias_list",
      this.URL_SEARCH_CATEGORIAS,
      (it) => it.nombre,
    );

    Utils.attachAutocomplete(
      "unidad_input",
      "unidades_hidden",
      "unidades_list",
      this.URL_SEARCH_UNIDADES,
      (it) => it.nombre,
    );

    this.checkboxActivo.onchange = function () {
      if (this.checked) {
        lblActivo.textContent = "Activo";
      } else {
        lblActivo.textContent = "Inactivo";
      }
    };

    this.btnAddCodigo.addEventListener("click", () => this.openModalCodigo());

    this.btnAddPrecio.addEventListener("click", () => this.openModalPrecio());
  }

  getParameterByName(name) {
    const url = new URL(window.location.href);
    return url.searchParams.get(name);
  }

  loadProductoData() {
    try {
      const json = this.getParameterByName("datos");
      this.producto = JSON.parse(json);
      console.log("Producto recibido:", this.producto);
      if (!this.producto) return;

      this.codigo.value = this.producto.codigo;
      this.nombre.value = this.producto.nombre;
      this.descripcion.value = this.producto.descripcion;
      this.categoria_id.value = this.producto.categoria_id;
      this.categoria_input.value = this.producto.categoria;
      this.marca_id.value = this.producto.marca_id;
      this.marca_input.value = this.producto.marca;
      this.unidad_medida_id.value = this.producto.unidad_medida_id;
      this.unidad_medida_input.value = this.producto.unidad_medida;
      this.stock_minimo.value = this.producto.stock_minimo;
      this.checkboxActivo.checked = this.producto.activo == 1;
      this.checkboxInventario.checked = this.producto.maneja_inventario == 1;
      this.cTipo.value = this.producto.tipo;
      this.lblActivo.textContent =
        this.producto.activo == 1 ? "Activo" : "Inactivo";
      this.renderCodigos(this.producto.codigos);

      this.renderPrecios(this.producto.precios);
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

  renderCodigos(codigos) {
    const tbody = document.querySelector("#tabla_codigos tbody");
    if (!tbody) return;
    // guardamos los datos para usos posteriores (por ejemplo abrir modales)
    if (Array.isArray(codigos)) {
      this.codigos = codigos;
    }
    if (!Array.isArray(codigos) || codigos.length === 0) {
      tbody.innerHTML = `<tr><td colspan="4" class="text-center text-muted">No hay registros.</td></tr>`;
    } else {
      tbody.innerHTML = codigos
        .map((r) => {
          const id = r.id || "";
          const badgeEstado = obtnerBadgeEstado(r.activo);

          const btns = [];

          if (productosManager.canEdit)
            btns.push(
              `<button class="btn btn-sm btn-warning btn-edit round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">edit</i></button>`,
            );

          if (productosManager.canDelete)
            btns.push(
              `<button class="btn btn-sm btn-danger btn-delete round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">delete</i></button>`,
            );

          return `
            <tr data-id="${id}"">
              <td class="align-middle d-none d-sm-table-cell" 
            data-label="Costo">${Utils.escapeHtml(r.tipo_codigo.replace("_", " "))}</td>

              <td class="align-middle text-center d-none d-sm-table-cell" 
            data-label="Costo"><code>${Utils.escapeHtml(r.codigo)}</code></td>

            <td class="align-middle  text-center d-none d-sm-table-cell" 
            data-label="Estado">${badgeEstado || ""}</td>

            <td class="align-middle text-center">
              <div class="btn-group btn-group-sm" 
                role="group" aria-label="Acciones de Medicos">
                ${btns.join("")}
              </div>
            </td>
          </tr>
          `;
        })
        .join();
    }

    tbody.querySelectorAll(".btn-edit").forEach((b) =>
      b.addEventListener("click", (e) => {
        this.openModalCodigo(b.getAttribute("data-id"));
      }),
    );

    // borrar
    tbody
      .querySelectorAll(".btn-delete")
      .forEach((b) =>
        b.addEventListener("click", (e) =>
          deleteCodigo(b.getAttribute("data-id")),
        ),
      );
  }

  renderPrecios(precios) {
    const tbody = document.querySelector("#tabla_precios tbody");
    if (!tbody) return;
    // guardamos los datos para usos posteriores (por ejemplo abrir modales)
    if (Array.isArray(precios)) {
      this.precios = precios;
    }
    if (!Array.isArray(precios) || precios.length === 0) {
      tbody.innerHTML = `<tr><td colspan="8" class="text-center text-muted">No hay registros.</td></tr>`;
    } else {
      tbody.innerHTML = precios
        .map((r) => {
          const id = r.id || "";
          const badgeEstado = obtnerBadgeEstado(r.activo);
          const badgeOferta = obtnerBadgeOferta(
            r.fecha_inicio_oferta,
            r.fecha_fin_oferta,
          );

          const btns = [];

          if (productosManager.canEdit)
            btns.push(
              `<button class="btn btn-sm btn-warning btn-edit round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">edit</i></button>`,
            );

          if (productosManager.canDelete)
            btns.push(
              `<button class="btn btn-sm btn-danger btn-delete round-4 border-0" data-id="${r.id}" ><i class="material-symbols-rounded">delete</i></button>`,
            );

          return `
            <tr data-id="${id}"">
              <td class="align-middle d-none d-sm-table-cell" 
            data-label="Costo">${Utils.formatNumbers(r.precio_compra, 2)}</td>

            <td class="align-middle d-none d-sm-table-cell" 
            data-label="Utilidad" title ="Ganancia de: ${Utils.formatNumbers(r.utilidad_absoluta, 2)}"><code>${Utils.formatNumbers(r.margen_sobre_costo, 2)}</code></td>

            <td class="align-middle d-none d-sm-table-cell" 
            data-label="Venta">${Utils.formatNumbers(r.precio_venta, 2)}</td>
            
            <td class="align-middle d-none d-sm-table-cell" 
            data-label="Venta">${Utils.formatNumbers(r.precio_oferta, 2)}</td>

            <td class="align-middle d-none d-sm-table-cell" 
            data-label="Venta">${badgeOferta}</td>

           <td class="align-middle d-none d-sm-table-cell" 
            data-label="Venta">${Utils.formatNumbers(r.margen_sobre_venta, 2)}</td>

            <td class="align-middle d-none d-sm-table-cell" 
            data-label="Estado">${badgeEstado || ""}</td>

            <td class="align-middle text-center">
              <div class="btn-group btn-group-sm" 
                role="group" aria-label="Acciones de Medicos">
                ${btns.join("")}
              </div>
            </td>
          </tr>
          `;
        })
        .join();
    }

    tbody.querySelectorAll(".btn-edit").forEach((b) =>
      b.addEventListener("click", (e) => {
        this.openModalPrecio(b.getAttribute("data-id"));
      }),
    );

    // borrar
    tbody
      .querySelectorAll(".btn-delete")
      .forEach((b) =>
        b.addEventListener("click", (e) =>
          deletePrecio(b.getAttribute("data-id")),
        ),
      );
  }

  /**
   * Muestra el Modal de codigos
   * @param {*} id
   */

  async openModalCodigo(id) {
    // lógica para abrir el modal de edición o creación de codigo
    console.log("Abrir modal para codigo ID:", id);
    // Aquí puedes implementar la lógica para mostrar un modal con los detalles del codigo
    await Utils.ensureSwal();
    const isNew = !id;
    const title = isNew ? "Nuevo Codigo" : "Editar Codigo";

    // Function to check for duplicates
    async function checkDuplicate(codigo) {
      if (!codigo) return null;
      try {
        const params = new URLSearchParams();
        if (codigo) params.set("codigo", codigo);
        params.set("id", null);
        const resp = await fetch(interBase + "/obtenerBy" + `?${params}`, {
          cache: "no-store",
        });
        const data = await resp.json();
        if (data && data.success) {
          var _resu = [];
          var resultados = data.resultados || [];
          var code = resultados.codigo || "";
          var codCodigo = cedula ? cedula.codigo : "";
          var existing = codCodigo === 200;

          var msj = "";
          if (codCodigo === 200) {
            msj += ` <strong>Codigo:</strong> <code>${code.data[0].codigo}</code> `;
            msj += `Insumo: <strong>${code.data[0].nombre || ""}</strong><br />`;
          }

          if (isNew && existing) {
            return JSON.stringify({
              success: existing,
              msj: msj,
              cedula: code ? code.valor : "",
            });
          }
        }
      } catch (e) {
        return JSON.stringify({
          success: false,
          error: e.message || "Error desconocido",
        });
      }
      return JSON.stringify({
        success: false,
      });
    }

    async function guardar() {
      const popup = Swal.getPopup();
      const form = popup.querySelector("#swal-form");

      const codigo = form.querySelector('[name="codigo"]').value.trim();

      // Verificar duplicados (solo para nuevos insumos)
      if (isNew) {
        const duplicate = JSON.parse(await checkDuplicate(codigo));
        if (duplicate.success) {
          Swal.showValidationMessage(
            `Ya existe un insumo  con este codigo.<br />${duplicate.msj}`,
          );
          return false;
        }
      }

      // Recopilar datos del formulario
      const data = {
        id: form.querySelector('[name="id"]')?.value || null,
        codigo: codigo,
        tipo_codigo: form.querySelector("#tTipoCodigo").value,
        activo: form.querySelector("#checkboxActivo").checked ? 1 : 0,
      };

      if (!data.codigo) {
        Swal.showValidationMessage("codigo es requerida");
        return false;
      }

      if (!data.tipo_codigo) {
        Swal.showValidationMessage("Tipo de codigo es requerido");
        return false;
      }

      if (!data.activo) {
        Swal.showValidationMessage("Activo es requerido");
        return false;
      }

      // Mostrar indicador de carga
      Swal.showLoading();

      // Enviar al servidor
      try {
        if (!isNew) {
          const resp = await fetch(
            interBase + (data.id ? "/update" : "/create"),
            {
              method: "POST",
              headers: { "Content-Type": "application/json" },
              body: JSON.stringify(data),
            },
          );

          const result = await resp.json();

          if (!result || result.status !== "success") {
            throw new Error(result.message || "Error guardando");
          }
        } else {
          
        }
        // Cerrar el modal actual
        Swal.close();

        // Mostrar mensaje de éxito
        Utils.showSwalSB(
          "success",
          "¡Guardado!",
          result.message || "Paciente guardado exitosamente",
          1500,
        );

        // Recargar la tabla
        await loadTable();

        return true;
      } catch (err) {
        Swal.hideLoading();
        Swal.showValidationMessage(
          err.message || "Error guardando el paciente",
        );
        return false;
      }
    }

    const modalHTML = `
    <form id="swal-form" novalidate>
      <input type="hidden" name="id"/>
        <div class="header-form row gx-3 gy-2 align-items-center">
          <div class="col-12 col-md-6">
            <div class="mb-2">
              <div class="d-flex align-items-start" style="gap:.5rem;
                flex-wrap:wrap;">
                <label for="tTipo" class="form-label small 
                  mb-0">Nombre</label>
                <select id="tTipoCodigo" class="form-control" autocomplete="off" required>
                    <option value=''>Seleccione un tipo de codigo</option>
                    <option value='EAN13'>EAN13</option>
                    <option value='UPC'>UPC</option>
                    <option value='CODIGO_INTERNO'>CODIGO INTERNO</option>
                    <option value='OTRO'>OTRO</option>
                  </select>
              </div>
            </div>
          </div>
          <div class="col-12 col-md-6">
            <label class="font-weight-bold small">Codigo</label>
            <input name="codigo" id="tCodigo" class="form-control" placeholder="Codigo" required
                aria-label="Codigo" />
          </div>  
          <div class="col-12 col-md-12">
            <div class="parent-container">
              
              <div class="checkbox-container align-content-start">
                <div class="checkbox-wrapper">
                  <input class="checkbox" id="checkboxActivo" type="checkbox"  />
                  <label class="checkbox-label" for="checkboxActivo">
                    <div class="checkbox-flip">
                      <div class="checkbox-front">
                        <svg
                          fill="white"
                          height="16"
                          width="16"
                          viewBox="0 0 24 24"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M18 6L12 12L18 18L17 19L11 13L5 19L4 18L10 12L4 6L5 5L11 11L17 5L18 6Z"
                            class="icon-path"
                          />
                        </svg>
                      </div>
                      <div class="checkbox-back">
                        <svg
                          fill="white"
                          height="16"
                          width="16"
                          viewBox="0 0 24 24"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            d="M9 19l-7-7 1.41-1.41L9 16.17l11.29-11.3L22 6l-13 13z"
                            class="icon-path"
                          ></path>
                        </svg>
                      </div>
                    </div>
                  </label>
                </div>
              </div>
              <h5 id="lblActivo">Inactivo</h5>
            </div>
          </div>

        </div>
    </form>
  
  `;

    Swal.fire({
      title: title,
      html: modalHTML,
      width: "600px",
      heightAuto: false,
      showCancelButton: true,
      confirmButtonColor: "rgb(92, 190, 255)",
      cancelButtonColor: "#d33",
      confirmButtonText: "Grabar",
      cancelButtonText: "Cancelar",
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
      didOpen: () => {
        const popup = Swal.getPopup();
        const form = popup.querySelector("#swal-form");
        const checkbox = form.querySelector("#checkboxActivo");
        const lblActivo = form.querySelector("#lblActivo");

        if (!isNew) {
          // cargar datos del codigo en el formulario
          const codigoData = this.codigos.find((c) => c.id == id);
          if (codigoData) {
            form.codigo.value = codigoData.codigo;
            form.tTipoCodigo.value = codigoData.tipo_codigo;
            checkbox.checked = codigoData.activo == 1;
            lblActivo.textContent =
              codigoData.activo == 1 ? "Activo" : "Inactivo";
          }
        }

        try {
          checkbox.onchange = function () {
            if (this.checked) {
              lblActivo.textContent = "Activo";
            } else {
              lblActivo.textContent = "Inactivo";
            }
          };
        } catch (error) {}
        // evitar que Enter cierre el modal o dispare el s
      },
    });
  }

  async openModalPrecio(id) {
    // lógica para abrir el modal de edición o creación de precio
    console.log("Abrir modal para precio ID:", id);
    // Aquí puedes implementar la lógica para mostrar un modal con los detalles del precio
    await Utils.ensureSwal();
    const isNew = !id;
    const title = isNew ? "Nuevo Precio" : "Editar Precio";

    Swal.fire({
      title,
      html: `<p>Funcionalidad de ${isNew ? "creación" : "edición"} de producto aún no implementada.</p>`,
      icon: "info",
    });
  }
}

function obtnerBadgeEstado(estado) {
  if (!estado) return "";
  estado = estado === 1 ? "Activo" : "Inactivo";

  let icon = "";
  let color = "secondary";
  switch (estado.toLowerCase()) {
    case "activo":
      icon = "check";
      color = "success";
      break;
    case "inactivo":
      icon = "mode_off_on";
      color = "danger";
    default:
      icon = "mode_off_on";
      color = "secondary";
  }
  return `<span class=\"badge bg-${color}\"><span class=\"material-symbols-outlined 
    align-middle\" style=\"font-size:16px;vertical-align:middle;\">${icon}</span> ${Utils.escapeHtml(estado)}</span>`;
}

function obtnerBadgeOferta(inicio, fin) {
  let estado = "";
  if (!inicio || !fin) return "";

  let icon = "alarm_on";
  let color = "secondary";

  const dateInicio = new Date(inicio);
  const dateFin = new Date(fin);
  const ahora = new Date();

  if (ahora >= dateInicio && ahora <= dateFin) {
    color = "succes";
    estado = "Activa";
  } else {
    icon = "do_not_disturb_off";
    estado = "Inactiva";
  }

  return `<span class=\"badge bg-${color}\"><span class=\"material-symbols-outlined 
    align-middle\" style=\"font-size:16px;vertical-align:middle;\">${icon}</span> ${Utils.escapeHtml(estado)}</span>`;
}

// Inicializar la aplicación cuando el DOM esté listo
$(document).ready(function () {
  // Inicializar Material Design
  if (typeof $.fn.bootstrapMaterialDesign !== "undefined") {
    $("body").bootstrapMaterialDesign();
  }

  // Crear instancia del gestor del formulario
  window.productosManager = new ProductosManager();
});
