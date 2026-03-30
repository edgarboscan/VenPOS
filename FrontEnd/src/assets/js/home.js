class HomeManager {
  constructor() {
    this.BASE_URL =
      document.querySelector('meta[name="base-url"]')?.content || "";

    const URL =
      window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
    this.BASE_URL = URL;

    this.init();
  }

  async init() {
    // Aquí puedes agregar cualquier inicialización adicional que necesites
    console.log("HomeManager inicializado");
    Utils.getAll_Config(this.BASE_URL);
    this.addEventListeners();
  }

  addEventListeners() {
    // Ejemplo: Agregar un evento de clic a un botón
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

    setTimeout(() => {
      document
        .querySelectorAll(".stat-card .skeleton-content")
        .forEach((skel) => {
          skel.style.display = "none";
        });
      document.querySelectorAll(".stat-card .real-content").forEach((real) => {
        real.style.display = "block";
      });
      // Para gráficos
      document
        .querySelectorAll(".chart-card .skeleton-content")
        .forEach((skel) => {
          skel.style.display = "none";
        });
      document.querySelectorAll(".chart-card .real-content").forEach((real) => {
        real.style.display = "block";
      });
      // Inicializar gráficos (si aún no se han inicializado)
      this.initCharts();

      // Observar la sección de gráficos
      const chartsSection = document.querySelector(".charts-section");
      if (chartsSection && "IntersectionObserver" in window) {
        const observer = new IntersectionObserver(
          (entries) => {
            entries.forEach((entry) => {
              if (entry.isIntersecting) {
                this.initCharts();
                observer.unobserve(entry.target);
              }
            });
          },
          { threshold: 0.1 },
        );
        observer.observe(chartsSection);
      } else {
        // Fallback: inicializar inmediatamente
        this.initCharts();
      }
    }, 500);

    // Exportar gráficos a PDF
    document.querySelectorAll(".export-pdf-btn").forEach((btn) => {
      btn.addEventListener("click", async function (e) {
        const chartId = this.getAttribute("data-chart");
        const canvas = document.getElementById(chartId);
        if (!canvas) return;

        // Usamos html2canvas para capturar el canvas (o el contenedor del gráfico)
        try {
          const { jsPDF } = window.jspdf;
          const imgData = canvas.toDataURL("image/png");
          const pdf = new jsPDF("landscape");
          pdf.addImage(imgData, "PNG", 10, 10, 280, 150);
          pdf.save(`grafico_${chartId}.pdf`);
        } catch (error) {
          console.error("Error al generar PDF:", error);
          if (typeof Swal !== "undefined") {
            Swal.fire("Error", "No se pudo generar el PDF", "error");
          }
        }
      });
    });
  }

  // Lazy loading de gráficos
  initCharts() {
    // Verificar si los canvas ya están inicializados
    if (window.chartsInitialized) return;
    window.chartsInitialized = true;

    // Aquí va el código que dibuja los gráficos con Chart.js
    // Ejemplo:
    const ctxVentas = document.getElementById("ventasChart")?.getContext("2d");
    const ctxCompras = document
      .getElementById("comprasChart")
      ?.getContext("2d");
    if (ctxVentas) {
      new Chart(ctxVentas, {
        type: "bar",
        data: {
          labels: ["Ene", "Feb", "Mar"],
          datasets: [{ label: "Ventas", data: [1200, 1500, 1800] }],
        },
      });
    }
    if (ctxCompras) {
      new Chart(ctxCompras, {
        type: "line",
        data: {
          labels: ["Ene", "Feb", "Mar"],
          datasets: [{ label: "Compras", data: [800, 900, 1100] }],
        },
      });
    }
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
