<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Obtener el ID de la reserva desde el atributo de sesión o parámetro
    String idReservaParam = request.getParameter("idReserva");
    if (idReservaParam == null) {
        idReservaParam = session.getAttribute("idReserva") != null ? 
                        session.getAttribute("idReserva").toString() : "";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | Reserva Exitosa</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        .success-page {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8fafc;
        }

        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
            max-width: 500px;
            width: 100%;
            padding: 50px 30px;
            text-align: center;
            border: none;
            position: relative;
            overflow: hidden;
        }

        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 6px;
            background: linear-gradient(90deg, #10B981, #34D399);
        }

        .icon-container {
            width: 100px;
            height: 100px;
            background-color: #D1FAE5;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            animation: popIn 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }

        .icon-check {
            font-size: 3.5rem;
            color: #059669;
        }

        @keyframes popIn {
            0% { transform: scale(0); opacity: 0; }
            80% { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }

        h2 {
            color: #1F2937;
            font-weight: 800;
            margin-bottom: 15px;
        }

        p {
            color: #6B7280;
            font-size: 1.1rem;
            line-height: 1.6;
            margin-bottom: 35px;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
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
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/perfil-cliente">Mi Perfil</a></li>
                    <li class="nav-item ms-lg-3">
                        <!-- <a href="${pageContext.request.contextPath}/logout-cliente" class="btn btn-logout text-decoration-none">
                            <i class="fas fa-sign-out-alt me-1"></i> Cerrar Sesión
                        </a>-->
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="success-page pt-5">
        <div class="container d-flex justify-content-center">
            
            <div class="card success-card">
                <div class="icon-container">
                    <i class="fas fa-check icon-check"></i>
                </div>
                
                <h2>¡Reserva Confirmada!</h2>
                
                <p>
                    Tu solicitud ha sido procesada con éxito. <br>
                    Hemos enviado los detalles a tu correo electrónico.
                </p>

                <div class="d-grid gap-3">
                    <a href="${pageContext.request.contextPath}/client/mis-reservas.jsp" class="btn btn-primary btn-lg fw-bold shadow-sm">
                        <i class="fas fa-ticket-alt me-2"></i> Ver Mis Reservas
                    </a>
                    
                    <% if (!idReservaParam.isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/descargar-boleta?idReserva=<%= idReservaParam %>" 
                       class="btn btn-primary btn-lg fw-bold shadow-sm"
                       target="_blank">
                        <i class="fas fa-download me-2"></i> Descargar Boleta PDF
                    </a>
                    <% } %>
                    
                    <a href="${pageContext.request.contextPath}/vehiculos" class="btn btn-outline-secondary fw-bold border-2">
                        Volver al Catálogo
                    </a>
                </div>
                
                <div class="mt-4 text-muted small">
                    <i class="fas fa-info-circle me-1"></i> Puedes cancelar sin costo hasta 24h antes.
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