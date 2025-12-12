<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaEntidad.Cliente, capaEntidad.Ciudad, java.util.List" %>
<%
    // 
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

    Cliente cliente = (Cliente) request.getAttribute("cliente");
    List<Ciudad> ciudades = (List<Ciudad>) request.getAttribute("ciudades");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Editar Cliente</title>
    
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

        /* Estilos del Formulario */
        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: none;
            max-width: 900px;
            margin: 0 auto;
        }

        .form-header {
            background-color: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            padding: 20px 30px;
            border-radius: 12px 12px 0 0;
        }
        
        .form-body { padding: 30px; }

        .input-group-text {
            background-color: #f1f5f9;
            color: #64748b;
            border-color: #cbd5e1;
        }

        .form-label { font-weight: 600; font-size: 0.9rem; color: #334155; }
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
        
        <div class="form-card">
            <div class="form-header d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="mb-0 fw-bold text-dark">
                        <i class="fas fa-user-edit me-2"></i>Editar Cliente
                    </h4>
                    <small class="text-muted">Modificar información del usuario registrado</small>
                </div>
                <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-arrow-left me-1"></i> Volver
                </a>
            </div>

            <div class="form-body">
                
                <% if (mensajeError != null || error != null) { %>
                    <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <div><%= mensajeError != null ? mensajeError : error %></div>
                    </div>
                <% } %>
                <% if (mensajeExito != null || success != null) { %>
                    <div class="alert alert-success d-flex align-items-center mb-4" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <div><%= mensajeExito != null ? mensajeExito : success %></div>
                    </div>
                <% } %>

                <% if (cliente != null) { %>
                <form action="${pageContext.request.contextPath}/editar-cliente" method="POST" class="needs-validation" novalidate>
                    <input type="hidden" name="idCliente" value="<%= cliente.getIdCliente() %>">
                    
                    <div class="row g-3">
                        
                        <div class="col-12 mt-2">
                            <h6 class="text-primary fw-bold text-uppercase small border-bottom pb-2 mb-3">Información Personal</h6>
                        </div>

                        <div class="col-md-6">
                            <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="nombre" name="nombre" 
                                       value="<%= cliente.getNombre() != null ? cliente.getNombre() : "" %>" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <label for="apellido" class="form-label">Apellido <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" class="form-control" id="apellido" name="apellido" 
                                       value="<%= cliente.getApellido() != null ? cliente.getApellido() : "" %>" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="dni" class="form-label">DNI <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                <input type="text" class="form-control" id="dni" name="dni" 
                                       value="<%= cliente.getDni() != null ? cliente.getDni() : "" %>" 
                                       required pattern="[0-9]{8}" maxlength="8">
                            </div>
                        </div>

                        <div class="col-12 mt-4">
                            <h6 class="text-primary fw-bold text-uppercase small border-bottom pb-2 mb-3">Contacto y Ubicación</h6>
                        </div>

                        <div class="col-md-6">
                            <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="<%= cliente.getEmail() != null ? cliente.getEmail() : "" %>" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="telefono" class="form-label">Teléfono <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="tel" class="form-control" id="telefono" name="telefono" 
                                       value="<%= cliente.getTelefono() != null ? cliente.getTelefono() : "" %>" 
                                       required pattern="[0-9]{9,}">
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label for="idCiudad" class="form-label">Ciudad <span class="text-danger">*</span></label>
                            <select class="form-select" id="idCiudad" name="idCiudad" required>
                                <option value="">Seleccione...</option>
                                <% if (ciudades != null) { 
                                    for (Ciudad c : ciudades) { %>
                                    <option value="<%= c.getIdCiudad() %>" <%= (cliente.getIdCiudad() == c.getIdCiudad()) ? "selected" : "" %>>
                                        <%= c.getNombreCiudad() %>
                                    </option>
                                <% } } %>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="direccion" class="form-label">Dirección</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-home"></i></span>
                                <input type="text" class="form-control" id="direccion" name="direccion" 
                                       value="<%= cliente.getDireccion() != null ? cliente.getDireccion() : "" %>">
                            </div>
                        </div>

                        <div class="col-12 mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="btn btn-light border">Cancelar</a>
                            <button type="submit" class="btn btn-primary px-4 fw-bold">
                                <i class="fas fa-save me-2"></i> Guardar Cambios
                            </button>
                        </div>
                    </div>
                </form>
                <% } else { %>
                    <div class="text-center py-5">
                        <div class="text-muted mb-3"><i class="fas fa-user-slash fa-4x"></i></div>
                        <h4>Cliente no encontrado</h4>
                        <p class="text-muted">No se pudo cargar la información solicitada.</p>
                        <a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp" class="btn btn-primary">Volver al Listado</a>
                    </div>
                <% } %>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Validación de Bootstrap
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms)
                .forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault()
                            event.stopPropagation()
                        }
                        form.classList.add('was-validated')
                    }, false)
                })
        })()
    </script>
</body>
</html>