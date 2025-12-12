<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="capaDatos.CiudadDAO, capaEntidad.Ciudad, java.util.List" %>
        <% CiudadDAO ciudadDAO=new CiudadDAO(); List<Ciudad> ciudades = ciudadDAO.obtenerCiudadesActivas();

            String nombre = (String) request.getAttribute("nombre");
            String apellido = (String) request.getAttribute("apellido");
            String dni = (String) request.getAttribute("dni");
            String telefono = (String) request.getAttribute("telefono");
            String email = (String) request.getAttribute("email");
            String direccion = (String) request.getAttribute("direccion");
            String idCiudad = (String) request.getAttribute("idCiudad");

            if (nombre == null) nombre = "";
            if (apellido == null) apellido = "";
            if (dni == null) dni = "";
            if (telefono == null) telefono = "";
            if (email == null) email = "";
            if (direccion == null) direccion = "";
            if (idCiudad == null) idCiudad = "";

            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            %>
            <!DOCTYPE html>
            <html lang="es">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>FastWheels | Crear Cuenta</title>
                <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/img/Logo.jpg">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap');

                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Poppins', sans-serif;
                        min-height: 100vh;
                        background: linear-gradient(135deg, #0F172A 0%, #1E3A8A 50%, #3B82F6 100%);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 40px 20px;
                        position: relative;
                        overflow-x: hidden;
                    }

                    body::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
                        pointer-events: none;
                    }

                    .register-container {
                        position: relative;
                        z-index: 1;
                        width: 100%;
                        max-width: 700px;
                    }

                    .register-card {
                        background: rgba(255, 255, 255, 0.98);
                        border-radius: 24px;
                        box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
                        padding: 48px;
                        animation: slideUp 0.6s ease;
                    }

                    @keyframes slideUp {
                        from {
                            opacity: 0;
                            transform: translateY(40px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    .logo-section {
                        text-align: center;
                        margin-bottom: 32px;
                    }

                    .register-logo {
                        width: 80px;
                        height: 80px;
                        border-radius: 50%;
                        object-fit: cover;
                        box-shadow: 0 8px 25px rgba(30, 58, 138, 0.3);
                        margin-bottom: 16px;
                    }

                    .register-title {
                        font-size: 1.8rem;
                        font-weight: 800;
                        background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                        -webkit-background-clip: text;
                        -webkit-text-fill-color: transparent;
                        background-clip: text;
                        margin-bottom: 8px;
                    }

                    .register-subtitle {
                        color: #64748B;
                        font-size: 0.95rem;
                    }

                    .form-section {
                        margin-top: 24px;
                    }

                    .form-row {
                        display: grid;
                        grid-template-columns: repeat(2, 1fr);
                        gap: 20px;
                    }

                    .form-row.single {
                        grid-template-columns: 1fr;
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-label {
                        display: block;
                        font-size: 0.8rem;
                        font-weight: 600;
                        color: #475569;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                        margin-bottom: 8px;
                    }

                    .form-label .required {
                        color: #EF4444;
                    }

                    .input-wrapper {
                        position: relative;
                    }

                    .input-wrapper i {
                        position: absolute;
                        left: 16px;
                        top: 50%;
                        transform: translateY(-50%);
                        color: #94A3B8;
                        font-size: 0.95rem;
                        transition: color 0.3s;
                    }

                    .form-input {
                        width: 100%;
                        padding: 14px 16px 14px 48px;
                        border: 2px solid #E2E8F0;
                        border-radius: 12px;
                        font-size: 0.95rem;
                        transition: all 0.3s;
                        background: #F8FAFC;
                    }

                    .form-input:focus {
                        outline: none;
                        border-color: #3B82F6;
                        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
                        background: white;
                    }

                    .form-input:focus+i,
                    .input-wrapper:focus-within i {
                        color: #3B82F6;
                    }

                    .form-select {
                        width: 100%;
                        padding: 14px 16px 14px 48px;
                        border: 2px solid #E2E8F0;
                        border-radius: 12px;
                        font-size: 0.95rem;
                        transition: all 0.3s;
                        background: #F8FAFC;
                        cursor: pointer;
                        appearance: none;
                    }

                    .form-select:focus {
                        outline: none;
                        border-color: #3B82F6;
                        box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
                        background: white;
                    }

                    .strength-indicator {
                        font-size: 0.8rem;
                        margin-top: 6px;
                        font-weight: 500;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .strength-weak {
                        color: #EF4444;
                    }

                    .strength-medium {
                        color: #F59E0B;
                    }

                    .strength-strong {
                        color: #10B981;
                    }

                    .btn-register {
                        width: 100%;
                        padding: 16px;
                        background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                        border: none;
                        border-radius: 12px;
                        color: white;
                        font-size: 1rem;
                        font-weight: 700;
                        cursor: pointer;
                        transition: all 0.3s;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 10px;
                        margin-top: 10px;
                    }

                    .btn-register:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 12px 30px rgba(30, 58, 138, 0.4);
                    }

                    .btn-register:disabled {
                        opacity: 0.7;
                        cursor: not-allowed;
                        transform: none;
                    }

                    .divider {
                        display: flex;
                        align-items: center;
                        margin: 28px 0;
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
                    }

                    .login-link {
                        display: block;
                        text-align: center;
                        padding: 14px;
                        border-radius: 12px;
                        background: #F1F5F9;
                        color: #475569;
                        text-decoration: none;
                        font-weight: 600;
                        transition: all 0.3s;
                    }

                    .login-link:hover {
                        background: #E2E8F0;
                        color: #1E293B;
                    }

                    .login-link span {
                        color: #3B82F6;
                    }

                    .employee-link {
                        display: block;
                        text-align: center;
                        margin-top: 16px;
                        color: #94A3B8;
                        text-decoration: none;
                        font-size: 0.9rem;
                        transition: color 0.3s;
                    }

                    .employee-link:hover {
                        color: #3B82F6;
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

                    /* Responsive */
                    @media (max-width: 768px) {
                        body {
                            padding: 20px 15px;
                        }

                        .register-card {
                            padding: 32px 24px;
                        }

                        .form-row {
                            grid-template-columns: 1fr;
                            gap: 0;
                        }

                        .register-title {
                            font-size: 1.5rem;
                        }

                        .register-logo {
                            width: 70px;
                            height: 70px;
                        }
                    }

                    @media (max-width: 480px) {
                        .register-card {
                            padding: 28px 20px;
                            border-radius: 20px;
                        }

                        .register-title {
                            font-size: 1.35rem;
                        }

                        .form-input,
                        .form-select {
                            padding: 12px 14px 12px 44px;
                            font-size: 0.9rem;
                        }

                        .btn-register {
                            padding: 14px;
                            font-size: 0.95rem;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="register-container">
                    <div class="register-card">
                        <div class="logo-section">
                            <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="FastWheels"
                                class="register-logo"
                                onerror="this.src='https://cdn-icons-png.flaticon.com/512/3202/3202926.png'">
                            <h1 class="register-title">Crear Cuenta</h1>
                            <p class="register-subtitle">Únete a FastWheels y empieza a viajar</p>
                        </div>

                        <% if (error !=null) { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-circle"></i>
                                <span>
                                    <%= error %>
                                </span>
                            </div>
                            <% } %>

                                <% if (success !=null) { %>
                                    <div class="alert alert-success">
                                        <i class="fas fa-check-circle"></i>
                                        <span>
                                            <%= success %>
                                        </span>
                                    </div>
                                    <% } %>

                                        <form action="${pageContext.request.contextPath}/registro-cliente" method="post"
                                            id="formRegistro" class="form-section">
                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">Nombre <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="text" class="form-input" id="nombre" name="nombre"
                                                            value="<%= nombre %>" required placeholder="Tu nombre">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Apellido <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="text" class="form-input" id="apellido"
                                                            name="apellido" value="<%= apellido %>" required
                                                            placeholder="Tu apellido">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">DNI <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="text" class="form-input" id="dni" name="dni"
                                                            value="<%= dni %>" pattern="[0-9]{8}" maxlength="8" required
                                                            placeholder="8 dígitos"
                                                            oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                                        <i class="fas fa-id-card"></i>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Teléfono <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="tel" class="form-input" id="telefono"
                                                            name="telefono" value="<%= telefono %>" required
                                                            placeholder="987654321"
                                                            oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                                                        <i class="fas fa-phone"></i>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-row single">
                                                <div class="form-group">
                                                    <label class="form-label">Correo Electrónico <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="email" class="form-input" id="email" name="email"
                                                            value="<%= email %>" required
                                                            placeholder="usuario@correo.com">
                                                        <i class="fas fa-envelope"></i>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">Ciudad <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <select class="form-select" id="idCiudad" name="idCiudad"
                                                            required>
                                                            <option value="">Selecciona tu ciudad</option>
                                                            <% for (Ciudad ciudad : ciudades) { %>
                                                                <option value="<%= ciudad.getIdCiudad() %>"
                                                                    <%=idCiudad.equals(String.valueOf(ciudad.getIdCiudad()))
                                                                    ? "selected" : "" %>>
                                                                    <%= ciudad.getNombreCiudad() %>
                                                                </option>
                                                                <% } %>
                                                        </select>
                                                        <i class="fas fa-map-marker-alt"></i>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Dirección</label>
                                                    <div class="input-wrapper">
                                                        <input type="text" class="form-input" id="direccion"
                                                            name="direccion" value="<%= direccion %>"
                                                            placeholder="Av. Principal 123">
                                                        <i class="fas fa-home"></i>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-row">
                                                <div class="form-group">
                                                    <label class="form-label">Contraseña <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="password" class="form-input" id="contraseña"
                                                            name="contraseña" required minlength="6"
                                                            placeholder="Mínimo 6 caracteres"
                                                            oninput="validarFortaleza(this.value)">
                                                        <i class="fas fa-lock"></i>
                                                    </div>
                                                    <div id="password-strength" class="strength-indicator"></div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="form-label">Confirmar Contraseña <span
                                                            class="required">*</span></label>
                                                    <div class="input-wrapper">
                                                        <input type="password" class="form-input"
                                                            id="confirmarContraseña" name="confirmarContraseña" required
                                                            minlength="6" placeholder="Repite la contraseña"
                                                            oninput="validarCoincidencia()">
                                                        <i class="fas fa-lock"></i>
                                                    </div>
                                                    <div id="password-match" class="strength-indicator"></div>
                                                </div>
                                            </div>

                                            <button type="submit" class="btn-register" id="btnRegistro">
                                                <i class="fas fa-user-plus"></i>
                                                <span>Crear Cuenta</span>
                                            </button>
                                        </form>

                                        <div class="divider">
                                            <span>¿Ya tienes cuenta?</span>
                                        </div>

                                        <a href="${pageContext.request.contextPath}/auth/login-cliente.jsp"
                                            class="login-link">
                                            <span>Iniciar Sesión</span>
                                        </a>

                                        <a href="${pageContext.request.contextPath}/auth/login.jsp"
                                            class="employee-link">
                                            <i class="fas fa-briefcase me-1"></i>Acceso Empleados
                                        </a>
                    </div>
                </div>

                <script>
                    function validarFortaleza(password) {
                        const el = document.getElementById('password-strength');
                        let text = '', cls = '';

                        if (password.length === 0) {
                            text = '';
                        } else if (password.length < 6) {
                            text = '❌ Muy corta';
                            cls = 'strength-weak';
                        } else if (password.length < 8) {
                            text = '⚠️ Media';
                            cls = 'strength-medium';
                        } else {
                            const hasLetter = /[a-zA-Z]/.test(password);
                            const hasNumber = /[0-9]/.test(password);
                            if (hasLetter && hasNumber) {
                                text = '✅ Fuerte';
                                cls = 'strength-strong';
                            } else {
                                text = '⚠️ Media (añade números y letras)';
                                cls = 'strength-medium';
                            }
                        }
                        el.textContent = text;
                        el.className = 'strength-indicator ' + cls;
                        validarCoincidencia();
                    }

                    function validarCoincidencia() {
                        const pass = document.getElementById('contraseña').value;
                        const confirm = document.getElementById('confirmarContraseña').value;
                        const el = document.getElementById('password-match');
                        const btn = document.getElementById('btnRegistro');

                        if (confirm.length === 0) {
                            el.textContent = '';
                            btn.disabled = pass.length < 6;
                        } else if (pass === confirm) {
                            el.textContent = '✅ Coinciden';
                            el.className = 'strength-indicator strength-strong';
                            btn.disabled = pass.length < 6;
                        } else {
                            el.textContent = '❌ No coinciden';
                            el.className = 'strength-indicator strength-weak';
                            btn.disabled = true;
                        }
                    }

                    document.getElementById('formRegistro').addEventListener('submit', function (e) {
                        const btn = document.getElementById('btnRegistro');
                        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Creando cuenta...</span>';
                        btn.disabled = true;
                    });

                    document.addEventListener('DOMContentLoaded', validarCoincidencia);
                </script>
            </body>

            </html>