class HomeManager {
  constructor() {
    this.init();
  }

  init() {
    // Aquí puedes agregar cualquier inicialización adicional que necesites
    console.log("HomeManager inicializado");
  }
}

// Inicializar la aplicación cuando el DOM esté listo
$(document).ready(function () {
  // Inicializar Material Design
  if (typeof $.fn.bootstrapMaterialDesign !== "undefined") {
    $("body").bootstrapMaterialDesign();
  }

  // Crear instancia del gestor del formulario
  window.homeManager = new HomeManager();
});
