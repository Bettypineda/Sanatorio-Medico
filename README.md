# Sistema Sanatorio

Sistema administrativo para un sanatorio médico con múltiples sucursales, desarrollado como proyecto de la Tarea Semana 10 del curso de Desarrollo Web.

## Módulos implementados

El sistema cuenta con cinco módulos completos, cada uno con las operaciones de Consultar, Agregar, Editar, Eliminar y Buscar:

1. **Sucursales**
2. **Pacientes**
3. **Colaboradores** (médicos y personal con acceso al sistema)
4. **Citas / Consultas**
5. **Especialidades**

## Tecnologías

- **Base de datos:** PostgreSQL (tablas y procedimientos almacenados `Usp_*`)
- **Backend:** NestJS (Node.js + TypeScript)
- **Frontend:** Next.js (React + TypeScript)

## Estructura del proyecto

```
Sistema Sanatorio/
├── database/        Scripts SQL: tablas, stored procedures y datos de prueba
├── backend/
│   └── sanatorio-medico-api/   API REST en NestJS (puerto 3000)
└── frontend/
    └── sanatorio-medico-web/   Interfaz en Next.js (puerto 3001)
```

## Cómo ejecutar el proyecto

### 1. Base de datos

Ejecutar en PostgreSQL, en este orden, los scripts dentro de `database/`:
1. Creación de base de datos y tablas
2. Stored procedures (CRUD)
3. Datos de prueba

### 2. Backend

```
cd backend/sanatorio-medico-api
npm install
npm run start:dev
```

El backend queda disponible en `http://localhost:3000`.

### 3. Frontend

```
cd frontend/sanatorio-medico-web
npm install
npm run dev -- -p 3001
```

El frontend queda disponible en `http://localhost:3001`.

> Nota: el backend debe estar corriendo antes de abrir el frontend, ya que las pantallas consultan la información directamente desde la API.
