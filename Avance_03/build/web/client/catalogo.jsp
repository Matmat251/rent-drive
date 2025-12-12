<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="java.util.List" %>
        <%@ page import="capaEntidad.Vehiculo" %>
            <%@ page import="capaEntidad.Cliente" %>
                <%@ page import="capaDatos.VehiculoDAO" %>
                    <% Cliente clienteLogueado=(Cliente) session.getAttribute("cliente"); boolean
                        estaLogueado=(clienteLogueado !=null); String fechaFiltro=request.getParameter("fecha"); String
                        tipoFiltro=request.getParameter("tipo"); VehiculoDAO vehiculoDAO=new VehiculoDAO();
                        List<Vehiculo> vehiculos;

                        if ((fechaFiltro != null && !fechaFiltro.isEmpty()) || (tipoFiltro != null &&
                        !tipoFiltro.isEmpty())) {
                        vehiculos = vehiculoDAO.filtrarVehiculosCatalogo(tipoFiltro, fechaFiltro);
                        } else {
                        vehiculos = vehiculoDAO.listarVehiculosDisponibles();
                        }

                        int total = (vehiculos != null) ? vehiculos.size() : 0;
                        %>
                        <!DOCTYPE html>
                        <html lang="es">

                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0">
                            <title>Catálogo | FastWheels</title>
                            <link rel="icon" type="image/jpeg"
                                href="${pageContext.request.contextPath}/assets/img/Logo.jpg">
                            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                                rel="stylesheet">
                            <link rel="stylesheet"
                                href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                            <style>
                                body {
                                    background: linear-gradient(180deg, #F8FAFC 0%, #E2E8F0 100%);
                                    min-height: 100vh;
                                }

                                .catalog-hero {
                                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                                    padding: 50px 0 80px;
                                    margin-bottom: -40px;
                                    position: relative;
                                }

                                .catalog-hero h1 {
                                    color: white;
                                    font-weight: 800;
                                    font-size: 2.5rem;
                                }

                                .catalog-hero p {
                                    color: rgba(255, 255, 255, 0.9);
                                }

                                .result-badge {
                                    background: rgba(255, 255, 255, 0.15);
                                    border: 1px solid rgba(255, 255, 255, 0.2);
                                    color: white;
                                    padding: 10px 20px;
                                    border-radius: 50px;
                                    font-weight: 600;
                                    display: inline-flex;
                                    align-items: center;
                                    gap: 8px;
                                }

                                .filter-card {
                                    background: white;
                                    border-radius: 20px;
                                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
                                    padding: 30px;
                                    position: relative;
                                    z-index: 10;
                                }

                                .filter-group {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                                    gap: 20px;
                                    align-items: end;
                                }

                                .filter-item label {
                                    font-size: 0.8rem;
                                    font-weight: 700;
                                    color: #64748B;
                                    text-transform: uppercase;
                                    margin-bottom: 8px;
                                    display: block;
                                }

                                .filter-item .form-control,
                                .filter-item .form-select {
                                    border: 2px solid #E2E8F0;
                                    border-radius: 12px;
                                    padding: 12px 16px;
                                }

                                .filter-item .form-control:focus,
                                .filter-item .form-select:focus {
                                    border-color: #3B82F6;
                                    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
                                }

                                .btn-search {
                                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                                    color: white;
                                    border: none;
                                    padding: 14px 28px;
                                    border-radius: 12px;
                                    font-weight: 700;
                                }

                                .btn-search:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 8px 25px rgba(30, 58, 138, 0.35);
                                    color: white;
                                }

                                .btn-clear {
                                    background: #F1F5F9;
                                    color: #64748B;
                                    border: none;
                                    padding: 14px 20px;
                                    border-radius: 12px;
                                    font-weight: 600;
                                    text-decoration: none;
                                }

                                .btn-clear:hover {
                                    background: #E2E8F0;
                                    color: #1E293B;
                                }

                                .vehicles-grid {
                                    display: grid;
                                    grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
                                    gap: 30px;
                                    padding: 40px 0;
                                }

                                .vehicle-card {
                                    background: white;
                                    border-radius: 20px;
                                    overflow: hidden;
                                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                                    transition: all 0.4s;
                                    display: flex;
                                    flex-direction: column;
                                }

                                .vehicle-card:hover {
                                    transform: translateY(-12px);
                                    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
                                }

                                .vehicle-image {
                                    position: relative;
                                    height: 220px;
                                    background: #F1F5F9;
                                    overflow: hidden;
                                }

                                .vehicle-image img {
                                    width: 100%;
                                    height: 100%;
                                    object-fit: cover;
                                    transition: transform 0.6s;
                                }

                                .vehicle-card:hover .vehicle-image img {
                                    transform: scale(1.08);
                                }

                                .vehicle-badge {
                                    position: absolute;
                                    top: 15px;
                                    left: 15px;
                                    padding: 8px 16px;
                                    border-radius: 50px;
                                    font-size: 0.75rem;
                                    font-weight: 700;
                                    text-transform: uppercase;
                                    color: white;
                                    z-index: 2;
                                }

                                .badge-available {
                                    background: linear-gradient(135deg, #10B981, #059669);
                                }

                                .badge-rented {
                                    background: linear-gradient(135deg, #EF4444, #DC2626);
                                }

                                .badge-maintenance {
                                    background: linear-gradient(135deg, #F59E0B, #D97706);
                                }

                                .vehicle-content {
                                    padding: 24px;
                                    flex-grow: 1;
                                    display: flex;
                                    flex-direction: column;
                                }

                                .vehicle-type {
                                    font-size: 0.75rem;
                                    font-weight: 700;
                                    color: #3B82F6;
                                    text-transform: uppercase;
                                    margin-bottom: 6px;
                                }

                                .vehicle-title {
                                    font-size: 1.35rem;
                                    font-weight: 800;
                                    color: #0F172A;
                                    margin-bottom: 16px;
                                }

                                .vehicle-specs {
                                    display: flex;
                                    gap: 16px;
                                    padding: 16px 0;
                                    border-top: 1px solid #E2E8F0;
                                    border-bottom: 1px solid #E2E8F0;
                                    margin-bottom: 20px;
                                }

                                .spec-item {
                                    display: flex;
                                    align-items: center;
                                    gap: 6px;
                                    font-size: 0.85rem;
                                    color: #64748B;
                                }

                                .spec-item i {
                                    color: #F97316;
                                }

                                .vehicle-footer {
                                    display: flex;
                                    justify-content: space-between;
                                    align-items: center;
                                    margin-top: auto;
                                }

                                .price-value {
                                    font-size: 1.8rem;
                                    font-weight: 800;
                                    color: #1E3A8A;
                                }

                                .price-label {
                                    font-size: 0.85rem;
                                    color: #64748B;
                                }

                                .btn-reserve {
                                    background: linear-gradient(135deg, #1E3A8A 0%, #3B82F6 100%);
                                    color: white;
                                    border: none;
                                    padding: 12px 24px;
                                    border-radius: 12px;
                                    font-weight: 700;
                                    text-decoration: none;
                                }

                                .btn-reserve:hover {
                                    transform: translateY(-2px);
                                    box-shadow: 0 8px 25px rgba(30, 58, 138, 0.4);
                                    color: white;
                                }

                                .btn-disabled {
                                    background: #CBD5E1;
                                    color: #94A3B8;
                                    cursor: not-allowed;
                                }

                                .empty-state {
                                    text-align: center;
                                    padding: 80px 20px;
                                    background: white;
                                    border-radius: 20px;
                                }

                                .empty-state i {
                                    font-size: 4rem;
                                    color: #CBD5E1;
                                    margin-bottom: 20px;
                                }

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
                                }

                                .whatsapp-float:hover {
                                    transform: scale(1.1);
                                    color: white;
                                }

                                .footer-catalog {
                                    background: #0F172A;
                                    color: #94A3B8;
                                    padding: 30px 0;
                                    margin-top: 60px;
                                    text-align: center;
                                }

                                @media (max-width: 768px) {
                                    .catalog-hero {
                                        padding: 40px 0 70px;
                                    }

                                    .catalog-hero h1 {
                                        font-size: 1.8rem;
                                    }

                                    .filter-card {
                                        padding: 20px;
                                    }

                                    .filter-group {
                                        grid-template-columns: 1fr;
                                    }

                                    .vehicles-grid {
                                        grid-template-columns: 1fr;
                                        gap: 20px;
                                    }

                                    .whatsapp-float {
                                        bottom: 20px;
                                        right: 20px;
                                        width: 55px;
                                        height: 55px;
                                        font-size: 1.6rem;
                                    }
                                }
                            </style>
                        </head>

                        <body>
                            <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
                                <div class="container">
                                    <a class="navbar-brand d-flex align-items-center"
                                        href="${pageContext.request.contextPath}/index.jsp">
                                        <img src="${pageContext.request.contextPath}/assets/img/Logo.jpg" alt="Logo"
                                            width="40" height="40" class="rounded me-2">
                                        <span>FastWheels</span>
                                    </a>
                                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                                        data-bs-target="#navbarNav">
                                        <span class="navbar-toggler-icon"></span>
                                    </button>
                                    <div class="collapse navbar-collapse" id="navbarNav">
                                        <ul class="navbar-nav ms-auto align-items-center">
                                            <li class="nav-item"><a class="nav-link active"
                                                    href="${pageContext.request.contextPath}/vehiculos">Catálogo</a>
                                            </li>
                                            <% if (estaLogueado) { %>
                                                <li class="nav-item"><a class="nav-link"
                                                        href="${pageContext.request.contextPath}/client/mis-reservas.jsp">Mis
                                                        Reservas</a></li>
                                                <li class="nav-item"><a class="nav-link"
                                                        href="${pageContext.request.contextPath}/perfil-cliente">Mi
                                                        Perfil</a></li>
                                                <li class="nav-item ms-lg-3">
                                                    <div class="d-flex align-items-center gap-2">
                                                        <span class="text-white small d-none d-lg-block">Hola, <%=
                                                                clienteLogueado.getNombre() %></span>
                                                        <a href="${pageContext.request.contextPath}/logout-cliente"
                                                            class="btn btn-logout"><i
                                                                class="fas fa-sign-out-alt me-1"></i>Salir</a>
                                                    </div>
                                                </li>
                                                <% } else { %>
                                                    <li class="nav-item ms-lg-2"><a
                                                            href="${pageContext.request.contextPath}/auth/login-cliente.jsp"
                                                            class="nav-link">Iniciar Sesión</a></li>
                                                    <li class="nav-item ms-lg-2"><a
                                                            href="${pageContext.request.contextPath}/auth/registro-cliente.jsp"
                                                            class="btn btn-light text-primary fw-bold btn-sm rounded-pill px-3">Registrarse</a>
                                                    </li>
                                                    <% } %>
                                        </ul>
                                    </div>
                                </div>
                            </nav>

                            <section class="catalog-hero">
                                <div class="container text-center">
                                    <h1 class="mb-3">Nuestra Flota Premium</h1>
                                    <p class="lead mb-4" style="max-width: 600px; margin: 0 auto;">Descubre nuestra
                                        selección de vehículos.</p>
                                    <div class="d-flex justify-content-center flex-wrap gap-3">
                                        <span class="result-badge"><i class="fas fa-car"></i><span>
                                                <%= total %> vehículos
                                            </span></span>
                                        <% if (fechaFiltro !=null && !fechaFiltro.isEmpty()) { %>
                                            <span class="result-badge"><i class="fas fa-calendar-check"></i><span>Fecha:
                                                    <%= fechaFiltro %></span></span>
                                            <% } %>
                                    </div>
                                </div>
                            </section>

                            <div class="container">
                                <div class="filter-card">
                                    <form action="${pageContext.request.contextPath}/vehiculos" method="GET">
                                        <div class="filter-group">
                                            <div class="filter-item">
                                                <label><i class="fas fa-calendar-alt me-1"></i>Fecha de Recogida</label>
                                                <input type="date" class="form-control" name="fecha"
                                                    value="<%= (fechaFiltro != null) ? fechaFiltro : "" %>">
                                            </div>
                                            <div class="filter-item">
                                                <label><i class="fas fa-car me-1"></i>Tipo de Vehículo</label>
                                                <select class="form-select" name="tipo">
                                                    <option value="">Todos los tipos</option>
                                                    <option value="Sedan" <%="Sedan" .equals(tipoFiltro) ? "selected"
                                                        : "" %>>Sedan</option>
                                                    <option value="SUV" <%="SUV" .equals(tipoFiltro) ? "selected" : ""
                                                        %>>SUV</option>
                                                    <option value="Pickup" <%="Pickup" .equals(tipoFiltro) ? "selected"
                                                        : "" %>>Pickup</option>
                                                    <option value="Van" <%="Van" .equals(tipoFiltro) ? "selected" : ""
                                                        %>>Van</option>
                                                    <option value="Deportivo" <%="Deportivo" .equals(tipoFiltro)
                                                        ? "selected" : "" %>>Deportivo</option>
                                                </select>
                                            </div>
                                            <div class="filter-item">
                                                <label>&nbsp;</label>
                                                <div class="d-flex gap-2">
                                                    <button type="submit" class="btn-search flex-grow-1"><i
                                                            class="fas fa-search me-2"></i>Buscar</button>
                                                    <% if ((fechaFiltro !=null && !fechaFiltro.isEmpty()) || (tipoFiltro
                                                        !=null && !tipoFiltro.isEmpty())) { %>
                                                        <a href="${pageContext.request.contextPath}/vehiculos"
                                                            class="btn-clear"><i class="fas fa-times"></i></a>
                                                        <% } %>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="container">
                                <div class="vehicles-grid">
                                    <% if (vehiculos !=null && !vehiculos.isEmpty()) { for (Vehiculo v : vehiculos) {
                                        String imagen=obtenerImagenVehiculo(v.getMarca(), v.getModelo(), v.getTipo());
                                        boolean isDisponible="Disponible" .equals(v.getEstado()); String
                                        badgeClass=isDisponible ? "badge-available" : ("Alquilado".equals(v.getEstado())
                                        ? "badge-rented" : "badge-maintenance" ); String badgeText=isDisponible
                                        ? "Disponible" : v.getEstado(); String reservaUrl=request.getContextPath()
                                        + "/client/reserva-form.jsp?id=" + v.getIdVehiculo() + (fechaFiltro !=null
                                        ? "&fechaInicio=" + fechaFiltro : "" ); String loginUrl=request.getContextPath()
                                        + "/auth/login-cliente.jsp" ; %>
                                        <div class="vehicle-card">
                                            <div class="vehicle-image">
                                                <span class="vehicle-badge <%= badgeClass %>">
                                                    <%= badgeText %>
                                                </span>
                                                <img src="${pageContext.request.contextPath}/assets/img/<%= imagen %>"
                                                    alt="<%= v.getMarca() %>"
                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/default-car.jpg'">
                                            </div>
                                            <div class="vehicle-content">
                                                <span class="vehicle-type">
                                                    <%= v.getTipo() %> • <%= v.getAnio() %>
                                                </span>
                                                <h3 class="vehicle-title">
                                                    <%= v.getMarca() %>
                                                        <%= v.getModelo() %>
                                                </h3>
                                                <div class="vehicle-specs">
                                                    <span class="spec-item"><i
                                                            class="fas fa-gas-pump"></i>Gasolina</span>
                                                    <span class="spec-item"><i class="fas fa-user-friends"></i>5
                                                        Pas.</span>
                                                    <span class="spec-item"><i class="fas fa-cogs"></i>Auto</span>
                                                </div>
                                                <div class="vehicle-footer">
                                                    <div>
                                                        <span class="price-value">S/<%= v.getPrecioDiario() %></span>
                                                        <span class="price-label">por día</span>
                                                    </div>
                                                    <% if (isDisponible) { %>
                                                        <a href="<%= estaLogueado ? reservaUrl : loginUrl %>"
                                                            class="btn-reserve"><i
                                                                class="fas fa-calendar-check me-2"></i>Reservar</a>
                                                        <% } else { %>
                                                            <button class="btn-reserve btn-disabled">No
                                                                disponible</button>
                                                            <% } %>
                                                </div>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <div class="empty-state" style="grid-column: 1 / -1;">
                                                <i class="fas fa-search"></i>
                                                <h3>No encontramos vehículos</h3>
                                                <p>Intenta cambiar la fecha o el tipo.</p>
                                                <a href="${pageContext.request.contextPath}/vehiculos"
                                                    class="btn btn-primary mt-3"><i class="fas fa-redo me-2"></i>Ver
                                                    todos</a>
                                            </div>
                                            <% } %>
                                </div>
                            </div>

                            <a href="https://wa.me/51900888566?text=Hola,%20me%20interesa%20alquilar%20un%20vehículo"
                                target="_blank" class="whatsapp-float" title="WhatsApp"><i
                                    class="fab fa-whatsapp"></i></a>

                            <footer class="footer-catalog">
                                <div class="container">
                                    <p class="mb-0">&copy; 2025 FastWheels Rental System.</p>
                                </div>
                            </footer>

                            <script
                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                        </body>

                        </html>

                        <%! private String obtenerImagenVehiculo(String marca, String modelo, String tipo) { if
                            (marca==null || modelo==null) return "default-car.jpg" ; String marcaModelo=(marca + " " +
                            modelo).toLowerCase(); if (marcaModelo.contains("toyota") &&
                            marcaModelo.contains("corolla")) return "ToyotaCorolla.jpg" ; if
                            (marcaModelo.contains("hyundai") && marcaModelo.contains("tucson"))
                            return "HyundaiTucson.png" ; if (marcaModelo.contains("ford") &&
                            marcaModelo.contains("ranger")) return "FordRanger.png" ; if (marcaModelo.contains("ford")
                            && marcaModelo.contains("raptor")) return "FORD RAPTOR.png" ; if
                            (marcaModelo.contains("chevrolet") && marcaModelo.contains("spark"))
                            return "ChevroletSpark.png" ; if (marcaModelo.contains("chevrolet") &&
                            marcaModelo.contains("suburban")) return "suburban.png" ; if (marcaModelo.contains("nissan")
                            && marcaModelo.contains("versa")) return "NissanVersa.jpg" ; if
                            (marcaModelo.contains("audi") && marcaModelo.contains("a4")) return "AudiA4.jpg" ; if
                            (marcaModelo.contains("jetour") && marcaModelo.contains("x70")) return "JETOUR X70.png" ; if
                            (marcaModelo.contains("toyota") && marcaModelo.contains("corolla cross"))
                            return "corolla_cross.png" ; if (marcaModelo.contains("geely") &&
                            marcaModelo.contains("cityray")) return "GeelyCityray.png" ; if
                            (marcaModelo.contains("bmw")) return "BMW Serie 3.jpg" ; if
                            (marcaModelo.contains("explorer")) return "FordExplorer.jpg" ; if
                            (marcaModelo.contains("civic")) return "HondaCiviC.jpg" ; if
                            (marcaModelo.contains("mercedes")) return "MercedesBenz.jpg" ; if
                            (marcaModelo.contains("mazda")) return "Mazda.jpg" ; if
                            (marcaModelo.contains("lamborghini")) return "Lamborguini.jpg" ; if
                            (marcaModelo.contains("ferrari")) return "imagen10_ferrari.jpg" ; if
                            (marcaModelo.contains("rolls")) return "imagen11_Rolls Royce Phantom 2023.jpg" ; if
                            (marcaModelo.contains("tesla")) return "imagen12_Tesla Q2025.JPG" ; return
                            obtenerImagenPorTipo(tipo); } private String obtenerImagenPorTipo(String tipo) { if
                            (tipo==null) return "default-car.jpg" ; switch(tipo.toLowerCase()) { case "sedan" :
                            return "ToyotaCorolla.jpg" ; case "suv" : return "FordExplorer.jpg" ; case "pickup" :
                            return "FordRanger.png" ; case "deportivo" : return "Lamborguini.jpg" ; case "van" :
                            return "HyundaiTucson.png" ; default: return "default-car.jpg" ; } } %>