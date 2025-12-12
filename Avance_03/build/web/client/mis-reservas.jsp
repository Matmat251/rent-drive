<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.ReservaDAO" %>
<%@ page import="capaEntidad.Reserva" %>
<%@ page import="java.util.List" %>
<%@ page import="capaEntidad.Cliente" %>
<%   
    // 
    Cliente cliente = (Cliente) session.getAttribute("cliente");
    
    // Verificación de sesión
    if (cliente == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
        return;
    }
    
    String dniCliente = cliente.getDni();
    ReservaDAO reservaDAO = new ReservaDAO();
    List<Reserva> reservas = reservaDAO.obtenerReservasPorCliente(dniCliente);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Mis Reservas</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Estilos específicos para las tarjetas de reserva */
        .reserva-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.05);
            transition: transform 0.2s;
            background: white;
            border-left: 5px solid transparent; /* Borde de estado */
        }

        .reserva-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        /* Colores de estado en el borde izquierdo */
        .border-activa { border-left-color: var(--success); }
        .border-cancelada { border-left-color: var(--danger); opacity: 0.75; }
        .border-finalizada { border-left-color: #64748B; }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #64748B;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-weight: 500;
            color: #1F2937;
            font-size: 0.95rem;
        }

        .price-total {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--primary-color);
        }

        .user-welcome-card {
            background: linear-gradient(135deg, #e0e7ff 0%, #f3f4f6 100%);
            border: 1px solid #c7d2fe;
            border-radius: 12px;
        }
        
        /* Botón de descargar boleta en las tarjetas */
        .btn-descargar-boleta {
            background: linear-gradient(135deg, #10B981, #34D399);
            border: none;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-descargar-boleta:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
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
                    <li class="nav-item"><a class="nav-link active" href="#">Mis Reservas</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/perfil-cliente">Mi Perfil</a></li>
                    <li class="nav-item ms-lg-3">
                        <a href="${pageContext.request.contextPath}/logout-cliente" class="btn btn-logout text-decoration-none">
                            <i class="fas fa-sign-out-alt me-1"></i> Salir
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="page-header text-center">
        <div class="container">
            <h1 class="display-5 fw-bold text-dark">Mis Reservas</h1>
            <p class="text-muted">Administra tus viajes y consulta tu historial.</p>
        </div>
    </div>

    <div class="container pb-5">
        
        <div class="row mb-4">
            <div class="col-12">
                <div class="p-4 user-welcome-card d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div class="d-flex align-items-center">
                        <div class="bg-white p-3 rounded-circle shadow-sm me-3 text-primary">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </div>
                        <div>
                            <h5 class="mb-0 fw-bold"><%= cliente.getNombre() %> <%= cliente.getApellido() %></h5>
                            <small class="text-muted">DNI: <%= dniCliente %></small>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/vehiculos" class="btn btn-primary shadow-sm">
                            <i class="fas fa-plus-circle me-2"></i> Nueva Reserva
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3 bg-white p-3 rounded shadow-sm border">
            <div class="d-flex gap-2">
                <span class="badge bg-light text-dark border"><i class="fas fa-list"></i> Total: <span id="totalReservas">0</span></span>
                <span class="badge bg-success bg-opacity-10 text-success border border-success"><i class="fas fa-check"></i> Activas: <span id="reservasActivas">0</span></span>
                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger"><i class="fas fa-times"></i> Canceladas: <span id="reservasCanceladas">0</span></span>
            </div>
            
            <div class="form-check form-switch">
                <input class="form-check-input" type="checkbox" id="mostrarCanceladas" checked onchange="toggleReservasCanceladas()">
                <label class="form-check-label small fw-bold text-muted" for="mostrarCanceladas">Mostrar Canceladas</label>
            </div>
        </div>

        <div class="row g-4">
            <% if (reservas != null && !reservas.isEmpty()) { 
                for (Reserva reserva : reservas) {
                    // Determinar estilos según estado
                    String estadoLower = reserva.getEstado().toLowerCase();
                    String borderClass = "";
                    String badgeClass = "";
                    String icon = "";
                    
                    if(estadoLower.contains("activa")) {
                        borderClass = "border-activa";
                        badgeClass = "bg-success";
                        icon = "fa-check-circle";
                    } else if (estadoLower.contains("cancelada")) {
                        borderClass = "border-cancelada";
                        badgeClass = "bg-danger";
                        icon = "fa-times-circle";
                    } else {
                        borderClass = "border-finalizada";
                        badgeClass = "bg-secondary";
                        icon = "fa-flag-checkered";
                    }
            %>
            
            <div class="col-12 reserva-item" data-estado="<%= estadoLower %>">
                <div class="reserva-card <%= borderClass %> p-4">
                    <div class="row align-items-center">
                        
                        <div class="col-lg-4 col-md-6 mb-3 mb-lg-0">
                            <div class="d-flex align-items-center">
                                <div class="bg-light p-3 rounded me-3 text-center" style="min-width: 60px;">
                                    <i class="fas fa-car fa-2x text-muted"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-1 text-primary"><%= reserva.getMarcaVehiculo() %> <%= reserva.getModeloVehiculo() %></h5>
                                    <span class="badge <%= badgeClass %> rounded-pill">
                                        <i class="fas <%= icon %> me-1"></i> <%= reserva.getEstado() %>
                                    </span>
                                    <div class="small text-muted mt-1">Reserva #<%= reserva.getIdReserva() %></div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 mb-3 mb-lg-0">
                            <div class="mb-2">
                                <div class="info-label"><i class="fas fa-calendar-alt me-1"></i> Fechas</div>
                                <div class="info-value"><%= reserva.getFechaInicio() %> <i class="fas fa-arrow-right mx-1 text-muted" style="font-size: 0.7rem;"></i> <%= reserva.getFechaFin() %></div>
                            </div>
                            <div>
                                <div class="info-label"><i class="fas fa-clock me-1"></i> Duración</div>
                                <div class="info-value"><%= reserva.getDias() %> días</div>
                            </div>
                        </div>

                        <div class="col-lg-2 col-md-6 mb-3 mb-lg-0">
                            <div class="mb-2">
                                <div class="info-label">Total a Pagar</div>
                                <div class="price-total">$<%= String.format("%.2f", reserva.getTotal()) %></div>
                            </div>
                            <div class="small text-muted">
                                <i class="fas fa-credit-card me-1"></i> <%= reserva.getMetodoPago() %>
                            </div>
                        </div>

                        <div class="col-lg-3 col-md-6 text-lg-end">
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <!-- Botón para descargar boleta - disponible para todas las reservas -->
                                <a href="${pageContext.request.contextPath}/descargar-boleta?idReserva=<%= reserva.getIdReserva() %>" 
                                   class="btn btn-descargar-boleta btn-sm" 
                                   target="_blank"
                                   title="Descargar Boleta PDF">
                                    <i class="fas fa-download me-1"></i> Boleta
                                </a>
                                
                                <% if ("Activa".equals(reserva.getEstado())) { %>
                                    <button class="btn btn-outline-primary btn-sm" onclick="verDetalles(<%= reserva.getIdReserva() %>)">
                                        <i class="fas fa-info-circle"></i> Detalles
                                    </button>
                                    <button class="btn btn-outline-danger btn-sm" onclick="cancelarReserva(<%= reserva.getIdReserva() %>)">
                                        <i class="fas fa-times"></i> Cancelar
                                    </button>
                                <% } else { %>
                                    <button class="btn btn-light btn-sm text-muted" disabled>
                                        <i class="fas fa-lock"></i> Acciones
                                    </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%  } 
               } else { %>
                <div class="col-12 text-center py-5">
                    <div class="text-muted opacity-75">
                        <i class="fas fa-calendar-times fa-4x mb-3"></i>
                        <h3>No tienes reservas registradas</h3>
                        <p>¿Planeando un viaje? Revisa nuestra flota disponible.</p>
                        <a href="${pageContext.request.contextPath}/vehiculos" class="btn btn-primary mt-3">
                            Ver Vehículos
                        </a>
                    </div>
                </div>
            <% } %>
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
            actualizarContadores();
        });
        
        function actualizarContadores() {
            const reservasActivas = document.querySelectorAll('.reserva-item[data-estado*="activa"]').length;
            const reservasCanceladas = document.querySelectorAll('.reserva-item[data-estado*="cancelada"]').length;
            const reservasFinalizadas = document.querySelectorAll('.reserva-item[data-estado*="finalizada"]').length;
            const total = reservasActivas + reservasCanceladas + reservasFinalizadas;
            
            document.getElementById('totalReservas').textContent = total;
            document.getElementById('reservasActivas').textContent = reservasActivas;
            document.getElementById('reservasCanceladas').textContent = reservasCanceladas;
        }
        
        function toggleReservasCanceladas() {
            const mostrar = document.getElementById('mostrarCanceladas').checked;
            const reservasCanceladas = document.querySelectorAll('.reserva-item[data-estado*="cancelada"]');
            
            reservasCanceladas.forEach(reserva => {
                if (mostrar) {
                    reserva.style.display = 'block';
                    // Pequeña animación de entrada
                    reserva.style.opacity = '0';
                    setTimeout(() => { reserva.style.opacity = '1'; }, 50);
                } else {
                    reserva.style.display = 'none';
                }
            });
        }
        
        function cancelarReserva(idReserva) {
            if (confirm('¿Estás seguro de que deseas cancelar esta reserva?\nEsta acción es irreversible.')) {
                // Feedback visual inmediato en el botón
                const btn = event.target.closest('button');
                const originalText = btn.innerHTML;
                btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Cancelando...';
                btn.disabled = true;

                fetch('${pageContext.request.contextPath}/cancelar-reserva?id=' + idReserva, {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) return response.text();
                    throw new Error('Error del servidor');
                })
                .then(result => {
                    if (result === 'success') {
                        // Recargar para ver cambios
                        window.location.reload();
                    } else {
                        throw new Error('Fallo en la cancelación');
                    }
                })
                .catch(error => {
                    alert('❌ Error: No se pudo cancelar la reserva.');
                    btn.innerHTML = originalText;
                    btn.disabled = false;
                });
            }
        }
        
        function verDetalles(idReserva) {
            // Generamos un Modal de Bootstrap dinámicamente
            const modalHTML = `
                <div class="modal fade" id="detalleModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content border-0 shadow">
                            <div class="modal-header bg-primary text-white">
                                <h5 class="modal-title"><i class="fas fa-clipboard-list me-2"></i>Detalles de Reserva #${idReserva}</h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body p-4">
                                <div class="text-center mb-4">
                                    <div class="display-6 text-primary mb-2"><i class="fas fa-check-circle"></i></div>
                                    <h4 class="fw-bold">Reserva Confirmada</h4>
                                    <p class="text-muted">Tu vehículo está listo para la fecha seleccionada.</p>
                                </div>
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item d-flex justify-content-between">
                                        <span><i class="fas fa-file-contract text-muted me-2"></i>Seguro</span>
                                        <span class="fw-bold">Básico Incluido</span>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between">
                                        <span><i class="fas fa-gas-pump text-muted me-2"></i>Tanque</span>
                                        <span class="fw-bold">Lleno / Lleno</span>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between">
                                        <span><i class="fas fa-phone text-muted me-2"></i>Soporte</span>
                                        <span class="fw-bold">24/7</span>
                                    </div>
                                </div>
                                <div class="alert alert-info mt-3 small">
                                    <i class="fas fa-info-circle me-1"></i> Recuerda llevar tu DNI y Licencia vigente al momento de recoger el auto.
                                </div>
                            </div>
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                                <!-- BOTÓN CORREGIDO: Ahora descarga la boleta en PDF -->
                                <a href="${pageContext.request.contextPath}/descargar-boleta?idReserva=${idReserva}" 
                                   class="btn btn-primary" 
                                   target="_blank">
                                    <i class="fas fa-download me-1"></i> Descargar Boleta
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            // Eliminar modal anterior si existe
            const oldModal = document.getElementById('detalleModal');
            if (oldModal) oldModal.remove();

            // Insertar y mostrar
            document.body.insertAdjacentHTML('beforeend', modalHTML);
            const myModal = new bootstrap.Modal(document.getElementById('detalleModal'));
            myModal.show();
        }
        
        // Función para mostrar notificación de descarga
        function mostrarNotificacionDescarga() {
            // Crear notificación toast
            const toastHTML = `
                <div class="toast align-items-center text-white bg-success border-0 position-fixed top-0 end-0 m-3" 
                     role="alert" aria-live="assertive" aria-atomic="true" id="descargaToast">
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas fa-check-circle me-2"></i> Descargando boleta...
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                </div>
            `;
            
            document.body.insertAdjacentHTML('beforeend', toastHTML);
            const toast = new bootstrap.Toast(document.getElementById('descargaToast'));
            toast.show();
            
            // Remover el toast después de 3 segundos
            setTimeout(() => {
                const toastElement = document.getElementById('descargaToast');
                if (toastElement) {
                    toastElement.remove();
                }
            }, 3000);
        }
        
        // Agregar evento a todos los botones de descarga
        document.addEventListener('click', function(e) {
            if (e.target.closest('.btn-descargar-boleta')) {
                mostrarNotificacionDescarga();
            }
        });
    </script>
</body>
</html>