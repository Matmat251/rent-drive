<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% jakarta.servlet.http.HttpSession userSession=request.getSession(false); String mensajeExito=null; if (userSession
        !=null) { mensajeExito=(String) userSession.getAttribute("mensajeExito"); if (mensajeExito !=null) {
        userSession.removeAttribute("mensajeExito"); } } String error=(String) request.getAttribute("error"); %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FastWheels | Acceso Clientes</title>
            <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/img/Logo.jpg">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: linear-gradient(135deg, #0F172A 0%, #1E3A8A 50%, #3B82F6 100%);
                    position: relative;
                    overflow: hidden;
                }

                /* Animated background elements */
                .bg-shapes {
                    position: absolute;
                    inset: 0;
                    overflow: hidden;
                    z-index: 0;
                }

                .bg-shapes::before,
                .bg-shapes::after {
                    content: '';
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(59, 130, 246, 0.1);
                    animation: float 6s ease-in-out infinite;
                }

                .bg-shapes::before {
                    width: 400px;
                    height: 400px;
                    top: -100px;
                    right: -100px;
                    animation-delay: 0s;
                }

                .bg-shapes::after {
                    width: 300px;
                    height: 300px;
                    bottom: -50px;
                    left: -50px;
                    animation-delay: -3s;
                }

                @keyframes float {

                    0%,
                    100% {
                        transform: translateY(0) rotate(0deg);
                    }

                    50% {
                        transform: translateY(-20px) rotate(5deg);
                    }
                }

                .login-container {
                    position: relative;
                    z-index: 1;
                    width: 100%;
                    max-width: 440px;
                    padding: 20px;
                }

                .login-card {
                    background: rgba(255, 255, 255, 0.95);
                    backdrop-filter: blur(20px);
                    -webkit-backdrop-filter: blur(20px);
                    border-radius: 24px;
                    box-shadow:
                        0 25px 50px -12px rgba(0, 0, 0, 0.25),
                        0 0 0 1px rgba(255, 255, 255, 0.1);
                    padding: 48px 40px;
                    animation: slideUp 0.6s ease-out;
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .logo-container {
                    position: relative;
                    margin-bottom: 24px;
                }

                .login-logo {
                    width: 90px;
                    height: 90px;
                    object-fit: cover;
                    border-radius: 50%;
                    box-shadow:
                        0 8px 25px rgba(30, 58, 138, 0.3),
                        0 0 0 4px white,
                        0 0 0 6px rgba(30, 58, 138, 0.2);
                    transition: transform 0.3s ease;
                }

                .login-logo:hover {
                    transform: scale(1.05) rotate(-5deg);
                }

                .welcome-title {
                    font-size: 1.75rem;
                    font-weight: 800;
                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                    -webkit-background-clip: text;
                    -webkit-text-fill-color: transparent;
                    background-clip: text;
                    margin-bottom: 8px;
                }

                .welcome-subtitle {
                    color: #64748B;
                    font-size: 0.95rem;
                    font-weight: 400;
                }

                .form-floating {
                    margin-bottom: 20px;
                }

                .form-floating .form-control {
                    border: 2px solid #E2E8F0;
                    border-radius: 12px;
                    padding: 16px;
                    height: 58px;
                    font-size: 1rem;
                    transition: all 0.3s ease;
                    background-color: #F8FAFC;
                }

                .form-floating .form-control:focus {
                    border-color: #3B82F6;
                    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
                    background-color: white;
                }

                .form-floating label {
                    padding: 16px;
                    color: #64748B;
                }

                .form-floating>.form-control:focus~label,
                .form-floating>.form-control:not(:placeholder-shown)~label {
                    color: #3B82F6;
                    font-weight: 600;
                }

                .input-icon {
                    position: absolute;
                    right: 16px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #94A3B8;
                    pointer-events: none;
                    transition: color 0.3s;
                }

                .form-control:focus+.input-icon {
                    color: #3B82F6;
                }

                .btn-login {
                    width: 100%;
                    padding: 16px;
                    font-size: 1rem;
                    font-weight: 700;
                    border: none;
                    border-radius: 12px;
                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                    color: white;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    position: relative;
                    overflow: hidden;
                    margin-top: 8px;
                }

                .btn-login::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: -100%;
                    width: 100%;
                    height: 100%;
                    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                    transition: left 0.5s ease;
                }

                .btn-login:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 12px 30px rgba(30, 58, 138, 0.4);
                }

                .btn-login:hover::before {
                    left: 100%;
                }

                .btn-login:active {
                    transform: translateY(-1px);
                }

                .divider {
                    display: flex;
                    align-items: center;
                    margin: 28px 0 20px;
                    color: #94A3B8;
                    font-size: 0.85rem;
                }

                .divider::before,
                .divider::after {
                    content: '';
                    flex: 1;
                    height: 1px;
                    background: linear-gradient(90deg, transparent, #E2E8F0, transparent);
                }

                .divider span {
                    padding: 0 16px;
                    font-weight: 500;
                }

                .register-link {
                    display: block;
                    text-align: center;
                    padding: 14px;
                    border-radius: 12px;
                    background: linear-gradient(135deg, #FEF3C7, #FDE68A);
                    color: #92400E;
                    font-weight: 600;
                    text-decoration: none;
                    transition: all 0.3s ease;
                    margin-bottom: 16px;
                }

                .register-link:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(245, 158, 11, 0.3);
                    color: #92400E;
                }

                .alt-links {
                    display: flex;
                    flex-direction: column;
                    gap: 12px;
                }

                .alt-link {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 8px;
                    padding: 12px;
                    border-radius: 10px;
                    text-decoration: none;
                    font-size: 0.9rem;
                    font-weight: 500;
                    transition: all 0.3s ease;
                }

                .alt-link.employee {
                    background: linear-gradient(135deg, #1E293B 0%, #334155 100%);
                    color: white;
                    border: 2px solid #475569;
                    font-weight: 600;
                }

                .alt-link.employee:hover {
                    background: linear-gradient(135deg, #3B82F6 0%, #8B5CF6 100%);
                    border-color: #3B82F6;
                    color: white;
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
                }

                .alt-link.home {
                    background: transparent;
                    color: #3B82F6;
                }

                .alt-link.home:hover {
                    background: rgba(59, 130, 246, 0.1);
                }

                .alert {
                    border: none;
                    border-radius: 12px;
                    padding: 14px 18px;
                    margin-bottom: 24px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    font-weight: 500;
                    animation: shake 0.5s ease-in-out;
                }

                @keyframes shake {

                    0%,
                    100% {
                        transform: translateX(0);
                    }

                    25% {
                        transform: translateX(-5px);
                    }

                    75% {
                        transform: translateX(5px);
                    }
                }

                .alert-success {
                    background: linear-gradient(135deg, #D1FAE5, #A7F3D0);
                    color: #065F46;
                }

                .alert-danger {
                    background: linear-gradient(135deg, #FEE2E2, #FECACA);
                    color: #991B1B;
                }

                .password-toggle {
                    position: absolute;
                    right: 16px;
                    top: 50%;
                    transform: translateY(-50%);
                    background: none;
                    border: none;
                    color: #94A3B8;
                    cursor: pointer;
                    padding: 4px;
                    z-index: 10;
                    transition: color 0.3s;
                }

                .password-toggle:hover {
                    color: #3B82F6;
                }

                /* Responsive */
                @media (max-width: 768px) {
                    body {
                        padding: 20px 0;
                        min-height: 100vh;
                        align-items: flex-start;
                        overflow-y: auto;
                    }

                    .login-container {
                        padding: 15px;
                        max-width: 100%;
                    }

                    .login-card {
                        padding: 32px 24px;
                        border-radius: 20px;
                    }

                    .login-logo {
                        width: 75px;
                        height: 75px;
                    }

                    .welcome-title {
                        font-size: 1.5rem;
                    }

                    .welcome-subtitle {
                        font-size: 0.9rem;
                    }

                    .form-floating .form-control {
                        height: 54px;
                        padding: 14px;
                        font-size: 0.95rem;
                    }

                    .btn-login {
                        padding: 14px;
                        font-size: 0.95rem;
                    }

                    .register-link {
                        padding: 12px;
                        font-size: 0.9rem;
                    }

                    .alt-link {
                        padding: 12px;
                        font-size: 0.85rem;
                    }

                    .alt-link.employee {
                        padding: 14px;
                    }

                    .divider {
                        margin: 20px 0 16px;
                    }
                }

                @media (max-width: 480px) {
                    body {
                        padding: 15px 0;
                    }

                    .login-container {
                        padding: 10px;
                    }

                    .login-card {
                        padding: 28px 20px;
                        border-radius: 16px;
                    }

                    .login-logo {
                        width: 65px;
                        height: 65px;
                        box-shadow:
                            0 6px 20px rgba(30, 58, 138, 0.25),
                            0 0 0 3px white,
                            0 0 0 5px rgba(30, 58, 138, 0.15);
                    }

                    .logo-container {
                        margin-bottom: 16px;
                    }

                    .welcome-title {
                        font-size: 1.35rem;
                        margin-bottom: 6px;
                    }

                    .welcome-subtitle {
                        font-size: 0.85rem;
                    }

                    .form-floating {
                        margin-bottom: 16px;
                    }

                    .form-floating .form-control {
                        height: 50px;
                        padding: 12px;
                        font-size: 0.9rem;
                        border-radius: 10px;
                    }

                    .form-floating label {
                        padding: 12px;
                        font-size: 0.9rem;
                    }

                    .password-toggle {
                        right: 12px;
                    }

                    .btn-login {
                        padding: 12px;
                        font-size: 0.9rem;
                        border-radius: 10px;
                        margin-top: 4px;
                    }

                    .divider {
                        margin: 18px 0 14px;
                    }

                    .divider span {
                        font-size: 0.8rem;
                    }

                    .register-link {
                        padding: 11px;
                        font-size: 0.85rem;
                        border-radius: 10px;
                        margin-bottom: 12px;
                    }

                    .alt-links {
                        gap: 10px;
                    }

                    .alt-link {
                        padding: 11px;
                        font-size: 0.8rem;
                        border-radius: 8px;
                    }

                    .alt-link.employee {
                        padding: 12px;
                        font-size: 0.8rem;
                    }

                    .alert {
                        padding: 12px 14px;
                        font-size: 0.85rem;
                        border-radius: 10px;
                    }
                }

                @media (max-width: 360px) {
                    .login-card {
                        padding: 24px 16px;
                    }

                    .welcome-title {
                        font-size: 1.25rem;
                    }

                    .alt-link.employee span {
                        font-size: 0.75rem;
                    }
                }

                @media (max-height: 650px) {
                    body {
                        overflow-y: auto;
                        align-items: flex-start;
                        padding: 20px 0;
                    }

                    .login-card {
                        padding: 24px 20px;
                    }

                    .logo-container {
                        margin-bottom: 12px;
                    }

                    .login-logo {
                        width: 60px;
                        height: 60px;
                    }

                    .form-floating {
                        margin-bottom: 14px;
                    }

                    .divider {
                        margin: 16px 0 12px;
                    }
                }
            </style>
        </head>

        <body>
            <div class="bg-shapes"></div>

            <div class="login-container">
                <div class="login-card">
                    <div class="text-center logo-container">
                        <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="FastWheels Logo"
                            class="login-logo"
                            onerror="this.src='https://cdn-icons-png.flaticon.com/512/3202/3202926.png'">
                    </div>

                    <div class="text-center mb-4">
                        <h1 class="welcome-title">Bienvenido</h1>
                        <p class="welcome-subtitle">Ingresa tus credenciales para continuar</p>
                    </div>

                    <% if (mensajeExito !=null) { %>
                        <div class="alert alert-success" role="alert">
                            <i class="fas fa-check-circle"></i>
                            <span>
                                <%= mensajeExito %>
                            </span>
                        </div>
                        <% } %>

                            <% if (error !=null) { %>
                                <div class="alert alert-danger" role="alert">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span>
                                        <%= error %>
                                    </span>
                                </div>
                                <% } %>

                                    <form action="${pageContext.request.contextPath}/login-cliente" method="POST"
                                        id="loginForm">
                                        <div class="form-floating position-relative">
                                            <input type="text" class="form-control" id="usuario" name="usuario"
                                                placeholder="Usuario" autocomplete="username" required>
                                            <label for="usuario"><i class="fas fa-user me-2"></i>Usuario o DNI</label>
                                        </div>

                                        <div class="form-floating position-relative">
                                            <input type="password" class="form-control" id="contrasena"
                                                name="contrasena" placeholder="Contraseña"
                                                autocomplete="current-password" required>
                                            <label for="contrasena"><i class="fas fa-lock me-2"></i>Contraseña</label>
                                            <button type="button" class="password-toggle" onclick="togglePassword()">
                                                <i class="fas fa-eye" id="toggleIcon"></i>
                                            </button>
                                        </div>

                                        <button type="submit" class="btn-login">
                                            <i class="fas fa-sign-in-alt me-2"></i>Ingresar
                                        </button>
                                    </form>

                                    <div class="divider">
                                        <span>¿Nuevo aquí?</span>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/auth/registro-cliente.jsp"
                                        class="register-link">
                                        <i class="fas fa-user-plus me-2"></i>Crear una cuenta gratis
                                    </a>

                                    <div class="alt-links">
                                        <a href="${pageContext.request.contextPath}/auth/login.jsp"
                                            class="alt-link employee">
                                            <i class="fas fa-building"></i>
                                            <span>Acceso Portal Corporativo (Empleados)</span>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/index.jsp" class="alt-link home">
                                            <i class="fas fa-home"></i>
                                            <span>Volver al Inicio</span>
                                        </a>
                                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                function togglePassword() {
                    const passwordInput = document.getElementById('contrasena');
                    const toggleIcon = document.getElementById('toggleIcon');

                    if (passwordInput.type === 'password') {
                        passwordInput.type = 'text';
                        toggleIcon.classList.remove('fa-eye');
                        toggleIcon.classList.add('fa-eye-slash');
                    } else {
                        passwordInput.type = 'password';
                        toggleIcon.classList.remove('fa-eye-slash');
                        toggleIcon.classList.add('fa-eye');
                    }
                }

                // Add loading state to button on form submit
                document.getElementById('loginForm').addEventListener('submit', function (e) {
                    const btn = this.querySelector('.btn-login');
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Ingresando...';
                    btn.disabled = true;
                });
            </script>
        </body>

        </html>