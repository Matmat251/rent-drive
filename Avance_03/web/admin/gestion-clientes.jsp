<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.ClienteDAO, capaEntidad.Cliente, capaDatos.CiudadDAO, capaEntidad.Ciudad, java.util.List" %>
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

    String nombre = request.getParameter("nombre");
    String dni = request.getParameter("dni");
    String email = request.getParameter("email");
    String ciudad = request.getParameter("ciudad");
    
    if (nombre == null) nombre = "";
    if (dni == null) dni = "";
    if (email == null) email = "";
    if (ciudad == null) ciudad = "";

    ClienteDAO clienteDAO = new ClienteDAO();
    CiudadDAO ciudadDAO = new CiudadDAO();
    List<Cliente> clientes = clienteDAO.buscarClientes(nombre, dni, email);
    List<Ciudad> ciudades = ciudadDAO.obtenerCiudadesActivas();

    if (!ciudad.isEmpty()) {
        int idCiudadFiltro = Integer.parseInt(ciudad);
        clientes.removeIf(cliente -> cliente.getIdCiudad() != idCiudadFiltro);
    }
    
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Gestion de Clientes</title>
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
        .card-stat { border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); background: white; padding: 20px; display: flex; align-items: center; justify-content: space-between; }
        .card-filter { background: white; border: none; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); padding: 20px; margin-bottom: 25px; }
        .card-table { border: none; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); overflow: hidden; background: white; }
        .table thead th { background-color: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 0.8rem; border-bottom: 2px solid #e2e8f0; padding: 15px; }
        .table tbody td { vertical-align: middle; padding: 15px; font-size: 0.95rem; border-bottom: 1px solid #f1f5f9; }
        .avatar-initials { width: 40px; height: 40px; border-radius: 50%; background-color: #e0e7ff; color: var(--primary-color); display: flex; align-items: center; justify-content: center; font-weight: bold; margin-right: 15px; }
        .city-badge { background-color: #f1f5f9; color: #475569; padding: 5px 10px; border-radius: 6px; font-size: 0.8rem; }
        .btn-action-icon { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; color: #64748b; text-decoration: none; }
        .btn-action-icon:hover { background-color: #f1f5f9; color: var(--primary-color); }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-brand"><i class="fas fa-steering-wheel me-2"></i> FastWheels</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Gestion</li>
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos"><i class="fas fa-car"></i> Vehiculos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp"><i class="fas fa-calendar-check"></i> Reservas</a></li>
            <li><a href="#" class="active"><i class="fas fa-users"></i> Clientes</a></li>
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
                <h2 class="fw-bold text-dark">Directorio de Clientes</h2>
                <p class="text-muted mb-0">Administra la informacion de los usuarios registrados.</p>
            </div>
            <a href="${pageContext.request.contextPath}/auth/registro-cliente.jsp" class="btn btn-primary fw-bold shadow-sm">
                <i class="fas fa-user-plus me-2"></i> Nuevo Cliente
            </a>
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

        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="card-stat">
                    <div>
                        <h6 class="text-muted text-uppercase small fw-bold mb-1">Total Clientes</h6>
                        <h2 class="mb-0 fw-bold text-dark"><%= clientes.size() %></h2>
                    </div>
                    <div class="bg-light rounded-circle p-3 text-primary"><i class="fas fa-users fa-2x"></i></div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card-stat">
                    <div>
                        <h6 class="text-muted text-uppercase small fw-bold mb-1">Nuevos (Hoy)</h6>
                        <h2 class="mb-0 fw-bold text-success">0</h2>
                    </div>
                    <div class="bg-light rounded-circle p-3 text-success"><i class="fas fa-user-clock fa-2x"></i></div>
                </div>
            </div>
        </div>

        <div class="card-filter">
            <form method="GET" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Nombre / Apellido</label>
                    <input type="text" class="form-control" name="nombre" value="<%= nombre %>" placeholder="Buscar...">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">DNI</label>
                    <input type="text" class="form-control" name="dni" value="<%= dni %>" placeholder="Documento...">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted">Ciudad</label>
                    <select class="form-select" name="ciudad" id="ciudadSelect">
                        <option value="">Todas</option>
                        <% for (Ciudad c : ciudades) { %>
                            <option value="<%= c.getIdCiudad() %>" <%= ciudad.equals(String.valueOf(c.getIdCiudad())) ? "selected" : "" %>><%= c.getNombreCiudad() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-3 d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100 fw-bold"><i class="fas fa-search me-2"></i> Buscar</button>
                    <a href="gestion-clientes.jsp" class="btn btn-light border" title="Limpiar Filtros"><i class="fas fa-undo"></i></a>
                </div>
            </form>
        </div>

        <div class="card card-table">
            <div class="table-responsive">
                <% if (clientes != null && !clientes.isEmpty()) { %>
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Cliente</th>
                            <th>Contacto</th>
                            <th>Ubicacion</th>
                            <th>Registro</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Cliente c : clientes) { 
                             String inicial = (c.getNombre() != null && !c.getNombre().isEmpty()) ? c.getNombre().substring(0,1) : "U";
                        %>
                        <tr>
                            <td>
                                <div class="d-flex align-items-center">
                                    <div class="avatar-initials"><%= inicial %></div>
                                    <div>
                                        <div class="fw-bold text-dark"><%= c.getNombre() %> <%= c.getApellido() %></div>
                                        <div class="small text-muted"><i class="far fa-id-card me-1"></i> <%= c.getDni() %></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div class="d-flex flex-column">
                                    <small class="mb-1"><i class="far fa-envelope me-2 text-muted"></i><%= c.getEmail() != null ? c.getEmail() : "-" %></small>
                                    <small><i class="fas fa-phone me-2 text-muted"></i><%= c.getTelefono() != null ? c.getTelefono() : "-" %></small>
                                </div>
                            </td>
                            <td>
                                <span class="city-badge"><i class="fas fa-map-marker-alt me-1 text-muted"></i> <%= c.getNombreCiudad() != null ? c.getNombreCiudad() : "N/A" %></span>
                            </td>
                            <td><small class="text-muted"><%= c.getFechaRegistro() != null ? c.getFechaRegistro() : "-" %></small></td>
                            <td class="text-end">
                                <a href="${pageContext.request.contextPath}/editar-cliente?id=<%= c.getIdCliente() %>" class="btn-action-icon" title="Editar"><i class="fas fa-pen"></i></a>
                                <a href="${pageContext.request.contextPath}/admin/detalle-cliente.jsp?id=<%= c.getIdCliente() %>" class="btn-action-icon text-primary" title="Ver Historial"><i class="fas fa-eye"></i></a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="card-footer bg-white py-3"><small class="text-muted">Mostrando <%= clientes.size() %> resultados</small></div>
                <% } else { %>
                    <div class="text-center py-5">
                        <div class="text-muted mb-3 opacity-50"><i class="fas fa-users-slash fa-4x"></i></div>
                        <h4>No se encontraron clientes</h4>
                        <p class="text-muted">Intenta con otros criterios de busqueda.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('ciudadSelect').addEventListener('change', function() {
            // this.form.submit();
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/fw-utils.js"></script>
</body>
</html>
