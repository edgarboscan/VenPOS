/**
 * POS (Punto de Venta) Module
 * Autor: Ing. Edgar Boscan
 * Fecha: 01/04/2026
 */

class POSManager {
  constructor() {
    this.BASE_URL = document.querySelector('meta[name="base-url"]')?.content || "";

    const URL =
      window.location.href.includes(this.BASE_URL) ? this.BASE_URL : "";
    this.BASE_URL = URL;

    this.BASE_URL = URL;

    this.EMPRESA_ID = document.querySelector('meta[name="empresa-id"]')?.content || "";

    this.API_URL = this.BASE_URL + "/backend/public/index.php/api";

    // Estado del carrito
    this.cart = [];
    this.selectedClient = null;
    this.saleType = 'CONTADO'; // CONTADO o CREDITO

    // Elementos DOM
    this.productsGrid = document.getElementById('productsGrid');
    this.cartItems = document.getElementById('cartItems');
    this.searchInput = document.getElementById('searchProduct');

    // Inicializar
    this.init();
  }

  async init() {
    await this.loadProducts();
    this.initEventListeners();
    this.renderCart();
    this.updateTotals();
  }

  initEventListeners() {
    // Búsqueda de productos con debounce
    this.searchInput.addEventListener('input', Utils.debounce(() => {
      this.loadProducts();
    }, 300));

    // Enter en búsqueda
    this.searchInput.addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        this.loadProducts();
      }
    });

    // Limpiar carrito
    document.getElementById('clearCartBtn')?.addEventListener('click', () => this.clearCart());
    document.getElementById('clearCartBtn2')?.addEventListener('click', () => this.clearCart());

    // Checkout
    document.getElementById('checkoutBtn')?.addEventListener('click', () => this.showClientModal());

    // Modal de cliente
    document.getElementById('searchClient')?.addEventListener('input', Utils.debounce(() => {
      this.searchClients();
    }, 300));

    document.getElementById('confirmClientBtn')?.addEventListener('click', () => {
      if (this.selectedClient) {
        this.showPaymentModal();
      }
    });

    document.getElementById('newClientBtn')?.addEventListener('click', () => {
      $('#clientModal').modal('hide');
      $('#newClientModal').modal('show');
    });

    document.getElementById('saveNewClientBtn')?.addEventListener('click', () => this.saveNewClient());

    // Modal de pago
    document.getElementById('paymentMethod')?.addEventListener('change', (e) => {
      const isCash = e.target.value === 'EFECTIVO';
      document.getElementById('cashAmountGroup').style.display = isCash ? 'block' : 'none';
      this.saleType = isCash ? 'CONTADO' : 'CREDITO';
      document.getElementById('creditInfo').style.display = this.saleType === 'CREDITO' ? 'block' : 'none';
    });

    document.getElementById('cashAmount')?.addEventListener('input', () => this.calculateChange());
    document.getElementById('confirmPaymentBtn')?.addEventListener('click', () => this.processSale());
  }

  async loadProducts() {
    try {
      Utils.showSpinner();
      const search = this.searchInput?.value || '';
      const params = new URLSearchParams({
        empresa_id: this.EMPRESA_ID,
        search: search,
        pagina: 1,
        por_pagina: 50,
        activo: 1
      });

      const response = await fetch(`${this.API_URL}/inventario?${params}`, {
        credentials: 'include'
      });

      const data = await response.json();
      let products = [];

      if (data.success && data.data && data.data[0]?.result) {
        const parsed = JSON.parse(data.data[0].result);
        products = parsed.data || [];
      } else if (data.data && Array.isArray(data.data)) {
        products = data.data;
      }

      this.renderProducts(products);
    } catch (error) {
      console.error('Error loading products:', error);
      this.productsGrid.innerHTML = '<div class="text-center p-5 text-danger">Error cargando productos</div>';
    } finally {
      Utils.hideSpinner();
    }
  }

  renderProducts(products) {
    if (!products || products.length === 0) {
      this.productsGrid.innerHTML = `
                <div class="text-center p-5 text-muted">
                    <span class="material-symbols-outlined" style="font-size: 48px;">inventory</span>
                    <p>No se encontraron productos</p>
                </div>`;
      return;
    }

    this.productsGrid.innerHTML = products.map(product => {
      const stock = product.stock || 0;
      const hasStock = stock > 0;
      const outOfStockClass = !hasStock ? 'out-of-stock' : '';

      return `
                <div class="product-card ${outOfStockClass}" 
                     data-id="${product.id}"
                     data-name="${Utils.escapeHtml(product.nombre)}"
                     data-price="${product.precio_venta || 0}"
                     data-stock="${stock}"
                     onclick="posManager.addToCart(${product.id}, '${Utils.escapeHtml(product.nombre)}', ${product.precio_venta || 0}, ${stock})">
                    <div class="product-code">${product.codigo || ''}</div>
                    <div class="product-name">${Utils.escapeHtml(product.nombre) || ''}</div>
                    <div class="product-price">${Utils.formatCurrency(product.precio_venta || 0)}</div>
                    <div class="product-stock">Stock: ${stock}</div>
                </div>
            `;
    }).join('');
  }

  addToCart(id, name, price, stock) {
    // Verificar stock
    const existingItem = this.cart.find(item => item.id === id);
    const currentQty = existingItem ? existingItem.quantity : 0;

    if (currentQty + 1 > stock) {
      Utils.showToast(`Stock insuficiente. Solo quedan ${stock} unidades.`, 'error');
      return;
    }

    if (existingItem) {
      existingItem.quantity++;
    } else {
      this.cart.push({
        id: id,
        name: name,
        price: price,
        quantity: 1,
        stock: stock
      });
    }

    this.renderCart();
    this.updateTotals();
    Utils.showToast(`${name} agregado al carrito`, 'success');
  }

  renderCart() {
    if (!this.cartItems) return;

    if (this.cart.length === 0) {
      this.cartItems.innerHTML = `
                <div class="text-center p-5 text-muted">
                    <span class="material-symbols-outlined" style="font-size: 48px;">shopping_cart</span>
                    <p>Carrito vacío</p>
                </div>`;
      return;
    }

    this.cartItems.innerHTML = this.cart.map(item => `
            <div class="cart-item" data-id="${item.id}">
                <div class="cart-item-info">
                    <div class="cart-item-name">${Utils.escapeHtml(item.name)}</div>
                    <div class="cart-item-price">${Utils.formatCurrency(item.price)}</div>
                </div>
                <div class="cart-item-quantity">
                    <button onclick="posManager.updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                    <input type="number" value="${item.quantity}" 
                           onchange="posManager.updateQuantity(${item.id}, parseInt(this.value))"
                           min="1" max="${item.stock}">
                    <button onclick="posManager.updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                </div>
                <div class="cart-item-subtotal">${Utils.formatCurrency(item.price * item.quantity)}</div>
                <button class="cart-item-remove" onclick="posManager.removeFromCart(${item.id})">
                    <span class="material-symbols-outlined">delete</span>
                </button>
            </div>
        `).join('');
  }

  updateQuantity(id, newQuantity) {
    const item = this.cart.find(i => i.id === id);
    if (!item) return;

    if (newQuantity <= 0) {
      this.removeFromCart(id);
      return;
    }

    if (newQuantity > item.stock) {
      Utils.showToast(`Stock insuficiente. Máximo ${item.stock} unidades.`, 'error');
      return;
    }

    item.quantity = newQuantity;
    this.renderCart();
    this.updateTotals();
  }

  removeFromCart(id) {
    this.cart = this.cart.filter(item => item.id !== id);
    this.renderCart();
    this.updateTotals();
  }

  clearCart() {
    if (this.cart.length === 0) return;

    Utils.showSwallConfirm('Limpiar carrito', '¿Estás seguro de que deseas vaciar el carrito?').then(result => {
      if (result.isConfirmed) {
        this.cart = [];
        this.renderCart();
        this.updateTotals();
        Utils.showToast('Carrito vaciado', 'success');
      }
    });
  }

  updateTotals() {
    const subtotal = this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    const tax = subtotal * 0.16; // IVA 16%
    const total = subtotal + tax;

    document.getElementById('subtotal').innerText = Utils.formatCurrency(subtotal);
    document.getElementById('tax').innerText = Utils.formatCurrency(tax);
    document.getElementById('total').innerText = Utils.formatCurrency(total);
  }

  async searchClients() {
    const search = document.getElementById('searchClient')?.value || '';
    if (search.length < 2) {
      document.getElementById('clientList').innerHTML = '<div class="text-center p-3 text-muted">Escriba al menos 2 caracteres...</div>';
      return;
    }

    try {
      const response = await fetch(`${this.API_URL}/clientes?empresa_id=${this.EMPRESA_ID}&search=${encodeURIComponent(search)}&activo=1&pagina=1&por_pagina=20`, {
        credentials: 'include'
      });

      const data = await response.json();
      let clients = [];

      if (data.data && Array.isArray(data.data)) {
        clients = data.data;
      }

      this.renderClients(clients);
    } catch (error) {
      console.error('Error searching clients:', error);
    }
  }

  renderClients(clients) {
    const container = document.getElementById('clientList');

    if (!clients || clients.length === 0) {
      container.innerHTML = '<div class="text-center p-3 text-muted">No se encontraron clientes</div>';
      return;
    }

    container.innerHTML = clients.map(client => `
            <div class="client-item" onclick="posManager.selectClient(${client.id}, '${Utils.escapeHtml(client.nombre)} ${Utils.escapeHtml(client.apellido || '')}', ${client.limite_credito || 0}, ${client.saldo_credito || 0})">
                <div class="client-name">${Utils.escapeHtml(client.nombre)} ${Utils.escapeHtml(client.apellido || '')}</div>
                <div class="client-document">${client.numero_documento || ''} | ${client.telefono || ''}</div>
                <div class="client-balance">Saldo: ${Utils.formatCurrency(client.saldo_credito || 0)} / Límite: ${Utils.formatCurrency(client.limite_credito || 0)}</div>
            </div>
        `).join('');
  }

  selectClient(id, name, limit, balance) {
    this.selectedClient = { id, name, limit, balance };
    document.getElementById('selectedClientName').innerText = name;
    document.getElementById('confirmClientBtn').disabled = false;

    // Mostrar info de crédito
    const canCredit = limit - balance >= this.getCartTotal();
    const creditInfo = document.getElementById('creditInfo');
    if (creditInfo) {
      creditInfo.innerHTML = `
                <span class="material-symbols-outlined">info</span>
                Cliente: ${name}<br>
                Límite disponible: ${Utils.formatCurrency(limit - balance)}<br>
                ${canCredit ? 'Puede realizar compra a crédito' : '⚠️ No tiene suficiente crédito disponible'}
            `;
    }
  }

  getCartTotal() {
    const subtotal = this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    return subtotal + (subtotal * 0.16);
  }

  showClientModal() {
    if (this.cart.length === 0) {
      Utils.showToast('El carrito está vacío', 'warning');
      return;
    }

    this.selectedClient = null;
    document.getElementById('clientList').innerHTML = '<div class="text-center p-3 text-muted">Escriba para buscar clientes...</div>';
    document.getElementById('searchClient').value = '';
    document.getElementById('confirmClientBtn').disabled = true;
    document.getElementById('selectedClientName').innerText = '';

    $('#clientModal').modal('show');
  }

  showPaymentModal() {
    $('#clientModal').modal('hide');

    const total = this.getCartTotal();
    document.getElementById('paymentTotal').innerText = Utils.formatCurrency(total);
    document.getElementById('paymentMethod').value = 'EFECTIVO';
    document.getElementById('cashAmountGroup').style.display = 'block';
    document.getElementById('creditInfo').style.display = 'none';
    document.getElementById('cashAmount').value = '';
    this.saleType = 'CONTADO';

    $('#paymentModal').modal('show');
  }

  calculateChange() {
    const total = this.getCartTotal();
    const received = parseFloat(document.getElementById('cashAmount')?.value) || 0;
    const change = received - total;
    document.getElementById('changeAmount').innerText = Utils.formatCurrency(change > 0 ? change : 0);
  }

  async processSale() {
    if (this.cart.length === 0) {
      Utils.showToast('No hay productos en el carrito', 'error');
      return;
    }

    const total = this.getCartTotal();
    const paymentMethod = document.getElementById('paymentMethod').value;
    const isCredit = paymentMethod !== 'EFECTIVO';

    if (!isCredit) {
      const received = parseFloat(document.getElementById('cashAmount')?.value) || 0;
      if (received < total) {
        Utils.showToast('El monto recibido es insuficiente', 'error');
        return;
      }
    }

    // Preparar datos de la venta
    const saleData = {
      empresa_id: this.EMPRESA_ID,
      cliente_id: this.selectedClient?.id || null,
      tipo_venta: isCredit ? 'CREDITO' : 'CONTADO',
      detalle: this.cart.map(item => ({
        producto_id: item.id,
        cantidad: item.quantity,
        descuento: 0
      }))
    };

    try {
      Utils.showSpinner();

      const response = await fetch(`${this.API_URL}/ventas/registrar`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify(saleData)
      });

      const result = await response.json();

      if (result.status === 'success') {
        // Registrar pago si es crédito
        if (isCredit && this.selectedClient) {
          await this.registerPayment(result.venta_id);
        }

        Utils.showSwalSB('success', 'Venta Completada', `Venta #${result.venta_id} registrada exitosamente`, 2000);

        // Limpiar carrito y cerrar modales
        this.cart = [];
        this.renderCart();
        this.updateTotals();
        $('#paymentModal').modal('hide');

        // Recargar productos para actualizar stock
        this.loadProducts();

        // Preguntar si desea imprimir ticket
        setTimeout(() => {
          Utils.showSwallConfirm('¿Imprimir ticket?', '¿Desea imprimir el comprobante de venta?').then(res => {
            if (res.isConfirmed) {
              this.printTicket(result.venta_id);
            }
          });
        }, 500);
      } else {
        Utils.showToast(result.message || 'Error al procesar la venta', 'error');
      }
    } catch (error) {
      console.error('Error processing sale:', error);
      Utils.showToast('Error al procesar la venta', 'error');
    } finally {
      Utils.hideSpinner();
    }
  }

  async registerPayment(saleId) {
    try {
      const paymentData = {
        empresa_id: this.EMPRESA_ID,
        cliente_id: this.selectedClient.id,
        venta_id: saleId,
        monto: this.getCartTotal(),
        fecha_pago: new Date().toISOString().split('T')[0],
        forma_pago: document.getElementById('paymentMethod').value
      };

      await fetch(`${this.API_URL}/pagos-clientes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify(paymentData)
      });
    } catch (error) {
      console.error('Error registering payment:', error);
    }
  }

  async saveNewClient() {
    const clientData = {
      empresa_id: this.EMPRESA_ID,
      tipo_documento: document.getElementById('newClientDocType').value,
      numero_documento: document.getElementById('newClientDocNumber').value,
      nombre: document.getElementById('newClientName').value,
      telefono: document.getElementById('newClientPhone').value,
      email: document.getElementById('newClientEmail').value,
      limite_credito: 0,
      activo: 1
    };

    if (!clientData.numero_documento || !clientData.nombre) {
      Utils.showToast('Complete los campos obligatorios', 'error');
      return;
    }

    try {
      const response = await fetch(`${this.API_URL}/clientes`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        credentials: 'include',
        body: JSON.stringify(clientData)
      });

      const result = await response.json();

      if (result.status === 'success') {
        this.selectedClient = {
          id: result.id,
          name: clientData.nombre,
          limit: 0,
          balance: 0
        };
        $('#newClientModal').modal('hide');
        this.showPaymentModal();
        Utils.showToast('Cliente creado exitosamente', 'success');
      } else {
        Utils.showToast(result.message || 'Error al crear cliente', 'error');
      }
    } catch (error) {
      console.error('Error creating client:', error);
      Utils.showToast('Error al crear cliente', 'error');
    }
  }

  printTicket(saleId) {
    // Abrir ventana de impresión con el ticket
    const printWindow = window.open('', '_blank', 'width=400,height=600');
    printWindow.document.write(`
            <html>
            <head>
                <title>Ticket de Venta #${saleId}</title>
                <style>
                    body { font-family: monospace; padding: 20px; }
                    .header { text-align: center; margin-bottom: 20px; }
                    .line { border-top: 1px dashed #000; margin: 10px 0; }
                    .item { display: flex; justify-content: space-between; margin: 5px 0; }
                    .total { font-weight: bold; margin-top: 10px; }
                    .footer { text-align: center; margin-top: 20px; font-size: 12px; }
                </style>
            </head>
            <body>
                <div class="header">
                    <h3>VenPOS</h3>
                    <p>Ticket de Venta #${saleId}</p>
                    <p>${new Date().toLocaleString()}</p>
                </div>
                <div class="line"></div>
                ${this.cart.map(item => `
                    <div class="item">
                        <span>${item.quantity}x ${item.name}</span>
                        <span>${Utils.formatCurrency(item.price * item.quantity)}</span>
                    </div>
                `).join('')}
                <div class="line"></div>
                <div class="item total">
                    <span>TOTAL</span>
                    <span>${Utils.formatCurrency(this.getCartTotal())}</span>
                </div>
                <div class="footer">
                    <p>¡Gracias por su compra!</p>
                </div>
                <script>window.print(); setTimeout(() => window.close(), 500);<\/script>
            </body>
            </html>
        `);
  }
}

// Inicializar POS
let posManager;
$(document).ready(function () {
  posManager = new POSManager();
  window.posManager = posManager;
});