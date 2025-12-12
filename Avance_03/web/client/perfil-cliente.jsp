<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaEntidad.Cliente, capaEntidad.Ciudad, capaDatos.CiudadDAO, java.util.List" %>
<%
    // --- LÓGICA DE BACKEND ---
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Cliente cliente = (userSession != null) ? (Cliente) userSession.getAttribute("cliente") : null;
    
    // Verificación de sesión
    if (cliente == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
        return;
    }
    
    // Obtener mensajes
    String mensajeExito = (String) userSession.getAttribute("mensajeExito");
    String mensajeError = (String) userSession.getAttribute("error");
    if (mensajeExito != null) userSession.removeAttribute("mensajeExito");
    if (mensajeError != null) userSession.removeAttribute("error");
    
    // Datos para mostrar
    Cliente clienteActual = (Cliente) request.getAttribute("cliente");
    if (clienteActual == null) {
        clienteActual = cliente;
    }

    //  BUSCAR NOMBRE DE CIUDAD SI NO EXISTE
    String nombreCiudadMostrar = clienteActual.getNombreCiudad();
    
    if ((nombreCiudadMostrar == null || nombreCiudadMostrar.isEmpty()) && clienteActual.getIdCiudad() > 0) {
        try {
            CiudadDAO ciudadDAO = new CiudadDAO();
            Ciudad c = ciudadDAO.obtenerCiudadPorId(clienteActual.getIdCiudad());
            if (c != null) {
                nombreCiudadMostrar = c.getNombreCiudad();
            }
        } catch (Exception e) {
            // Si falla, se queda como null
        }
    }
    
    if (nombreCiudadMostrar == null) nombreCiudadMostrar = "Sin asignar";
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Mi Perfil</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Estilos específicos para el perfil */
        .profile-header-bg {
            background: linear-gradient(135deg, var(--primary-color) 0%, #1e40af 100%);
            padding-bottom: 100px;
            margin-bottom: -60px;
        }

        .avatar-circle {
            width: 120px;
            height: 120px;
            background-color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 700;
            color: var(--primary-color);
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            margin: 0 auto 20px;
            border: 4px solid white;
        }

        .info-group-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: #64748B;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .info-group-value {
            font-size: 1rem;
            color: #1F2937;
            font-weight: 500;
            padding-bottom: 10px;
            border-bottom: 1px solid #f1f5f9;
        }

        .section-title {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 20px;
            font-size: 1.1rem;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/index.jsp">
                <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="Logo" width="40" height="40" class="rounded me-2">
                <span>FastWheels</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/vehiculos">Catálogo</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/mis-reservas.jsp">Mis Reservas</a></li>
                    <li class="nav-item"><a class="nav-link active" href="#">Mi Perfil</a></li>
                    <li class="nav-item ms-lg-3">
                        <a href="${pageContext.request.contextPath}/logout-cliente" class="btn btn-logout text-decoration-none">
                            <i class="fas fa-sign-out-alt me-1"></i> Salir
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="profile-header-bg text-center text-white pt-5">
        <div class="container">
            <h1 class="fw-bold">Mi Cuenta</h1>
            <p class="opacity-75">Gestiona tu información personal y preferencias.</p>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <% if (mensajeExito != null) { %>
                    <div class="alert alert-success d-flex align-items-center shadow-sm mb-4" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        <div><%= mensajeExito %></div>
                    </div>
                <% } %>
                <% if (mensajeError != null) { %>
                    <div class="alert alert-danger d-flex align-items-center shadow-sm mb-4" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <div><%= mensajeError %></div>
                    </div>
                <% } %>

                <div class="card border-0 shadow-lg rounded-4 overflow-hidden bg-white">
                    <div class="card-body p-5">
                        
                        <div class="text-center mb-5">
                            <% 
                                String inicialNombre = clienteActual.getNombre() != null && !clienteActual.getNombre().isEmpty() ? 
                                    String.valueOf(clienteActual.getNombre().charAt(0)) : "U";
                                String inicialApellido = clienteActual.getApellido() != null && !clienteActual.getApellido().isEmpty() ? 
                                    String.valueOf(clienteActual.getApellido().charAt(0)) : "";
                            %>
                            <div class="avatar-circle">
                                <%= inicialNombre %><%= inicialApellido %>
                            </div>
                            <h2 class="fw-bold text-dark"><%= clienteActual.getNombre() %> <%= clienteActual.getApellido() %></h2>
                            <span class="badge bg-light text-muted border px-3 py-2 mt-2">
                                <i class="fas fa-user-tag me-1"></i> Cliente Registrado
                            </span>
                        </div>

                        <div class="row g-4 mb-4">
                            <div class="col-12">
                                <h5 class="section-title"><i class="far fa-id-card me-2"></i>Información Personal</h5>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="info-group-label">Usuario</div>
                                <div class="info-group-value">
                                    <%= clienteActual.getUsuario() != null ? clienteActual.getUsuario() : "No definido" %>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="info-group-label">DNI / Identificación</div>
                                <div class="info-group-value">
                                    <%= clienteActual.getDni() %>
                                </div>
                            </div>

                            <div class="col-12 mt-4">
                                <h5 class="section-title"><i class="far fa-address-book me-2"></i>Datos de Contacto</h5>
                            </div>

                            <div class="col-md-6">
                                <div class="info-group-label">Correo Electrónico</div>
                                <div class="info-group-value text-break">
                                    <i class="far fa-envelope me-2 text-muted"></i>
                                    <%= clienteActual.getEmail() != null ? clienteActual.getEmail() : "-" %>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-group-label">Teléfono</div>
                                <div class="info-group-value">
                                    <i class="fas fa-phone-alt me-2 text-muted"></i>
                                    <%= clienteActual.getTelefono() != null ? clienteActual.getTelefono() : "-" %>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-group-label">Ciudad</div>
                                <div class="info-group-value">
                                    <i class="fas fa-map-marker-alt me-2 text-muted"></i>
                                    <%= nombreCiudadMostrar %>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="info-group-label">Dirección</div>
                                <div class="info-group-value">
                                    <i class="fas fa-home me-2 text-muted"></i>
                                    <%= clienteActual.getDireccion() != null ? clienteActual.getDireccion() : "-" %>
                                </div>
                            </div>
                            
                            <div class="col-12 mt-3">
                                <div class="p-3 bg-light rounded border text-center text-muted small">
                                    <i class="fas fa-calendar-check me-2"></i> 
                                    Miembro desde: <strong><%= clienteActual.getFechaRegistro() != null ? clienteActual.getFechaRegistro() : "N/A" %></strong>
                                </div>
                            </div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-center mt-5">
                            <a href="${pageContext.request.contextPath}/editar-perfil" class="btn btn-primary px-4 py-2 fw-bold">
                                <i class="fas fa-user-edit me-2"></i> Editar Mis Datos
                            </a>
                            <a href="${pageContext.request.contextPath}/vehiculos" class="btn btn-outline-secondary px-4 py-2">
                                <i class="fas fa-arrow-left me-2"></i> Volver al Catálogo
                            </a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer-main">
        <div class="container">
            <p class="mb-0">&copy; 2025 FastWheels Rental System.</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>