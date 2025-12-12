<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.VehiculoDAO, capaDatos.ReservaDAO" %>
<%
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    VehiculoDAO vehiculoDAO = new VehiculoDAO();
    int totalVehiculos = 0;
    try {
        totalVehiculos = vehiculoDAO.listarTodosVehiculos().size();
    } catch (Exception e) {
        totalVehiculos = 0;
    }
    
    int vehiculosDisponibles = vehiculoDAO.contarVehiculosPorEstado("Disponible");
    int vehiculosMantenimiento = vehiculoDAO.contarVehiculosPorEstado("Mantenimiento");
    int vehiculosAlquilados = vehiculoDAO.contarVehiculosPorEstado("Alquilado");
    int porcentajeOcupacion = (totalVehiculos > 0) ? (vehiculosAlquilados * 100 / totalVehiculos) : 0;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Dashboard Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { background-color: #f1f5f9; min-height: 100vh; }
        .sidebar {
            height: 100vh; width: 260px; position: fixed; top: 0; left: 0;
            background-color: #1e293b; padding-top: 20px; color: #94a3b8;
            transition: all 0.3s; z-index: 1000;
        }
        .sidebar-brand {
            padding: 0 20px 20px; border-bottom: 1px solid #334155;
            color: white; font-size: 1.4rem; font-weight: bold;
            display: flex; align-items: center;
        }
        .sidebar-menu { list-style: none; padding: 0; margin-top: 20px; }
        .sidebar-menu li a {
            display: block; padding: 12px 25px; color: #94a3b8;
            text-decoration: none; transition: 0.2s; border-left: 4px solid transparent;
        }
        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #334155; color: white; border-left-color: var(--primary-color);
        }
        .sidebar-menu li a i { width: 25px; text-align: center; margin-right: 10px; }
        .main-content { margin-left: 260px; padding: 30px; }
        .stat-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: none; transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon-wrapper {
            width: 50px; height: 50px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center; font-size: 1.5rem;
        }
        .bg-icon-primary { background-color: #e0e7ff; color: var(--primary-color); }
        .bg-icon-success { background-color: #d1fae5; color: var(--success); }
        .bg-icon-warning { background-color: #fef3c7; color: #d97706; }
        .bg-icon-danger { background-color: #fee2e2; color: var(--danger); }
        .mobile-header { display: none; }
        @media (max-width: 992px) {
            .sidebar { transform: translateX(-100%); }
            .main-content { margin-left: 0; }
            .mobile-header { display: block; background: #1e293b; padding: 15px; color: white; }
            .sidebar.active { transform: translateX(0); }
        }
    </style>
</head>
<body>
    <div class="mobile-header d-flex justify-content-between align-items-center">
        <span class="fw-bold">FastWheels Admin</span>
        <button class="btn btn-dark btn-sm" onclick="toggleSidebar()"><i class="fas fa-bars"></i></button>
    </div>

    <div class="sidebar" id="sidebar">
        <div class="sidebar-brand"><i class="fas fa-steering-wheel me-2"></i> FastWheels</div>
        <ul class="sidebar-menu">
            <li><a href="#" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Gestion</li>
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos"><i class="fas fa-car"></i> Vehiculos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp"><i class="fas fa-calendar-check"></i> Reservas</a></li>
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
                <h2 class="fw-bold text-dark">Panel de Control</h2>
                <p class="text-muted mb-0">Resumen general del estado de la flota.</p>
            </div>
            <div class="d-none d-md-block">
                <span class="badge bg-white text-dark shadow-sm border p-2">
                    <i class="far fa-calendar-alt me-2"></i> <%= new java.util.Date() %>
                </span>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center">
                    <div class="stat-icon-wrapper bg-icon-primary me-3"><i class="fas fa-car"></i></div>
                    <div>
                        <h6 class="text-muted mb-1 text-uppercase small fw-bold">Flota Total</h6>
                        <h3 class="mb-0 fw-bold text-dark"><%= totalVehiculos %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center">
                    <div class="stat-icon-wrapper bg-icon-success me-3"><i class="fas fa-check"></i></div>
                    <div>
                        <h6 class="text-muted mb-1 text-uppercase small fw-bold">Disponibles</h6>
                        <h3 class="mb-0 fw-bold text-dark"><%= vehiculosDisponibles %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center">
                    <div class="stat-icon-wrapper bg-icon-danger me-3"><i class="fas fa-road"></i></div>
                    <div>
                        <h6 class="text-muted mb-1 text-uppercase small fw-bold">En Alquiler</h6>
                        <h3 class="mb-0 fw-bold text-dark"><%= vehiculosAlquilados %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center">
                    <div class="stat-icon-wrapper bg-icon-warning me-3"><i class="fas fa-tools"></i></div>
                    <div>
                        <h6 class="text-muted mb-1 text-uppercase small fw-bold">Mantenimiento</h6>
                        <h3 class="mb-0 fw-bold text-dark"><%= vehiculosMantenimiento %></h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white border-bottom-0 pt-4 px-4 pb-0">
                        <h5 class="fw-bold mb-0">Accesos Directos</h5>
                    </div>
                    <div class="card-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/vehiculo?action=crear" class="text-decoration-none">
                                    <div class="p-3 border rounded d-flex align-items-center">
                                        <div class="bg-primary text-white rounded-circle p-2 me-3" style="width: 40px; height: 40px; text-align: center;">
                                            <i class="fas fa-plus"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold text-dark mb-1">Registrar Vehiculo</h6>
                                            <small class="text-muted">Anadir nueva unidad a la flota</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp" class="text-decoration-none">
                                    <div class="p-3 border rounded d-flex align-items-center">
                                        <div class="bg-success text-white rounded-circle p-2 me-3" style="width: 40px; height: 40px; text-align: center;">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold text-dark mb-1">Revisar Reservas</h6>
                                            <small class="text-muted">Aprobar o rechazar solicitudes</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="text-decoration-none">
                                    <div class="p-3 border rounded d-flex align-items-center">
                                        <div class="bg-info text-white rounded-circle p-2 me-3" style="width: 40px; height: 40px; text-align: center;">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold text-dark mb-1">Directorio Clientes</h6>
                                            <small class="text-muted">Ver lista de usuarios registrados</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                            <div class="col-md-6">
                                <a href="${pageContext.request.contextPath}/admin/reportes.jsp" class="text-decoration-none">
                                    <div class="p-3 border rounded d-flex align-items-center">
                                        <div class="bg-warning text-white rounded-circle p-2 me-3" style="width: 40px; height: 40px; text-align: center;">
                                            <i class="fas fa-file-invoice-dollar"></i>
                                        </div>
                                        <div>
                                            <h6 class="fw-bold text-dark mb-1">Reporte Financiero</h6>
                                            <small class="text-muted">Ver ingresos y ganancias</small>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3 h-100">
                    <div class="card-body p-4">
                        <h5 class="fw-bold mb-4">Ocupacion de Flota</h5>
                        <div class="text-center mb-4 position-relative">
                            <div class="d-inline-block rounded-circle border border-5 border-primary p-5 mb-2">
                                <h2 class="mb-0 fw-bold"><%= porcentajeOcupacion %>%</h2>
                            </div>
                            <p class="text-muted small">Vehiculos alquilados actualmente</p>
                        </div>
                        <h6 class="fw-bold mb-3">Metricas Rapidas</h6>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>Tasa de Disponibilidad</span>
                                <span class="fw-bold text-success"><%= (100 - porcentajeOcupacion) %>%</span>
                            </div>
                            <div class="progress" style="height: 6px;">
                                <div class="progress-bar bg-success" role="progressbar" style="width: <%= (100 - porcentajeOcupacion) %>%"></div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between small mb-1">
                                <span>En Mantenimiento</span>
                                <span class="fw-bold text-warning"><%= vehiculosMantenimiento %> und.</span>
                            </div>
                            <div class="progress" style="height: 6px;">
                                <div class="progress-bar bg-warning" role="progressbar" style="width: <%= (totalVehiculos > 0 ? (vehiculosMantenimiento * 100 / totalVehiculos) : 0) %>%"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('active');
        }
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/fw-utils.js"></script>
</body>
</html>
