<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="capaEntidad.Reserva" %>
<%
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    String mensajeExito = (String) userSession.getAttribute("mensajeExito");
    String mensajeError = (String) userSession.getAttribute("mensajeError");
    if (mensajeExito != null) userSession.removeAttribute("mensajeExito");
    if (mensajeError != null) userSession.removeAttribute("mensajeError");
    
    List<Reserva> reservas = (List<Reserva>) request.getAttribute("reservas");
    
    String dniCliente = (String) request.getAttribute("dniCliente");
    String matriculaVehiculo = (String) request.getAttribute("matriculaVehiculo");
    String estado = (String) request.getAttribute("estado");
    String fechaDesde = (String) request.getAttribute("fechaDesde");
    String fechaHasta = (String) request.getAttribute("fechaHasta");
    
    if (dniCliente == null) dniCliente = "";
    if (matriculaVehiculo == null) matriculaVehiculo = "";
    if (estado == null) estado = "";
    if (fechaDesde == null) fechaDesde = "";
    if (fechaHasta == null) fechaHasta = "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Gestion de Reservas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f1f5f9; min-height: 100vh; }
        .sidebar { height: 100vh; width: 260px; position: fixed; top: 0; left: 0; background-color: #1e293b; padding-top: 20px; color: #94a3b8; z-index: 1000; }
        .sidebar-brand { padding: 0 20px 20px; border-bottom: 1px solid #334155; color: white; font-size: 1.4rem; font-weight: bold; display: flex; align-items: center; }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 20px; }
        .sidebar-menu li a { display: block; padding: 12px 25px; color: #94a3b8; text-decoration: none; border-left: 4px solid transparent; }
        .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #334155; color: white; border-left-color: var(--primary-color); }
        .sidebar-menu li a i { width: 25px; text-align: center; margin-right: 10px; }
        .main-content { margin-left: 260px; padding: 30px; }
        .card-filter { background: white; border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); margin-bottom: 25px; }
        .card-table { border: none; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); overflow: hidden; background: white; }
        .table thead th { background-color: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; border-bottom: 2px solid #e2e8f0; padding: 15px; }
        .table tbody td { vertical-align: middle; padding: 15px; font-size: 0.95rem; border-bottom: 1px solid #f1f5f9; }
        .badge-reserva { padding: 6px 10px; border-radius: 6px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; }
        .status-activa { background-color: #dcfce7; color: #166534; }
        .status-finalizada { background-color: #e0e7ff; color: #3730a3; }
        .status-cancelada { background-color: #fee2e2; color: #991b1b; }
        .client-avatar { width: 35px; height: 35px; background-color: #f1f5f9; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #64748b; font-weight: bold; font-size: 0.8rem; margin-right: 10px; }
        .btn-action-dropdown { background: transparent; border: none; color: #94a3b8; padding: 5px; }
        .btn-action-dropdown:hover { color: #334155; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand"><i class="fas fa-steering-wheel me-2"></i> FastWheels</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Gestion</li>
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos"><i class="fas fa-car"></i> Vehiculos</a></li>
            <li><a href="#" class="active"><i class="fas fa-calendar-check"></i> Reservas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Reportes</li>
            <li><a href="${pageContext.request.contextPath}/admin/reportes.jsp"><i class="fas fa-chart-line"></i> Estadisticas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/calendario.jsp"><i class="fas fa-calendar-alt"></i> Calendario</a></li>
            <li class="mt-5 border-top border-secondary pt-3">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Cerrar Sesion</a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark">Gestion de Reservas</h2>
                <p class="text-muted mb-0">Controla y supervisa los alquileres activos e historicos.</p>
            </div>
            <div>
                <button class="btn btn-primary" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFilters">
                    <i class="fas fa-filter me-2"></i> Filtros Avanzados
                </button>
            </div>
        </div>

        <% if (mensajeExito != null) { %>
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= mensajeExito %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (mensajeError != null) { %>
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= mensajeError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="collapse show" id="collapseFilters">
            <div class="card card-filter p-4 mb-4">
                <form action="${pageContext.request.contextPath}/admin/reservas" method="get">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">DNI Cliente</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control border-start-0" name="dniCliente" value="<%= dniCliente %>" placeholder="Buscar...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-bold text-muted">Matricula</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-car"></i></span>
                                <input type="text" class="form-control border-start-0" name="matriculaVehiculo" value="<%= matriculaVehiculo %>" placeholder="ABC-123">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label small fw-bold text-muted">Estado</label>
                            <select class="form-select" name="estado">
                                <option value="">Todos</option>
                                <option value="Activa" <%= "Activa".equals(estado) ? "selected" : "" %>>Activa</option>
                                <option value="Finalizada" <%= "Finalizada".equals(estado) ? "selected" : "" %>>Finalizada</option>
                                <option value="Cancelada" <%= "Cancelada".equals(estado) ? "selected" : "" %>>Cancelada</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label small fw-bold text-muted">Desde</label>
                            <input type="date" class="form-control" name="fechaDesde" value="<%= fechaDesde %>">
                        </div>
                        <div class="col-md-2">
                            <label class="form-label small fw-bold text-muted">Hasta</label>
                            <input type="date" class="form-control" name="fechaHasta" value="<%= fechaHasta %>">
                        </div>
                        <div class="col-12 d-flex justify-content-end gap-2 mt-3 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/admin/reservas" class="btn btn-light border text-muted">
                                <i class="fas fa-undo me-1"></i> Limpiar
                            </a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">
                                <i class="fas fa-search me-1"></i> Buscar
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="card card-table">
            <div class="table-responsive">
                <% if (reservas != null && !reservas.isEmpty()) { %>
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Cliente</th>
                            <th>Vehiculo</th>
                            <th>Periodo</th>
                            <th>Total</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Reserva r : reservas) { 
                            String statusClass = "bg-secondary";
                            if ("Activa".equals(r.getEstado())) statusClass = "status-activa";
                            if ("Finalizada".equals(r.getEstado())) statusClass = "status-finalizada";
                            if ("Cancelada".equals(r.getEstado())) statusClass = "status-cancelada";
                        %>
                        <tr>
                            <td><span class="fw-bold text-muted">#<%= r.getIdReserva() %></span></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="client-avatar"><%= r.getNombreCliente().substring(0,1) %></div>
                                    <div>
                                        <div class="fw-bold text-dark"><%= r.getNombreCliente() %></div>
                                        <small class="text-muted"><%= r.getDniCliente() %></small>
                                    </div>
                                </div>
                            </td>
                            <td><div class="fw-bold text-dark"><%= r.getMarcaVehiculo() %> <%= r.getModeloVehiculo() %></div></td>
                            <td>
                                <div class="small text-muted"><i class="far fa-calendar me-1"></i> <%= r.getFechaInicio() %></div>
                                <div class="small text-muted"><i class="fas fa-arrow-down me-1 text-light"></i> <%= r.getFechaFin() %></div>
                            </td>
                            <td class="fw-bold text-dark">$<%= r.getTotal() %></td>
                            <td><span class="badge-reserva <%= statusClass %>"><%= r.getEstado() %></span></td>
                            <td class="text-end">
                                <div class="dropdown">
                                    <button class="btn btn-action-dropdown" type="button" data-bs-toggle="dropdown"><i class="fas fa-ellipsis-v"></i></button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow border-0">
                                        <li><h6 class="dropdown-header">Acciones</h6></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reserva-detalle?id=<%= r.getIdReserva() %>"><i class="fas fa-eye me-2 text-primary"></i> Ver Detalles</a></li>
                                        <% if ("Activa".equals(r.getEstado())) { %>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <form action="${pageContext.request.contextPath}/admin/reserva-accion" method="post">
                                                    <input type="hidden" name="action" value="finalizar">
                                                    <input type="hidden" name="id" value="<%= r.getIdReserva() %>">
                                                    <button class="dropdown-item text-success" onclick="return confirm('Finalizar reserva?')">
                                                        <i class="fas fa-check-circle me-2"></i> Finalizar Reserva
                                                    </button>
                                                </form>
                                            </li>
                                            <li>
                                                <form action="${pageContext.request.contextPath}/admin/reserva-accion" method="post">
                                                    <input type="hidden" name="action" value="cancelar">
                                                    <input type="hidden" name="id" value="<%= r.getIdReserva() %>">
                                                    <button class="dropdown-item text-danger" onclick="return confirm('Cancelar reserva?')">
                                                        <i class="fas fa-times-circle me-2"></i> Cancelar Reserva
                                                    </button>
                                                </form>
                                            </li>
                                        <% } %>
                                        <% if ("Cancelada".equals(r.getEstado())) { %>
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <form action="${pageContext.request.contextPath}/admin/reserva-accion" method="post">
                                                    <input type="hidden" name="action" value="reactivar">
                                                    <input type="hidden" name="id" value="<%= r.getIdReserva() %>">
                                                    <button class="dropdown-item text-warning" onclick="return confirm('Reactivar reserva?')">
                                                        <i class="fas fa-undo me-2"></i> Reactivar
                                                    </button>
                                                </form>
                                            </li>
                                        <% } %>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% } else { %>
                    <div class="text-center py-5">
                        <div class="text-muted mb-3 opacity-50"><i class="fas fa-calendar-times fa-4x"></i></div>
                        <h4>No se encontraron reservas</h4>
                        <p class="text-muted">Intenta ajustar los filtros de busqueda.</p>
                        <a href="${pageContext.request.contextPath}/admin/reservas" class="btn btn-outline-primary btn-sm">Limpiar Filtros</a>
                    </div>
                <% } %>
            </div>
            <% if (reservas != null && !reservas.isEmpty()) { %>
            <div class="card-footer bg-white border-top-0 py-3">
                <nav>
                    <ul class="pagination justify-content-center mb-0 pagination-sm">
                        <li class="page-item disabled"><a class="page-link" href="#">Anterior</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">Siguiente</a></li>
                    </ul>
                </nav>
            </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/fw-utils.js"></script>
</body>
</html>
