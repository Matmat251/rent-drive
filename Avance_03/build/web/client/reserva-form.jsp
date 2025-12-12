<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.VehiculoDAO" %>
<%@ page import="capaEntidad.Vehiculo" %>
<%@ page import="capaEntidad.Cliente" %>
<%
    Cliente clienteLogueado = (Cliente) session.getAttribute("cliente");

    // Si no hay cliente en sesión, redirigir al login
    if (clienteLogueado == null) {
        System.out.println("❌ No hay sesión de cliente - Redirigiendo a login");
        response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
        return;
    }
    
    System.out.println("✅ Cliente en sesión para reserva: " + clienteLogueado.getNombre());
    
    // Obtener el ID del vehículo desde el parámetro URL
    String idVehiculoParam = request.getParameter("id");
    Vehiculo vehiculo = null;
    
    if (idVehiculoParam != null && !idVehiculoParam.trim().isEmpty()) {
        try {
            int idVehiculo = Integer.parseInt(idVehiculoParam);
            VehiculoDAO vehiculoDAO = new VehiculoDAO();
            vehiculo = vehiculoDAO.obtenerVehiculoPorId(idVehiculo);
        } catch (NumberFormatException e) {
            // ID inválido
        }
    }
    
    // Si no se encontró el vehículo, redirigir al catálogo
    if (vehiculo == null) {
        response.sendRedirect(request.getContextPath() + "/vehiculos");
        return;
    }
    
    // Manejar errores de disponibilidad
    String errorReserva = (String) session.getAttribute("errorReserva");
    String tipoError = (String) session.getAttribute("tipoError");
    java.util.Map<String, String> datosFormulario = (java.util.Map<String, String>) session.getAttribute("datosFormulario");

    // Limpiar errores de sesión después de mostrarlos
    if (errorReserva != null) {
        session.removeAttribute("errorReserva");
        session.removeAttribute("tipoError"); 
        session.removeAttribute("datosFormulario");
    }
    
    // PRECARGAR DATOS DEL CLIENTE
    String nombreParam = clienteLogueado.getNombre() + " " + clienteLogueado.getApellido();
    String dniParam = clienteLogueado.getDni();
    String telefonoParam = clienteLogueado.getTelefono() != null ? clienteLogueado.getTelefono() : "";
    String emailParam = clienteLogueado.getEmail() != null ? clienteLogueado.getEmail() : "";
    String fechaInicioParam = "";
    String fechaFinParam = "";
    String metodoPagoParam = "";
    
    // Si hay datos del formulario guardados (por error), usarlos
    if (datosFormulario != null) {
        idVehiculoParam = datosFormulario.get("idVehiculo");
        fechaInicioParam = datosFormulario.get("fechaInicio");
        fechaFinParam = datosFormulario.get("fechaFin");
        metodoPagoParam = datosFormulario.get("metodoPago");
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Completar Reserva</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        .form-section-title {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        .readonly-input {
            background-color: #f8fafc;
            border-color: #e2e8f0;
            color: #64748b;
            cursor: not-allowed;
        }

        .summary-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            background: white;
            position: sticky;
            top: 100px;
        }

        .vehicle-preview {
            background-color: #f1f5f9;
            border-radius: 12px;
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #64748b;
            font-size: 0.95rem;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px dashed #e2e8f0;
            font-weight: 800;
            font-size: 1.4rem;
            color: var(--primary-color);
        }

        .custom-checkbox .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Estilos para la tarjeta visual */
        .tarjeta-visual {
            background: linear-gradient(135deg, #1E3A8A 0%, #3730A3 100%);
            border-radius: 15px;
            padding: 25px;
            color: white;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            min-height: 200px;
            position: relative;
            overflow: hidden;
        }

        .tarjeta-chip {
            width: 50px;
            height: 40px;
            background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .tarjeta-numero {
            font-size: 1.5rem;
            letter-spacing: 3px;
            margin: 15px 0;
            font-family: 'Courier New', monospace;
            font-weight: bold;
        }

        .tarjeta-info {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            font-size: 0.9rem;
        }

        .tarjeta-titular {
            flex: 2;
        }

        .tarjeta-fecha {
            flex: 1;
            text-align: right;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="Logo" width="40" height="40" class="rounded me-2">
                <span>FastWheels</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/vehiculos">Catálogo</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/mis-reservas.jsp">Mis Reservas</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/perfil-cliente">Mi Perfil</a></li>
                    <li class="nav-item ms-lg-3">
                        <a href="${pageContext.request.contextPath}/logout-cliente" class="btn btn-logout text-decoration-none">
                            <i class="fas fa-sign-out-alt me-1"></i> Cerrar Sesión
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container py-5">
        <div class="row g-5">
            
            <div class="col-lg-8">
                
                <div class="d-flex align-items-center mb-4">
                    <a href="${pageContext.request.contextPath}/vehiculos" class="btn btn-light rounded-circle me-3 shadow-sm">
                        <i class="fas fa-arrow-left"></i>
                    </a>
                    <h2 class="fw-bold mb-0">Confirmar Reserva</h2>
                </div>

                <% if (errorReserva != null) { %>
                    <div class="alert alert-danger shadow-sm border-0 mb-4">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <strong>No se pudo completar:</strong> <%= errorReserva %>
                    </div>
                <% } %>
                
                <div id="mensajeDisponibilidad" style="display: none;" class="mb-4"></div>

                <form id="formReserva" action="${pageContext.request.contextPath}/procesar-reserva" method="post" class="needs-validation">
                    <input type="hidden" name="idVehiculo" value="<%= vehiculo.getIdVehiculo() %>">

                    <!-- Sección Datos del Conductor -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-body p-4">
                            <h4 class="form-section-title"><i class="fas fa-user-check me-2"></i>Datos del Conductor</h4>
                            
                            <div class="alert alert-info small d-flex align-items-center">
                                <i class="fas fa-info-circle me-2"></i>
                                <span>Estos datos se han cargado desde tu perfil. Para cambiarlos, edita tu cuenta.</span>
                            </div>

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label text-muted small fw-bold">Nombre Completo</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control readonly-input border-start-0" value="<%= nombreParam %>" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label text-muted small fw-bold">DNI / ID</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control readonly-input border-start-0" name="dni" value="<%= dniParam %>" readonly>
                                    </div>
                                    <input type="hidden" name="nombre" value="<%= nombreParam %>">
                                    <input type="hidden" name="telefono" value="<%= telefonoParam %>">
                                    <input type="hidden" name="email" value="<%= emailParam %>">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección Detalles del Viaje -->
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-body p-4">
                            <h4 class="form-section-title"><i class="fas fa-calendar-alt me-2"></i>Detalles del Viaje</h4>
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="fechaInicio" class="form-label fw-bold">Fecha de Recogida</label>
                                    <input type="date" class="form-control p-3" id="fechaInicio" name="fechaInicio" 
                                           value="<%= fechaInicioParam %>" required min="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="col-md-6">
                                    <label for="fechaFin" class="form-label fw-bold">Fecha de Devolución</label>
                                    <input type="date" class="form-control p-3" id="fechaFin" name="fechaFin" 
                                           value="<%= fechaFinParam %>" required>
                                </div>
                                
                                <div class="col-12 mt-4">
                                    <label for="metodoPago" class="form-label fw-bold">Método de Pago</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-white"><i class="fas fa-credit-card text-primary"></i></span>
                                        <select class="form-select p-3" id="metodoPago" name="metodoPago" required>
                                            <option value="">Selecciona cómo pagar...</option>
                                            <option value="Tarjeta" <%= "Tarjeta".equals(metodoPagoParam) ? "selected" : "" %>>Tarjeta de Crédito / Débito</option>
                                            <option value="Transferencia" <%= "Transferencia".equals(metodoPagoParam) ? "selected" : "" %>>Transferencia Bancaria</option>
                                            <option value="Efectivo" <%= "Efectivo".equals(metodoPagoParam) ? "selected" : "" %>>Pago en Agencias (Efectivo)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Sección Datos de Tarjeta (solo visible cuando se selecciona Tarjeta) -->
                    <div class="card border-0 shadow-sm mb-4" id="formularioTarjeta" style="display: none;">
                        <div class="card-body p-4">
                            <h4 class="form-section-title"><i class="fas fa-credit-card me-2"></i>Datos de la Tarjeta</h4>
                            
                            <!-- Tarjeta Visual -->
                            <div class="tarjeta-visual mb-4">
                                <div class="tarjeta-chip"></div>
                                <div class="tarjeta-numero" id="numeroVisual">•••• •••• •••• ••••</div>
                                <div class="tarjeta-info">
                                    <div class="tarjeta-titular">
                                        <small class="d-block text-white-50 mb-1">TITULAR</small>
                                        <span id="titularVisual"><%= clienteLogueado.getNombre().toUpperCase() %></span>
                                    </div>
                                    <div class="tarjeta-fecha">
                                        <small class="d-block text-white-50 mb-1">VENCE</small>
                                        <span id="fechaVisual">MM/AA</span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Campos del formulario -->
                            <div class="mb-3">
                                <label for="numeroTarjeta" class="form-label">Número de Tarjeta</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="numeroTarjeta" 
                                       name="numeroTarjeta" 
                                       placeholder="1234 5678 9012 3456"
                                       maxlength="19"
                                       required>
                                <div class="form-text">Puede ingresar el número con o sin espacios</div>
                            </div>

                            <div class="mb-3">
                                <label for="nombreTitular" class="form-label">Nombre del Titular</label>
                                <input type="text" 
                                       class="form-control" 
                                       id="nombreTitular" 
                                       name="nombreTitular" 
                                       placeholder="JUAN PEREZ"
                                       value="<%= nombreParam.toUpperCase() %>"
                                       required>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <label for="fechaVencimiento" class="form-label">Fecha Vencimiento</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="fechaVencimiento" 
                                           name="fechaVencimiento" 
                                           placeholder="MM/AA"
                                           maxlength="5"
                                           required>
                                </div>
                                <div class="col-md-6">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="text" 
                                           class="form-control" 
                                           id="cvv" 
                                           name="cvv" 
                                           placeholder="123"
                                           maxlength="4"
                                           required>
                                </div>
                            </div>
                            
                            <div class="alert alert-info mt-3 small d-flex align-items-center">
                                <i class="fas fa-shield-alt me-2"></i>
                                <span>Tus datos están protegidos con encriptación SSL de grado bancario.</span>
                            </div>
                        </div>
                    </div>

                    <!-- Sección Términos y Condiciones -->
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4">
                            <div class="form-check custom-checkbox mb-3">
                                <input class="form-check-input" type="checkbox" id="brevete" name="brevete" required>
                                <label class="form-check-label" for="brevete">
                                    Declaro bajo juramento que cuento con <strong>Licencia de Conducir (Brevete)</strong> vigente.
                                </label>
                            </div>
                            <div class="form-check custom-checkbox">
                                <input class="form-check-input" type="checkbox" id="terminos" name="terminos" required>
                                <label class="form-check-label" for="terminos">
                                    He leído y acepto los <a href="#" class="text-primary text-decoration-none">Términos y Condiciones</a> del servicio.
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Botón para móviles -->
                    <div class="d-block d-lg-none mt-4">
                        <button type="submit" class="btn btn-primary w-100 py-3 fw-bold rounded-pill">Confirmar Reserva</button>
                    </div>
                </form>
            </div>

            <!-- Resumen Lateral -->
            <div class="col-lg-4">
                <div class="summary-card p-4">
                    <h5 class="fw-bold mb-4">Resumen de Reserva</h5>
                    
                    <div class="vehicle-preview">
                        <i class="fas fa-car fa-3x text-primary mb-3"></i>
                        <h5 class="fw-bold text-dark"><%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %></h5>
                        <div class="badge bg-secondary bg-opacity-10 text-secondary mb-2"><%= vehiculo.getTipo() %></div>
                        <div class="small text-muted"><%= vehiculo.getAnio() %> • Transmisión Automática</div>
                    </div>

                    <div class="price-details mt-4">
                        <div class="price-row">
                            <span>Precio por día</span>
                            <span class="fw-bold text-dark">$<%= vehiculo.getPrecioDiario() %></span>
                        </div>
                        <div class="price-row">
                            <span>Días seleccionados</span>
                            <span id="diasSeleccionados" class="fw-bold text-dark">0</span>
                        </div>
                        <div class="price-row">
                            <span>Seguro Básico</span>
                            <span class="text-success">Gratis</span>
                        </div>
                        
                        <div class="total-row" id="precioTotalContainer">
                            <span>Total</span>
                            <span id="precioTotalTexto">$0.00</span>
                        </div>
                    </div>

                    <button type="submit" form="formReserva" id="btnReservar" class="btn btn-primary w-100 py-3 mt-4 fw-bold rounded-pill shadow-sm" disabled>
                        Confirmar y Pagar
                    </button>
                    
                    <div class="text-center mt-3 small text-muted">
                        <i class="fas fa-lock me-1"></i> Transacción segura SSL
                    </div>
                </div>
            </div>

        </div>
    </div>

    <footer class="footer-main">
        <div class="container">
            <p class="mb-0">&copy; 2025 FastWheels Rental System.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const fechaInicio = document.getElementById('fechaInicio');
        const fechaFin = document.getElementById('fechaFin');
        const metodoPago = document.getElementById('metodoPago');
        
        // Elementos de UI
        const precioTotalTexto = document.getElementById('precioTotalTexto');
        const diasSeleccionados = document.getElementById('diasSeleccionados');
        const mensajeDisponibilidad = document.getElementById('mensajeDisponibilidad');
        const btnReservar = document.getElementById('btnReservar');
        
        // Elementos de tarjeta
        const formularioTarjeta = document.getElementById('formularioTarjeta');
        const numeroTarjeta = document.getElementById('numeroTarjeta');
        const nombreTitular = document.getElementById('nombreTitular');
        const fechaVencimiento = document.getElementById('fechaVencimiento');
        const cvv = document.getElementById('cvv');
        
        // Visualización de tarjeta
        const numeroVisual = document.getElementById('numeroVisual');
        const titularVisual = document.getElementById('titularVisual');
        const fechaVisual = document.getElementById('fechaVisual');
        
        const precioPorDia = <%= vehiculo.getPrecioDiario() %>;
        
        // Establecer fecha mínima para hoy
        const today = new Date().toISOString().split('T')[0];
        fechaInicio.min = today;
        
        // Mostrar/ocultar formulario de tarjeta según método de pago
        metodoPago.addEventListener('change', function() {
            if (this.value === 'Tarjeta') {
                formularioTarjeta.style.display = 'block';
                // Hacer campos de tarjeta obligatorios
                numeroTarjeta.required = true;
                nombreTitular.required = true;
                fechaVencimiento.required = true;
                cvv.required = true;
            } else {
                formularioTarjeta.style.display = 'none';
                // Quitar obligatoriedad
                numeroTarjeta.required = false;
                nombreTitular.required = false;
                fechaVencimiento.required = false;
                cvv.required = false;
            }
        });
        
        // Formatear número de tarjeta
        if (numeroTarjeta) {
            numeroTarjeta.addEventListener('input', function(e) {
                let valor = e.target.value.replace(/\s/g, '').replace(/\D/g, '');
                let formatado = valor.match(/.{1,4}/g)?.join(' ') || '';
                e.target.value = formatado;
                
                if (valor.length > 0) {
                    numeroVisual.textContent = formatado.padEnd(19, '•');
                } else {
                    numeroVisual.textContent = '•••• •••• •••• ••••';
                }
            });
        }
        
        // Formatear fecha de vencimiento
        if (fechaVencimiento) {
            fechaVencimiento.addEventListener('input', function(e) {
                let valor = e.target.value.replace(/\D/g, '');
                if (valor.length >= 2) {
                    valor = valor.slice(0, 2) + '/' + valor.slice(2, 4);
                }
                e.target.value = valor;
                fechaVisual.textContent = valor || 'MM/AA';
            });
        }
        
        // Formatear CVV (solo números)
        if (cvv) {
            cvv.addEventListener('input', function(e) {
                e.target.value = e.target.value.replace(/\D/g, '');
            });
        }
        
        // Actualizar nombre titular
        if (nombreTitular) {
            nombreTitular.addEventListener('input', function(e) {
                titularVisual.textContent = e.target.value.toUpperCase() || '<%= clienteLogueado.getNombre().toUpperCase() %>';
            });
        }
        
        function calcularTotal() {
            if (fechaInicio.value && fechaFin.value) {
                const inicio = new Date(fechaInicio.value);
                const fin = new Date(fechaFin.value);
                
                // Validar fechas
                if (fin <= inicio) {
                    precioTotalTexto.textContent = '$0.00';
                    diasSeleccionados.textContent = '0';
                    btnReservar.disabled = true;
                    mensajeDisponibilidad.style.display = 'block';
                    mensajeDisponibilidad.className = 'alert alert-warning';
                    mensajeDisponibilidad.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>La fecha de devolución debe ser posterior a la de recogida.';
                    return;
                }
                
                // Calcular días
                const diferenciaTiempo = fin.getTime() - inicio.getTime();
                const dias = Math.ceil(diferenciaTiempo / (1000 * 3600 * 24));
                const total = dias * precioPorDia;
                
                // Actualizar UI
                diasSeleccionados.textContent = dias;
                precioTotalTexto.textContent = '$' + total.toFixed(2);
                
                // Verificar disponibilidad
                verificarDisponibilidad();
                
            } else {
                precioTotalTexto.textContent = '$0.00';
                diasSeleccionados.textContent = '0';
                mensajeDisponibilidad.style.display = 'none';
                btnReservar.disabled = true;
            }
        }
        
        function verificarDisponibilidad() {
            mensajeDisponibilidad.style.display = 'block';
            mensajeDisponibilidad.className = 'alert alert-info';
            mensajeDisponibilidad.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Verificando disponibilidad...';
            btnReservar.disabled = true;
            
            fetch("${pageContext.request.contextPath}/verificar-disponibilidad?idVehiculo=<%= vehiculo.getIdVehiculo() %>&fechaInicio=" + fechaInicio.value + "&fechaFin=" + fechaFin.value)
                .then(response => response.json())
                .then(data => {
                    if (data.disponible) {
                        mensajeDisponibilidad.className = 'alert alert-success border-0';
                        mensajeDisponibilidad.innerHTML = '<i class="fas fa-check-circle me-2"></i>' + data.mensaje;
                        btnReservar.disabled = false;
                    } else {
                        mensajeDisponibilidad.className = 'alert alert-danger border-0';
                        mensajeDisponibilidad.innerHTML = '<i class="fas fa-times-circle me-2"></i>' + data.mensaje;
                        btnReservar.disabled = true;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    mensajeDisponibilidad.className = 'alert alert-danger';
                    mensajeDisponibilidad.innerHTML = 'Error de conexión al verificar disponibilidad.';
                });
        }
        
        // Listeners
        fechaInicio.addEventListener('change', function() {
            if (this.value) fechaFin.min = this.value;
            calcularTotal();
        });
        fechaFin.addEventListener('change', calcularTotal);
        
        // Calcular si hay datos precargados
        if (fechaInicio.value || fechaFin.value) {
            calcularTotal();
        }
        
        // Mostrar formulario de tarjeta si ya está seleccionado
        if (metodoPago.value === 'Tarjeta') {
            formularioTarjeta.style.display = 'block';
        }
    });
    </script>
</body>
</html>