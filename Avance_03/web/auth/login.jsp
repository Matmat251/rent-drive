<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% String error=(String) request.getAttribute("error"); %>
        <!DOCTYPE html>
        <html lang="es">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>FastWheels | Portal Corporativo</title>
            <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/img/Logo.jpg">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    min-height: 100vh;
                    display: flex;
                    background: #0a0a1a;
                    overflow-x: hidden;
                    overflow-y: auto;
                }

                /* Left Panel - Branding */
                .brand-panel {
                    flex: 1;
                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 50%, #60A5FA 100%);
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    padding: 60px;
                    position: relative;
                    overflow: hidden;
                }

                .brand-panel::before {
                    content: '';
                    position: absolute;
                    top: -50%;
                    left: -50%;
                    width: 200%;
                    height: 200%;
                    background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
                    animation: moveBackground 20s linear infinite;
                }

                @keyframes moveBackground {
                    0% {
                        transform: translate(0, 0);
                    }

                    100% {
                        transform: translate(30px, 30px);
                    }
                }

                .brand-content {
                    position: relative;
                    z-index: 1;
                    text-align: center;
                    color: white;
                }

                .brand-logo {
                    width: 120px;
                    height: 120px;
                    border-radius: 30px;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                    margin-bottom: 30px;
                    animation: float 3s ease-in-out infinite;
                }

                @keyframes float {

                    0%,
                    100% {
                        transform: translateY(0);
                    }

                    50% {
                        transform: translateY(-15px);
                    }
                }

                .brand-title {
                    font-size: 3rem;
                    font-weight: 800;
                    margin-bottom: 15px;
                    text-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                }

                .brand-subtitle {
                    font-size: 1.2rem;
                    opacity: 0.9;
                    margin-bottom: 40px;
                    max-width: 400px;
                }

                .feature-list {
                    text-align: left;
                    background: rgba(255, 255, 255, 0.1);
                    backdrop-filter: blur(10px);
                    padding: 30px;
                    border-radius: 20px;
                    border: 1px solid rgba(255, 255, 255, 0.2);
                }

                .feature-item {
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    margin-bottom: 20px;
                    font-size: 1rem;
                }

                .feature-item:last-child {
                    margin-bottom: 0;
                }

                .feature-icon {
                    width: 45px;
                    height: 45px;
                    background: rgba(255, 255, 255, 0.2);
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.2rem;
                }

                /* Right Panel - Login Form */
                .login-panel {
                    width: 500px;
                    background: #0f0f23;
                    display: flex;
                    flex-direction: column;
                    justify-content: flex-start;
                    padding: 40px 50px;
                    position: relative;
                    overflow-y: auto;
                    min-height: 100vh;
                }

                .login-panel::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 4px;
                    height: 100%;
                    background: linear-gradient(180deg, #3B82F6, #8B5CF6, #EC4899);
                }

                .login-header {
                    margin-bottom: 25px;
                }

                .login-badge {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    background: linear-gradient(135deg, #F59E0B, #EAB308);
                    color: #1a1a2e;
                    font-size: 0.75rem;
                    font-weight: 700;
                    padding: 8px 16px;
                    border-radius: 50px;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    margin-bottom: 20px;
                }

                .login-title {
                    font-size: 2.2rem;
                    font-weight: 800;
                    color: white;
                    margin-bottom: 10px;
                }

                .login-subtitle {
                    color: #64748B;
                    font-size: 1rem;
                }

                .form-group {
                    margin-bottom: 24px;
                }

                .form-label {
                    display: block;
                    color: #94A3B8;
                    font-size: 0.85rem;
                    font-weight: 600;
                    margin-bottom: 10px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .form-input-wrapper {
                    position: relative;
                }

                .form-input {
                    width: 100%;
                    padding: 16px 20px;
                    padding-left: 50px;
                    background: #1a1a2e;
                    border: 2px solid #2a2a4a;
                    border-radius: 12px;
                    color: white;
                    font-size: 1rem;
                    transition: all 0.3s;
                }

                .form-input:focus {
                    outline: none;
                    border-color: #3B82F6;
                    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.2);
                    background: #252540;
                }

                .form-input::placeholder {
                    color: #4a4a6a;
                }

                .input-icon {
                    position: absolute;
                    left: 18px;
                    top: 50%;
                    transform: translateY(-50%);
                    color: #64748B;
                    font-size: 1.1rem;
                }

                .btn-login {
                    width: 100%;
                    padding: 18px;
                    background: linear-gradient(135deg, #3B82F6 0%, #8B5CF6 100%);
                    border: none;
                    border-radius: 12px;
                    color: white;
                    font-size: 1.05rem;
                    font-weight: 700;
                    cursor: pointer;
                    transition: all 0.3s;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 10px;
                    position: relative;
                    overflow: hidden;
                }

                .btn-login::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: -100%;
                    width: 100%;
                    height: 100%;
                    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                    transition: left 0.5s;
                }

                .btn-login:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 15px 35px rgba(59, 130, 246, 0.4);
                }

                .btn-login:hover::before {
                    left: 100%;
                }

                .security-badge {
                    display: flex;
                    align-items: center;
                    gap: 10px;
                    padding: 16px;
                    background: rgba(16, 185, 129, 0.1);
                    border: 1px solid rgba(16, 185, 129, 0.3);
                    border-radius: 10px;
                    margin-top: 24px;
                }

                .security-badge i {
                    color: #10B981;
                    font-size: 1.2rem;
                }

                .security-badge span {
                    color: #10B981;
                    font-size: 0.85rem;
                    font-weight: 500;
                }

                .divider {
                    height: 1px;
                    background: linear-gradient(90deg, transparent, #2a2a4a, transparent);
                    margin: 30px 0;
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
                    padding: 14px;
                    border-radius: 10px;
                    text-decoration: none;
                    font-size: 0.9rem;
                    font-weight: 500;
                    transition: all 0.3s;
                }

                .alt-link.client {
                    background: #1a1a2e;
                    border: 1px solid #2a2a4a;
                    color: #94A3B8;
                }

                .alt-link.client:hover {
                    background: #252540;
                    border-color: #3B82F6;
                    color: white;
                }

                .alt-link.home {
                    color: #64748B;
                }

                .alt-link.home:hover {
                    color: #3B82F6;
                }

                .alert {
                    border: none;
                    border-radius: 12px;
                    padding: 16px 20px;
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

                .alert-danger {
                    background: rgba(239, 68, 68, 0.15);
                    border: 1px solid rgba(239, 68, 68, 0.3);
                    color: #F87171;
                }

                /* Responsive */
                /* Específico para laptops 1366x768 y similares */
                @media (max-height: 800px) and (min-width: 1024px) {
                    .login-panel {
                        padding: 25px 40px;
                        justify-content: flex-start;
                    }

                    .login-header {
                        margin-bottom: 18px;
                    }

                    .login-badge {
                        padding: 6px 12px;
                        font-size: 0.7rem;
                        margin-bottom: 12px;
                    }

                    .login-title {
                        font-size: 1.8rem;
                        margin-bottom: 6px;
                    }

                    .login-subtitle {
                        font-size: 0.85rem;
                    }

                    .form-group {
                        margin-bottom: 16px;
                    }

                    .form-label {
                        margin-bottom: 6px;
                        font-size: 0.75rem;
                    }

                    .form-input {
                        padding: 12px 16px;
                        padding-left: 42px;
                    }

                    .btn-login {
                        padding: 14px;
                    }

                    .security-badge {
                        padding: 10px;
                        margin-top: 16px;
                    }

                    .security-badge span {
                        font-size: 0.75rem;
                    }

                    .divider {
                        margin: 18px 0;
                    }

                    .alt-link {
                        padding: 11px;
                        font-size: 0.85rem;
                    }

                    .brand-panel {
                        padding: 30px;
                    }

                    .brand-logo {
                        width: 80px;
                        height: 80px;
                        margin-bottom: 20px;
                    }

                    .brand-title {
                        font-size: 2.2rem;
                        margin-bottom: 10px;
                    }

                    .brand-subtitle {
                        font-size: 1rem;
                        margin-bottom: 25px;
                    }

                    .feature-list {
                        padding: 20px;
                    }

                    .feature-item {
                        margin-bottom: 14px;
                        font-size: 0.9rem;
                    }

                    .feature-icon {
                        width: 38px;
                        height: 38px;
                        font-size: 1rem;
                    }
                }

                @media (max-width: 1200px) {
                    .brand-panel {
                        padding: 40px;
                    }

                    .brand-title {
                        font-size: 2.5rem;
                    }

                    .login-panel {
                        width: 450px;
                        padding: 35px 45px;
                    }
                }

                @media (max-width: 1024px) {
                    body {
                        overflow-y: auto;
                    }

                    .brand-panel {
                        display: none;
                    }

                    .login-panel {
                        width: 100%;
                        max-width: 100%;
                        min-height: 100vh;
                        padding: 40px;
                    }

                    .login-panel::before {
                        width: 100%;
                        height: 4px;
                        left: 0;
                        top: 0;
                    }
                }

                @media (max-width: 768px) {
                    body {
                        overflow-y: auto;
                    }

                    .login-panel {
                        padding: 30px 24px;
                        min-height: 100vh;
                        justify-content: flex-start;
                        padding-top: 40px;
                    }

                    .login-header {
                        margin-bottom: 30px;
                    }

                    .login-title {
                        font-size: 1.6rem;
                    }

                    .login-subtitle {
                        font-size: 0.9rem;
                    }

                    .form-input {
                        padding: 14px 16px;
                        padding-left: 45px;
                        font-size: 0.95rem;
                    }

                    .btn-login {
                        padding: 16px;
                        font-size: 1rem;
                    }

                    .alt-link {
                        padding: 14px 16px;
                        font-size: 0.9rem;
                    }

                    .alt-link.client {
                        background: linear-gradient(135deg, #3B82F6 0%, #60A5FA 100%);
                        color: white;
                        border: none;
                        font-weight: 600;
                    }

                    .security-badge {
                        padding: 12px;
                    }

                    .security-badge span {
                        font-size: 0.8rem;
                    }
                }

                @media (max-width: 480px) {
                    .login-panel {
                        padding: 24px 20px;
                        padding-bottom: 40px;
                    }

                    .login-badge {
                        font-size: 0.65rem;
                        padding: 6px 12px;
                    }

                    .login-title {
                        font-size: 1.4rem;
                    }

                    .login-subtitle {
                        font-size: 0.85rem;
                    }

                    .form-label {
                        font-size: 0.75rem;
                    }

                    .form-input {
                        padding: 12px 14px;
                        padding-left: 42px;
                        font-size: 0.9rem;
                    }

                    .input-icon {
                        left: 14px;
                        font-size: 1rem;
                    }

                    .btn-login {
                        padding: 14px;
                        font-size: 0.95rem;
                    }

                    .divider {
                        margin: 20px 0;
                    }

                    .alt-links {
                        gap: 10px;
                    }

                    .alt-link {
                        padding: 12px 14px;
                        font-size: 0.85rem;
                    }

                    .security-badge {
                        margin-top: 16px;
                        padding: 10px;
                    }
                }

                @media (max-height: 700px) and (max-width: 768px) {
                    body {
                        overflow-y: auto;
                    }

                    .login-panel {
                        min-height: auto;
                        padding-top: 30px;
                        padding-bottom: 30px;
                    }

                    .login-header {
                        margin-bottom: 20px;
                    }

                    .form-group {
                        margin-bottom: 16px;
                    }

                    .security-badge {
                        margin-top: 16px;
                    }

                    .divider {
                        margin: 20px 0;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Left Panel - Branding -->
            <div class="brand-panel">
                <div class="brand-content">
                    <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="FastWheels"
                        class="brand-logo" onerror="this.src='https://cdn-icons-png.flaticon.com/512/3202/3202926.png'">
                    <h1 class="brand-title">FastWheels</h1>
                    <p class="brand-subtitle">
                        Sistema de Gestión Empresarial para el control total de tu flota de vehículos
                    </p>

                    <div class="feature-list">
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-chart-line"></i>
                            </div>
                            <span>Dashboard con métricas en tiempo real</span>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-car"></i>
                            </div>
                            <span>Gestión completa de vehículos</span>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <span>Control de reservas y pagos</span>
                        </div>
                        <div class="feature-item">
                            <div class="feature-icon">
                                <i class="fas fa-users"></i>
                            </div>
                            <span>Directorio de clientes</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Panel - Login Form -->
            <div class="login-panel">
                <div class="login-header">
                    <div class="login-badge">
                        <i class="fas fa-shield-alt"></i>
                        <span>Acceso Restringido</span>
                    </div>
                    <h2 class="login-title">Portal Corporativo</h2>
                    <p class="login-subtitle">Ingresa tus credenciales de empleado para acceder al sistema</p>
                </div>

                <% if (error !=null) { %>
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>
                            <%= error %>
                        </span>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                            <div class="form-group">
                                <label class="form-label">Usuario Corporativo</label>
                                <div class="form-input-wrapper">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" class="form-input" id="usuario" name="usuario"
                                        placeholder="Ej: ana_admin" autocomplete="username" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Contraseña</label>
                                <div class="form-input-wrapper">
                                    <i class="fas fa-lock input-icon"></i>
                                    <input type="password" class="form-input" id="contrasena" name="contrasena"
                                        placeholder="••••••••" autocomplete="current-password" required>
                                </div>
                            </div>

                            <button type="submit" class="btn-login">
                                <i class="fas fa-sign-in-alt"></i>
                                <span>Iniciar Sesión</span>
                            </button>

                            <div class="security-badge">
                                <i class="fas fa-lock"></i>
                                <span>Conexión cifrada y segura con SSL</span>
                            </div>
                        </form>

                        <div class="divider"></div>

                        <div class="alt-links">
                            <a href="${pageContext.request.contextPath}/auth/login-cliente.jsp" class="alt-link client">
                                <i class="fas fa-arrow-left"></i>
                                <span>Ir al Portal de Clientes</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/index.jsp" class="alt-link home">
                                <i class="fas fa-home"></i>
                                <span>Volver al Inicio</span>
                            </a>
                        </div>
            </div>

            <script>
                // Add loading state to button on form submit
                document.getElementById('loginForm').addEventListener('submit', function (e) {
                    const btn = this.querySelector('.btn-login');
                    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Verificando credenciales...</span>';
                    btn.disabled = true;
                    btn.style.opacity = '0.8';
                });
            </script>
        </body>

        </html>