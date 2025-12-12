<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.VehiculoDAO" %>
<%@ page import="capaDatos.ReservaDAO" %>
<%@ page import="java.util.*" %>
<%
    //
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    // Obtener datos
    VehiculoDAO vehiculoDAO = new VehiculoDAO();
    ReservaDAO reservaDAO = new ReservaDAO();
    
    // Estadísticas vehículos
    int totalVehiculos = 0;
    try { totalVehiculos = vehiculoDAO.listarTodosVehiculos().size(); } catch (Exception e) {}
    
    int vehiculosDisponibles = vehiculoDAO.contarVehiculosPorEstado("Disponible");
    int vehiculosMantenimiento = vehiculoDAO.contarVehiculosPorEstado("Mantenimiento");
    int vehiculosAlquilados = vehiculoDAO.contarVehiculosPorEstado("Alquilado");
    
    // Estadísticas reservas
    Map<String, Integer> reservasPorEstado = reservaDAO.contarReservasPorEstado();
    int reservasActivas = reservasPorEstado.getOrDefault("Activa", 0);
    int reservasFinalizadas = reservasPorEstado.getOrDefault("Finalizada", 0);
    int reservasCanceladas = reservasPorEstado.getOrDefault("Cancelada", 0);
    int totalReservas = reservasActivas + reservasFinalizadas + reservasCanceladas;
    
    // Gráficos
    Map<String, Double> ingresosMensuales = reservaDAO.obtenerIngresosMensuales();
    Map<String, Integer> reservasPorMes = reservaDAO.obtenerReservasPorMes();
    Map<String, Integer> metodosPago = reservaDAO.obtenerMetodosPagoPopulares();
    Map<String, Double> vehiculosRentables = reservaDAO.obtenerVehiculosMasRentables();
    List<capaEntidad.Reserva> todasReservas = reservaDAO.listarTodasReservas();
    
    // Calcular ingresos totales
    double ingresosTotales = 0;
    if(todasReservas != null) {
        for (capaEntidad.Reserva reserva : todasReservas) {
            if ("Finalizada".equals(reserva.getEstado()) || "Activa".equals(reserva.getEstado())) {
                ingresosTotales += reserva.getTotal();
            }
        }
    }
%>
<%!
    // Helper JSON (Intacto)
    private String buildJsonArray(Collection<?> items, boolean isString) {
        if (items == null || items.isEmpty()) return "[]";
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (Object item : items) {
            if (!first) sb.append(", ");
            if (isString) sb.append("\"").append(item.toString().replace("\"", "\\\"")).append("\"");
            else sb.append(item);
            first = false;
        }
        sb.append("]");
        return sb.toString();
    }
%>
<%
    // Construcción de datos JSON
    String ingresosLabels = buildJsonArray(ingresosMensuales.keySet(), true);
    String ingresosData = buildJsonArray(ingresosMensuales.values(), false);
    String reservasLabels = buildJsonArray(reservasPorMes.keySet(), true);
    String reservasData = buildJsonArray(reservasPorMes.values(), false);
    String metodosPagoLabels = buildJsonArray(metodosPago.keySet(), true);
    String metodosPagoData = buildJsonArray(metodosPago.values(), false);
    String vehiculosRentablesLabels = buildJsonArray(vehiculosRentables.keySet(), true);
    String vehiculosRentablesData = buildJsonArray(vehiculosRentables.values(), false);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Reportes BI</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        body { background-color: #f1f5f9; min-height: 100vh; }
        
        /* Sidebar Fijo */
        .sidebar {
            height: 100vh;
            width: 260px;
            position: fixed;
            top: 0;
            left: 0;
            background-color: #1e293b;
            padding-top: 20px;
            color: #94a3b8;
            transition: all 0.3s;
            z-index: 1000;
        }

        .sidebar-brand {
            padding: 0 20px 20px;
            border-bottom: 1px solid #334155;
            color: white;
            font-size: 1.4rem;
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .sidebar-menu { list-style: none; padding: 0; margin-top: 20px; }
        .sidebar-menu li a {
            display: block;
            padding: 12px 25px;
            color: #94a3b8;
            text-decoration: none;
            transition: 0.2s;
            border-left: 4px solid transparent;
        }
        .sidebar-menu li a:hover, .sidebar-menu li a.active {
            background-color: #334155;
            color: white;
            border-left-color: var(--primary-color);
        }
        .sidebar-menu li a i { width: 25px; text-align: center; margin-right: 10px; }

        .main-content { margin-left: 260px; padding: 30px; }

        /* Tarjetas de Métricas */
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            border: none;
            position: relative;
            overflow: hidden;
            height: 100%;
        }
        
        .stat-card .icon-bg {
            position: absolute;
            right: -10px;
            bottom: -10px;
            font-size: 5rem;
            opacity: 0.1;
            transform: rotate(-15deg);
        }

        .chart-container {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            margin-bottom: 25px;
            height: 380px; /* Altura fija para uniformidad */
        }

        .table-responsive {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            overflow: hidden;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-brand">
            <i class="fas fa-steering-wheel me-2"></i> FastWheels
        </div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Gestión</li>
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos"><i class="fas fa-car"></i> Vehículos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp"><i class="fas fa-calendar-check"></i> Reservas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Reportes</li>
            <li><a href="#" class="active"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li> 
                <a href="${pageContext.request.contextPath}/admin/calendario.jsp">
                        <i class="fas fa-calendar-alt"></i> Calendario
                </a>
            </li>
            <li class="mt-5 border-top border-secondary pt-3">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div>
                <h2 class="fw-bold text-dark">Reportes y Análisis</h2>
                <p class="text-muted mb-0">Visión general del rendimiento financiero y operativo.</p>
            </div>
            
            <div class="d-flex gap-2">
                <div class="dropdown">
                    <button class="btn btn-primary dropdown-toggle shadow-sm" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-download me-2"></i> Exportar Reporte
                    </button>
                    <ul class="dropdown-menu shadow border-0">
                        <li><a class="dropdown-item" href="#" onclick="exportToPDF('completo')"><i class="fas fa-file-pdf me-2 text-danger"></i> Reporte Completo</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportToPDF('financiero')"><i class="fas fa-file-invoice-dollar me-2 text-success"></i> Reporte Financiero</a></li>
                        <li><a class="dropdown-item" href="#" onclick="exportToPDF('reservas')"><i class="fas fa-list-alt me-2 text-primary"></i> Detalle Reservas</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="#" onclick="exportToExcel()"><i class="fas fa-file-excel me-2 text-success"></i> Exportar a Excel</a></li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stat-card border-start border-4 border-success">
                    <h6 class="text-muted text-uppercase fw-bold small">Ingresos Totales</h6>
                    <h2 class="fw-bold text-success mb-0">$<%= String.format("%.2f", ingresosTotales) %></h2>
                    <i class="fas fa-dollar-sign icon-bg text-success"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card border-start border-4 border-primary">
                    <h6 class="text-muted text-uppercase fw-bold small">Reservas Totales</h6>
                    <h2 class="fw-bold text-primary mb-0"><%= totalReservas %></h2>
                    <i class="fas fa-calendar-check icon-bg text-primary"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card border-start border-4 border-warning">
                    <h6 class="text-muted text-uppercase fw-bold small">Activas Ahora</h6>
                    <h2 class="fw-bold text-warning mb-0"><%= reservasActivas %></h2>
                    <i class="fas fa-clock icon-bg text-warning"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card border-start border-4 border-info">
                    <h6 class="text-muted text-uppercase fw-bold small">Flota Total</h6>
                    <h2 class="fw-bold text-info mb-0"><%= totalVehiculos %></h2>
                    <i class="fas fa-car icon-bg text-info"></i>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-lg-8">
                <div class="chart-container">
                    <h5 class="fw-bold mb-3">Evolución de Ingresos</h5>
                    <canvas id="chartIngresos"></canvas>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="chart-container">
                    <h5 class="fw-bold mb-3">Métodos de Pago</h5>
                    <canvas id="chartMetodosPago"></canvas>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-lg-4">
                <div class="chart-container">
                    <h5 class="fw-bold mb-3">Estado de Reservas</h5>
                    <canvas id="chartReservas"></canvas>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="chart-container">
                    <h5 class="fw-bold mb-3">Vehículos Más Rentables</h5>
                    <canvas id="chartVehiculosRentables"></canvas>
                </div>
            </div>
        </div>

        <h5 class="fw-bold mb-3">Últimas Transacciones</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="bg-light">
                    <tr>
                        <th class="py-3 ps-4">ID</th>
                        <th>Cliente</th>
                        <th>Vehículo</th>
                        <th>Total</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    int limit = 0;
                    if(todasReservas != null && !todasReservas.isEmpty()) {
                        // Ordenar por ID descendente para ver las últimas (simulado)
                        for(int i = todasReservas.size() - 1; i >= 0 && limit < 5; i--) {
                            capaEntidad.Reserva r = todasReservas.get(i);
                            limit++;
                            String badgeClass = "bg-secondary";
                            if("Activa".equals(r.getEstado())) badgeClass = "bg-success";
                            if("Finalizada".equals(r.getEstado())) badgeClass = "bg-primary";
                            if("Cancelada".equals(r.getEstado())) badgeClass = "bg-danger";
                    %>
                    <tr>
                        <td class="ps-4 fw-bold text-muted">#<%= r.getIdReserva() %></td>
                        <td><%= r.getNombreCliente() %></td>
                        <td><%= r.getMarcaVehiculo() %> <%= r.getModeloVehiculo() %></td>
                        <td class="fw-bold">$<%= String.format("%.2f", r.getTotal()) %></td>
                        <td><small class="text-muted"><%= r.getFechaInicio() %></small></td>
                        <td><span class="badge <%= badgeClass %> rounded-pill"><%= r.getEstado() %></span></td>
                    </tr>
                    <% 
                        } 
                    } else { 
                    %>
                    <tr><td colspan="6" class="text-center py-4 text-muted">No hay datos disponibles</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // --- Configuración de Gráficos Chart.js ---
        
        // 1. Ingresos (Barra)
        new Chart(document.getElementById('chartIngresos'), {
            type: 'bar',
            data: {
                labels: <%= ingresosLabels %>,
                datasets: [{
                    label: 'Ingresos ($)',
                    data: <%= ingresosData %>,
                    backgroundColor: '#1E3A8A',
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } }
            }
        });

        // 2. Métodos de Pago (Doughnut)
        new Chart(document.getElementById('chartMetodosPago'), {
            type: 'doughnut',
            data: {
                labels: <%= metodosPagoLabels %>,
                datasets: [{
                    data: <%= metodosPagoData %>,
                    backgroundColor: ['#10B981', '#3B82F6', '#F59E0B', '#EF4444']
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // 3. Estado Reservas (Pie)
        new Chart(document.getElementById('chartReservas'), {
            type: 'pie',
            data: {
                labels: ['Activas', 'Finalizadas', 'Canceladas'],
                datasets: [{
                    data: [<%= reservasActivas %>, <%= reservasFinalizadas %>, <%= reservasCanceladas %>],
                    backgroundColor: ['#10B981', '#3B82F6', '#EF4444']
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });

        // 4. Rentabilidad (Barra Horizontal)
        new Chart(document.getElementById('chartVehiculosRentables'), {
            type: 'bar',
            data: {
                labels: <%= vehiculosRentablesLabels %>,
                datasets: [{
                    label: 'Total Generado ($)',
                    data: <%= vehiculosRentablesData %>,
                    backgroundColor: '#8B5CF6',
                    borderRadius: 4
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Funciones de Exportación
        function exportToPDF(tipo) {
            const width = 800;
            const height = 600;
            const left = (screen.width/2)-(width/2);
            const top = (screen.height/2)-(height/2);
            window.open('${pageContext.request.contextPath}/admin/exportar-pdf?tipo=' + tipo, 
                        'Exportar PDF', 
                        'width='+width+', height='+height+', top='+top+', left='+left);
        }

        function exportToExcel() {
            alert('Funcionalidad de Excel en construcción. Utilice la exportación PDF por el momento.');
        }
    </script>
</body>
</html>