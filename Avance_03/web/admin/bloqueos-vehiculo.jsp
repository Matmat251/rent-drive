<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaEntidad.Vehiculo, capaEntidad.BloqueoCalendario, java.util.*" %>
<%
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    Vehiculo vehiculo = (Vehiculo) request.getAttribute("vehiculo");
    List<BloqueoCalendario> bloqueos = (List<BloqueoCalendario>) request.getAttribute("bloqueos");
    List<String> fechasOcupadas = (List<String>) request.getAttribute("fechasOcupadas");
    
    if (vehiculo == null) {
        response.sendRedirect(request.getContextPath() + "/admin/calendario.jsp");
        return;
    }
    
    String mensajeExito = (String) userSession.getAttribute("mensajeExito");
    String mensajeError = (String) userSession.getAttribute("mensajeError");
    if (mensajeExito != null) userSession.removeAttribute("mensajeExito");
    if (mensajeError != null) userSession.removeAttribute("mensajeError");

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    String fechaHoy = sdf.format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Bloqueos de Calendario</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Reutilizamos estilos del Admin */
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

        /* Estilos específicos de Bloqueos */
        .vehicle-summary-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            margin-bottom: 25px;
            border-left: 5px solid var(--primary-color);
        }

        .block-form-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .badge-reason {
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .reason-mantenimiento { background-color: #fef3c7; color: #92400e; }
        .reason-reparacion { background-color: #fee2e2; color: #991b1b; }
        .reason-otro { background-color: #e2e8f0; color: #475569; }

        .table-blocks thead th {
            background-color: #f1f5f9;
            color: #64748b;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            border-bottom: 2px solid #e2e8f0;
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
            <li><a href="${pageContext.request.contextPath}/admin/calendario.jsp" class="active"><i class="fas fa-calendar-alt"></i> Calendario</a></li>
            <li class="mt-5 border-top border-secondary pt-3">
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="text-danger"><i class="fas fa-sign-out-alt"></i> Cerrar Sesión</a>
            </li>
        </ul>
    </div>

    <div class="main-content">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold text-dark">Bloqueo de Fechas</h2>
                <p class="text-muted mb-0">Gestiona la disponibilidad manual del vehículo.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/calendario.jsp?vehiculo=<%= vehiculo.getIdVehiculo() %>" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i> Volver al Calendario
            </a>
        </div>

        <% if (mensajeExito != null) { %>
            <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm" role="alert">
                <i class="fas fa-check-circle me-2"></i> <%= mensajeExito %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% if (mensajeError != null) { %>
            <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i> <%= mensajeError %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <div class="vehicle-summary-card">
            <div class="d-flex align-items-center">
                <div class="bg-light p-3 rounded me-3 text-primary">
                    <i class="fas fa-car fa-2x"></i>
                </div>
                <div>
                    <h4 class="fw-bold text-dark mb-1"><%= vehiculo.getMarca() %> <%= vehiculo.getModelo() %></h4>
                    <span class="badge bg-secondary me-2"><%= vehiculo.getMatricula() %></span>
                    <span class="text-muted small"><%= vehiculo.getAnio() %> • <%= vehiculo.getTipo() %></span>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white fw-bold py-3">
                        <i class="fas fa-plus-circle me-2 text-primary"></i> Nuevo Bloqueo
                    </div>
                    <div class="card-body p-4">
                        <form method="post" action="${pageContext.request.contextPath}/admin/gestion-bloqueo">
                            <input type="hidden" name="action" value="crear">
                            <input type="hidden" name="idVehiculo" value="<%= vehiculo.getIdVehiculo() %>">
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Fecha Inicio</label>
                                <input type="date" name="fechaInicio" class="form-control" min="<%= fechaHoy %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Fecha Fin</label>
                                <input type="date" name="fechaFin" class="form-control" min="<%= fechaHoy %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Motivo</label>
                                <select name="motivo" class="form-select" required>
                                    <option value="">Selecciona...</option>
                                    <option value="Mantenimiento">Mantenimiento</option>
                                    <option value="Reparación">Reparación</option>
                                    <option value="No Disponible">No Disponible</option>
                                    <option value="Otro">Otro</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Descripción (Opcional)</label>
                                <textarea name="descripcion" class="form-control" rows="2" placeholder="Ej: Cambio de aceite"></textarea>
                            </div>
                            
                            <button type="submit" class="btn btn-primary w-100 fw-bold">
                                <i class="fas fa-lock me-2"></i> Bloquear Fechas
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card border-0 shadow-sm rounded-3">
                    <div class="card-header bg-white fw-bold py-3 d-flex justify-content-between align-items-center">
                        <span><i class="fas fa-list me-2 text-primary"></i> Bloqueos Activos</span>
                        <span class="badge bg-light text-dark"><%= bloqueos != null ? bloqueos.size() : 0 %> registros</span>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <% if (bloqueos != null && !bloqueos.isEmpty()) { %>
                            <table class="table table-blocks table-hover mb-0 align-middle">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Periodo</th>
                                        <th>Duración</th>
                                        <th>Motivo</th>
                                        <th>Nota</th>
                                        <th class="text-end pe-4">Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (BloqueoCalendario b : bloqueos) { 
                                        long dias = java.time.temporal.ChronoUnit.DAYS.between(b.getFechaInicio(), b.getFechaFin()) + 1;
                                        String badgeClass = "reason-otro";
                                        if(b.getMotivo().equalsIgnoreCase("Mantenimiento")) badgeClass = "reason-mantenimiento";
                                        if(b.getMotivo().equalsIgnoreCase("Reparación")) badgeClass = "reason-reparacion";
                                    %>
                                    <tr>
                                        <td class="ps-4">
                                            <div class="fw-bold text-dark"><%= b.getFechaInicio() %></div>
                                            <div class="small text-muted">hasta <%= b.getFechaFin() %></div>
                                        </td>
                                        <td><%= dias %> días</td>
                                        <td><span class="badge-reason <%= badgeClass %>"><%= b.getMotivo() %></span></td>
                                        <td><small class="text-muted"><%= b.getDescripcion() != null ? b.getDescripcion() : "-" %></small></td>
                                        <td class="text-end pe-4">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/gestion-bloqueo">
                                                <input type="hidden" name="action" value="eliminar">
                                                <input type="hidden" name="idBloqueo" value="<%= b.getIdBloqueo() %>">
                                                <input type="hidden" name="idVehiculo" value="<%= vehiculo.getIdVehiculo() %>">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm('¿Desbloquear estas fechas?')">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <% } else { %>
                                <div class="text-center py-5">
                                    <div class="text-muted mb-3 opacity-50"><i class="fas fa-calendar-check fa-3x"></i></div>
                                    <p class="text-muted mb-0">No hay bloqueos activos para este vehículo.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-ajustar fecha fin
        document.addEventListener('DOMContentLoaded', function() {
            const inicio = document.querySelector('input[name="fechaInicio"]');
            const fin = document.querySelector('input[name="fechaFin"]');
            
            if (inicio && fin) {
                inicio.addEventListener('change', function() {
                    fin.min = this.value;
                    if (fin.value && fin.value < this.value) fin.value = this.value;
                });
            }
        });
    </script>
</body>
</html>