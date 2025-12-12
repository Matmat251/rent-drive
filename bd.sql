-- ============================================================================
-- SISTEMA DE ALQUILER DE VEHÍCULOS - FastWheels
-- Base de Datos: alquiler_vehiculos
-- Versión: 1.0
-- ============================================================================

-- ============================================================================
-- SECCIÓN 1: CREACIÓN DE BASE DE DATOS
-- ============================================================================

CREATE DATABASE IF NOT EXISTS alquiler_vehiculos;
USE alquiler_vehiculos;


-- ============================================================================
-- SECCIÓN 2: CREACIÓN DE TABLAS
-- ============================================================================

-- Tabla de Clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(15) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    direccion VARCHAR(200),
    id_ciudad INT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(50) UNIQUE,
    contraseña VARCHAR(255)
);

-- Tabla de Empleados
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cargo ENUM('Administrador','Recepcionista','Mantenimiento') NOT NULL,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);

-- Tabla de Vehículos
CREATE TABLE vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio YEAR NOT NULL,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    tipo ENUM('Sedan','SUV','Pickup','Van','Deportivo') NOT NULL,
    precio_diario DECIMAL(10,2) NOT NULL,
    estado ENUM('Disponible','Alquilado','Mantenimiento','Inactivo') DEFAULT 'Disponible'
);

-- Tabla de Reservas
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_vehiculo INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado ENUM('Activa','Finalizada','Cancelada') DEFAULT 'Activa',
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE CASCADE,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

-- Tabla de Pagos
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('Efectivo','Tarjeta','Transferencia') NOT NULL,
    FOREIGN KEY (id_reserva) REFERENCES reservas(id_reserva)
);

-- Tabla de Mantenimientos
CREATE TABLE mantenimientos (
    id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    costo DECIMAL(10,2),
    fecha DATE NOT NULL,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo)
);

-- Tabla de Ciudades
CREATE TABLE IF NOT EXISTS ciudades (
    id_ciudad INT NOT NULL AUTO_INCREMENT,
    nombre_ciudad VARCHAR(100) NOT NULL,
    estado ENUM('Activa','Inactiva') DEFAULT 'Activa',
    PRIMARY KEY (id_ciudad),
    UNIQUE KEY nombre_ciudad (nombre_ciudad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Tabla de Bloqueos de Calendario
CREATE TABLE bloqueos_calendario (
    id_bloqueo INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    motivo ENUM('Mantenimiento', 'Reparación', 'No Disponible', 'Otro') NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo) ON DELETE CASCADE
);

-- Agregar FK de ciudad a clientes (si no existe)
-- ALTER TABLE clientes ADD CONSTRAINT fk_clientes_ciudad FOREIGN KEY (id_ciudad) REFERENCES ciudades(id_ciudad);


-- ============================================================================
-- SECCIÓN 3: ÍNDICES PARA OPTIMIZACIÓN
-- ============================================================================

CREATE INDEX idx_vehiculo_fechas ON bloqueos_calendario (id_vehiculo, fecha_inicio, fecha_fin);
CREATE INDEX idx_reservas_estado ON reservas (estado);
CREATE INDEX idx_vehiculos_estado ON vehiculos (estado);


-- ============================================================================
-- SECCIÓN 4: PROCEDIMIENTOS ALMACENADOS - AUTENTICACIÓN
-- ============================================================================

-- Procedimiento: Autenticar Empleado
DELIMITER $$
CREATE PROCEDURE sp_AutenticarEmpleado(
    IN p_usuario VARCHAR(50),
    IN p_contraseña VARCHAR(255)
)
BEGIN
    SELECT id_empleado, nombre, apellido, cargo, usuario 
    FROM empleados 
    WHERE usuario = p_usuario AND contraseña = p_contraseña;
END$$
DELIMITER ;

-- Procedimiento: Autenticar Cliente
DELIMITER $$
CREATE PROCEDURE sp_AutenticarCliente(
    IN p_dni VARCHAR(15),
    IN p_contraseña VARCHAR(255),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_cliente_existe INT DEFAULT 0;
    DECLARE v_contraseña_correcta INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_cliente_existe 
    FROM clientes 
    WHERE dni = p_dni;
    
    IF v_cliente_existe = 0 THEN
        SET p_resultado = 'USUARIO_NO_EXISTE';
    ELSE
        SELECT COUNT(*) INTO v_contraseña_correcta
        FROM clientes 
        WHERE dni = p_dni AND contraseña = p_contraseña;
        
        IF v_contraseña_correcta = 0 THEN
            SET p_resultado = 'CONTRASEÑA_INCORRECTA';
        ELSE
            SET p_resultado = 'EXITO';
        END IF;
    END IF;
END$$
DELIMITER ;


-- ============================================================================
-- SECCIÓN 5: PROCEDIMIENTOS ALMACENADOS - CLIENTES
-- ============================================================================

-- Procedimiento: Registrar Cliente (con ciudad)
DELIMITER $$
CREATE PROCEDURE sp_RegistrarCliente(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_dni VARCHAR(15),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(200),
    IN p_id_ciudad INT,
    IN p_contraseña VARCHAR(255),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_dni_existe INT DEFAULT 0;
    DECLARE v_telefono_existe INT DEFAULT 0;
    DECLARE v_email_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_dni_existe FROM clientes WHERE dni = p_dni;
    SELECT COUNT(*) INTO v_telefono_existe FROM clientes WHERE telefono = p_telefono AND telefono IS NOT NULL AND telefono != '';
    SELECT COUNT(*) INTO v_email_existe FROM clientes WHERE email = p_email AND email IS NOT NULL AND email != '';
    
    IF v_dni_existe > 0 THEN
        SET p_resultado = 'DNI_EXISTE';
    ELSEIF v_telefono_existe > 0 THEN
        SET p_resultado = 'TELEFONO_EXISTE';
    ELSEIF v_email_existe > 0 THEN
        SET p_resultado = 'EMAIL_EXISTE';
    ELSE
        INSERT INTO clientes (nombre, apellido, dni, telefono, email, direccion, id_ciudad, usuario, contraseña)
        VALUES (p_nombre, p_apellido, p_dni, p_telefono, p_email, p_direccion, p_id_ciudad, p_dni, p_contraseña);
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Obtener Cliente por DNI
DELIMITER $$
CREATE PROCEDURE sp_ObtenerClientePorDni(
    IN p_dni VARCHAR(15)
)
BEGIN
    SELECT id_cliente, nombre, apellido, dni, telefono, email, direccion
    FROM clientes 
    WHERE dni = p_dni;
END$$
DELIMITER ;

-- Procedimiento: Obtener Cliente Completo (con ciudad)
DELIMITER $$
CREATE PROCEDURE sp_ObtenerClienteCompleto(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.dni,
        c.telefono,
        c.email,
        c.direccion,
        c.id_ciudad,
        ci.nombre_ciudad,
        c.fecha_registro,
        c.usuario
    FROM clientes c
    LEFT JOIN ciudades ci ON c.id_ciudad = ci.id_ciudad
    WHERE c.id_cliente = p_id_cliente;
END$$
DELIMITER ;

-- Procedimiento: Actualizar Cliente (Admin)
DELIMITER $$
CREATE PROCEDURE sp_ActualizarCliente(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_dni VARCHAR(15),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(200),
    IN p_id_ciudad INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_dni_existe INT DEFAULT 0;
    DECLARE v_telefono_existe INT DEFAULT 0;
    DECLARE v_email_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_dni_existe 
    FROM clientes 
    WHERE dni = p_dni AND id_cliente != p_id_cliente;
    
    SELECT COUNT(*) INTO v_telefono_existe 
    FROM clientes 
    WHERE telefono = p_telefono AND telefono IS NOT NULL AND telefono != '' AND id_cliente != p_id_cliente;
    
    SELECT COUNT(*) INTO v_email_existe 
    FROM clientes 
    WHERE email = p_email AND email IS NOT NULL AND email != '' AND id_cliente != p_id_cliente;
    
    IF v_dni_existe > 0 THEN
        SET p_resultado = 'DNI_EXISTE';
    ELSEIF v_telefono_existe > 0 THEN
        SET p_resultado = 'TELEFONO_EXISTE';
    ELSEIF v_email_existe > 0 THEN
        SET p_resultado = 'EMAIL_EXISTE';
    ELSE
        UPDATE clientes 
        SET nombre = p_nombre,
            apellido = p_apellido,
            dni = p_dni,
            telefono = p_telefono,
            email = p_email,
            direccion = p_direccion,
            id_ciudad = p_id_ciudad
        WHERE id_cliente = p_id_cliente;
        
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Actualizar Perfil Cliente (propio perfil)
DELIMITER $$
CREATE PROCEDURE sp_ActualizarPerfilCliente(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(200),
    IN p_id_ciudad INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_telefono_existe INT DEFAULT 0;
    DECLARE v_email_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_telefono_existe 
    FROM clientes 
    WHERE telefono = p_telefono AND telefono IS NOT NULL AND telefono != '' AND id_cliente != p_id_cliente;
    
    SELECT COUNT(*) INTO v_email_existe 
    FROM clientes 
    WHERE email = p_email AND email IS NOT NULL AND email != '' AND id_cliente != p_id_cliente;
    
    IF v_telefono_existe > 0 THEN
        SET p_resultado = 'TELEFONO_EXISTE';
    ELSEIF v_email_existe > 0 THEN
        SET p_resultado = 'EMAIL_EXISTE';
    ELSE
        UPDATE clientes 
        SET nombre = p_nombre,
            apellido = p_apellido,
            telefono = p_telefono,
            email = p_email,
            direccion = p_direccion,
            id_ciudad = p_id_ciudad
        WHERE id_cliente = p_id_cliente;
        
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Buscar Clientes
DELIMITER $$
CREATE PROCEDURE sp_BuscarClientes(
    IN p_nombre VARCHAR(100),
    IN p_dni VARCHAR(15),
    IN p_email VARCHAR(100)
)
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.apellido,
        c.dni,
        c.telefono,
        c.email,
        c.direccion,
        c.id_ciudad,
        ci.nombre_ciudad,
        c.fecha_registro
    FROM clientes c
    LEFT JOIN ciudades ci ON c.id_ciudad = ci.id_ciudad
    WHERE 
        (p_nombre IS NULL OR c.nombre LIKE CONCAT('%', p_nombre, '%') OR c.apellido LIKE CONCAT('%', p_nombre, '%'))
        AND (p_dni IS NULL OR c.dni = p_dni)
        AND (p_email IS NULL OR c.email LIKE CONCAT('%', p_email, '%'))
    ORDER BY c.fecha_registro DESC;
END$$
DELIMITER ;


-- ============================================================================
-- SECCIÓN 6: PROCEDIMIENTOS ALMACENADOS - VEHÍCULOS
-- ============================================================================

-- Procedimiento: Obtener Vehículos Disponibles
DELIMITER $$
CREATE PROCEDURE sp_ObtenerVehiculosDisponibles()
BEGIN
    SELECT 
        id_vehiculo, 
        marca, 
        modelo, 
        anio, 
        matricula, 
        tipo, 
        precio_diario,
        estado
    FROM vehiculos 
    WHERE estado = 'Disponible';
END$$
DELIMITER ;

-- Procedimiento: Listar Todos los Vehículos
DELIMITER $$
CREATE PROCEDURE sp_ListarVehiculos()
BEGIN
    SELECT id_vehiculo, marca, modelo, anio, matricula, tipo, precio_diario, estado
    FROM vehiculos
    ORDER BY id_vehiculo DESC;
END$$
DELIMITER ;

-- Procedimiento: Obtener Vehículo por ID
DELIMITER $$
CREATE PROCEDURE sp_ObtenerVehiculoPorId(
    IN p_id_vehiculo INT
)
BEGIN
    SELECT id_vehiculo, marca, modelo, anio, matricula, tipo, precio_diario, estado
    FROM vehiculos
    WHERE id_vehiculo = p_id_vehiculo;
END$$
DELIMITER ;

-- Procedimiento: Crear Vehículo
DELIMITER $$
CREATE PROCEDURE sp_CrearVehiculo(
    IN p_marca VARCHAR(50),
    IN p_modelo VARCHAR(50),
    IN p_anio YEAR,
    IN p_matricula VARCHAR(20),
    IN p_tipo ENUM('Sedan','SUV','Pickup','Van','Deportivo'),
    IN p_precio_diario DECIMAL(10,2),
    IN p_estado ENUM('Disponible','Alquilado','Mantenimiento','Inactivo'),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_matricula_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_matricula_existe 
    FROM vehiculos 
    WHERE matricula = p_matricula;
    
    IF v_matricula_existe > 0 THEN
        SET p_resultado = 'MATRICULA_EXISTE';
    ELSE
        INSERT INTO vehiculos (marca, modelo, anio, matricula, tipo, precio_diario, estado)
        VALUES (p_marca, p_modelo, p_anio, p_matricula, p_tipo, p_precio_diario, p_estado);
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Actualizar Vehículo
DELIMITER $$
CREATE PROCEDURE sp_ActualizarVehiculo(
    IN p_id_vehiculo INT,
    IN p_marca VARCHAR(50),
    IN p_modelo VARCHAR(50),
    IN p_anio YEAR,
    IN p_matricula VARCHAR(20),
    IN p_tipo ENUM('Sedan','SUV','Pickup','Van','Deportivo'),
    IN p_precio_diario DECIMAL(10,2),
    IN p_estado ENUM('Disponible','Alquilado','Mantenimiento','Inactivo'),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_matricula_existe INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_matricula_existe 
    FROM vehiculos 
    WHERE matricula = p_matricula AND id_vehiculo != p_id_vehiculo;
    
    IF v_matricula_existe > 0 THEN
        SET p_resultado = 'MATRICULA_EXISTE';
    ELSE
        UPDATE vehiculos 
        SET marca = p_marca,
            modelo = p_modelo,
            anio = p_anio,
            matricula = p_matricula,
            tipo = p_tipo,
            precio_diario = p_precio_diario,
            estado = p_estado
        WHERE id_vehiculo = p_id_vehiculo;
        
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Eliminar Vehículo
DELIMITER $$
CREATE PROCEDURE sp_EliminarVehiculo(
    IN p_id_vehiculo INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_tiene_reservas INT DEFAULT 0;
    
    SELECT COUNT(*) INTO v_tiene_reservas 
    FROM reservas 
    WHERE id_vehiculo = p_id_vehiculo;
    
    IF v_tiene_reservas > 0 THEN
        -- Eliminar pagos asociados
        DELETE FROM pagos 
        WHERE id_reserva IN (
            SELECT id_reserva FROM reservas WHERE id_vehiculo = p_id_vehiculo
        );
        -- Eliminar reservas
        DELETE FROM reservas WHERE id_vehiculo = p_id_vehiculo;
    END IF;
    
    DELETE FROM vehiculos WHERE id_vehiculo = p_id_vehiculo;
    SET p_resultado = 'EXITO';
END$$
DELIMITER ;

-- Procedimiento: Cambiar Estado de Vehículo
DELIMITER $$
CREATE PROCEDURE sp_CambiarEstadoVehiculo(
    IN p_id_vehiculo INT,
    IN p_estado ENUM('Disponible','Alquilado','Mantenimiento','Inactivo'),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    UPDATE vehiculos 
    SET estado = p_estado 
    WHERE id_vehiculo = p_id_vehiculo;
    
    SET p_resultado = 'EXITO';
END$$
DELIMITER ;


-- ============================================================================
-- SECCIÓN 7: PROCEDIMIENTOS ALMACENADOS - RESERVAS
-- ============================================================================

-- Procedimiento: Crear Reserva Real
DELIMITER $$
CREATE PROCEDURE sp_CrearReservaReal(
    IN p_id_cliente INT,
    IN p_id_vehiculo INT, 
    IN p_id_empleado INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_metodo_pago ENUM('Efectivo','Tarjeta','Transferencia'),
    IN p_nombre_cliente VARCHAR(100),
    IN p_dni_cliente VARCHAR(15),
    IN p_telefono_cliente VARCHAR(20),
    IN p_email_cliente VARCHAR(100),
    OUT p_id_reserva INT
)
BEGIN
    DECLARE v_dias INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_precio_diario DECIMAL(10,2);
    
    SET v_dias = DATEDIFF(p_fecha_fin, p_fecha_inicio);
    IF v_dias < 1 THEN SET v_dias = 1; END IF;
    
    SELECT precio_diario INTO v_precio_diario 
    FROM vehiculos WHERE id_vehiculo = p_id_vehiculo;
    
    SET v_total = v_dias * v_precio_diario;
    
    INSERT INTO reservas (id_cliente, id_vehiculo, id_empleado, fecha_inicio, fecha_fin, estado)
    VALUES (p_id_cliente, p_id_vehiculo, p_id_empleado, p_fecha_inicio, p_fecha_fin, 'Activa');
    
    SET p_id_reserva = LAST_INSERT_ID();
    
    INSERT INTO pagos (id_reserva, monto, metodo_pago)
    VALUES (p_id_reserva, v_total, p_metodo_pago);
    
    UPDATE vehiculos SET estado = 'Alquilado' WHERE id_vehiculo = p_id_vehiculo;
END$$
DELIMITER ;

-- Procedimiento: Obtener Reservas por Cliente
DELIMITER $$
CREATE PROCEDURE sp_ObtenerReservasPorCliente(
    IN p_dni_cliente VARCHAR(15)
)
BEGIN
    SELECT 
        r.id_reserva,
        v.marca,
        v.modelo, 
        r.fecha_inicio,
        r.fecha_fin,
        DATEDIFF(r.fecha_fin, r.fecha_inicio) as dias,
        p.monto as total,
        p.metodo_pago,
        r.estado,
        c.nombre as nombre_cliente,
        c.dni
    FROM reservas r
    JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN pagos p ON r.id_reserva = p.id_reserva
    JOIN clientes c ON r.id_cliente = c.id_cliente
    WHERE c.dni = p_dni_cliente
    ORDER BY r.fecha_inicio DESC;
END$$
DELIMITER ;

-- Procedimiento: Cancelar Reserva
DELIMITER $$
CREATE PROCEDURE sp_CancelarReserva(
    IN p_id_reserva INT
)
BEGIN
    DECLARE v_id_vehiculo INT;
    
    SELECT id_vehiculo INTO v_id_vehiculo 
    FROM reservas WHERE id_reserva = p_id_reserva;
    
    UPDATE reservas SET estado = 'Cancelada' WHERE id_reserva = p_id_reserva;
    UPDATE vehiculos SET estado = 'Disponible' WHERE id_vehiculo = v_id_vehiculo;
END$$
DELIMITER ;

-- Procedimiento: Listar Todas las Reservas
DELIMITER $$
CREATE PROCEDURE sp_ListarTodasReservas()
BEGIN
    SELECT 
        r.id_reserva,
        c.nombre as cliente_nombre,
        c.apellido as cliente_apellido,
        c.dni as cliente_dni,
        v.marca as vehiculo_marca,
        v.modelo as vehiculo_modelo,
        v.matricula as vehiculo_matricula,
        r.fecha_inicio,
        r.fecha_fin,
        DATEDIFF(r.fecha_fin, r.fecha_inicio) as dias,
        p.monto as total,
        p.metodo_pago,
        r.estado,
        e.nombre as empleado_nombre,
        e.apellido as empleado_apellido
    FROM reservas r
    JOIN clientes c ON r.id_cliente = c.id_cliente
    JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN pagos p ON r.id_reserva = p.id_reserva
    JOIN empleados e ON r.id_empleado = e.id_empleado
    ORDER BY r.fecha_inicio DESC;
END$$
DELIMITER ;

-- Procedimiento: Obtener Detalles de Reserva
DELIMITER $$
CREATE PROCEDURE sp_ObtenerDetallesReserva(
    IN p_id_reserva INT
)
BEGIN
    SELECT 
        r.id_reserva,
        c.id_cliente,
        c.nombre as cliente_nombre,
        c.apellido as cliente_apellido,
        c.dni as cliente_dni,
        c.telefono as cliente_telefono,
        c.email as cliente_email,
        v.id_vehiculo,
        v.marca as vehiculo_marca,
        v.modelo as vehiculo_modelo,
        v.matricula as vehiculo_matricula,
        v.tipo as vehiculo_tipo,
        v.precio_diario,
        r.fecha_inicio,
        r.fecha_fin,
        DATEDIFF(r.fecha_fin, r.fecha_inicio) as dias,
        p.monto as total,
        p.metodo_pago,
        r.estado,
        e.nombre as empleado_nombre,
        e.apellido as empleado_apellido
    FROM reservas r
    JOIN clientes c ON r.id_cliente = c.id_cliente
    JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN pagos p ON r.id_reserva = p.id_reserva
    JOIN empleados e ON r.id_empleado = e.id_empleado
    WHERE r.id_reserva = p_id_reserva;
END$$
DELIMITER ;

-- Procedimiento: Cambiar Estado de Reserva
DELIMITER $$
CREATE PROCEDURE sp_CambiarEstadoReserva(
    IN p_id_reserva INT,
    IN p_nuevo_estado ENUM('Activa','Finalizada','Cancelada'),
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE v_id_vehiculo INT;
    DECLARE v_estado_actual VARCHAR(20);
    
    SELECT id_vehiculo, estado INTO v_id_vehiculo, v_estado_actual
    FROM reservas WHERE id_reserva = p_id_reserva;
    
    IF v_estado_actual IS NULL THEN
        SET p_resultado = 'RESERVA_NO_EXISTE';
    ELSE
        UPDATE reservas SET estado = p_nuevo_estado WHERE id_reserva = p_id_reserva;
        
        IF p_nuevo_estado = 'Cancelada' OR p_nuevo_estado = 'Finalizada' THEN
            UPDATE vehiculos SET estado = 'Disponible' WHERE id_vehiculo = v_id_vehiculo;
        ELSEIF p_nuevo_estado = 'Activa' THEN
            UPDATE vehiculos SET estado = 'Alquilado' WHERE id_vehiculo = v_id_vehiculo;
        END IF;
        
        SET p_resultado = 'EXITO';
    END IF;
END$$
DELIMITER ;

-- Procedimiento: Contar Reservas por Estado
DELIMITER $$
CREATE PROCEDURE sp_ContarReservasPorEstado()
BEGIN
    SELECT 
        estado,
        COUNT(*) as total
    FROM reservas 
    GROUP BY estado;
END$$
DELIMITER ;

-- Procedimiento: Buscar Reservas
DELIMITER $$
CREATE PROCEDURE sp_BuscarReservas(
    IN p_dni_cliente VARCHAR(15),
    IN p_matricula_vehiculo VARCHAR(20),
    IN p_estado VARCHAR(20),
    IN p_fecha_desde DATE,
    IN p_fecha_hasta DATE
)
BEGIN
    SELECT 
        r.id_reserva,
        c.nombre as cliente_nombre,
        c.apellido as cliente_apellido,
        c.dni as cliente_dni,
        v.marca as vehiculo_marca,
        v.modelo as vehiculo_modelo,
        v.matricula as vehiculo_matricula,
        r.fecha_inicio,
        r.fecha_fin,
        DATEDIFF(r.fecha_fin, r.fecha_inicio) as dias,
        p.monto as total,
        p.metodo_pago,
        r.estado
    FROM reservas r
    JOIN clientes c ON r.id_cliente = c.id_cliente
    JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN pagos p ON r.id_reserva = p.id_reserva
    WHERE 1=1
    AND (p_dni_cliente IS NULL OR c.dni LIKE CONCAT('%', p_dni_cliente, '%'))
    AND (p_matricula_vehiculo IS NULL OR v.matricula LIKE CONCAT('%', p_matricula_vehiculo, '%'))
    AND (p_estado IS NULL OR r.estado = p_estado)
    AND (p_fecha_desde IS NULL OR r.fecha_inicio >= p_fecha_desde)
    AND (p_fecha_hasta IS NULL OR r.fecha_inicio <= p_fecha_hasta)
    ORDER BY r.fecha_inicio DESC;
END$$
DELIMITER ;


-- ============================================================================
-- SECCIÓN 8: PROCEDIMIENTOS ALMACENADOS - CIUDADES
-- ============================================================================

-- Procedimiento: Obtener Ciudades Activas
DELIMITER $$
CREATE PROCEDURE sp_ObtenerCiudadesActivas()
BEGIN
    SELECT id_ciudad, nombre_ciudad
    FROM ciudades
    WHERE estado = 'Activa'
    ORDER BY nombre_ciudad;
END$$
DELIMITER ;


-- ============================================================================
-- SECCIÓN 9: DATOS DE EJEMPLO - EMPLEADOS
-- ============================================================================

INSERT INTO empleados (nombre, apellido, cargo, usuario, contraseña) VALUES
('Ana', 'Torres', 'Administrador', 'ana_admin', '1234'),
('Pedro', 'López', 'Recepcionista', 'pedro_recep', 'abcd'),
('Sofía', 'Martínez', 'Mantenimiento', 'sofia_mant', 'xyz');


-- ============================================================================
-- SECCIÓN 10: DATOS DE EJEMPLO - CLIENTES
-- ============================================================================

INSERT INTO clientes (nombre, apellido, dni, telefono, email, direccion, usuario, contraseña) VALUES
('Juan', 'Pérez', '12345678', '987654321', 'juan.perez@mail.com', 'Av. Siempre Viva 123', '12345678', 'cliente123'),
('María', 'García', '87654321', '912345678', 'maria.garcia@mail.com', 'Calle Falsa 456', '87654321', 'cliente123'),
('Luis', 'Ramírez', '11223344', '965432187', 'luis.ramirez@mail.com', 'Jr. Los Olivos 789', '11223344', 'cliente123'),
('Carlos', 'López', '44556677', '955444333', 'carlos.lopez@mail.com', 'Av. Los Jardines 456', '44556677', 'cliente456'),
('Ana', 'Martínez', '99887766', '966555444', 'ana.martinez@mail.com', 'Calle Primavera 789', '99887766', 'cliente789');


-- ============================================================================
-- SECCIÓN 11: DATOS DE EJEMPLO - VEHÍCULOS
-- ============================================================================

INSERT INTO vehiculos (marca, modelo, anio, matricula, tipo, precio_diario, estado) VALUES
('Toyota', 'Corolla', 2020, 'ABC-123', 'Sedan', 50.00, 'Disponible'),
('Hyundai', 'Tucson', 2021, 'XYZ-456', 'SUV', 70.00, 'Disponible'),
('Ford', 'Ranger', 2019, 'LMN-789', 'Pickup', 90.00, 'Mantenimiento'),
('Chevrolet', 'Spark', 2022, 'QWE-321', 'Sedan', 40.00, 'Disponible'),
('Nissan', 'Versa', 2023, 'NIS-001', 'Sedan', 45.00, 'Disponible'),
('Honda', 'Civic', 2024, 'HON-002', 'Sedan', 55.00, 'Disponible'),
('Mazda', '3', 2023, 'MAZ-003', 'Sedan', 52.00, 'Disponible'),
('Audi', 'A4', 2023, 'AUD-004', 'Sedan', 85.00, 'Disponible'),
('BMW', 'Serie 3', 2023, 'BMW-005', 'Sedan', 95.00, 'Disponible'),
('Mercedes-Benz', 'Clase C', 2023, 'MER-006', 'Sedan', 100.00, 'Disponible'),
('Ford', 'Explorer', 2023, 'FOR-007', 'SUV', 80.00, 'Disponible'),
('Lamborghini', 'Huracán', 2024, 'LAM-008', 'Deportivo', 350.00, 'Disponible'),
('Ferrari', 'F8 Tributo', 2024, 'FER-009', 'Deportivo', 400.00, 'Disponible'),
('Rolls Royce', 'Phantom', 2023, 'ROL-010', 'Sedan', 500.00, 'Disponible'),
('Tesla', 'Model S', 2025, 'TES-011', 'Sedan', 120.00, 'Disponible');


-- ============================================================================
-- SECCIÓN 12: DATOS DE EJEMPLO - CIUDADES
-- ============================================================================

INSERT INTO ciudades (nombre_ciudad, estado) VALUES
('Lima', 'Activa'),
('Arequipa', 'Activa'),
('Trujillo', 'Activa'),
('Chiclayo', 'Activa'),
('Piura', 'Activa'),
('Cusco', 'Activa'),
('Iquitos', 'Activa'),
('Huancayo', 'Activa'),
('Tacna', 'Activa'),
('Pucallpa', 'Activa'),
('Ayacucho', 'Activa'),
('Cajamarca', 'Activa'),
('Chimbote', 'Activa'),
('Huaraz', 'Activa'),
('Ica', 'Activa'),
('Juliaca', 'Activa'),
('Puno', 'Activa'),
('Tarapoto', 'Activa'),
('Tumbes', 'Activa'),
('Moquegua', 'Activa');


-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================