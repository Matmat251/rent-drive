<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.ReservaDAO, capaEntidad.Reserva" %>
<%
    // 1. SEGURIDAD: Verificar sesión de admin
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    // 2. LÓGICA: Obtener la reserva por ID
    String idParam = request.getParameter("id");
    Reserva reserva = null;
    
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int idReserva = Integer.parseInt(idParam);
            ReservaDAO reservaDAO = new ReservaDAO();
            // Asumiendo que tienes un método obtenerReservaPorId o reutilizando lógica
            // Nota: Si tu DAO no tiene este método específico, deberías agregarlo.
            // Aquí simulamos buscar en la lista completa si no existe el método individual
            java.util.List<Reserva> lista = reservaDAO.listarTodasReservas();
            for(Reserva r : lista) {
                if(r.getIdReserva() == idReserva) {
                    reserva = r;
                    break;
                }
            }
        } catch (Exception e) { }
    }

    if (reserva == null) {
        response.sendRedirect("gestion-reservas.jsp?error=Reserva no encontrada");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Detalle Reserva #<%= reserva.getIdReserva() %></title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        body { background-color: #f1f5f9; min-height: 100vh; }
        
        /* Sidebar Fijo (Igual que los demás) */
        .sidebar {
            height: 100vh; width: 260px; position: fixed; top: 0; left: 0;
            background-color: #1e293b; padding-top: 20px; color: #94a3b8;
            transition: all 0.3s; z-index: 1000;
        }
        .sidebar-brand { padding: 0 20px 20px; border-bottom: 1px solid #334155; color: white; font-size: 1.4rem; font-weight: bold; display: flex; align-items: center; }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 20px; }
        .sidebar-menu li a { display: block; padding: 12px 25px; color: #94a3b8; text-decoration: none; transition: 0.2s; border-left: 4px solid transparent; }
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #334155; color: white; border-left-color: var(--primary-color); }
        .sidebar-menu li a i { width: 25px; text-align: center; margin-right: 10px; }
        
        .main-content { margin-left: 260px; padding: 30px; }

        /* Estilos Detalle */
        .invoice-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            overflow: hidden;
            border: none;
        }
        
        .invoice-header {
            background-color: #f8fafc;
            padding: 25px 30px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .status-badge {
            font-size: 0.9rem;
            padding: 8px 15px;
            border-radius: 30px;
            font-weight: 700;
            text-transform: uppercase;
        }
        .bg-activa { background-color: #dcfce7; color: #166534; }
        .bg-finalizada { background-color: #e0e7ff; color: #3730a3; }
        .bg-cancelada { background-color: #fee2e2; color: #991b1b; }

        .detail-section { padding: 30px; }
        
        .detail-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #64748b;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .detail-value {
            font-size: 1rem;
            color: #1e293b;
            font-weight: 500;
        }

        .total-box {
            background-color: #f8fafc;
            border-radius: 10px;
            padding: 20px;
            text-align: right;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand"><i class="fas fa-steering-wheel me-2"></i> FastWheels</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Gestión</li>
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos"><i class="fas fa-car"></i> Vehículos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp" class="active"><i class="fas fa-calendar-check"></i> Reservas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Reportes</li>
            <li><a href="${pageContext.request.contextPath}/admin/reportes.jsp"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/calendario.jsp"><i class="fas fa-calendar-alt"></i> Calendario</a></li>
            <li class="mt-5 border-top border-secondary pt-3">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp" class="text-decoration-none text-muted small">
                    <i class="fas fa-arrow-left me-1"></i> Volver a Reservas
                </a>
                <h2 class="fw-bold text-dark mt-1">Detalle de Reserva</h2>
            </div>
            
            <div class="d-flex gap-2">
                <button onclick="window.print()" class="btn btn-outline-secondary">
                    <i class="fas fa-print me-2"></i> Imprimir
                </button>
                <% if ("Activa".equals(reserva.getEstado())) { %>
                    <form action="${pageContext.request.contextPath}/admin/reserva-accion" method="post">
                        <input type="hidden" name="action" value="finalizar">
                        <input type="hidden" name="id" value="<%= reserva.getIdReserva() %>">
                        <button class="btn btn-success fw-bold">
                            <i class="fas fa-check-circle me-2"></i> Finalizar Reserva
                        </button>
                    </form>
                <% } %>
            </div>
        </div>

        <div class="card invoice-card">
            <div class="invoice-header">
                <div>
                    <h5 class="mb-1 text-primary fw-bold">Reserva #<%= reserva.getIdReserva() %></h5>
                    <span class="text-muted small"><i class="far fa-clock me-1"></i> Registrada el: <%= reserva.getFechaInicio() %> (aprox)</span>
                </div>
                <div>
                    <% 
                        String badgeClass = "bg-secondary";
                        if("Activa".equals(reserva.getEstado())) badgeClass = "bg-activa";
                        if("Finalizada".equals(reserva.getEstado())) badgeClass = "bg-finalizada";
                        if("Cancelada".equals(reserva.getEstado())) badgeClass = "bg-cancelada";
                    %>
                    <span class="status-badge <%= badgeClass %>"><%= reserva.getEstado() %></span>
                </div>
            </div>

            <div class="detail-section">
                <div class="row g-4">
                    
                    <div class="col-md-4 border-end">
                        <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">
                            <i class="fas fa-user-circle me-2"></i> Datos del Cliente
                        </h6>
                        <div class="mb-3">
                            <div class="detail-label">Nombre Completo</div>
                            <div class="detail-value"><%= reserva.getNombreCliente() %></div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">DNI / Identificación</div>
                            <div class="detail-value"><%= reserva.getDniCliente() %></div>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp?dni=<%= reserva.getDniCliente() %>" class="btn btn-link btn-sm p-0 text-decoration-none">
                                Ver historial del cliente &rarr;
                            </a>
                        </div>
                    </div>

                    <div class="col-md-4 border-end">
                        <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">
                            <i class="fas fa-car me-2"></i> Vehículo Asignado
                        </h6>
                        <div class="mb-3">
                            <div class="detail-label">Vehículo</div>
                            <div class="detail-value fw-bold"><%= reserva.getMarcaVehiculo() %> <%= reserva.getModeloVehiculo() %></div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Tipo</div>
                            <div class="detail-value"><span class="badge bg-light text-dark border"><%= reserva.getTipoVehiculo() %></span></div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">
                            <i class="fas fa-calendar-alt me-2"></i> Periodo de Alquiler
                        </h6>
                        <div class="row">
                            <div class="col-6 mb-3">
                                <div class="detail-label">Fecha Recogida</div>
                                <div class="detail-value text-success"><%= reserva.getFechaInicio() %></div>
                            </div>
                            <div class="col-6 mb-3">
                                <div class="detail-label">Fecha Devolución</div>
                                <div class="detail-value text-danger"><%= reserva.getFechaFin() %></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="detail-label">Duración Total</div>
                            <div class="detail-value"><%= reserva.getDias() %> Días</div>
                        </div>
                    </div>

                </div>

                <div class="row mt-5">
                    <div class="col-md-6 offset-md-6">
                        <div class="total-box">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Método de Pago:</span>
                                <span class="fw-bold"><%= reserva.getMetodoPago() %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-2">
                                <span class="h5 mb-0 fw-bold text-dark">Total Pagado:</span>
                                <span class="h3 mb-0 fw-bold text-primary">$<%= String.format("%.2f", reserva.getTotal()) %></span>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>