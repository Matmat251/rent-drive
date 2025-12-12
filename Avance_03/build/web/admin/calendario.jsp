<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.VehiculoDAO" %>
<%@ page import="capaDatos.BloqueoCalendarioDAO" %>
<%@ page import="capaEntidad.Vehiculo" %>
<%@ page import="java.util.*" %>
<%
    
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    VehiculoDAO vehiculoDAO = new VehiculoDAO();
    BloqueoCalendarioDAO bloqueoDAO = new BloqueoCalendarioDAO();
    List<Vehiculo> vehiculos = vehiculoDAO.listarTodosVehiculos();
    
    String vehiculoSeleccionado = request.getParameter("vehiculo");
    int idVehiculo = 0;
    List<String> fechasOcupadas = new ArrayList<>();
    if (vehiculoSeleccionado != null && !vehiculoSeleccionado.isEmpty()) {
        idVehiculo = Integer.parseInt(vehiculoSeleccionado);
        fechasOcupadas = bloqueoDAO.obtenerFechasOcupadas(idVehiculo);
    }
    
    Calendar cal = Calendar.getInstance();
    int añoActual = cal.get(Calendar.YEAR);
    int mesActual = cal.get(Calendar.MONTH) + 1;
    
    String mesParam = request.getParameter("mes");
    String añoParam = request.getParameter("año");
    if (mesParam != null && añoParam != null) {
        mesActual = Integer.parseInt(mesParam);
        añoActual = Integer.parseInt(añoParam);
    }
    
    cal.set(añoActual, mesActual - 1, 1);
    int primerDiaSemana = cal.get(Calendar.DAY_OF_WEEK); 
    int diasEnMes = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    
    String[] nombresMeses = {"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", 
                            "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"};
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Calendario</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        /* Estilos Calendario */
        .calendar-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 30px;
            border: none;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 15px;
        }

        .day-name {
            text-align: center;
            font-weight: 600;
            color: #64748b;
            text-transform: uppercase;
            font-size: 0.85rem;
            padding-bottom: 15px;
        }

        .day-cell {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            min-height: 120px;
            padding: 10px;
            position: relative;
            transition: all 0.2s;
        }

        .day-cell:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            border-color: #cbd5e1;
            transform: translateY(-2px);
        }

        .day-number {
            font-weight: 700;
            color: #334155;
            margin-bottom: 5px;
            display: inline-block;
            width: 28px;
            height: 28px;
            text-align: center;
            line-height: 28px;
            border-radius: 50%;
        }

        .day-today .day-number {
            background-color: var(--primary-color);
            color: white;
        }

        .event-badge {
            display: block;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 0.75rem;
            margin-top: 5px;
            font-weight: 600;
            text-align: center;
        }

        .badge-available { background-color: #dcfce7; color: #166534; }
        .badge-occupied { background-color: #fee2e2; color: #991b1b; }
        
        .empty-day { background: transparent; border: none; }

        .filter-card {
            background: #f8fafc;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            border: 1px solid #e2e8f0;
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
            <li><a href="${pageContext.request.contextPath}/admin/reportes.jsp"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
            <li><a href="#" class="active"><i class="fas fa-calendar-alt"></i> Calendario</a></li>
            <li class="mt-5 border-top border-secondary pt-3">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark">Calendario de Disponibilidad</h2>
                <p class="text-muted mb-0">Consulta la ocupación de tu flota por mes.</p>
            </div>
        </div>

        <div class="calendar-card">
            
            <div class="filter-card">
                <form method="get" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label small fw-bold text-muted">Vehículo</label>
                        <select name="vehiculo" class="form-select" onchange="this.form.submit()">
                            <option value="">-- Seleccione un vehículo --</option>
                            <% for (Vehiculo v : vehiculos) { %>
                                <option value="<%= v.getIdVehiculo() %>" <%= (idVehiculo == v.getIdVehiculo()) ? "selected" : "" %>>
                                    <%= v.getMarca() %> <%= v.getModelo() %> - <%= v.getMatricula() %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted">Mes</label>
                        <select name="mes" class="form-select">
                            <% for (int i = 1; i <= 12; i++) { %>
                                <option value="<%= i %>" <%= (i == mesActual) ? "selected" : "" %>><%= nombresMeses[i-1] %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold text-muted">Año</label>
                        <select name="año" class="form-select">
                            <% for (int i = 2024; i <= 2030; i++) { %>
                                <option value="<%= i %>" <%= (i == añoActual) ? "selected" : "" %>><%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100 fw-bold">Actualizar</button>
                    </div>
                </form>
            </div>

            <% if (idVehiculo > 0) { %>
                
                <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <%
                        int mesAnt = (mesActual == 1) ? 12 : mesActual - 1;
                        int anoAnt = (mesActual == 1) ? añoActual - 1 : añoActual;
                        int mesSig = (mesActual == 12) ? 1 : mesActual + 1;
                        int anoSig = (mesActual == 12) ? añoActual + 1 : añoActual;
                    %>
                    <a href="?vehiculo=<%= idVehiculo %>&mes=<%= mesAnt %>&año=<%= anoAnt %>" class="btn btn-outline-secondary btn-sm">
                        <i class="fas fa-chevron-left me-1"></i> Anterior
                    </a>
                    
                    <h3 class="fw-bold text-primary mb-0"><%= nombresMeses[mesActual-1] %> <%= añoActual %></h3>
                    
                    <a href="?vehiculo=<%= idVehiculo %>&mes=<%= mesSig %>&año=<%= anoSig %>" class="btn btn-outline-secondary btn-sm">
                        Siguiente <i class="fas fa-chevron-right ms-1"></i>
                    </a>
                </div>

                <div class="calendar-grid">
                    <div class="day-name">Domingo</div>
                    <div class="day-name">Lunes</div>
                    <div class="day-name">Martes</div>
                    <div class="day-name">Miércoles</div>
                    <div class="day-name">Jueves</div>
                    <div class="day-name">Viernes</div>
                    <div class="day-name">Sábado</div>

                    <% for (int i = 1; i < primerDiaSemana; i++) { %>
                        <div class="day-cell empty-day"></div>
                    <% } %>

                    <% 
                        Calendar hoy = Calendar.getInstance();
                        for (int dia = 1; dia <= diasEnMes; dia++) {
                            String fechaStr = String.format("%04d-%02d-%02d", añoActual, mesActual, dia);
                            boolean esHoy = (hoy.get(Calendar.YEAR) == añoActual && 
                                            hoy.get(Calendar.MONTH) + 1 == mesActual && 
                                            hoy.get(Calendar.DAY_OF_MONTH) == dia);
                            boolean ocupado = fechasOcupadas.contains(fechaStr);
                    %>
                        <div class="day-cell <%= esHoy ? "day-today" : "" %>">
                            <span class="day-number"><%= dia %></span>
                            
                            <% if (ocupado) { %>
                                <span class="event-badge badge-occupied">
                                    <i class="fas fa-lock me-1"></i> Ocupado
                                </span>
                            <% } else { %>
                                <span class="event-badge badge-available">
                                    <i class="fas fa-check me-1"></i> Libre
                                </span>
                            <% } %>
                        </div>
                    <% } %>
                </div>

                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/admin/gestion-bloqueo?action=ver&idVehiculo=<%= idVehiculo %>" class="btn btn-secondary">
                        <i class="fas fa-cog me-2"></i> Gestionar Bloqueos Manuales
                    </a>
                </div>

            <% } else { %>
                <div class="text-center py-5">
                    <div class="text-muted mb-3 opacity-50"><i class="fas fa-calendar-alt fa-4x"></i></div>
                    <h4>Selecciona un vehículo</h4>
                    <p class="text-muted">Elige un auto de la lista para ver su disponibilidad mensual.</p>
                </div>
            <% } %>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>