# EcoHome API

Backend API para la aplicación EcoHome, construida con Java y Spring Boot. Proporciona funcionalidades de autenticación y gestión de usuarios.

## ✨ Características

-   Registro de usuarios con hash de contraseñas (BCrypt).
-   Login de usuarios y autenticación.
-   Autenticación stateless usando JSON Web Tokens (JWT).
-   Endpoints seguros utilizando Spring Security.

## 🛠️ Tecnologías Utilizadas

-   Java 17+
-   Spring Boot 3
-   Spring Security
-   Maven
-   Lombok
-   Auth0 JWT
-   jBCrypt

## 📋 Prerrequisitos

Antes de comenzar, asegúrate de tener instalado lo siguiente:
-   JDK 17 o superior.
-   Maven 3.6 o superior.
-   Una instancia de base de datos relacional en ejecución (ej. PostgreSQL, MySQL).

## 🚀 Cómo Empezar

Sigue estos pasos para tener una copia del proyecto funcionando en tu máquina local.

### 1. Clonar el Repositorio

```bash
git clone <URL-DEL-REPOSITORIO>
cd <NOMBRE-DEL-PROYECTO>
```

### 2. Configuración

Crea un archivo `application.properties` en el directorio `src/main/resources/` y añade la siguiente configuración. **No olvides reemplazar los valores de ejemplo con tu configuración real.**

```properties
# Configuración de la Base de Datos (Ejemplo para PostgreSQL)
spring.datasource.url=jdbc:postgresql://localhost:5432/ecohome_db
spring.datasource.username=postgres
spring.datasource.password=tu_contraseña

# Configuración de JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Secreto para JWT
# Utiliza una clave secreta fuerte y segura. Puedes generar una aquí: https://www.allkeysgenerator.com/
jwt.secret=tu-clave-secreta-muy-larga-y-segura-para-firmar-tokens
```

### 3. Construir y Ejecutar

Puedes construir y ejecutar la aplicación usando Maven.

```bash
# Construir el proyecto
mvn clean install

# Ejecutar la aplicación
mvn spring-boot:run
```

La API estará disponible en `http://localhost:8080`.

## Endpoints de la API

### Autenticación

#### `POST /api/v1/auth/register`

Registra un nuevo usuario en el sistema.

**Request Body:**
```json
{
  "name": "John Doe",
  "documentNumber": "123456789",
  "email": "john.doe@example.com",
  "password": "yourpassword",
  "role": "USER"
}
```

**Success Response (200 OK):**
```json
{
  "message": "Registro exitoso"
}
```

---

#### `POST /api/v1/auth/login`

Autentica a un usuario y devuelve un token JWT si las credenciales son correctas.

**Request Body:**
```json
{
  "email": "john.doe@example.com",
  "password": "yourpassword"
}
```

**Success Response (200 OK):**
```json
{
    "message": "Login exitoso",
    "userId": 1,
    "name": "John Doe",
    "token": "ey..."
}
```

## 🔒 Seguridad

La API utiliza Spring Security para proteger los endpoints. Todas las rutas, excepto `/api/v1/auth/login` y `/api/v1/auth/register`, requieren un token JWT válido en el encabezado `Authorization`.

**Formato del encabezado:** `Authorization: Bearer <tu-token-jwt>`