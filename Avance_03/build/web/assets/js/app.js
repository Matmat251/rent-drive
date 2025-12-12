/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("loginForm");
    const registerForm = document.getElementById("registerForm");

    // Redirigir al catálogo
    loginForm.addEventListener("submit", (e) => {
        e.preventDefault(); // evita que recargue la página
        window.location.href = "client/catalogo.jsp";
    });

    registerForm.addEventListener("submit", (e) => {
        e.preventDefault();
        window.location.href = "client/catalogo.jsp";
    });
});

// ===== CATALOGO: Mostrar info del auto en un modal =====
document.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("modalAuto");
    const closeModal = document.getElementById("closeModal");
    const modalInfo = document.getElementById("modalInfo");

    // Datos de los autos
    const autos = {
        "Audi A4": {
            precio: "$90/día",
            motor: "2.0L TFSI, 190 HP",
            transmision: "Automática 7 velocidades",
            asientos: 5,
            consumo: "14 km/L",
            descripcion: "Sedán premium, elegante y con excelente confort."
        },
        "Toyota Corolla": {
            precio: "$50/día",
            motor: "1.8L, 140 HP",
            transmision: "CVT automática",
            asientos: 5,
            consumo: "16 km/L",
            descripcion: "Confiable, eficiente y perfecto para ciudad."
        },
        "Honda Civic": {
            precio: "$75/día",
            motor: "2.0L, 158 HP",
            transmision: "Automática CVT",
            asientos: 5,
            consumo: "15 km/L",
            descripcion: "Deportivo y práctico con diseño moderno."
        },
        "Ford Explorer": {
            precio: "$150/día",
            motor: "3.0L V6, 365 HP",
            transmision: "Automática 10 velocidades",
            asientos: 7,
            consumo: "9 km/L",
            descripcion: "SUV espaciosa, ideal para viajes familiares."
        },
        "Mazda CX-5": {
            precio: "$100/día",
            motor: "2.5L, 187 HP",
            transmision: "Automática 6 velocidades",
            asientos: 5,
            consumo: "13 km/L",
            descripcion: "SUV con gran manejo y diseño sofisticado."
        },
        "Mercedes Benz": {
            precio: "$150/día",
            motor: "2.0L Turbo, 255 HP",
            transmision: "Automática 9 velocidades",
            asientos: 5,
            consumo: "12 km/L",
            descripcion: "Lujo, potencia y tecnología en un solo auto."
        },
        "Nissan Versa": {
            precio: "$80/día",
            motor: "1.6L, 118 HP",
            transmision: "Manual 5 velocidades",
            asientos: 5,
            consumo: "18 km/L",
            descripcion: "Económico, compacto y eficiente para ciudad."
        },
        "BMW serie 3": {
            precio: "$75/día",
            motor: "2.0L Turbo, 255 HP",
            transmision: "Automática 8 velocidades",
            asientos: 5,
            consumo: "13 km/L",
            descripcion: "Sedán premium con alto rendimiento."
        },
        "Lamborghini huracan Evo": {
            precio: "$1000/día",
            motor: "5.2L V10, 640 HP",
            transmision: "Automática 7 velocidades",
            asientos: 2,
            consumo: "7 km/L",
            descripcion: "Superdeportivo italiano, lujo y velocidad extrema."
        },
        "Ferrari F8 Tributo": {
            precio: "$1500/día",
            motor: "V8 3.9L Twin Turbo, 710 HP",
            transmision: "Automática 7 velocidades",
            asientos: 2,
            consumo: "6 km/L",
            descripcion: "Superdeportivo italiano con diseño agresivo y desempeño extremo."
        },
        "Rolls-Royce Phantom": {
            precio: "$2000/día",
            motor: "V12 6.75L, 563 HP",
            transmision: "Automática 8 velocidades",
            asientos: 5,
            consumo: "7 km/L",
            descripcion: "El máximo lujo británico, confort incomparable y tecnología de primera."
        },
        "Tesla Model Q 2025": {
            precio: "$1200/día",
            motor: "Doble motor eléctrico, 600 HP",
            transmision: "Automática eléctrica",
            asientos: 5,
            consumo: "Autonomía de 600 km",
            descripcion: "Sedán eléctrico futurista con conducción autónoma y tecnología avanzada."
        }
    };

    // Detectar clicks en los botones "Reservar"
    document.querySelectorAll(".card button").forEach((btn) => {
        btn.addEventListener("click", () => {
            const nombreAuto = btn.parentElement.querySelector("h3").innerText.trim();
            const auto = autos[nombreAuto];
            if (!auto) return;

            modalInfo.innerHTML = `
                <h2>${nombreAuto}</h2>
                <p><strong>Precio:</strong> ${auto.precio}</p>
                <ul>
                    <li><strong>Motor:</strong> ${auto.motor}</li>
                    <li><strong>Transmisión:</strong> ${auto.transmision}</li>
                    <li><strong>Asientos:</strong> ${auto.asientos}</li>
                    <li><strong>Consumo:</strong> ${auto.consumo}</li>
                </ul>
                <p>${auto.descripcion}</p>
                <button class="btn-primary">Reservar este auto</button>
            `;
            modal.style.display = "flex";

            modalInfo.querySelector(".btn-primary").addEventListener("click", () => {
    modalInfo.innerHTML = `
        <form id="formReserva" class="form-section" style="margin-top:20px; background:#f8fafc; border-radius:12px; padding:24px; box-shadow:0 2px 8px rgba(30,58,138,0.10);">
            <h3 style="text-align:center; color:#1E3A8A;">Formulario de Reserva</h3>
            <input type="text" name="nombre" placeholder="Nombre completo" required style="margin-bottom:12px;">
            <input type="text" name="dni" placeholder="DNI" required pattern="\\d{8}" style="margin-bottom:12px;">
            <input type="number" name="edad" placeholder="Edad" required min="18" style="margin-bottom:12px;">
            <label style="display:flex;align-items:center;gap:8px;margin-bottom:12px;">
                <input type="checkbox" name="brevete" required> Confirmo que tengo brevete
            </label>
            <label style="margin-bottom:12px;">Fecha inicio: <input type="date" name="fechaInicio" required></label>
            <label style="margin-bottom:12px;">Fecha fin: <input type="date" name="fechaFin" required></label>
            <select name="pago" required style="margin-bottom:16px;">
                <option value="">Método de pago</option>
                <option value="Tarjeta">Tarjeta</option>
                <option value="Efectivo">Efectivo</option>
                <option value="Yape/Plin">Yape/Plin</option>
            </select>
            <button type="submit" class="btn-primary" style="width:100%;margin-top:8px;">Confirmar Reserva</button>
        </form>
        <div id="reservaError" style="color:#F44336;margin-top:10px;text-align:center;"></div>
    `;
    const form = document.getElementById("formReserva");
    form.addEventListener("submit", function(e) {
        e.preventDefault();
        const nombre = form.nombre.value.trim();
        const dni = form.dni.value.trim();
        const edad = parseInt(form.edad.value, 10);
        const brevete = form.brevete.checked;
        const fechaInicio = form.fechaInicio.value;
        const fechaFin = form.fechaFin.value;
        const pago = form.pago.value;
        const errorDiv = document.getElementById("reservaError");

        // Validaciones
        if (edad < 18) {
            errorDiv.textContent = "Debes tener al menos 18 años.";
            return;
        }
        if (!brevete) {
            errorDiv.textContent = "Debes confirmar que tienes brevete.";
            return;
        }
        if (!fechaInicio || !fechaFin || fechaFin < fechaInicio) {
            errorDiv.textContent = "Las fechas no son válidas.";
            return;
        }
        if (!nombre || !dni.match(/^\d{8}$/)) {
            errorDiv.textContent = "Ingresa un nombre y DNI válidos.";
            return;
        }
        if (!pago) {
            errorDiv.textContent = "Selecciona un método de pago.";
            return;
        }

        // Guardar reserva en localStorage
        const reserva = {
            auto: nombreAuto,
            foto: btn.parentElement.querySelector("img").src,
            nombreCliente: nombre,
            dni,
            edad,
            brevete,
            fechaInicio,
            fechaFin,
            pago,
            estado: "Activa"
        };
        let reservas = JSON.parse(localStorage.getItem("reservas") || "[]");
        reservas.push(reserva);
        localStorage.setItem("reservas", JSON.stringify(reservas));
        errorDiv.style.color = "#1E3A8A";
        errorDiv.textContent = "¡Reserva confirmada!";
        setTimeout(() => modal.style.display = "none", 1200);
    });
});

        });
    });

    // Cerrar modal
    closeModal.addEventListener("click", () => modal.style.display = "none");
    window.addEventListener("click", (e) => {
        if (e.target === modal) modal.style.display = "none";
    });
});


// MIS RESERVAS: Mostrar y cancelar reservas
document.addEventListener("DOMContentLoaded", () => {
    const reservasContainer = document.getElementById("reservasContainer");
    if (reservasContainer) {
        let reservas = JSON.parse(localStorage.getItem("reservas") || "[]");
        if (reservas.length === 0) {
            reservasContainer.innerHTML = "<p style='text-align:center;'>No tienes reservas.</p>";
            return;
        }

        // Precios por auto 
        const preciosPorAuto = {
            "Audi A4": 90,
            "Toyota Corolla": 50,
            "Honda Civic": 75,
            "Ford Explorer": 150,
            "Mazda CX-5": 100,
            "Mercedes Benz": 150,
            "Nissan Versa": 80,
            "BMW serie 3": 75,
            "Lamborghini huracan Evo": 1000,
            "Ferrari F8 Tributo": 1500,
            "Rolls-Royce Phantom": 2000,
            "Tesla Model Q 2025": 1200
        };

        let tabla = `
            <table style="width:100%;border-collapse:collapse;">
                <thead>
                    <tr style="background:#1E3A8A;color:#fff;">
                        <th>Auto</th>
                        <th>Fechas</th>
                        <th>Cliente</th>
                        <th>Precio Total</th>
                        <th>Estado</th>
                        <th>Acción</th>
                    </tr>
                </thead>
                <tbody>
        `;
        reservas.forEach((r, i) => {
            // Calcular días de reserva
            const fechaInicio = new Date(r.fechaInicio);
            const fechaFin = new Date(r.fechaFin);
            const dias = Math.max(1, Math.ceil((fechaFin - fechaInicio) / (1000 * 60 * 60 * 24)) + 1);
            const precioPorDia = preciosPorAuto[r.auto] || 0;
            const precioTotal = precioPorDia * dias;

            tabla += `
                <tr style="background:#fff;text-align:center;">
                    <td>
                        <img src="${r.foto}" alt="${r.auto}" style="max-width:80px;border-radius:8px;display:block;margin:auto;">
                        <div style="font-weight:600;">${r.auto}</div>
                    </td>
                    <td>
                        ${r.fechaInicio} <br> ${r.fechaFin}
                    </td>
                    <td>
                        ${r.nombreCliente}<br>
                        DNI: ${r.dni}<br>
                        Edad: ${r.edad}<br>
                        Brevete: ${r.brevete ? "Sí" : "No"}
                    </td>
                    <td style="font-weight:600;">$${precioTotal}</td>
                    <td>${r.estado || "Confirmada"}</td>
                    <td>
                        <button class="btn-primary" data-index="${i}">Cancelar</button>
                    </td>
                </tr>
            `;
        });
        tabla += "</tbody></table>";
        reservasContainer.innerHTML = tabla;

        // Cancelar reserva
        reservasContainer.querySelectorAll(".btn-primary").forEach(btn => {
            btn.addEventListener("click", function() {
                const idx = parseInt(btn.getAttribute("data-index"));
                reservas.splice(idx, 1);
                localStorage.setItem("reservas", JSON.stringify(reservas));
                location.reload();
            });
        });
    }
});