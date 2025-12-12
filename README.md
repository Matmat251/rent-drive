# FastWheels - Sistema de Alquiler de Vehiculos

Sistema web completo para la gestion de alquiler de vehiculos desarrollado en Java EE con arquitectura MVC.

---

## Descripcion del Proyecto

FastWheels es una plataforma integral para empresas de renta de vehiculos que permite gestionar clientes, vehiculos, reservas y pagos de manera eficiente. El sistema cuenta con interfaces separadas para clientes y administradores, ofreciendo una experiencia de usuario optimizada para cada tipo de rol.

---

## Tecnologias Utilizadas

### Backend
- **Java EE 8** - Lenguaje de programacion principal
- **JSP (JavaServer Pages)** - Motor de plantillas para vistas
- **Servlets** - Controladores HTTP
- **JDBC** - Conexion a base de datos

### Frontend
- **HTML5 / CSS3** - Estructura y estilos
- **JavaScript** - Interactividad del cliente
- **Bootstrap** - Framework CSS responsivo

### Base de Datos
- **MySQL 8.0** - Sistema gestor de base de datos relacional
- **Procedimientos Almacenados** - Logica de negocio en BD

### Servidor
- **Apache Tomcat 9** - Servidor de aplicaciones

---

## Arquitectura del Sistema

El proyecto sigue el patron de arquitectura **MVC (Modelo-Vista-Controlador)**:

```
src/java/
├── capaEntidad/      # Modelo - Clases de entidad (POJOs)
├── capaDatos/        # Acceso a datos (DAO Pattern)
└── servlets/         # Controladores HTTP

web/
├── admin/            # Vistas del panel administrativo
├── auth/             # Vistas de autenticacion
├── client/           # Vistas del portal de clientes
├── assets/           # Recursos estaticos (CSS, JS, imagenes)
└── index.jsp         # Pagina principal
```

---

## Funcionalidades Principales

### Modulo de Clientes
- Registro e inicio de sesion
- Catalogo de vehiculos disponibles
- Reserva de vehiculos en linea
- Historial de reservas
- Gestion de perfil personal

### Modulo Administrativo
- Gestion completa de vehiculos (CRUD)
- Administracion de clientes
- Control de reservas y estados
- Calendario de disponibilidad
- Reportes y estadisticas

### Caracteristicas Adicionales
- Sistema de autenticacion seguro
- Validacion de disponibilidad en tiempo real
- Generacion de boletas en PDF
- Busqueda y filtrado avanzado
- Interfaz responsiva

---

## Base de Datos

### Tablas Principales
| Tabla | Descripcion |
|-------|-------------|
| `clientes` | Informacion de clientes registrados |
| `empleados` | Usuarios administrativos del sistema |
| `vehiculos` | Catalogo de vehiculos disponibles |
| `reservas` | Registros de alquileres |
| `pagos` | Transacciones de pago |
| `mantenimientos` | Historial de mantenimiento vehicular |
| `ciudades` | Catalogo de ciudades |
| `bloqueos_calendario` | Bloqueos de disponibilidad |

### Tipos de Vehiculos Soportados
- Sedan
- SUV
- Pickup
- Van
- Deportivo

---

## Instalacion y Configuracion

### Requisitos Previos
- JDK 8 o superior
- Apache Tomcat 9.x
- MySQL Server 8.0
- NetBeans IDE (recomendado)

### Pasos de Instalacion

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/Matmat251/rent-drive.git
   ```

2. **Configurar la base de datos**
   ```bash
   mysql -u root -p < bd.sql
   ```

3. **Configurar conexion a BD**
   
   Modificar los parametros de conexion en la clase de acceso a datos segun su entorno.

4. **Desplegar en Tomcat**
   
   Importar el proyecto en NetBeans y ejecutar en el servidor Tomcat.

---

## Nota Importante sobre Seguridad

Este proyecto fue desarrollado con fines academicos y de demostracion. Los datos de clientes, empleados y vehiculos incluidos son completamente aleatorios y ficticios, utilizados unicamente para propositos de prueba.

### Consideraciones para un Entorno de Produccion

Para implementar este sistema en un entorno real, se deben aplicar las siguientes medidas de seguridad:

| Aspecto | Recomendacion |
|---------|---------------|
| Contrasenas | Implementar encriptacion con algoritmos seguros (BCrypt, Argon2) |
| Sesiones | Utilizar tokens JWT o sesiones seguras con tiempo de expiracion |
| Base de Datos | Configurar conexiones SSL y usuarios con privilegios minimos |
| Datos Sensibles | Cifrar informacion personal (DNI, telefono, email) en reposo |
| Comunicacion | Implementar HTTPS con certificado SSL valido |
| Validacion | Sanitizar todas las entradas para prevenir SQL Injection y XSS |
| Autenticacion | Agregar autenticacion de dos factores (2FA) |
| Auditoria | Implementar logs de acceso y operaciones criticas |

---

## Credenciales de Prueba

### Administrador
| Usuario | Contrasena |
|---------|------------|
| ana_admin | 1234 |
| pedro_recep | abcd |

### Clientes
| DNI | Contrasena |
|-----|------------|
| 12345678 | cliente123 |
| 87654321 | cliente123 |

---

## Estructura de Carpetas

```
Avance_03-FNL/
├── Avance_03/
│   ├── src/
│   │   ├── java/
│   │   │   ├── capaEntidad/    # Entidades del sistema
│   │   │   ├── capaDatos/      # Capa de acceso a datos
│   │   │   └── servlets/       # Controladores
│   │   └── conf/
│   ├── web/
│   │   ├── admin/              # Panel administrativo
│   │   ├── auth/               # Autenticacion
│   │   ├── client/             # Portal de clientes
│   │   └── assets/             # Recursos estaticos
│   └── build.xml
├── bd.sql                       # Script de base de datos
└── README.md
```

---

## Contribucion

1. Hacer fork del repositorio
2. Crear una rama para la nueva funcionalidad
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
3. Realizar los cambios y hacer commit
   ```bash
   git commit -m "Agregar nueva funcionalidad"
   ```
4. Enviar los cambios
   ```bash
   git push origin feature/nueva-funcionalidad
   ```
5. Crear un Pull Request

---

## Licencia

Este proyecto fue desarrollado con fines academicos.

---

## Contacto

- **Desarrollador**: MathewDev
- **GitHub**: [Matmat251](https://github.com/Matmat251)
