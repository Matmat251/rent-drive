<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="es">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description"
            content="FastWheels - Alquiler de vehículos premium. La mejor selección de autos para tu próximo viaje.">
        <title>FastWheels | Alquiler de Vehículos Premium</title>
        <link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/img/Logo.jpg">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

        <style>
            /* Landing Page Exclusive Styles */
            :root {
                --gradient-hero: linear-gradient(135deg, rgba(15, 23, 42, 0.85) 0%, rgba(30, 58, 138, 0.75) 50%, rgba(59, 130, 246, 0.65) 100%);
            }

            body {
                overflow-x: hidden;
            }

            /* Hero Section */
            .hero-section {
                min-height: 100vh;
                background: var(--gradient-hero), url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&w=1920&q=80');
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                display: flex;
                align-items: center;
                color: white;
                text-align: center;
                position: relative;
                margin-top: -76px;
                padding-top: 76px;
            }

            .hero-section::before {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 150px;
                background: linear-gradient(to top, var(--bg-light), transparent);
            }

            .hero-content {
                position: relative;
                z-index: 1;
            }

            .hero-badge {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                background: rgba(255, 255, 255, 0.15);
                backdrop-filter: blur(10px);
                padding: 10px 20px;
                border-radius: 50px;
                font-size: 0.85rem;
                font-weight: 600;
                margin-bottom: 24px;
                border: 1px solid rgba(255, 255, 255, 0.2);
                animation: fadeInDown 0.8s ease;
            }

            .hero-badge i {
                color: #FBBF24;
            }

            @keyframes fadeInDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .hero-title {
                font-size: clamp(2.5rem, 6vw, 4.5rem);
                font-weight: 800;
                margin-bottom: 24px;
                text-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
                line-height: 1.1;
                animation: fadeInUp 0.8s ease 0.2s both;
            }

            .hero-title span {
                background: linear-gradient(135deg, #FBBF24, #F97316);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }

                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .hero-subtitle {
                font-size: 1.2rem;
                margin-bottom: 40px;
                opacity: 0.9;
                max-width: 650px;
                margin-left: auto;
                margin-right: auto;
                line-height: 1.7;
                animation: fadeInUp 0.8s ease 0.4s both;
            }

            .hero-buttons {
                display: flex;
                justify-content: center;
                gap: 16px;
                flex-wrap: wrap;
                animation: fadeInUp 0.8s ease 0.6s both;
            }

            .btn-hero-primary {
                padding: 16px 36px;
                font-size: 1.05rem;
                font-weight: 700;
                border-radius: 50px;
                background: linear-gradient(135deg, #F97316, #FBBF24);
                border: none;
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
                box-shadow: 0 8px 30px rgba(249, 115, 22, 0.4);
            }

            .btn-hero-primary:hover {
                transform: translateY(-4px) scale(1.02);
                box-shadow: 0 12px 40px rgba(249, 115, 22, 0.5);
                color: white;
            }

            .btn-hero-secondary {
                padding: 16px 36px;
                font-size: 1.05rem;
                font-weight: 700;
                border-radius: 50px;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: white;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
            }

            .btn-hero-secondary:hover {
                background: white;
                color: #1E3A8A;
                transform: translateY(-4px);
            }

            /* Stats Bar */
            .stats-bar {
                background: white;
                padding: 0;
                position: relative;
                z-index: 10;
                margin-top: -60px;
            }

            .stats-container {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                padding: 40px;
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 30px;
            }

            .stat-item {
                text-align: center;
                padding: 10px;
                position: relative;
            }

            .stat-item:not(:last-child)::after {
                content: '';
                position: absolute;
                right: 0;
                top: 50%;
                transform: translateY(-50%);
                width: 1px;
                height: 60%;
                background: linear-gradient(to bottom, transparent, #E2E8F0, transparent);
            }

            .stat-number {
                font-size: 2.5rem;
                font-weight: 800;
                background: linear-gradient(135deg, #1E3A8A, #3B82F6);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                line-height: 1;
                margin-bottom: 8px;
            }

            .stat-label {
                font-size: 0.95rem;
                color: #64748B;
                font-weight: 500;
            }

            /* Features Section */
            .features-section {
                padding: 100px 0;
                background: linear-gradient(180deg, var(--bg-light) 0%, white 100%);
            }

            .section-badge {
                display: inline-block;
                background: linear-gradient(135deg, #E0E7FF, #C7D2FE);
                color: #1E3A8A;
                padding: 8px 18px;
                border-radius: 50px;
                font-size: 0.8rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1.5px;
                margin-bottom: 16px;
            }

            .section-title {
                font-size: 2.5rem;
                font-weight: 800;
                color: #0F172A;
                margin-bottom: 16px;
            }

            .section-subtitle {
                font-size: 1.1rem;
                color: #64748B;
                max-width: 600px;
                margin: 0 auto 50px;
            }

            .feature-card {
                background: white;
                padding: 40px 30px;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.05);
                text-align: center;
                height: 100%;
                transition: all 0.4s ease;
                border: 1px solid transparent;
                position: relative;
                overflow: hidden;
            }

            .feature-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #1E3A8A, #3B82F6);
                transform: scaleX(0);
                transition: transform 0.4s ease;
            }

            .feature-card:hover {
                transform: translateY(-12px);
                box-shadow: 0 25px 60px rgba(0, 0, 0, 0.12);
                border-color: rgba(59, 130, 246, 0.2);
            }

            .feature-card:hover::before {
                transform: scaleX(1);
            }

            .feature-icon {
                width: 80px;
                height: 80px;
                background: linear-gradient(135deg, #E0E7FF, #C7D2FE);
                color: #1E3A8A;
                border-radius: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                margin: 0 auto 24px;
                transition: all 0.4s ease;
            }

            .feature-card:hover .feature-icon {
                background: linear-gradient(135deg, #1E3A8A, #3B82F6);
                color: white;
                transform: scale(1.1) rotate(-5deg);
            }

            .feature-title {
                font-size: 1.3rem;
                font-weight: 700;
                color: #0F172A;
                margin-bottom: 12px;
            }

            .feature-description {
                color: #64748B;
                line-height: 1.7;
            }

            /* CTA Section */
            .cta-section {
                padding: 100px 0;
                background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                position: relative;
                overflow: hidden;
            }

            .cta-section::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -20%;
                width: 500px;
                height: 500px;
                background: rgba(255, 255, 255, 0.05);
                border-radius: 50%;
            }

            .cta-section::after {
                content: '';
                position: absolute;
                bottom: -30%;
                left: -10%;
                width: 400px;
                height: 400px;
                background: rgba(255, 255, 255, 0.03);
                border-radius: 50%;
            }

            .cta-content {
                position: relative;
                z-index: 1;
                text-align: center;
                color: white;
            }

            .cta-title {
                font-size: 2.8rem;
                font-weight: 800;
                margin-bottom: 20px;
            }

            .cta-subtitle {
                font-size: 1.15rem;
                opacity: 0.9;
                margin-bottom: 40px;
                max-width: 500px;
                margin-left: auto;
                margin-right: auto;
            }

            .btn-cta {
                padding: 18px 45px;
                font-size: 1.1rem;
                font-weight: 700;
                border-radius: 50px;
                background: white;
                color: #1E3A8A;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            }

            .btn-cta:hover {
                transform: translateY(-4px) scale(1.02);
                box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
                color: #1E3A8A;
            }

            /* Footer */
            .footer-premium {
                background: linear-gradient(180deg, #0F172A 0%, #1E293B 100%);
                color: #94A3B8;
                padding: 60px 0 30px;
            }

            .footer-brand {
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 16px;
            }

            .footer-brand img {
                width: 45px;
                height: 45px;
                border-radius: 10px;
            }

            .footer-brand span {
                font-size: 1.4rem;
                font-weight: 700;
                color: white;
            }

            .footer-description {
                font-size: 0.95rem;
                line-height: 1.7;
                margin-bottom: 20px;
            }

            .footer-title {
                font-size: 1rem;
                font-weight: 700;
                color: white;
                margin-bottom: 20px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .footer-links {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .footer-links li {
                margin-bottom: 12px;
            }

            .footer-links a {
                color: #94A3B8;
                text-decoration: none;
                transition: all 0.3s;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .footer-links a:hover {
                color: white;
                transform: translateX(5px);
            }

            .footer-contact p {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 12px;
            }

            .footer-contact i {
                color: #3B82F6;
                width: 20px;
            }

            .footer-bottom {
                border-top: 1px solid #334155;
                margin-top: 40px;
                padding-top: 25px;
                text-align: center;
                font-size: 0.9rem;
            }

            .social-links {
                display: flex;
                gap: 12px;
                margin-top: 20px;
            }

            .social-links a {
                width: 40px;
                height: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-decoration: none;
                transition: all 0.3s;
            }

            .social-links a:hover {
                background: #3B82F6;
                transform: translateY(-3px);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .hero-section {
                    min-height: auto;
                    padding: 120px 0 80px;
                }

                .hero-title {
                    font-size: 2.8rem;
                }

                .stats-container {
                    padding: 35px;
                }

                .feature-card {
                    padding: 30px 25px;
                }
            }

            @media (max-width: 768px) {
                .navbar-custom {
                    padding: 0.6rem 0;
                }

                .navbar-brand span {
                    font-size: 1.2rem;
                }

                .hero-section {
                    padding: 100px 0 60px;
                    background-attachment: scroll;
                }

                .hero-badge {
                    font-size: 0.75rem;
                    padding: 8px 14px;
                }

                .hero-title {
                    font-size: 2rem;
                    line-height: 1.2;
                }

                .hero-subtitle {
                    font-size: 0.95rem;
                    padding: 0 10px;
                }

                .hero-buttons {
                    flex-direction: column;
                    align-items: center;
                    gap: 12px;
                }

                .btn-hero-primary,
                .btn-hero-secondary {
                    width: 100%;
                    max-width: 280px;
                    justify-content: center;
                    padding: 14px 28px;
                    font-size: 0.95rem;
                }

                .stats-bar {
                    margin-top: -40px;
                }

                .stats-container {
                    grid-template-columns: repeat(2, 1fr);
                    padding: 25px 20px;
                    gap: 15px;
                    border-radius: 16px;
                }

                .stat-item:not(:last-child)::after {
                    display: none;
                }

                .stat-number {
                    font-size: 1.8rem;
                }

                .stat-label {
                    font-size: 0.8rem;
                }

                .features-section {
                    padding: 60px 0;
                }

                .section-title {
                    font-size: 1.6rem;
                }

                .section-subtitle {
                    font-size: 0.95rem;
                }

                .feature-card {
                    padding: 28px 22px;
                }

                .feature-icon {
                    width: 65px;
                    height: 65px;
                    font-size: 1.6rem;
                }

                .feature-title {
                    font-size: 1.15rem;
                }

                .cta-section {
                    padding: 60px 0;
                }

                .cta-title {
                    font-size: 1.8rem;
                }

                .cta-subtitle {
                    font-size: 1rem;
                }

                .btn-cta {
                    padding: 14px 32px;
                    font-size: 1rem;
                }

                .footer-premium {
                    padding: 40px 0 25px;
                    margin-top: 50px;
                }

                .footer-brand span {
                    font-size: 1.2rem;
                }
            }

            @media (max-width: 480px) {
                .navbar-brand img {
                    width: 32px;
                    height: 32px;
                }

                .navbar-brand span {
                    font-size: 1.1rem;
                }

                .hero-section {
                    padding: 90px 0 50px;
                }

                .hero-badge {
                    font-size: 0.7rem;
                    padding: 6px 12px;
                    margin-bottom: 16px;
                }

                .hero-title {
                    font-size: 1.7rem;
                    margin-bottom: 16px;
                }

                .hero-subtitle {
                    font-size: 0.9rem;
                    margin-bottom: 28px;
                    line-height: 1.6;
                }

                .btn-hero-primary,
                .btn-hero-secondary {
                    padding: 12px 24px;
                    font-size: 0.9rem;
                    max-width: 100%;
                }

                .stats-bar {
                    margin-top: -30px;
                }

                .stats-container {
                    padding: 20px 15px;
                    gap: 12px;
                }

                .stat-number {
                    font-size: 1.5rem;
                }

                .stat-label {
                    font-size: 0.7rem;
                }

                .section-badge {
                    font-size: 0.7rem;
                    padding: 6px 14px;
                }

                .section-title {
                    font-size: 1.4rem;
                }

                .section-subtitle {
                    font-size: 0.9rem;
                }

                .feature-card {
                    padding: 24px 18px;
                }

                .feature-icon {
                    width: 55px;
                    height: 55px;
                    font-size: 1.4rem;
                    margin-bottom: 18px;
                }

                .feature-title {
                    font-size: 1.1rem;
                }

                .feature-description {
                    font-size: 0.9rem;
                }

                .cta-title {
                    font-size: 1.5rem;
                }

                .cta-subtitle {
                    font-size: 0.9rem;
                    margin-bottom: 30px;
                }

                .btn-cta {
                    padding: 12px 28px;
                    font-size: 0.9rem;
                }

                .footer-title {
                    font-size: 0.9rem;
                }

                .footer-links a {
                    font-size: 0.9rem;
                }

                .footer-contact p {
                    font-size: 0.85rem;
                }
            }

            @media (max-width: 360px) {
                .hero-title {
                    font-size: 1.5rem;
                }

                .hero-subtitle {
                    font-size: 0.85rem;
                }

                .stats-container {
                    grid-template-columns: 1fr 1fr;
                    padding: 16px 12px;
                }

                .stat-number {
                    font-size: 1.3rem;
                }
            }
        </style>
    </head>

    <body>
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
            <div class="container">
                <a class="navbar-brand" href="#">
                    <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="Logo" width="40" height="40"
                        class="rounded">
                    <span>FastWheels</span>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto align-items-center">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/vehiculos">
                                <i class="fas fa-car me-1"></i>Catálogo
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login-cliente.jsp">
                                <i class="fas fa-sign-in-alt me-1"></i>Iniciar Sesión
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login.jsp">
                                <i class="fas fa-briefcase me-1"></i>Empleados
                            </a>
                        </li>
                        <li class="nav-item ms-lg-3">
                            <a href="${pageContext.request.contextPath}/auth/registro-cliente.jsp"
                                class="btn btn-light text-primary fw-bold rounded-pill px-4 py-2">
                                Registrarse
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Hero Section -->
        <header class="hero-section">
            <div class="container hero-content">
                <div class="hero-badge">
                    <i class="fas fa-star"></i>
                    <span>Más de 10,000 clientes satisfechos</span>
                </div>
                <h1 class="hero-title">
                    El Viaje de tus Sueños<br>
                    <span>Empieza Aquí</span>
                </h1>
                <p class="hero-subtitle">
                    Alquila vehículos premium con la mejor tarifa del mercado.
                    Sin filas, sin papeleos ocultos y con soporte 24/7 para que viajes tranquilo.
                </p>
                <div class="hero-buttons">
                    <a href="${pageContext.request.contextPath}/vehiculos" class="btn-hero-primary">
                        <i class="fas fa-car"></i>
                        <span>Ver Catálogo</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/registro-cliente.jsp" class="btn-hero-secondary">
                        <i class="fas fa-user-plus"></i>
                        <span>Crear Cuenta</span>
                    </a>
                </div>
            </div>
        </header>

        <!-- Stats Section -->
        <section class="stats-bar">
            <div class="container">
                <div class="stats-container">
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <div class="stat-label">Vehículos Premium</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">10K+</div>
                        <div class="stat-label">Clientes Felices</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Soporte Disponible</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">98%</div>
                        <div class="stat-label">Satisfacción</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Section -->
        <section class="features-section">
            <div class="container">
                <div class="text-center mb-5">
                    <span class="section-badge">¿Por qué nosotros?</span>
                    <h2 class="section-title">La Experiencia FastWheels</h2>
                    <p class="section-subtitle">
                        Descubre por qué miles de clientes confían en nosotros para sus viajes
                    </p>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h3 class="feature-title">Seguro Incluido</h3>
                            <p class="feature-description">
                                Viaja tranquilo. Todos nuestros alquileres incluyen seguro básico
                                contra accidentes y robo sin costo adicional.
                            </p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-bolt"></i>
                            </div>
                            <h3 class="feature-title">Reserva en 2 Minutos</h3>
                            <p class="feature-description">
                                Nuestro proceso 100% digital te permite reservar desde cualquier
                                lugar con confirmación inmediata.
                            </p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="feature-card">
                            <div class="feature-icon">
                                <i class="fas fa-headset"></i>
                            </div>
                            <h3 class="feature-title">Soporte 24/7</h3>
                            <p class="feature-description">
                                ¿Un problema en la carretera? Nuestro equipo de asistencia
                                está disponible las 24 horas, los 7 días.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <div class="container">
                <div class="cta-content">
                    <h2 class="cta-title">¿Listo para conducir?</h2>
                    <p class="cta-subtitle">
                        Únete a más de 10,000 clientes satisfechos que eligen FastWheels
                        para sus aventuras.
                    </p>
                    <a href="${pageContext.request.contextPath}/vehiculos" class="btn-cta">
                        <i class="fas fa-rocket"></i>
                        <span>Reservar Ahora</span>
                    </a>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer class="footer-premium">
            <div class="container">
                <div class="row g-4">
                    <div class="col-lg-4 col-md-6">
                        <div class="footer-brand">
                            <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="FastWheels">
                            <span>FastWheels</span>
                        </div>
                        <p class="footer-description">
                            La plataforma líder en alquiler de vehículos premium.
                            Conectamos personas con experiencias de viaje inolvidables.
                        </p>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-6">
                        <h5 class="footer-title">Enlaces</h5>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/vehiculos"><i
                                        class="fas fa-car"></i>Catálogo</a></li>
                            <li><a href="${pageContext.request.contextPath}/auth/login-cliente.jsp"><i
                                        class="fas fa-user"></i>Mi Cuenta</a></li>
                            <li><a href="${pageContext.request.contextPath}/auth/registro-cliente.jsp"><i
                                        class="fas fa-user-plus"></i>Registrarse</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="footer-title">Accesos</h5>
                        <ul class="footer-links">
                            <li><a href="${pageContext.request.contextPath}/auth/login.jsp"><i
                                        class="fas fa-briefcase"></i>Portal Corporativo</a></li>
                            <li><a href="#"><i class="fas fa-file-contract"></i>Términos y Condiciones</a></li>
                            <li><a href="#"><i class="fas fa-lock"></i>Política de Privacidad</a></li>
                        </ul>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <h5 class="footer-title">Contacto</h5>
                        <div class="footer-contact">
                            <p><i class="fas fa-envelope"></i>soporte@fastwheels.com</p>
                            <p><i class="fas fa-phone"></i>+51 900 888 566</p>
                            <p><i class="fas fa-map-marker-alt"></i>Lima, Perú</p>
                        </div>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2025 FastWheels Rental System. Todos los derechos reservados.</p>
                </div>
            </div>
        </footer>

        <!-- WhatsApp Floating Button -->
        <a href="https://wa.me/51900888566?text=Hola,%20me%20interesa%20alquilar%20un%20vehículo" target="_blank"
            class="whatsapp-float" title="Contáctanos por WhatsApp">
            <i class="fab fa-whatsapp"></i>
        </a>

        <style>
            .whatsapp-float {
                position: fixed;
                bottom: 30px;
                right: 30px;
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, #25D366, #128C7E);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 1.8rem;
                box-shadow: 0 6px 25px rgba(37, 211, 102, 0.4);
                z-index: 1000;
                text-decoration: none;
                transition: all 0.3s;
                animation: pulse-wa 2s infinite;
            }

            .whatsapp-float:hover {
                transform: scale(1.1);
                box-shadow: 0 8px 30px rgba(37, 211, 102, 0.5);
                color: white;
            }

            @keyframes pulse-wa {

                0%,
                100% {
                    box-shadow: 0 6px 25px rgba(37, 211, 102, 0.4);
                }

                50% {
                    box-shadow: 0 6px 35px rgba(37, 211, 102, 0.6);
                }
            }

            @media (max-width: 768px) {
                .whatsapp-float {
                    bottom: 20px;
                    right: 20px;
                    width: 55px;
                    height: 55px;
                    font-size: 1.6rem;
                }
            }
        </style>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>

    </html>