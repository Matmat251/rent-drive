<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaEntidad.Cliente, capaEntidad.Ciudad, java.util.List" %>
<%
   
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Cliente cliente = (userSession != null) ? (Cliente) userSession.getAttribute("cliente") : null;
    
    // Verificación de sesión
    if (cliente == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login-cliente.jsp");
        return;
    }
    
    // Recuperar datos
    Cliente clienteActual = (Cliente) request.getAttribute("cliente");
    List<Ciudad> ciudades = (List<Ciudad>) request.getAttribute("ciudades");
    
    if (clienteActual == null) {
        clienteActual = cliente;
    }
    
    String error = (String) userSession.getAttribute("error");
    if (error != null) userSession.removeAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Editar Perfil</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Estilos específicos para edición de perfil */
        .profile-header-bg {
            background: linear-gradient(135deg, var(--primary-color) 0%, #1e40af 100%);
            padding-bottom: 80px;
            margin-bottom: -50px;
        }

        .edit-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: none;
            overflow: hidden;
        }

        .form-section-title {
            color: var(--primary-color);
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #f1f5f9;
        }

        .readonly-input {
            background-color: #f8fafc;
            color: #64748b;
            cursor: not-allowed;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="#">
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
                        <a href="${pageContext.request.contextPath}/LogoutClientServlet" class="btn btn-logout text-decoration-none">
                            <i class="fas fa-sign-out-alt me-1"></i> Salir
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="profile-header-bg text-center text-white pt-5">
        <div class="container">
            <h2 class="fw-bold">Actualizar Información</h2>
            <p class="opacity-75">Mantén tus datos al día para futuras reservas.</p>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                
                <% if (error != null) { %>
                    <div class="alert alert-danger d-flex align-items-center mb-4 shadow-sm" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <div><%= error %></div>
                    </div>
                <% } %>

                <div class="card edit-card">
                    <div class="card-body p-5">
                        
                        <form action="${pageContext.request.contextPath}/actualizar-perfil" method="POST" class="needs-validation" novalidate>
                            
                            <h5 class="form-section-title"><i class="far fa-user me-2"></i>Datos Personales</h5>
                            
                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="nombre" class="form-label fw-bold small text-muted">Nombre</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="nombre" name="nombre" 
                                               value="<%= clienteActual.getNombre() != null ? clienteActual.getNombre() : "" %>" 
                                               required placeholder="Tu nombre">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="apellido" class="form-label fw-bold small text-muted">Apellido</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-user"></i></span>
                                        <input type="text" class="form-control" id="apellido" name="apellido" 
                                               value="<%= clienteActual.getApellido() != null ? clienteActual.getApellido() : "" %>" 
                                               required placeholder="Tu apellido">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="dni" class="form-label fw-bold small text-muted">DNI (No editable)</label>
                                    <div class="input-group">
                                        <span class="input-group-text readonly-input"><i class="fas fa-id-card"></i></span>
                                        <input type="text" class="form-control readonly-input" id="dni" name="dni" 
                                               value="<%= clienteActual.getDni() != null ? clienteActual.getDni() : "" %>" 
                                               readonly>
                                    </div>
                                </div>
                            </div>

                            <h5 class="form-section-title"><i class="far fa-address-book me-2"></i>Información de Contacto</h5>

                            <div class="row g-3 mb-4">
                                <div class="col-md-6">
                                    <label for="email" class="form-label fw-bold small text-muted">Correo Electrónico</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-envelope"></i></span>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="<%= clienteActual.getEmail() != null ? clienteActual.getEmail() : "" %>" 
                                               required placeholder="ejemplo@correo.com">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="telefono" class="form-label fw-bold small text-muted">Teléfono</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-phone"></i></span>
                                        <input type="tel" class="form-control" id="telefono" name="telefono" 
                                               value="<%= clienteActual.getTelefono() != null ? clienteActual.getTelefono() : "" %>" 
                                               required placeholder="987654321" pattern="[0-9]{9,}">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label for="idCiudad" class="form-label fw-bold small text-muted">Ciudad</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-map-marker-alt"></i></span>
                                        <select class="form-select" id="idCiudad" name="idCiudad" required>
                                            <option value="">Selecciona tu ciudad...</option>
                                            <% 
                                            if (ciudades != null) {
                                                for (Ciudad ciudad : ciudades) { 
                                            %>
                                                <option value="<%= ciudad.getIdCiudad() %>" 
                                                    <%= (clienteActual.getIdCiudad() == ciudad.getIdCiudad()) ? "selected" : "" %>>
                                                    <%= ciudad.getNombreCiudad() %>
                                                </option>
                                            <% 
                                                }
                                            } 
                                            %>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <label for="direccion" class="form-label fw-bold small text-muted">Dirección</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light"><i class="fas fa-home"></i></span>
                                        <input type="text" class="form-control" id="direccion" name="direccion" 
                                               value="<%= clienteActual.getDireccion() != null ? clienteActual.getDireccion() : "" %>" 
                                               placeholder="Av. Principal 123">
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2 mt-5 border-top pt-4">
                                <a href="${pageContext.request.contextPath}/perfil-cliente" class="btn btn-light border px-4">
                                    Cancelar
                                </a>
                                <button type="submit" class="btn btn-primary px-4 fw-bold shadow-sm">
                                    <i class="fas fa-save me-2"></i> Guardar Cambios
                                </button>
                            </div>

                        </form>
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
    
    <script>
        // Validación básica de Bootstrap
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