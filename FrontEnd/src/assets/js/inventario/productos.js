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
    this.chkActivo = document.getElementById("chkActivo");
    this.chkInventario = document.getElementById("chkInventario");
    this.cTipo = document.getElementById("cTipo");
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
  }

  getParameterByName(name) {
    const url = new URL(window.location.href);
    return url.searchParams.get(name);
  }

  loadProductoData() {
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
    this.stock_minimo.value = this.producto.stock_minimo;
    this.chkActivo.checked = this.producto.activo == 1;
    this.chkInventario.checked = this.producto.maneja_inventario == 1;
    this.cTipo.value = this.producto.tipo;
  }
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
