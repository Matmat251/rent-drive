<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaDatos.ClienteDAO, capaEntidad.Cliente, capaDatos.CiudadDAO, capaEntidad.Ciudad" %>
<%@ page import="capaDatos.ReservaDAO, capaEntidad.Reserva, java.util.List" %>
<%
    // 1. Verificar sesión de admin
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    Cliente cliente = null;
    Ciudad ciudad = null;
    
    // Variables para estadísticas
    int totalReservas = 0;
    int reservasCanceladas = 0;
    
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int idCliente = Integer.parseInt(idParam);
            ClienteDAO clienteDAO = new ClienteDAO();
            CiudadDAO ciudadDAO = new CiudadDAO();
            ReservaDAO reservaDAO = new ReservaDAO();
            
            // Obtener datos del cliente
            cliente = clienteDAO.obtenerClienteCompleto(idCliente);
            
            if (cliente != null) {
                // Obtener ciudad
                if (cliente.getIdCiudad() > 0) {
                    ciudad = ciudadDAO.obtenerCiudadPorId(cliente.getIdCiudad());
                }
                
                // ✅ NUEVO: Obtener historial de reservas para calcular estadísticas
                List<Reserva> historial = reservaDAO.obtenerReservasPorCliente(cliente.getDni());
                if (historial != null) {
                    totalReservas = historial.size();
                    for (Reserva r : historial) {
                        if ("Cancelada".equalsIgnoreCase(r.getEstado())) {
                            reservasCanceladas++;
                        }
                    }
                }
            }
        } catch (NumberFormatException e) { }
    }
    
    if (cliente == null) {
        response.sendRedirect("gestion-clientes.jsp?error=Cliente no encontrado");
        return;
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Detalle Cliente</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Layout Admin */
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

        /* Estilos Perfil Admin */
        .profile-card-side {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            text-align: center;
            padding: 30px 20px;
            height: 100%;
        }

        .profile-avatar-lg {
            width: 100px;
            height: 100px;
            background-color: #e0e7ff;
            color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
            margin: 0 auto 20px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            padding: 25px;
            height: 100%;
        }

        .info-label {
            color: #64748b;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            margin-bottom: 5px;
        }

        .info-value {
            color: #1e293b;
            font-size: 1rem;
            font-weight: 500;
            padding-bottom: 12px;
            border-bottom: 1px solid #f1f5f9;
            margin-bottom: 15px;
        }
        
        .info-value:last-child { border-bottom: none; margin-bottom: 0; }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            color: var(--primary-color);
            font-weight: 700;
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
            <li><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="active"><i class="fas fa-users"></i> Clientes</a></li>
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
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="text-decoration-none">Clientes</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Detalle</li>
                    </ol>
                </nav>
                <h2 class="fw-bold text-dark">Perfil de Cliente</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i> Volver a la lista
            </a>
        </div>

        <div class="row g-4">
            
            <div class="col-lg-4">
                <div class="profile-card-side">
                    <% 
                        String inicial = (cliente.getNombre() != null && !cliente.getNombre().isEmpty()) ? cliente.getNombre().substring(0,1) : "U";
                    %>
                    <div class="profile-avatar-lg">
                        <%= inicial %>
                    </div>
                    
                    <h4 class="fw-bold text-dark mb-1"><%= cliente.getNombre() %> <%= cliente.getApellido() %></h4>
                    <p class="text-muted mb-3">@<%= cliente.getUsuario() %></p>
                    
                    <span class="badge bg-success bg-opacity-10 text-success border border-success px-3 py-2 rounded-pill">
                        <i class="fas fa-check-circle me-1"></i> Cuenta Activa
                    </span>

                    <div class="mt-4 pt-4 border-top">
                        <div class="row text-center">
                            <div class="col-6 border-end">
                                <h5 class="fw-bold mb-0 text-dark"><%= totalReservas %></h5>
                                <small class="text-muted">Reservas</small>
                            </div>
                            <div class="col-6">
                                <h5 class="fw-bold mb-0 text-dark"><%= reservasCanceladas %></h5>
                                <small class="text-muted">Canceladas</small>
                            </div>
                        </div>
                    </div>

                    <div class="d-grid mt-4">
                        <a href="${pageContext.request.contextPath}/editar-cliente?id=<%= cliente.getIdCliente() %>" class="btn btn-primary">
                            <i class="fas fa-edit me-2"></i> Editar Datos
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                
                <div class="info-card mb-4">
                    <div class="section-header">
                        <i class="far fa-id-card me-2 fa-lg"></i> Información Personal
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label">Nombre Completo</div>
                            <div class="info-value"><%= cliente.getNombre() %> <%= cliente.getApellido() %></div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">DNI / Identificación</div>
                            <div class="info-value"><%= cliente.getDni() %></div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">Usuario de Sistema</div>
                            <div class="info-value"><%= cliente.getUsuario() %></div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">Fecha de Registro</div>
                            <div class="info-value"><i class="far fa-calendar-alt me-2 text-muted"></i> <%= cliente.getFechaRegistro() != null ? cliente.getFechaRegistro() : "N/A" %></div>
                        </div>
                    </div>
                </div>

                <div class="info-card">
                    <div class="section-header">
                        <i class="fas fa-map-marker-alt me-2 fa-lg"></i> Contacto y Ubicación
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-label">Correo Electrónico</div>
                            <div class="info-value">
                                <a href="mailto:<%= cliente.getEmail() %>" class="text-decoration-none">
                                    <%= cliente.getEmail() %>
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">Teléfono</div>
                            <div class="info-value">
                                <%= cliente.getTelefono() != null ? cliente.getTelefono() : "No registrado" %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">Ciudad</div>
                            <div class="info-value">
                                <%= cliente.getNombreCiudad() != null ? cliente.getNombreCiudad() : "No registrada" %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-label">Dirección</div>
                            <div class="info-value">
                                <%= cliente.getDireccion() != null ? cliente.getDireccion() : "No registrada" %>
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