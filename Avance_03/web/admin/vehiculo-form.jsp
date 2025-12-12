<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="capaEntidad.Vehiculo" %>
<%
    
    jakarta.servlet.http.HttpSession userSession = request.getSession(false);
    Object empleado = (userSession != null) ? userSession.getAttribute("empleado") : null;
    if (empleado == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    String modo = (String) request.getAttribute("modo");
    Vehiculo vehiculo = (Vehiculo) request.getAttribute("vehiculo");
    String error = (String) request.getAttribute("error");
    
    if ("editar".equals(modo) && vehiculo == null) {
        response.sendRedirect(request.getContextPath() + "/admin/vehiculos");
        return;
    }
    
    if (vehiculo == null) {
        vehiculo = new Vehiculo();
    }
    
    // Recuperar valores del request en caso de error
    String marca = (String) request.getAttribute("marca");
    String modelo = (String) request.getAttribute("modelo");
    String anio = (String) request.getAttribute("anio");
    String matricula = (String) request.getAttribute("matricula");
    String tipo = (String) request.getAttribute("tipo");
    String precioDiario = (String) request.getAttribute("precioDiario");
    String estado = (String) request.getAttribute("estado");

    if (marca != null) vehiculo.setMarca(marca);
    if (modelo != null) vehiculo.setModelo(modelo);
    if (anio != null) vehiculo.setAnio(Integer.parseInt(anio));
    if (matricula != null) vehiculo.setMatricula(matricula);
    if (tipo != null) vehiculo.setTipo(tipo);
    if (precioDiario != null) vehiculo.setPrecioDiario(Double.parseDouble(precioDiario));
    if (estado != null) vehiculo.setEstado(estado);
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastWheels | <%= "editar".equals(modo) ? "Editar" : "Nuevo" %> Vehículo</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        /* Reutilizamos estilos del Dashboard para consistencia */
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
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            background: white;
            max-width: 800px;
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
            <li><a href="${pageContext.request.contextPath}/admin/vehiculos" class="active"><i class="fas fa-car"></i> Vehículos</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-reservas.jsp"><i class="fas fa-calendar-check"></i> Reservas</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/gestion-clientes.jsp"><i class="fas fa-users"></i> Clientes</a></li>
            <li class="menu-header small text-uppercase px-4 mt-3 mb-1 fw-bold">Reportes</li>
            <li><a href="${pageContext.request.contextPath}/admin/reportes.jsp"><i class="fas fa-chart-line"></i> Estadísticas</a></li>
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
                        <%= "editar".equals(modo) ? "<i class='fas fa-edit me-2'></i>Editar Vehículo" : "<i class='fas fa-plus-circle me-2'></i>Registrar Vehículo" %>
                    </h4>
                    <small class="text-muted"><%= "editar".equals(modo) ? "Actualiza la información de la flota" : "Añade una nueva unidad al sistema" %></small>
                </div>
                <a href="${pageContext.request.contextPath}/admin/vehiculos" class="btn btn-outline-secondary btn-sm">
                    <i class="fas fa-times me-1"></i> Cancelar
                </a>
            </div>

            <div class="form-body">
                
                <% if (error != null) { %>
                    <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <div><%= error %></div>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/admin/vehiculo" method="post" id="formVehiculo" class="row g-3 needs-validation" novalidate>
                    <input type="hidden" name="action" value="<%= modo %>">
                    <% if ("editar".equals(modo)) { %>
                        <input type="hidden" name="idVehiculo" value="<%= vehiculo.getIdVehiculo() %>">
                    <% } %>

                    <div class="col-md-6">
                        <label for="marca" class="form-label">Marca <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-tag"></i></span>
                            <input type="text" class="form-control" id="marca" name="marca" 
                                   value="<%= vehiculo.getMarca() != null ? vehiculo.getMarca() : "" %>" 
                                   placeholder="Ej: Toyota" required>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <label for="modelo" class="form-label">Modelo <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-car-side"></i></span>
                            <input type="text" class="form-control" id="modelo" name="modelo" 
                                   value="<%= vehiculo.getModelo() != null ? vehiculo.getModelo() : "" %>" 
                                   placeholder="Ej: Corolla" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="tipo" class="form-label">Tipo de Vehículo <span class="text-danger">*</span></label>
                        <select class="form-select" id="tipo" name="tipo" required>
                            <option value="">Seleccionar...</option>
                            <option value="Sedan" <%= "Sedan".equals(vehiculo.getTipo()) ? "selected" : "" %>>Sedan</option>
                            <option value="SUV" <%= "SUV".equals(vehiculo.getTipo()) ? "selected" : "" %>>SUV</option>
                            <option value="Pickup" <%= "Pickup".equals(vehiculo.getTipo()) ? "selected" : "" %>>Pickup</option>
                            <option value="Van" <%= "Van".equals(vehiculo.getTipo()) ? "selected" : "" %>>Van</option>
                            <option value="Deportivo" <%= "Deportivo".equals(vehiculo.getTipo()) ? "selected" : "" %>>Deportivo</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label for="anio" class="form-label">Año de Fabricación <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                            <input type="number" class="form-control" id="anio" name="anio" 
                                   value="<%= vehiculo.getAnio() != 0 ? vehiculo.getAnio() : "" %>" 
                                   min="2000" max="<%= java.time.Year.now().getValue() + 1 %>" required>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="matricula" class="form-label">Matrícula (Placa) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                            <input type="text" class="form-control text-uppercase" id="matricula" name="matricula" 
                                   value="<%= vehiculo.getMatricula() != null ? vehiculo.getMatricula() : "" %>" 
                                   placeholder="ABC-123" required oninput="this.value = this.value.toUpperCase()">
                        </div>
                    </div>

                    <div class="col-md-6">
                        <label for="precioDiario" class="form-label">Precio por Día ($) <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-dollar-sign"></i></span>
                            <input type="number" class="form-control" id="precioDiario" name="precioDiario" 
                                   value="<%= vehiculo.getPrecioDiario() != 0 ? String.format("%.2f", vehiculo.getPrecioDiario()).replace(",", ".") : "" %>" 
                                   min="0" step="0.01" required placeholder="0.00">
                        </div>
                    </div>

                    <div class="col-md-12">
                        <label for="estado" class="form-label">Estado Inicial <span class="text-danger">*</span></label>
                        <div class="d-flex gap-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="estado" id="estado1" value="Disponible" 
                                       <%= "Disponible".equals(vehiculo.getEstado()) || vehiculo.getEstado() == null ? "checked" : "" %>>
                                <label class="form-check-label" for="estado1"><span class="badge bg-success bg-opacity-10 text-success">Disponible</span></label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="estado" id="estado2" value="Mantenimiento" 
                                       <%= "Mantenimiento".equals(vehiculo.getEstado()) ? "checked" : "" %>>
                                <label class="form-check-label" for="estado2"><span class="badge bg-warning bg-opacity-10 text-warning text-dark">Mantenimiento</span></label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="estado" id="estado3" value="Inactivo" 
                                       <%= "Inactivo".equals(vehiculo.getEstado()) ? "checked" : "" %>>
                                <label class="form-check-label" for="estado3"><span class="badge bg-secondary">Inactivo</span></label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 mt-4 pt-3 border-top d-flex justify-content-end gap-2">
                        <a href="${pageContext.request.contextPath}/admin/vehiculos" class="btn btn-light border">Cancelar</a>
                        <button type="submit" class="btn btn-primary px-4 fw-bold">
                            <i class="fas fa-save me-2"></i> Guardar Cambios
                        </button>
                    </div>

                </form>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Auto-completar año si está vacío
        document.addEventListener('DOMContentLoaded', function() {
            const anioInput = document.getElementById('anio');
            if (!anioInput.value) {
                anioInput.value = new Date().getFullYear();
            }
        });

        // Validación de Bootstrap personalizada
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