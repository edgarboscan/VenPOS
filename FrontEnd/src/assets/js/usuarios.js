// lógica para página de pacienntes
// utilidades compartidas se cargan mediante <script> en la página
// (no usamos import porque el archivo se incluye como script normal)
(function () {
  const BASE_URL =
    document.querySelector('meta[name="base-url"]')?.content || "";

  const interBase =
    (BASE_URL || "..") + "/backend/public/index.php/api/usuarios";

  let usuarios = [];

  let canEdit = true;

  let canDelete = true;
  let canView = true;

  var seguridad = [];
  var paginacion = [];
  let ruless = [];

  let rolesList = [];
  let rolesSelected = [];
  // helpers para carga dinámica de librerías ( SweetAlert2 )
  function loadScript(src) {
    return new Promise((resolve, reject) => {
      if (!src) return reject(new Error("missing src"));
      const s = document.createElement("script");
      s.src = src;
      s.async = true;
      s.onload = () => resolve();
      s.onerror = (e) => reject(e);
      document.head.appendChild(s);
    });
  }

  async function ensureSwal() {
    if (window.Swal) return;
    try {
      await loadScript("https://cdn.jsdelivr.net/npm/sweetalert2@11");
      console.info("SweetAlert2 cargado dinámicamente");
      // after loading define custom styles for step indicators, scoped to our custom popup
      const style = document.createElement("style");
      style.textContent = `
        /* progress bar container should distribute full width */
        .swal2-progress-steps { display: flex; flex-wrap: nowrap; padding-top: 1.5rem; }
        .swal2-progress-step {
          flex: 1 1 0;
          position: relative;
          display: flex !important;
          flex-direction: column;
          align-items: center;
          justify-content: center;
          padding: 0.75rem 0.5rem;
          margin: 0 0.125rem;
          border-radius: var(--radius-sm,0.375rem);
          background: var(--gray-50, #f8f9fa);
          color: var(--gray-900, #212529);
          min-width: 6rem;
        }
        .swal2-progress-step-number {
          position: absolute;
          top: -1.25rem;
          left: 50%;
          transform: translateX(-50%);
          width: 2rem;
          height: 2rem;
          line-height: 2rem;
          border-radius: 50%;
          background: var(--gray-200, #eeeeee);
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 1em;
        }
        .swal2-progress-step-label,
        .swal2-progress-step p {
          white-space: normal;
          text-align: center;
          font-size: 0.9em;
          margin: 0;
          padding-top: 0.5rem;
        }
        /* state colors */
        .swal2-progress-step.step-done { background: var(--success-100, #e8f5e9); color: var(--success-700, #388e3c); }
        .swal2-progress-step.step-upcoming { background: #fff; color: var(--gray-700, #616161); }
        .swal2-progress-step.swal2-progress-step-active { background: var(--primary-500, #2196f3); color: #fff; }
        .swal2-progress-step.swal2-progress-step-active .swal2-progress-step-number {
          background: #fff;
          color: var(--primary-500, #2196f3);
          font-weight: bold;
        }
        /* ensure modal content wraps nicely */
        .swal2-html-container { white-space: normal; word-wrap: break-word; }
        /* stepper styles scoped to our custom popup */
        .my-swal .stepper {
          display: flex !important;
          flex-wrap: nowrap !important;
          justify-content: space-between !important;
          margin-bottom: 1rem !important;
        }
        .my-swal .stepper-step {
          flex: 1 1 auto !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          text-align: center !important;
          padding: 0.5rem !important;
          border-radius: 0.25rem !important;
          background: #f8f9fa !important;
          margin: 0 0.25rem !important;
        }
        .my-swal .stepper-step.active { background: #007bff !important; color: white !important; }
        .my-swal .stepper-step.completed { background: #28a745 !important; color: white !important; }
        .my-swal .stepper-indicator {
          width: 2rem !important;
          height: 2rem !important;
          border-radius: 50% !important;
          background: #ddd !important;
          display: flex !important;
          align-items: center !important;
          justify-content: center !important;
          margin: 0 auto 0.5rem !important;
          font-weight: bold !important;
          color: #333 !important;
        }
        .my-swal .stepper-step.active .stepper-indicator { background: #007bff !important; color: white !important; }
        .my-swal .stepper-step.completed .stepper-indicator { background: #28a745 !important; color: white !important; }
        .my-swal .stepper-label { font-size: 0.9em !important; }
        .my-swal .step-panel { display: none !important; }
        .my-swal .step-panel.active { display: block !important; }
        .my-swal .stepper-controls { display: flex !important; gap: 0.5rem !important; }
        /* ensure Swal container and popup sit above header */
        .swal2-container { z-index: 2147483647 !important; }
        .swal2-popup { z-index: 2147483647 !important; }
      `;
      document.head.appendChild(style);
    } catch (e) {
      console.warn("No se pudo cargar SweetAlert2 dinámicamente:", e);
    }
    // estilos compactos para botones de acción en la tabla
    (function () {
      const s = document.createElement("style");
      s.textContent = `
      /* override bootstrap's nowrap on btn-group and force wrap even when td has inline nowrap */
      .paciente-actions { display:flex !important; flex-wrap:wrap !important; gap:0.25rem; justify-content:center; white-space:normal !important; }
      .paciente-actions .btn { padding: .18rem .32rem; min-width: auto; flex:0 0 48%; white-space:normal; }
      .paciente-actions .btn .material-icons { font-size: 16px; line-height: 1; }
      /* avoid extra left margin since flex-wrap handles spacing */
      .paciente-actions .btn + .btn { margin-left: 0; }

      /* floating container for control buttons */
      .footer-btn-container {
        position: fixed !important;
        bottom: 1rem !important;
        right: 1rem !important;
        z-index: 15000 !important;
        display: flex !important;
        gap: .5rem !important;
      }
      /* controls placed inside the filters area, aligned to the right */
      .filters-controls { display:flex; flex-wrap:wrap; justify-content:flex-end; gap:.5rem; margin-bottom: .5rem; }
      .filters-controls .btn { padding: .25rem .5rem; }


    `;
      document.head.appendChild(s);
    })();
  }

  // add global responsive styles that don't depend on Swal
  (function () {
    const s = document.createElement("style");
    s.textContent = `
    #usuarios-filters { overflow-x:auto; }
    /* allow filter input-groups to wrap instead of forcing horizontal scroll */
    #usuarios-filters .input-group { flex-wrap:wrap; }
    #usuarios-filters .input-group > * { flex:1 1 auto; min-width:0; }
    #usuarios-pagination .pagination { flex-wrap:wrap; }

    @media(max-width:576px){
      #usuarios-table thead{display:none;}
      #usuarios-table tbody tr{display:block;margin-bottom:1rem;border:1px solid #dee2e6;}
      #usuarios-table tbody td{display:flex;justify-content:space-between;padding:.5rem;}
      #usuarios-table tbody td:before{content:attr(data-label);font-weight:bold;margin-right:.5rem;}
    }
  `;
    document.head.appendChild(s);
  })();

  async function loadFilters() {
    const container = document.getElementById("usuarios-filters");
    if (!container) return;
    container.innerHTML = `<div class="text-center text-muted">Cargando filtros...</div>`;
    try {
      // en este ejemplo los filtros son estáticos, podríamos pedir al backend si hace falta
      renderFilters({}, container);
    } catch (e) {
      container.innerHTML = `<div class="text-danger">No se pudieron cargar filtros</div>`;
    }
  }

  // ocultar/mostrar sección de filtros mediante un botón de control
  function initFilterToggle() {
    const container = document.getElementById("usuarios-filters");
    if (!container) return;
    // el contenedor permanece visible para alojar los controles;
    // ocultamos por defecto sólo el cuerpo de filtros (la fila .row)
    container.style.display = "";
    // create a controls wrapper inside the filters container, aligned right
    let controls = container.querySelector(".filters-controls");
    if (!controls) {
      controls = document.createElement("div");
      controls.className = "filters-controls";
      // insert as first child so it appears above the filter fields
      container.prepend(controls);
      // force full width and right alignment with inline style to override other rules
      controls.style.cssText =
        "display:flex;justify-content:flex-end;gap:.5rem;margin-bottom:.5rem;width:100%;";
      console.log(
        "initFilterToggle: controls wrapper inserted inside filters container",
      );
    }

    const btn = document.createElement("button");
    btn.id = "btn_toggle_filters";
    btn.className = "btn btn-outline-secondary btn-sm";
    btn.title = "Mostrar / ocultar filtros";
    btn.innerHTML = '<i class="material-icons">filter_list</i>';
    btn.style.zIndex = "16001";
    btn.addEventListener("click", () => {
      const body = container.querySelector(".row");
      if (!body) return;
      if (
        body.style.display === "none" ||
        getComputedStyle(body).display === "none"
      ) {
        body.style.display = "";
        btn.innerHTML = '<i class="material-icons">filter_list_off</i>';
      } else {
        body.style.display = "none";
        btn.innerHTML = '<i class="material-icons">filter_list</i>';
      }
    });
    controls.appendChild(btn);

    const btnNew = document.createElement("button");
    btnNew.id = "btn_new";
    btnNew.className = "btn btn-outline-info btn-sm";
    btnNew.title = "Nuevo";
    btnNew.innerHTML = '<span class="material-icons">add_circle</span>';
    btnNew.style.zIndex = "16001";
    btnNew.addEventListener("click", () => {
      openModal(null);
      // comportamiento pendiente, el botón está preparado
    });

    controls.appendChild(btnNew);

    const btnUpdate = document.createElement("button");
    btnUpdate.id = "btn_update";
    btnUpdate.className = "btn btn-outline-warning btn-sm";
    btnUpdate.title = "Actualizar";
    btnUpdate.innerHTML = '<span class="material-icons">refresh</span>';
    btnUpdate.style.zIndex = "16001";
    btnUpdate.addEventListener("click", () => {
      loadTable();
      // comportamiento pendiente, el botón está preparado
    });

    controls.appendChild(btnUpdate);

    const btnPrint = document.createElement("button");
    btnPrint.id = "btn_print";
    btnPrint.className = "btn btn-outline-danger btn-sm";
    btnPrint.title = "Exportar PDF";
    btnPrint.innerHTML = '<span class="material-icons">picture_as_pdf</span>';
    btnPrint.style.zIndex = "16001";
    btnPrint.addEventListener("click", async () => {
      const params = new URLSearchParams();
      params.set("pagina", 1);

      const order = Utils.findInArray(paginacion, "ordenamiento_defecto");
      const tipoOrder = Utils.findInArray(
        paginacion,
        "ordenamiento_direccion_defecto",
      );
      params.set("por_pagina", 0);
      params.set("order", order || "nombre");
      params.set("tipoOrder", tipoOrder || "ASC");
      const fieldMap = [
        ["filter_search", "search"],
        ["filter_rol", "rol"],
      ];

      fieldMap.forEach(([id, name]) => {
        const el = document.getElementById(id);
        if (el && el.value) params.set(name, el.value);
      });

      try {
        const res = await fetch(interBase + "?" + params.toString(), {
          credentials: "include",
        });

        const data = await res.json();
        generarReporte(data.data);
      } catch (err) {
        console.error("loadTable: exception", err);
        tbody.innerHTML = `<tr><td colspan="6" class="text-danger">Error cargando datos</td></tr>`;
        pagerUl.innerHTML = "";
      }
      // comportamiento pendiente, el botón está preparado
    });

    controls.appendChild(btnPrint);

    // ocultar el cuerpo de filtros inicialmente
    const body = container.querySelector(".row");
    if (body) body.style.display = "none";
  }

  async function renderFilters(filtros, container) {
    container = container || document.getElementById("usuarios-filters");

    const cols = [];

    const params = new URLSearchParams();
    params.set("pagina", 0);
    params.set("por_pagina", 0);

    const res = await fetch(interBase + "/roles?" + params.toString(), {
      credentials: "include",
    });

    const data = await res.json();
    var options = [`<option value="">Todos los roles</option>`];

    if (data.success) {
      data.data.forEach((item) => {
        options.push(`<option value="${item.id}">${item.nombre}</option>`);
      });

      cols.push(
        `<div class="col-12  col-md-6 " >
        <div class="mb-2 multi-autocomplet">
         <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
          <label for="filter_search" 
            class="form-label small mb-0">Buscar</label>
          <input type="search" 
            id="filter_search" 
            class="form-control" 
            placeholder="Codigo, Nombre, Descripcion..." >
        </div>
        </div>
      </div>`,
      );

      cols.push(
        `<div class="col-12 col-md-4">
        <div class="mb-2 multi-autocomplet">
          <div class="d-flex align-items-start" style="gap:.5rem;flex-wrap:wrap;">
            <label class="form-label small mb-0" for="filter_rol">Rol</label>
            <select id="filter_rol" class="form-control">
              ${options.join("")}
            </select>
          </div>
        </div>
      </div>`,
      );

      //Botones de accion
      cols.push(
        `<div class="col col-md-auto d-flex align-items-end" >
          <button 
            type="button" 
            id="btn_apply_filters" 
            class="btn btn-outline-secondary btn-sm" 
            title="Aplicar filtros">
            <i class="material-icons">filter_alt</i>
          </button>
          <button 
            type="button" 
            id="btn_clear_filters" 
            class="btn btn-outline-danger btn-sm" 
            title="Limpiar filtros" 
            eft-radius: 0; margin-left: -1px; height: 100%;">
              <i class="material-icons" >filter_alt_off</i>
          </button>
      </div>`,
      );

      container.innerHTML = `
      <div class="d-flex justify-content-between align-items-center mb-2">
        <h2 class="h2 mb-0">FILTROS</h2>
        <div class="filters-controls"></div>
      </div>
      <div class="row gx-2 gy-2">${cols.join("")}</div>
    `;

      setupFilters();

      initFilterToggle();
      loadTable();
    } else {
      Utils.showSwallError(
        "Usuarios",
        "Error cargando información de filtros.",
      );
    }

    // buscador (aparece en todas las pantallas, ocupa la mitad en small y un tercio en md+)
  }

  function setupFilters() {
    const btn = document.getElementById("btn_apply_filters");
    const btnClear = document.getElementById("btn_clear_filters");
    const inputs = [document.getElementById("filter_search")].filter(Boolean);
    if (btn) {
      btn.addEventListener("click", () => {
        inputs.forEach((inp) => {
          if (inp.value && inp.value !== "") {
            inp.classList.add("active-filter");
          } else {
            inp.classList.remove("active-filter");
          }
        });
        loadTable();
      });
    }
    if (btnClear) {
      btnClear.addEventListener("click", () => {
        inputs.forEach((inp) => {
          if (
            inp.tagName === "SELECT" ||
            inp.type === "search" ||
            inp.type === "date" ||
            inp.type === "number"
          ) {
            inp.value = "";
          }

          inp.classList.remove("active-filter");
        });
        document.getElementById("filter_search").value = "";

        document.getElementById("filter_rol").value = "";
        loadTable();
      });
    }
    const search = document.getElementById("filter_search");
    if (search && btn) {
      search.addEventListener("keypress", (e) => {
        if (e.key === "Enter") {
          e.preventDefault();
          btn.click();
        }
      });
    }
  }

  async function loadTable(page = 1) {
    await Utils.showSpinner();
    const tbody = document.querySelector("#usuarios-table tbody");
    const pagerUl = document.querySelector("#usuarios-pagination pagerUl");
    if (!tbody) return;
    tbody.innerHTML = `<tr><td colspan="7" class="text-center text-muted">Cargando...</td></tr>`;
    const params = new URLSearchParams();
    params.set("pagina", page);
    const pp = Utils.findInArray(paginacion, "registros_por_pagina_defecto");
    const order = Utils.findInArray(paginacion, "ordenamiento_defecto");
    const tipoOrder = Utils.findInArray(
      paginacion,
      "ordenamiento_direccion_defecto",
    );
    params.set("por_pagina", parseInt(pp) || 10);
    params.set("order", order || "nombre");
    params.set("tipoOrder", tipoOrder || "ASC");
    const fieldMap = [
      ["filter_search", "search"],
      ["filter_rol", "rol"],
    ];

    fieldMap.forEach(([id, name]) => {
      const el = document.getElementById(id);
      if (el && el.value) params.set(name, el.value);
    });

    try {
      const res = await fetch(interBase + "?" + params.toString(), {
        credentials: "include",
      });

      const data = await res.json();
      renderTable(data.data || [], data.total || 0, page);
    } catch (err) {
      console.error("loadTable: exception", err);
      tbody.innerHTML = `<tr><td colspan="6" class="text-danger">Error cargando datos</td></tr>`;
      pagerUl.innerHTML = "";
    } finally {
      Utils.hideSpinner();
    }
  }

  function estadoBadge(estado) {
    let icon = "";
    let color = "secondary";
    switch (estado) {
      case 1:
        icon = "schedule";
        color = "success";
        break;
      case 0:
        icon = "warning";
        color = "danger";
        break;
      default:
        icon = "help_outline";
        color = "secondary";
    }
    return `<span class=\"badge bg-${color}\"><i class=\"material-icons 
    align-middle\" style=\"font-size:16px;vertical-align:middle;\">${icon}</i> ${estado === 1 ? "Activo" : "Inactivo"}</span>`;
  }

  function rolBadge(roles) {
    if (!roles) return "";
    roles = roles.split("||");
    let rows = [];
    let icon = "";
    let color = "secondary";
    roles.forEach((rol) => {
      switch (rol) {
        case "Super Administrador":
          icon = "supervisor_account";
          color = "primary";
          break;
        case "Administrador":
          icon = "admin_meds";
          color = "success";
          break;
          break;
        case "Médico":
          icon = "emoji_people";
          color = "warning";
          break;
          break;
        case "Farmacéutico":
          icon = "local_pharmacy";
          color = "info";
          break;
          break;
        case "Visitadortico":
          icon = "local_pharmacy";
          color = "drk";
          break;
        default:
          icon = "help_outline";
          color = "secondary";
      }
      rows.push(`<span class=\"badge bg-${color}\"><i class=\"material-icons 
    align-middle\" style=\"font-size:16px;vertical-align:middle;\">${icon}</i> ${rol}</span>`);
    });
    return rows;
  }

  function renderTable(rows, total, currentPage) {
    const tbody = document.querySelector("#usuarios-table tbody");
    const pagerUl = document.querySelector("#usuarios-pagination ul");
    if (!tbody) return;

    // guardamos los datos para usos posteriores (por ejemplo abrir modales)
    if (Array.isArray(rows)) {
      usuarios = rows;
    }

    if (!Array.isArray(rows) || rows.length === 0) {
      tbody.innerHTML = `<tr><td colspan="7" class="text-center text-muted">No hay registros.</td></tr>`;
    } else {
      tbody.innerHTML = rows
        .map((r) => {
          const id = r.id || "";
          const badge = estadoBadge(r.activo);
          const rolbadge = rolBadge(r.roles);
          const btns = [];

          if (canEdit)
            btns.push(
              `<button class="btn btn-sm btn-outline-primary btn-edit border-0" data-id="${r.id}"><i class="material-icons">edit</i></button>`,
            );

          if (canDelete)
            btns.push(
              `<button class="btn btn-sm btn-outline-danger btn-delete border-0" data-id="${r.id}" style="margin-left:.25rem;"><i class="material-icons">delete</i></button>`,
            );

          return `
        <tr data-id="${id}">

          <td class="align-middle" 
            data-label="Codigo"><code>${Utils.escapeHtml(r.cedula) || ""}</code></td>
          <td class="align-middle" 
            data-label="Nombre">${Utils.escapeHtml(r.nombre) || ""}</td>
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Apellido">${Utils.escapeHtml(r.apellido) || ""}</td>
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Mail">${Utils.escapeHtml(r.email) || ""}</td>
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Estado">${badge || ""}</td>
          <td class="align-middle d-none d-sm-table-cell" 
            data-label="Estado">${rolbadge || ""}</td>            
          <td class="align-middle d-sm-table-cell>
            <div class="btn-group btn-group-sm" 
              role="group" aria-label="Acciones de Pacientes">
              ${btns.join("")}
            </div>
          </td>
        </tr>`;
        })
        .join("");
    }
    // paginación con botones (primero, anterior, siguiente, último) y resumen
    const perPage = 10;
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
          loadTable(currentPage);
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
    const summary = document.getElementById("usuarios-page-summary");
    if (summary) {
      summary.innerHTML = `Página <strong>${currentPage}</strong> de <strong>${pages}</strong> - Total <strong>${total}</strong> `;
    }
    tbody
      .querySelectorAll(".btn-edit")
      .forEach((b) =>
        b.addEventListener("click", (e) =>
          openModal(b.getAttribute("data-id")),
        ),
      );

    // borrar
    tbody
      .querySelectorAll(".btn-delete")
      .forEach((b) =>
        b.addEventListener("click", (e) =>
          confirmDelete(b.getAttribute("data-id")),
        ),
      );
  }

  const modalHTML = `
    <form id="swal-form" novalidate>
      <input type="hidden" name="id"/>
      <div class="mb-3">

      <div class="row" style="display: grid;
          grid-template-columns: 1fr 1fr;gap: 20px;">
        <div class="col" style="padding: 20px;
          border-radius: 8px; text-align: start;display: flex; flex-direction: column;">
          <h3 class="mb-2">Información de Usuario</h3>
        </div>
        <div class="col" style="
          text-align: center; display: flex; flex-direction: row; justify-content: flex-end; padding: 25px;">
          <div class="checkbox-wrapper-46">
              <input type="checkbox" id="cbx-46" name="activo"
                class="inp-cbx"/>
                <label for="cbx-46" class="cbx">
                <span>
                  <svg viewBox="0 0 12 10" height="10px" width="12px">
                    <polyline points="1.5 6 4.5 9 10.5 1"></polyline>
                  </svg>
                </span>
                <span><strong>Activo</strong></span>
              </label>
          </div>
        </div>
      </div>

        <div class="row g-2 mt-2">
          <div class="col-4">
            <label class="font-weight-bold small">Cedula</label>
            <input name="cedula" id="cedula" class="form-control" placeholder="Ej. V-12345678"  required aria-label="Cedula" />
          </div>
          <div class="col-4">
            <label class="font-weight-bold small">Nombre</label>
            <input name="nombre" id="nombre" class="form-control" placeholder="Nombre" required aria-label="Nombre" />
          </div>
          <div class="col-4">
            <label class="font-weight-bold small">Apellido</label>
            <input name="apellido" id="apellido" class="form-control" placeholder="Apellido" required aria-label="Apellido" />
          </div>
        </div>

        <div class="row g-2 mt-2">
          <div class="col-4">
            <label class="font-weight-bold small">Telefono</label>
            <input name="telefono" id="telefono" class="form-control" placeholder="Telefono" required aria-label="Telefono" />
          </div>
          <div class="col-8">
            <label class="font-weight-bold small">Imagen Url</label>
              <input type="url" name="url_img" id="url_img" class="form-control" placeholder="Imagen Url" aria-label="img_url" />
          </div>
        </div>

        <div class="row g-2 mt-2">
          <div class="col-6">
            <label class="font-weight-bold small">Email</label>
            <input type="email" name="email" id="email" class="form-control" placeholder="Email" required aria-label="Email" />
          </div>
          <div class="col-3" name="d_Password">
            <label class="font-weight-bold small">Contraseña</label>
            <div class="field">
              <input type="password" name="password" id="password" class="form-control" placeholder="" required aria-label="Password" />
              <button id="showPass" type="button" class="eye" aria-label="Mostrar contraseña"><span class="material-icons">visibility</span></button>
            </div>
          </div>

          <div class="col-3" name="d_cPassword">
            <label class="font-weight-bold small">Confirmar Contraseña</label>
            <div class="field">
              <input type="password" name="confirm-password" id="confirm-password" class="form-control" placeholder="" required aria-label="Confirm-password" />
              <button id="showCondfirmPass" type="button" class="eye" aria-label="Mostrar contraseña">
                <span class="material-icons">
                  visibility
                </span>
              </button>
            </div>
          </div>
        </div>

        <div class="row g-2 mt-3">
          <div class="col-12">
            <label class="font-weight-bold small">Roles</label>
            <div class="multi-autocomplete">
              <div class="d-flex align-items-start" 
                style="gap:.5rem;flex-wrap:wrap;">
                <div id="roles_tags" class="d-flex flex-wrap" style="gap:.25rem;"></div>
                <input type="text" id="roles_input" class="form-control" placeholder="Buscar roles..." autocomplete="off" />
                </div>
                <input type="hidden" name="roles" id="roles_hidden" />
                <div class="autocomplete-list" id="roles_list"
                  style="max-height:180px;overflow:auto;margin-top:4px;"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </form>
  `;

  async function attachMultiAutocomplete(
    inputId,
    hiddenName,
    listId,
    searchUrl,
    labelFn,
  ) {
    // prefer element inside Swal popup if present
    let input = null;
    let list = null;
    try {
      if (window.Swal && Swal.getPopup) {
        const p = Swal.getPopup();
        if (p) {
          input = p.querySelector(`#${inputId}`) || null;
          list = p.querySelector(`#${listId}`) || null;
        }
      }
    } catch (e) {}
    if (!input) input = document.getElementById(inputId);
    if (!list) list = document.getElementById(listId);
    if (!input || !list) return;
    if (input.dataset.multiAttached) return;
    input.dataset.multiAttached = "1";

    const form = input.closest("form");
    let hidden = null;
    try {
      if (form) {
        hidden =
          form.elements[hiddenName] ||
          form.querySelector(`[name="${hiddenName}"]`);
      }
    } catch (e) {
      hidden = null;
    }
    if (!hidden) hidden = document.querySelector(`input[name="${hiddenName}"]`);
    const tagsContainer =
      inputId === "roles_input" ?
        (form && form.querySelector("#roles_tags")) ||
        document.getElementById("roles_tags")
      : (form && form.querySelector("#enfermedades_tags")) ||
        document.getElementById("enfermedades_tags");

    let selected = [];

    function renderTags() {
      if (!tagsContainer) return;
      tagsContainer.innerHTML = "";
      selected.forEach((it, idx) => {
        const span = document.createElement("span");
        span.className =
          "badge bg-secondary text-white d-inline-flex align-items-center";
        span.style.marginRight = ".25rem";
        span.style.padding = ".35rem .5rem";
        span.textContent = it.label;
        const remove = document.createElement("button");
        remove.type = "button";
        remove.className = "btn btn-sm btn-link text-white p-0 ms-2";
        remove.style.textDecoration = "none";
        remove.innerHTML = '<span style="line-height:1">&times;</span>';
        remove.addEventListener("click", () => {
          selected.splice(idx, 1);
          renderTags();
          updateHidden();
        });
        span.appendChild(remove);
        tagsContainer.appendChild(span);
      });
    }

    function updateHidden() {
      if (!hidden) return;
      const names = selected.map((s) => s.label);
      hidden.value = names.length ? JSON.stringify(names) : "";
    }

    // initialize from hidden value if present
    try {
      if (hidden && hidden.value) {
        const v = hidden.value.trim();
        if (v.startsWith("[")) {
          const parsed = JSON.parse(v);
          if (Array.isArray(parsed)) {
            parsed.forEach((p) =>
              selected.push({ id: null, label: String(p) }),
            );
          }
        } else if (v.includes("\n") || v.includes(",")) {
          const parts = v
            .split(/[,\r\n]+/)
            .map((s) => s.trim())
            .filter(Boolean);
          parts.forEach((p) => selected.push({ id: null, label: p }));
        } else if (v) {
          selected.push({ id: null, label: v });
        }
        renderTags();
        updateHidden();
      }
    } catch (e) {}

    const doSearch = Utils.debounce(async (q) => {
      if (!q || q.length < 2) {
        list.innerHTML = "";
        return;
      }

      try {
        const resp = await fetch(searchUrl + "?q=" + encodeURIComponent(q), {
          cache: "no-store",
        });
        const j = await resp.json();

        // normalize response into an array of items
        let listado = [];
        if (Array.isArray(j)) {
          listado = j;
        } else if (j && Array.isArray(j.data)) {
          listado = j.data;
        } else if (j) {
          // take first array value found
          for (const v of Object.values(j)) {
            if (Array.isArray(v)) {
              listado = v;
              break;
            }
          }
        }

        list.innerHTML = "";
        listado.forEach((itt) => {
          const div = document.createElement("div");
          div.className = "list-group-item list-group-item-action";
          div.style.cursor = "pointer";

          const label =
            labelFn ?
              labelFn(itt)
            : itt.nombre || itt.nombre_completo || itt.id;
          div.textContent = label;

          div.addEventListener("click", () => {
            if (rolesSelected.length >= 1) {
              selected = rolesSelected.map((r) => ({
                id: rolesList.find((u) => u.nombre === r)?.id,
                label: r,
              }));
              rolesSelected = [];
            }
            if (!selected.some((s) => s.label === label)) {
              selected.push({ id: itt.id || null, label });
              renderTags();
              updateHidden();
            }
            input.value = "";
            list.innerHTML = "";
            input.focus();
          });

          list.appendChild(div);
        });
      } catch (err) {
        console.error("multi-autocomplete error", err);
      }
    }, 200);

    input.addEventListener("input", (e) => {
      doSearch(e.target.value.trim());
    });

    input.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
        const v = input.value.trim();
        if (v) {
          if (!selected.some((s) => s.label === v)) {
            selected.push({ id: null, label: v });
            renderTags();
            updateHidden();
          }
          input.value = "";
          list.innerHTML = "";
        }
      }
    });
  }

  async function openModal(id) {
    // ensure Swal2 and its styles are available before showing the modal
    await ensureSwal();
    const isNew = !id;
    const title = isNew ? "Nuevo Usuario" : "Editar Usuario";

    // Function to check for duplicates
    async function checkDuplicate(tipo, valor) {
      if (!valor) return null;
      try {
        const params = new URLSearchParams();
        if (valor) params.set(tipo, valor);
        const resp = await fetch(interBase + "/obtenerBy" + `?${params}`, {
          cache: "no-store",
        });
        const data = await resp.json();
        if (data && data.success) {
          var _resu = [];
          var resultados = data.resultados || [];
          var obj = resultados.cedula || "";
          var codCodigo = obj.codigo;
          var existing = codCodigo === 200;

          var msj = "";
          if (codCodigo === 200) {
            msj += ` <strong>${Utils.capitalizeFirstLetter(tipo)}:</strong>${valor}`;
            msj += ` Usuario: <strong> ${
              obj.data[0].nombre + " " + obj.data[0].apellido || ""
            }</strong><br />`;
          }

          if (isNew && existing) {
            return JSON.stringify({
              success: existing,
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

    // Función para guardar los datos
    async function guardar() {
      const popup = Swal.getPopup();
      const form = popup.querySelector("#swal-form");
      // Verificar duplicados (solo para nuevas usuarios)
      const cedula = form.querySelector("[id=cedula]").value;
      const mail = form.querySelector("[name=email]").value;
      if (isNew) {
        let duplicate = JSON.parse(await checkDuplicate("cedula", cedula));
        if (duplicate.success) {
          Swal.showValidationMessage(`Ya existe un usuario con esta cedula.`);
          return false;
        }

        duplicate = JSON.parse(await checkDuplicate("email", mail));
        if (duplicate.success) {
          Swal.showValidationMessage(`Ya existe un usuario con este email.`);
          return false;
        }
      }
      let rolesName = form.querySelector("#roles_hidden").value;
      rolesName = rolesName
        .toString()
        .replace("[", "")
        .replace("]", "")
        .replace(/["']/g, "")
        .split(",")
        .map((r) => r.trim())
        .filter(Boolean);
      const roles = [];
      if (rolesName) {
        rolesName.forEach((r) => {
          const match = rolesList.find((u) => u.nombre === r).id;
          if (match) roles.push(match);
        });
      }

      // Recopilar datos del formulario
      const data = {
        id: form.querySelector('[name="id"]')?.value || null,
        cedula: cedula || "",
        nombre: form.querySelector('[name="nombre"]')?.value || "",
        apellido: form.querySelector('[name="apellido"]')?.value || "",
        telefono: form.querySelector('[name="telefono"]')?.value || "",
        email: mail || "",
        password: form.querySelector('[name="password"]')?.value || "",
        confirm_password:
          form.querySelector('[name="confirm-password"]')?.value || "",
        url_img: form.querySelector('[name="url_img"]')?.value || "",
        rol_id: roles,
        password: form.querySelector('[name="password"]')?.value || "",
        confirm_password:
          form.querySelector('[name="confirm-password"]')?.value || "",
        activo: form.querySelector('[name="activo"')?.checked === true ? 1 : 0,
      };

      if (!data.cedula) {
        Swal.showValidationMessage("Cedula es requerido");
        return false;
      }
      if (!data.nombre) {
        Swal.showValidationMessage("Nombre es requerido");
        return false;
      }
      if (!data.apellido) {
        Swal.showValidationMessage("Apellido es requerido");
        return false;
      }
      if (!data.email) {
        Swal.showValidationMessage("Correo electronico es requerido");
        return false;
      }

      if (isNew) {
        if (!data.password) {
          Swal.showValidationMessage("Password es requerido");
          return false;
        }

        if (!data.confirm_password) {
          Swal.showValidationMessage("Confirmar password es requerido");
          return false;
        }

        if (data.password !== data.confirm_password) {
          Swal.showValidationMessage("Las contraseñas no coinciden");
          return false;
        }

        // Validar reglas de contraseña
        const minLength = ruless.find(
          (r) => r.name === "longitud_minima_password",
        )?.valor;

        if (minLength && data.password.length < parseInt(minLength)) {
          Swal.showValidationMessage(
            `La contraseña debe tener al menos ${Utils.formatNumbers(minLength, 0)} caracteres.`,
          );
          return false;
        }
        const requiereMayus = ruless.find(
          (r) => r.name === "requiere_mayusculas" && r.valor === "1",
        );
        if (requiereMayus && !/[A-Z]/.test(data.password)) {
          Swal.showValidationMessage(
            "La contraseña debe contener al menos una letra mayúscula.",
          );
          return false;
        }
        const requiereNumeros = ruless.find(
          (r) => r.name === "requiere_numeros" && r.valor === "1",
        );
        if (requiereNumeros && !/\d/.test(data.password)) {
          Swal.showValidationMessage(
            "La contraseña debe contener al menos un número.",
          );
          return false;
        }
        const requiereSimbolos = ruless.find(
          (r) => r.name === "requiere_simbolos" && r.valor === "1",
        );
        if (requiereSimbolos && !/[!@#$%^&*(),.?":{}|<>]/.test(data.password)) {
          Swal.showValidationMessage(
            "La contraseña debe contener al menos un símbolo especial.",
          );
          return false;
        }
      }

      // Mostrar indicador de carga
      Swal.showLoading();

      // Enviar al servidor
      try {
        const resp = await fetch(interBase, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(data),
        });

        const result = await resp.json();

        if (!result || result.status !== "success") {
          throw new Error(result.message || "Error guardando");
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

    await ensureSwal();
    Swal.fire({
      title: title,
      html: modalHTML,
      width: "800px",
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
      didOpen: async () => {
        const popup = Swal.getPopup();
        const form = popup.querySelector("#swal-form");
        const eyePass = document.getElementById("showPass");
        const eyeConfirmPass = document.getElementById("showCondfirmPass");
        const i_passEl = form.querySelector('[name="password"]');
        const i_conf_passEl = form.querySelector('[name="confirm-password"]');

        // evitar que Enter cierre el modal o dispare el submit accidentalmente
        try {
          popup.addEventListener("keydown", (ev) => {
            if (ev.key === "Enter") {
              const t = ev.target || ev.srcElement;
              const tag = t && t.tagName ? t.tagName.toUpperCase() : "";
              // permitir Enter solo en textarea o si el foco está en el botón de guardar
              if (
                tag !== "TEXTAREA" &&
                !(
                  tag === "BUTTON" &&
                  (t.id === "btnSave" || t.type === "submit")
                )
              ) {
                ev.preventDefault();
                ev.stopPropagation();
                return false;
              }
            }
          });
          eyePass?.addEventListener("click", () => {
            if (i_passEl.type === "password") {
              i_passEl.type = "text";
              eyePass.innerHTML = "";
              eyePass.innerHTML =
                '<span class="material-icons">visibility_off</span>';
            } else {
              i_passEl.type = "password";
              eyePass.innerHTML = "";
              eyePass.innerHTML =
                '<span class="material-icons">visibility</span>';
            }
            passEl.focus();
          });

          eyeConfirmPass?.addEventListener("click", () => {
            if (i_conf_passEl.type === "password") {
              i_conf_passEl.type = "text";
              eyeConfirmPass.innerHTML = "";
              eyeConfirmPass.innerHTML =
                '<span class="material-icons">visibility_off</span>';
            } else {
              i_conf_passEl.type = "password";
              eyeConfirmPass.innerHTML = "";
              eyeConfirmPass.innerHTML =
                '<span class="material-icons">visibility</span>';
            }
            conf_passEl.focus();
          });

          attachMultiAutocomplete(
            "roles_input",
            "roles",
            "roles_list",
            interBase + "/roles",
            (it) => it.nombre,
          );
        } catch (e) {}

        const valuesFromRaw = (raw) => {
          if (raw === "Ninguno conocida") return;
          let items = [];
          try {
            if (Array.isArray(raw)) items = raw;
            else if (typeof raw === "string" && raw.startsWith("["))
              items = JSON.parse(raw);
            else if (typeof raw === "string" && raw.indexOf(",") !== -1)
              items = raw
                .split(",")
                .map((s) => s.trim())
                .filter(Boolean);
            else if (typeof raw === "string" && raw.trim() !== "")
              items = [raw.trim()];
          } catch (e) {
            items = [];
          }
          return items;
        };

        const syncHidden = (hiddenEl, arr) => {
          if (arr === "Ninguno conocida") arr = [];
          if (!hiddenEl) return;
          try {
            hiddenEl.value = (arr || []).join(",");
          } catch (e) {
            hiddenEl.value =
              Array.isArray(arr) ? arr.join(",") : String(arr || "");
          }
        };

        const renderChips = (container, hiddenEl, items) => {
          if (!container) return;
          container.innerHTML = "";
          (items || []).forEach((it) => {
            const wrap = document.createElement("div");
            wrap.style =
              "display:inline-block;margin-right:.4rem;margin-bottom:.35rem;";
            const span = document.createElement("span");
            span.className = "badge";
            span.textContent = it;
            span.style.padding = ".45rem .6rem";
            span.style.backgroundColor = "#6c757d";
            span.style.color = "#fff";
            span.style.display = "inline-block";
            span.style.borderRadius = "0.25rem";
            const btn = document.createElement("button");
            btn.type = "button";
            btn.className = "btn btn-sm btn-link text-white p-0 ms-2";
            btn.style.textDecoration = "none";
            btn.textContent = "×";
            btn.addEventListener("click", () => {
              const cur = valuesFromRaw(hiddenEl.value || "");
              const idx = cur.indexOf(it);

              if (idx !== -1) cur.splice(idx, 1);
              syncHidden(hiddenEl, cur);
              renderChips(container, hiddenEl, cur);
            });

            span.appendChild(btn);
            wrap.appendChild(span);
            container.appendChild(wrap);
          });
        };
        // Populate form if editing

        if (!isNew) {
          const item = usuarios.find((x) => String(x.id) === String(id));
          const divPass = form.querySelector('[name="d_Password"]');
          rolesSelected = item.roles ? item.roles.split("||") : [];
          const divCPass = form.querySelector('[name="d_cPassword"]');
          if (divPass) divPass.style.display = "none";
          if (divCPass) divCPass.style.display = "none";
          if (item) {
            form.querySelector('[name="id"]').value = item.id || "";
            form.querySelector('[name="cedula"]').value = item.cedula || "";
            form.querySelector('[name="nombre"]').value = item.nombre || "";
            form.querySelector('[name="apellido"]').value = item.apellido || "";
            form.querySelector('[name="telefono"]').value = item.telefono || "";
            form.querySelector('[name="email"]').value = item.email || "";
            form.querySelector('[name="url_img"]').value = item.url_img || "";
            form.querySelector('[name="activo"]').checked = item.activo === 1;
            const roleNames = item.roles ? item.roles.split("||") : [];
            const roleIds = item.rolesId ? item.rolesId.split("||") : [];
            const rolHiddenEl = form.querySelector("#roles_hidden");
            const rolContainer = form.querySelector("#roles_tags");
            const inicialRol = valuesFromRaw(roleNames);

            syncHidden(rolHiddenEl, roleNames);
            renderChips(rolContainer, rolHiddenEl, inicialRol);
          }
        }
      },
      didClose: () => {
        rolesSelected = [];
      },
      preConfirm: async (result) => {
        const isValid = await guardar();
        if (!isValid) {
          // Mantener el modal abierto si la validación falla
          return false;
        }
        const btnClear = document.getElementById("btn_clear_filters");
        if (btnClear) btnClear.click();
        loadTable();
      },
    });
  }

  async function confirmDelete(itemId) {
    const result = await Swal.fire({
      title: "¿Eliminar registro?",
      text: "Esta acción no se puede deshacer",
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#d33",
      cancelButtonColor: "#3085d6",
      confirmButtonText: "Sí, eliminar",
      cancelButtonText: "Cancelar",
    });

    if (result.isConfirmed) {
      await deleteUsuario(itemId);
    }
  }

  async function deleteUsuario(Id) {
    try {
      Swal.showLoading();

      const response = await fetch(`${interBase}/$id={itemId}`, {
        body: JSON.stringify({ id: Id }),
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
      });

      const data = await response.json();
      Swal.hideLoading();

      if (data.success) {
        Utils.showSwalSB("success", "Eliminado", data.message);
        const btnClear = document.getElementById("btn_clear_filters");
        if (btnClear) btnClear.click();
        loadTable();
      } else {
        throw new Error(data.message || "Error al eliminar");
      }
    } catch (error) {
      Swal.hideLoading();
      Utils.showSwallError(
        "Error",
        error.message || "No se pudo eliminar el registro.",
      );
    }
  }

  /**
   * Genera un reporte PDF con el historial cronológico de un paciente.
   * @param {Array} items - Lista de objetos con los datos de cada historia clínica.
   *                         Cada objeto debe contener al menos:
   *                         - creado_por, creado_por_id, descripcion, enfermedad_nombre,
   *                           enfermedad_nombre, fecha_evento, fecha_registro, id,
   *                           id_enfermedad, id_enfermedad, id_medico, id_paciente,
   *                           medico_nombre, tipo_enum.
   */

  async function generarReporte(items) {
    // Verificar que jsPDF esté disponible
    if (typeof jspdf === "undefined" && typeof window.jspdf === "undefined") {
      console.error("jsPDF no está cargado. Asegúrate de incluir la librería.");
      return;
    }

    const { jsPDF } =
      window.jspdf ||
      jspdf({
        unit: "pt",
        format: "a4",
      });
    const doc = new jsPDF();

    // Configuración de márgenes y columnas
    const margenIzq = 15;
    const margenSup = 20;
    const anchoPagina = doc.internal.pageSize.width;

    let y = margenSup;

    // Cargar logo (ruta relativa; ajustar si necesario)
    const logoPath = "../assets/img/cintillo.jpg";
    const logoData = await Utils.getImageDataUrl(logoPath);
    y += 20; // espacio después del logo

    if (logoData) {
      // colocar logo a la izquierda
      const logoW = anchoPagina;
      const logoH = 50;
      doc.addImage(logoData, "PNG", margenIzq * 2 - 30, -10, logoW, logoH);
    }

    const fieldMap = [
      ["filter_search", "search"],
      ["filter_rol", "rol"],
    ];

    // Recolectar filtros activos (con valor)
    const filtrosActivos = [];
    fieldMap.forEach(([elementId, paramName]) => {
      const el = document.getElementById(elementId);
      if (el && el.value && el.value.trim() !== "") {
        filtrosActivos.push(`${paramName}: ${el.value}`);
      }
    });

    // --- Título del reporte ---
    doc.setFontSize(16);
    doc.setFont("helvetica", "bold");
    doc.text("Listado de Usuarios", anchoPagina / 2, y, {
      align: "center",
    });
    y += 8;

    if (filtrosActivos.length > 0) {
      doc.setFontSize(10);
      doc.text("Filtros aplicados: " + filtrosActivos.join(" • "), 14, y);
      y += 8;
    } else {
      doc.setFontSize(10);
      doc.text("Filtros: ninguno", 14, y);
      y += 8;
    }

    const columnas = [
      { header: "ID", dataKey: "id" },
      { header: "Codigo", dataKey: "Codigo" },
      { header: "Nombre", dataKey: "nombre" },
      { header: "Descripcion", dataKey: "descripcion" },
      { header: "Stock Actual", dataKey: "stock_actual" },
      { header: "Stock Minimo", dataKey: "stock_minimo" },
      { header: "Unidad de Medida", dataKey: "unidad_medida" },
      { header: "Precio Unitario", dataKey: "precio_unitario" },
      { header: "Estado", dataKey: "estado" },
    ];
    // -----------------------------------------------------------------
    // 3. Preparar los datos (filas)
    // -----------------------------------------------------------------
    const filas = items.map((item) => {
      // Función auxiliar para formatear fechas (si son válidas)

      return {
        id: item.id ?? "",
        codigo: item.codigo ?? "",
        nombre: item.nombre ?? "",
        descripcion: item.descripcion ?? "",
        stock_actual: Utils.formatDate(item.stock_actual) ?? "",
        stock_minimo: item.stock_minimo ?? "",
        unidad_medida: item.unidad_medida ?? "",
        precio_unitario:
          item.precio_unitario === "F" ? "Femenino" : ("Masculino" ?? ""),
        estado: item.estado ?? "",
      };
    });

    doc.autoTable({
      startY: y + 2, // dejar un pequeño margen después del encabezado
      head: [columnas.map((col) => col.header)],
      body: filas.map((fila) => columnas.map((col) => fila[col.dataKey])),
      theme: "striped",
      headStyles: {
        fillColor: [41, 128, 185],
        textColor: 255,
        fontStyle: "bold",
      },
      styles: { fontSize: 7, cellPadding: 1.5, overflow: "linebreak" },
      columnStyles: {
        // Ajustar anchos según necesidad (opcional)
        observaciones_medicas: { cellWidth: 30 },
        Observacion: { cellWidth: 30 },
      },
      margin: { left: 10, right: 10 },
    });
    // Guardar el PDF con nombre basado en el ID del paciente
    doc.save(`listadoInsumos_${new Date().toISOString().split("T")[0]}.pdf`);
  }

  // iniciar
  document.addEventListener("DOMContentLoaded", async () => {
    try {
      await ensureSwal();
    } catch (e) {
      console.warn("ensureSwal fallo", e);
    }

    const conf = await Utils.getConfig(BASE_URL, "paginacion");
    const segu = await Utils.getConfig(BASE_URL, "seguridad");

    conf.forEach((element) => {
      var json = {
        nombre: element.clave,
        valor: element.valor,
        tipo: element.tipo,
      };

      paginacion.push(json);
    });

    segu.forEach((element) => {
      var json = {
        nombre: element.clave,
        valor: element.valor,
        tipo: element.tipo,
      };

      seguridad.push(json);
    });

    seguridad.forEach((x) => {
      if (x.nombre === "longitud_minima_password") {
        ruless.push({ name: x.nombre, valor: x.valor }); // Usar ruless
      }
      if (x.nombre === "requiere_mayusculas") {
        ruless.push({ name: x.nombre, valor: x.valor });
      }
      if (x.nombre === "requiere_numeros") {
        ruless.push({ name: x.nombre, valor: x.valor });
      }
      if (x.nombre === "requiere_simbolos") {
        ruless.push({ name: x.nombre, valor: x.valor });
      }
    });

    $(".capitalize-input").on("input", function () {
      let valor = this.value.toLowerCase().replace(/(?:^|\s)\S/g, function (a) {
        return a.toUpperCase();
      });
      this.value = valor;
    });

    const resp = await fetch(interBase + "/roles", {
      cache: "no-store",
    });
    const j = await resp.json();
    rolesList = j && Array.isArray(j.data) ? j.data : [];

    loadFilters();
  });
})();
