<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="capaEntidad.Vehiculo" %>
<%
    // --- LÓGICA DE BACKEND ---
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    // Obtener mensajes
    String mensajeExito = (String) userSession.getAttribute("mensajeExito");
    String mensajeError = (String) userSession.getAttribute("mensajeError");
    if (mensajeExito != null) userSession.removeAttribute("mensajeExito");
    if (mensajeError != null) userSession.removeAttribute("mensajeError");
    
    List<Vehiculo> vehiculos = (List<Vehiculo>) request.getAttribute("vehiculos");
    
    // Recuperar el término de búsqueda para mantenerlo en el input
    String busqueda = request.getParameter("busqueda");
    if (busqueda == null) busqueda = "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Gestión de Flota</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Reutilizamos estilos del Dashboard */
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

        /* Estilos de Tabla Avanzada */
        .card-table {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
            overflow: hidden;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #64748b;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
            border-bottom: 2px solid #e2e8f0;
            padding: 15px;
        }

        .table tbody td {
            vertical-align: middle;
            padding: 15px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        .table-hover tbody tr:hover { background-color: #f8fafc; }

        .badge-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-disponible { background-color: #dcfce7; color: #166534; }
        .status-alquilado { background-color: #fee2e2; color: #991b1b; }
        .status-mantenimiento { background-color: #fef3c7; color: #92400e; }

        .btn-icon {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.2s;
            border: none;
        }
        
        .btn-icon:hover { transform: translateY(-2px); }
        .btn-edit { background-color: #e0f2fe; color: #0284c7; }
        .btn-delete { background-color: #fee2e2; color: #ef4444; }
        .btn-tool { background-color: #f3e8ff; color: #9333ea; }
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
            <li><a href="#" class="active"><i class="fas fa-car"></i> Vehículos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp"><i class="fas fa-calendar-check"></i> Reservas</a></li>
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
                <h2 class="fw-bold text-dark">Gestión de Vehículos</h2>
                <p class="text-muted mb-0">Administra la flota: precios, estados y disponibilidad.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/vehiculo?action=crear" class="btn btn-primary fw-bold shadow-sm">
                <i class="fas fa-plus me-2"></i> Nuevo Vehículo
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

        <div class="card card-table bg-white">
            
            <div class="p-3 border-bottom d-flex align-items-center bg-light">
                <form action="${pageContext.request.contextPath}/admin/vehiculos" method="GET" class="d-flex w-100 align-items-center">
                    <div class="input-group shadow-sm" style="max-width: 400px;">
                        <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                        <input type="text" name="busqueda" class="form-control border-start-0 border-end-0 ps-0" 
                               placeholder="Buscar por placa, marca o modelo..." 
                               value="<%= busqueda %>">
                        <button class="btn btn-primary px-4" type="submit">Buscar</button>
                    </div>
                    
                    <% if (!busqueda.isEmpty()) { %>
                        <a href="${pageContext.request.contextPath}/admin/vehiculos" class="btn btn-link text-muted ms-2 text-decoration-none small">
                            <i class="fas fa-times-circle"></i> Limpiar filtro
                        </a>
                    <% } %>

                    <div class="ms-auto text-muted small">
                        Mostrando <strong><%= (vehiculos != null) ? vehiculos.size() : 0 %></strong> registros
                    </div>
                </form>
            </div>

            <div class="table-responsive">
                <% if (vehiculos != null && !vehiculos.isEmpty()) { %>
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Vehículo</th>
                            <th>Matrícula</th>
                            <th>Tipo</th>
                            <th>Precio / Día</th>
                            <th class="text-center">Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Vehiculo v : vehiculos) { 
                            String estadoClass = "status-disponible";
                            String estadoIcon = "fa-check";
                            if ("Alquilado".equals(v.getEstado())) { estadoClass = "status-alquilado"; estadoIcon = "fa-road"; }
                            if ("Mantenimiento".equals(v.getEstado())) { estadoClass = "status-mantenimiento"; estadoIcon = "fa-tools"; }
                        %>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded p-2 me-3 text-secondary">
                                        <i class="fas fa-car fa-lg"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark"><%= v.getMarca() %> <%= v.getModelo() %></div>
                                        <small class="text-muted"><%= v.getAnio() %></small>
                                    </div>
                                </div>
                            </td>
                            <td><code class="bg-light px-2 py-1 rounded border"><%= v.getMatricula() %></code></td>
                            <td><span class="text-muted small text-uppercase"><%= v.getTipo() %></span></td>
                            <td class="fw-bold text-dark">$<%= v.getPrecioDiario() %></td>
                            <td class="text-center">
                                <span class="badge-status <%= estadoClass %>">
                                    <i class="fas <%= estadoIcon %> me-1"></i> <%= v.getEstado() %>
                                </span>
                            </td>
                            <td class="text-end">
                                <a href="${pageContext.request.contextPath}/admin/vehiculo?action=editar&id=<%= v.getIdVehiculo() %>" 
                                   class="btn-icon btn-edit me-1" title="Editar">
                                    <i class="fas fa-pencil-alt"></i>
                                </a>

                                <form action="${pageContext.request.contextPath}/admin/vehiculo-accion" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="cambiar-estado">
                                    <input type="hidden" name="id" value="<%= v.getIdVehiculo() %>">
                                    <input type="hidden" name="estado" value="<%= "Disponible".equals(v.getEstado()) ? "Mantenimiento" : "Disponible" %>">
                                    <button type="submit" class="btn-icon btn-tool me-1" title="<%= "Disponible".equals(v.getEstado()) ? "Enviar a Mantenimiento" : "Habilitar" %>">
                                        <i class="fas fa-sync-alt"></i>
                                    </button>
                                </form>

                                <form action="${pageContext.request.contextPath}/admin/vehiculo-accion" method="post" class="d-inline">
                                    <input type="hidden" name="action" value="eliminar">
                                    <input type="hidden" name="id" value="<%= v.getIdVehiculo() %>">
                                    <button type="submit" class="btn-icon btn-delete" 
                                            onclick="return confirm('¿Eliminar <%= v.getMarca() %> <%= v.getModelo() %>? Esta acción no se puede deshacer.')"
                                            title="Eliminar">
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
                        <div class="text-muted mb-3 opacity-50"><i class="fas fa-search fa-4x"></i></div>
                        <h4>No se encontraron vehículos</h4>
                        <p class="text-muted">Intenta con otra búsqueda o agrega un nuevo vehículo.</p>
                        <% if (!busqueda.isEmpty()) { %>
                            <a href="${pageContext.request.contextPath}/admin/vehiculos" class="btn btn-outline-primary mt-2">Ver todos</a>
                        <% } else { %>
                            <a href="${pageContext.request.contextPath}/admin/vehiculo?action=crear" class="btn btn-primary mt-2">Agregar Vehículo</a>
                        <% } %>
                    </div>
                <% } %>
            </div>
            
            <% if (vehiculos != null && !vehiculos.isEmpty()) { %>
            <div class="card-footer bg-white border-top-0 py-3">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mb-0">
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
</body>
</html>