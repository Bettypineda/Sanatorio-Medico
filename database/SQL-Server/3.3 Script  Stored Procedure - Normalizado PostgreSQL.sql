
/*==============================================================
  1. FUNCIONES CRUD DE TBL_SUCURSALES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sucursales_Agregar
(
    p_NombreSucursal VARCHAR(100),
    p_Direccion VARCHAR(200),
    p_FechaApertura DATE,
    p_HoraApertura TIME,
    p_PresupuestoMensual DECIMAL(12,2),
    p_Estado BOOLEAN
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoSucursal INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Sucursales AS t
    (
        NombreSucursal,
        Direccion,
        FechaApertura,
        HoraApertura,
        PresupuestoMensual,
        Estado
    )
    VALUES
    (
        p_NombreSucursal,
        p_Direccion,
        p_FechaApertura,
        p_HoraApertura,
        p_PresupuestoMensual,
        p_Estado
    )
    RETURNING t.CodigoSucursal INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sucursales_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sucursales_Editar
(
    p_CodigoSucursal INT,
    p_NombreSucursal VARCHAR(100),
    p_Direccion VARCHAR(200),
    p_FechaApertura DATE,
    p_HoraApertura TIME,
    p_PresupuestoMensual DECIMAL(12,2),
    p_Estado BOOLEAN
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Sucursales
    SET NombreSucursal = p_NombreSucursal,
        Direccion = p_Direccion,
        FechaApertura = p_FechaApertura,
        HoraApertura = p_HoraApertura,
        PresupuestoMensual = p_PresupuestoMensual,
        Estado = p_Estado
    WHERE CodigoSucursal = p_CodigoSucursal;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sucursales_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sucursales_Eliminar
(
    p_CodigoSucursal INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Sucursales
    WHERE CodigoSucursal = p_CodigoSucursal;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sucursales_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sucursales_Consultar()
RETURNS TABLE
(
    CodigoSucursal INT,
    NombreSucursal VARCHAR(100),
    Direccion VARCHAR(200),
    FechaApertura DATE,
    HoraApertura TIME,
    PresupuestoMensual DECIMAL(12,2),
    Estado BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoSucursal,
        t.NombreSucursal,
        t.Direccion,
        t.FechaApertura,
        t.HoraApertura,
        t.PresupuestoMensual,
        t.Estado
    FROM Tbl_Sucursales t
    ORDER BY t.CodigoSucursal;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sucursales_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Sucursales_Buscar
(
    p_CodigoSucursal INT
)
RETURNS TABLE
(
    CodigoSucursal INT,
    NombreSucursal VARCHAR(100),
    Direccion VARCHAR(200),
    FechaApertura DATE,
    HoraApertura TIME,
    PresupuestoMensual DECIMAL(12,2),
    Estado BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Sucursales t
        WHERE t.CodigoSucursal = p_CodigoSucursal
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoSucursal,
        t.NombreSucursal,
        t.Direccion,
        t.FechaApertura,
        t.HoraApertura,
        t.PresupuestoMensual,
        t.Estado
    FROM Tbl_Sucursales t
    WHERE t.CodigoSucursal = p_CodigoSucursal;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Sucursales_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  2. FUNCIONES CRUD DE TBL_ROLES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Roles_Agregar
(
    p_NombreRol VARCHAR(80),
    p_DescripcionRol VARCHAR(250),
    p_ModuloPrincipal VARCHAR(100),
    p_PermiteConsultar BOOLEAN,
    p_PermiteAgregar BOOLEAN,
    p_PermiteEditar BOOLEAN,
    p_PermiteAnular BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoRol INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Roles AS t
    (
        NombreRol,
        DescripcionRol,
        ModuloPrincipal,
        PermiteConsultar,
        PermiteAgregar,
        PermiteEditar,
        PermiteAnular,
        Estado
    )
    VALUES
    (
        p_NombreRol,
        p_DescripcionRol,
        p_ModuloPrincipal,
        p_PermiteConsultar,
        p_PermiteAgregar,
        p_PermiteEditar,
        p_PermiteAnular,
        p_Estado
    )
    RETURNING t.CodigoRol INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Roles_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Roles_Editar
(
    p_CodigoRol INT,
    p_NombreRol VARCHAR(80),
    p_DescripcionRol VARCHAR(250),
    p_ModuloPrincipal VARCHAR(100),
    p_PermiteConsultar BOOLEAN,
    p_PermiteAgregar BOOLEAN,
    p_PermiteEditar BOOLEAN,
    p_PermiteAnular BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Roles
    SET NombreRol = p_NombreRol,
        DescripcionRol = p_DescripcionRol,
        ModuloPrincipal = p_ModuloPrincipal,
        PermiteConsultar = p_PermiteConsultar,
        PermiteAgregar = p_PermiteAgregar,
        PermiteEditar = p_PermiteEditar,
        PermiteAnular = p_PermiteAnular,
        Estado = p_Estado
    WHERE CodigoRol = p_CodigoRol;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Roles_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Roles_Eliminar
(
    p_CodigoRol INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Roles
    WHERE CodigoRol = p_CodigoRol;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Roles_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Roles_Consultar()
RETURNS TABLE
(
    CodigoRol INT,
    NombreRol VARCHAR(80),
    DescripcionRol VARCHAR(250),
    ModuloPrincipal VARCHAR(100),
    PermiteConsultar BOOLEAN,
    PermiteAgregar BOOLEAN,
    PermiteEditar BOOLEAN,
    PermiteAnular BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoRol,
        t.NombreRol,
        t.DescripcionRol,
        t.ModuloPrincipal,
        t.PermiteConsultar,
        t.PermiteAgregar,
        t.PermiteEditar,
        t.PermiteAnular,
        t.Estado
    FROM Tbl_Roles t
    ORDER BY t.CodigoRol;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Roles_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Roles_Buscar
(
    p_CodigoRol INT
)
RETURNS TABLE
(
    CodigoRol INT,
    NombreRol VARCHAR(80),
    DescripcionRol VARCHAR(250),
    ModuloPrincipal VARCHAR(100),
    PermiteConsultar BOOLEAN,
    PermiteAgregar BOOLEAN,
    PermiteEditar BOOLEAN,
    PermiteAnular BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Roles t
        WHERE t.CodigoRol = p_CodigoRol
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoRol,
        t.NombreRol,
        t.DescripcionRol,
        t.ModuloPrincipal,
        t.PermiteConsultar,
        t.PermiteAgregar,
        t.PermiteEditar,
        t.PermiteAnular,
        t.Estado
    FROM Tbl_Roles t
    WHERE t.CodigoRol = p_CodigoRol;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Roles_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  3. FUNCIONES CRUD DE TBL_COLABORADORES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Colaboradores_Agregar
(
    p_CodigoSucursal INT,
    p_CodigoRol INT,
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_DPI VARCHAR(20),
    p_NumeroColegiado VARCHAR(30),
    p_TipoColaborador VARCHAR(50),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_FechaContratacion DATE,
    p_NombreUsuario VARCHAR(80),
    p_ClaveAcceso VARCHAR(255),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoColaborador INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Colaboradores AS t
    (
        CodigoSucursal,
        CodigoRol,
        Nombres,
        Apellidos,
        DPI,
        NumeroColegiado,
        TipoColaborador,
        Telefono,
        CorreoElectronico,
        Direccion,
        FechaContratacion,
        NombreUsuario,
        ClaveAcceso,
        Estado
    )
    VALUES
    (
        p_CodigoSucursal,
        p_CodigoRol,
        p_Nombres,
        p_Apellidos,
        p_DPI,
        p_NumeroColegiado,
        p_TipoColaborador,
        p_Telefono,
        p_CorreoElectronico,
        p_Direccion,
        p_FechaContratacion,
        p_NombreUsuario,
        p_ClaveAcceso,
        p_Estado
    )
    RETURNING t.CodigoColaborador INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Colaboradores_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Colaboradores_Editar
(
    p_CodigoColaborador INT,
    p_CodigoSucursal INT,
    p_CodigoRol INT,
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_DPI VARCHAR(20),
    p_NumeroColegiado VARCHAR(30),
    p_TipoColaborador VARCHAR(50),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_FechaContratacion DATE,
    p_NombreUsuario VARCHAR(80),
    p_ClaveAcceso VARCHAR(255),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Colaboradores
    SET CodigoSucursal = p_CodigoSucursal,
        CodigoRol = p_CodigoRol,
        Nombres = p_Nombres,
        Apellidos = p_Apellidos,
        DPI = p_DPI,
        NumeroColegiado = p_NumeroColegiado,
        TipoColaborador = p_TipoColaborador,
        Telefono = p_Telefono,
        CorreoElectronico = p_CorreoElectronico,
        Direccion = p_Direccion,
        FechaContratacion = p_FechaContratacion,
        NombreUsuario = p_NombreUsuario,
        ClaveAcceso = p_ClaveAcceso,
        Estado = p_Estado
    WHERE CodigoColaborador = p_CodigoColaborador;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Colaboradores_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Colaboradores_Eliminar
(
    p_CodigoColaborador INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Colaboradores
    WHERE CodigoColaborador = p_CodigoColaborador;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Colaboradores_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Colaboradores_Consultar()
RETURNS TABLE
(
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoRol INT,
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DPI VARCHAR(20),
    NumeroColegiado VARCHAR(30),
    TipoColaborador VARCHAR(50),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    FechaContratacion DATE,
    NombreUsuario VARCHAR(80),
    ClaveAcceso VARCHAR(255),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoRol,
        t.Nombres,
        t.Apellidos,
        t.DPI,
        t.NumeroColegiado,
        t.TipoColaborador,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.FechaContratacion,
        t.NombreUsuario,
        t.ClaveAcceso,
        t.Estado
    FROM Tbl_Colaboradores t
    ORDER BY t.CodigoColaborador;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Colaboradores_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Colaboradores_Buscar
(
    p_CodigoColaborador INT
)
RETURNS TABLE
(
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoRol INT,
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    DPI VARCHAR(20),
    NumeroColegiado VARCHAR(30),
    TipoColaborador VARCHAR(50),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    FechaContratacion DATE,
    NombreUsuario VARCHAR(80),
    ClaveAcceso VARCHAR(255),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Colaboradores t
        WHERE t.CodigoColaborador = p_CodigoColaborador
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoRol,
        t.Nombres,
        t.Apellidos,
        t.DPI,
        t.NumeroColegiado,
        t.TipoColaborador,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.FechaContratacion,
        t.NombreUsuario,
        t.ClaveAcceso,
        t.Estado
    FROM Tbl_Colaboradores t
    WHERE t.CodigoColaborador = p_CodigoColaborador;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Colaboradores_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  4. FUNCIONES CRUD DE TBL_PACIENTES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pacientes_Agregar
(
    p_NumeroExpediente VARCHAR(30),
    p_TipoDocumento VARCHAR(30),
    p_NumeroDocumento VARCHAR(25),
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_FechaNacimiento DATE,
    p_Genero VARCHAR(20),
    p_TipoSangre VARCHAR(10),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_ContactoEmergencia VARCHAR(150),
    p_TelefonoEmergencia VARCHAR(20),
    p_Alergias VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoPaciente INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Pacientes AS t
    (
        NumeroExpediente,
        TipoDocumento,
        NumeroDocumento,
        Nombres,
        Apellidos,
        FechaNacimiento,
        Genero,
        TipoSangre,
        Telefono,
        CorreoElectronico,
        Direccion,
        ContactoEmergencia,
        TelefonoEmergencia,
        Alergias,
        Estado
    )
    VALUES
    (
        p_NumeroExpediente,
        p_TipoDocumento,
        p_NumeroDocumento,
        p_Nombres,
        p_Apellidos,
        p_FechaNacimiento,
        p_Genero,
        p_TipoSangre,
        p_Telefono,
        p_CorreoElectronico,
        p_Direccion,
        p_ContactoEmergencia,
        p_TelefonoEmergencia,
        p_Alergias,
        p_Estado
    )
    RETURNING t.CodigoPaciente INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pacientes_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pacientes_Editar
(
    p_CodigoPaciente INT,
    p_NumeroExpediente VARCHAR(30),
    p_TipoDocumento VARCHAR(30),
    p_NumeroDocumento VARCHAR(25),
    p_Nombres VARCHAR(100),
    p_Apellidos VARCHAR(100),
    p_FechaNacimiento DATE,
    p_Genero VARCHAR(20),
    p_TipoSangre VARCHAR(10),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_Direccion VARCHAR(200),
    p_ContactoEmergencia VARCHAR(150),
    p_TelefonoEmergencia VARCHAR(20),
    p_Alergias VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Pacientes
    SET NumeroExpediente = p_NumeroExpediente,
        TipoDocumento = p_TipoDocumento,
        NumeroDocumento = p_NumeroDocumento,
        Nombres = p_Nombres,
        Apellidos = p_Apellidos,
        FechaNacimiento = p_FechaNacimiento,
        Genero = p_Genero,
        TipoSangre = p_TipoSangre,
        Telefono = p_Telefono,
        CorreoElectronico = p_CorreoElectronico,
        Direccion = p_Direccion,
        ContactoEmergencia = p_ContactoEmergencia,
        TelefonoEmergencia = p_TelefonoEmergencia,
        Alergias = p_Alergias,
        Estado = p_Estado
    WHERE CodigoPaciente = p_CodigoPaciente;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pacientes_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pacientes_Eliminar
(
    p_CodigoPaciente INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Pacientes
    WHERE CodigoPaciente = p_CodigoPaciente;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pacientes_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pacientes_Consultar()
RETURNS TABLE
(
    CodigoPaciente INT,
    NumeroExpediente VARCHAR(30),
    TipoDocumento VARCHAR(30),
    NumeroDocumento VARCHAR(25),
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    FechaNacimiento DATE,
    Genero VARCHAR(20),
    TipoSangre VARCHAR(10),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    ContactoEmergencia VARCHAR(150),
    TelefonoEmergencia VARCHAR(20),
    Alergias VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoPaciente,
        t.NumeroExpediente,
        t.TipoDocumento,
        t.NumeroDocumento,
        t.Nombres,
        t.Apellidos,
        t.FechaNacimiento,
        t.Genero,
        t.TipoSangre,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.ContactoEmergencia,
        t.TelefonoEmergencia,
        t.Alergias,
        t.Estado
    FROM Tbl_Pacientes t
    ORDER BY t.CodigoPaciente;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pacientes_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Pacientes_Buscar
(
    p_CodigoPaciente INT
)
RETURNS TABLE
(
    CodigoPaciente INT,
    NumeroExpediente VARCHAR(30),
    TipoDocumento VARCHAR(30),
    NumeroDocumento VARCHAR(25),
    Nombres VARCHAR(100),
    Apellidos VARCHAR(100),
    FechaNacimiento DATE,
    Genero VARCHAR(20),
    TipoSangre VARCHAR(10),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    Direccion VARCHAR(200),
    ContactoEmergencia VARCHAR(150),
    TelefonoEmergencia VARCHAR(20),
    Alergias VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Pacientes t
        WHERE t.CodigoPaciente = p_CodigoPaciente
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoPaciente,
        t.NumeroExpediente,
        t.TipoDocumento,
        t.NumeroDocumento,
        t.Nombres,
        t.Apellidos,
        t.FechaNacimiento,
        t.Genero,
        t.TipoSangre,
        t.Telefono,
        t.CorreoElectronico,
        t.Direccion,
        t.ContactoEmergencia,
        t.TelefonoEmergencia,
        t.Alergias,
        t.Estado
    FROM Tbl_Pacientes t
    WHERE t.CodigoPaciente = p_CodigoPaciente;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Pacientes_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  5. FUNCIONES CRUD DE TBL_ESPECIALIDADES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Especialidades_Agregar
(
    p_NombreEspecialidad VARCHAR(100),
    p_Descripcion VARCHAR(250),
    p_AreaMedica VARCHAR(100),
    p_DuracionConsulta INT,
    p_CostoConsulta DECIMAL(12,2),
    p_RequiereCita BOOLEAN,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoEspecialidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Especialidades AS t
    (
        NombreEspecialidad,
        Descripcion,
        AreaMedica,
        DuracionConsulta,
        CostoConsulta,
        RequiereCita,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_NombreEspecialidad,
        p_Descripcion,
        p_AreaMedica,
        p_DuracionConsulta,
        p_CostoConsulta,
        p_RequiereCita,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoEspecialidad INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Especialidades_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Especialidades_Editar
(
    p_CodigoEspecialidad INT,
    p_NombreEspecialidad VARCHAR(100),
    p_Descripcion VARCHAR(250),
    p_AreaMedica VARCHAR(100),
    p_DuracionConsulta INT,
    p_CostoConsulta DECIMAL(12,2),
    p_RequiereCita BOOLEAN,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Especialidades
    SET NombreEspecialidad = p_NombreEspecialidad,
        Descripcion = p_Descripcion,
        AreaMedica = p_AreaMedica,
        DuracionConsulta = p_DuracionConsulta,
        CostoConsulta = p_CostoConsulta,
        RequiereCita = p_RequiereCita,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoEspecialidad = p_CodigoEspecialidad;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Especialidades_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Especialidades_Eliminar
(
    p_CodigoEspecialidad INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Especialidades
    WHERE CodigoEspecialidad = p_CodigoEspecialidad;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Especialidades_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Especialidades_Consultar()
RETURNS TABLE
(
    CodigoEspecialidad INT,
    NombreEspecialidad VARCHAR(100),
    Descripcion VARCHAR(250),
    AreaMedica VARCHAR(100),
    DuracionConsulta INT,
    CostoConsulta DECIMAL(12,2),
    RequiereCita BOOLEAN,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoEspecialidad,
        t.NombreEspecialidad,
        t.Descripcion,
        t.AreaMedica,
        t.DuracionConsulta,
        t.CostoConsulta,
        t.RequiereCita,
        t.Observaciones,
        t.Estado
    FROM Tbl_Especialidades t
    ORDER BY t.CodigoEspecialidad;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Especialidades_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Especialidades_Buscar
(
    p_CodigoEspecialidad INT
)
RETURNS TABLE
(
    CodigoEspecialidad INT,
    NombreEspecialidad VARCHAR(100),
    Descripcion VARCHAR(250),
    AreaMedica VARCHAR(100),
    DuracionConsulta INT,
    CostoConsulta DECIMAL(12,2),
    RequiereCita BOOLEAN,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Especialidades t
        WHERE t.CodigoEspecialidad = p_CodigoEspecialidad
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoEspecialidad,
        t.NombreEspecialidad,
        t.Descripcion,
        t.AreaMedica,
        t.DuracionConsulta,
        t.CostoConsulta,
        t.RequiereCita,
        t.Observaciones,
        t.Estado
    FROM Tbl_Especialidades t
    WHERE t.CodigoEspecialidad = p_CodigoEspecialidad;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Especialidades_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  6. FUNCIONES CRUD DE TBL_COLABORADORESESPECIALIDADES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_ColaboradoresEspecialidades_Agregar
(
    p_CodigoColaborador INT,
    p_CodigoEspecialidad INT,
    p_FechaAsignacion DATE,
    p_NumeroAutorizacion VARCHAR(50),
    p_InstitucionAcreditadora VARCHAR(150),
    p_FechaVencimiento DATE,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoColaboradorEspecialidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_ColaboradoresEspecialidades AS t
    (
        CodigoColaborador,
        CodigoEspecialidad,
        FechaAsignacion,
        NumeroAutorizacion,
        InstitucionAcreditadora,
        FechaVencimiento,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoColaborador,
        p_CodigoEspecialidad,
        p_FechaAsignacion,
        p_NumeroAutorizacion,
        p_InstitucionAcreditadora,
        p_FechaVencimiento,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoColaboradorEspecialidad INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_ColaboradoresEspecialidades_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_ColaboradoresEspecialidades_Editar
(
    p_CodigoColaboradorEspecialidad INT,
    p_CodigoColaborador INT,
    p_CodigoEspecialidad INT,
    p_FechaAsignacion DATE,
    p_NumeroAutorizacion VARCHAR(50),
    p_InstitucionAcreditadora VARCHAR(150),
    p_FechaVencimiento DATE,
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_ColaboradoresEspecialidades
    SET CodigoColaborador = p_CodigoColaborador,
        CodigoEspecialidad = p_CodigoEspecialidad,
        FechaAsignacion = p_FechaAsignacion,
        NumeroAutorizacion = p_NumeroAutorizacion,
        InstitucionAcreditadora = p_InstitucionAcreditadora,
        FechaVencimiento = p_FechaVencimiento,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoColaboradorEspecialidad = p_CodigoColaboradorEspecialidad;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_ColaboradoresEspecialidades_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_ColaboradoresEspecialidades_Eliminar
(
    p_CodigoColaboradorEspecialidad INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_ColaboradoresEspecialidades
    WHERE CodigoColaboradorEspecialidad = p_CodigoColaboradorEspecialidad;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_ColaboradoresEspecialidades_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_ColaboradoresEspecialidades_Consultar()
RETURNS TABLE
(
    CodigoColaboradorEspecialidad INT,
    CodigoColaborador INT,
    CodigoEspecialidad INT,
    FechaAsignacion DATE,
    NumeroAutorizacion VARCHAR(50),
    InstitucionAcreditadora VARCHAR(150),
    FechaVencimiento DATE,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoColaboradorEspecialidad,
        t.CodigoColaborador,
        t.CodigoEspecialidad,
        t.FechaAsignacion,
        t.NumeroAutorizacion,
        t.InstitucionAcreditadora,
        t.FechaVencimiento,
        t.Observaciones,
        t.Estado
    FROM Tbl_ColaboradoresEspecialidades t
    ORDER BY t.CodigoColaboradorEspecialidad;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_ColaboradoresEspecialidades_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_ColaboradoresEspecialidades_Buscar
(
    p_CodigoColaboradorEspecialidad INT
)
RETURNS TABLE
(
    CodigoColaboradorEspecialidad INT,
    CodigoColaborador INT,
    CodigoEspecialidad INT,
    FechaAsignacion DATE,
    NumeroAutorizacion VARCHAR(50),
    InstitucionAcreditadora VARCHAR(150),
    FechaVencimiento DATE,
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_ColaboradoresEspecialidades t
        WHERE t.CodigoColaboradorEspecialidad = p_CodigoColaboradorEspecialidad
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoColaboradorEspecialidad,
        t.CodigoColaborador,
        t.CodigoEspecialidad,
        t.FechaAsignacion,
        t.NumeroAutorizacion,
        t.InstitucionAcreditadora,
        t.FechaVencimiento,
        t.Observaciones,
        t.Estado
    FROM Tbl_ColaboradoresEspecialidades t
    WHERE t.CodigoColaboradorEspecialidad = p_CodigoColaboradorEspecialidad;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_ColaboradoresEspecialidades_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  7. FUNCIONES CRUD DE TBL_HORARIOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Horarios_Agregar
(
    p_CodigoColaborador INT,
    p_CodigoSucursal INT,
    p_CodigoEspecialidad INT,
    p_DiaSemana VARCHAR(20),
    p_HoraInicio TIME,
    p_HoraFin TIME,
    p_DuracionCitaMinutos INT,
    p_Jornada VARCHAR(30),
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoHorario INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Horarios AS t
    (
        CodigoColaborador,
        CodigoSucursal,
        CodigoEspecialidad,
        DiaSemana,
        HoraInicio,
        HoraFin,
        DuracionCitaMinutos,
        Jornada,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoColaborador,
        p_CodigoSucursal,
        p_CodigoEspecialidad,
        p_DiaSemana,
        p_HoraInicio,
        p_HoraFin,
        p_DuracionCitaMinutos,
        p_Jornada,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoHorario INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Horarios_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Horarios_Editar
(
    p_CodigoHorario INT,
    p_CodigoColaborador INT,
    p_CodigoSucursal INT,
    p_CodigoEspecialidad INT,
    p_DiaSemana VARCHAR(20),
    p_HoraInicio TIME,
    p_HoraFin TIME,
    p_DuracionCitaMinutos INT,
    p_Jornada VARCHAR(30),
    p_Observaciones VARCHAR(250),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Horarios
    SET CodigoColaborador = p_CodigoColaborador,
        CodigoSucursal = p_CodigoSucursal,
        CodigoEspecialidad = p_CodigoEspecialidad,
        DiaSemana = p_DiaSemana,
        HoraInicio = p_HoraInicio,
        HoraFin = p_HoraFin,
        DuracionCitaMinutos = p_DuracionCitaMinutos,
        Jornada = p_Jornada,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoHorario = p_CodigoHorario;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Horarios_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Horarios_Eliminar
(
    p_CodigoHorario INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Horarios
    WHERE CodigoHorario = p_CodigoHorario;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Horarios_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Horarios_Consultar()
RETURNS TABLE
(
    CodigoHorario INT,
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoEspecialidad INT,
    DiaSemana VARCHAR(20),
    HoraInicio TIME,
    HoraFin TIME,
    DuracionCitaMinutos INT,
    Jornada VARCHAR(30),
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoHorario,
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoEspecialidad,
        t.DiaSemana,
        t.HoraInicio,
        t.HoraFin,
        t.DuracionCitaMinutos,
        t.Jornada,
        t.Observaciones,
        t.Estado
    FROM Tbl_Horarios t
    ORDER BY t.CodigoHorario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Horarios_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Horarios_Buscar
(
    p_CodigoHorario INT
)
RETURNS TABLE
(
    CodigoHorario INT,
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoEspecialidad INT,
    DiaSemana VARCHAR(20),
    HoraInicio TIME,
    HoraFin TIME,
    DuracionCitaMinutos INT,
    Jornada VARCHAR(30),
    Observaciones VARCHAR(250),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Horarios t
        WHERE t.CodigoHorario = p_CodigoHorario
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoHorario,
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoEspecialidad,
        t.DiaSemana,
        t.HoraInicio,
        t.HoraFin,
        t.DuracionCitaMinutos,
        t.Jornada,
        t.Observaciones,
        t.Estado
    FROM Tbl_Horarios t
    WHERE t.CodigoHorario = p_CodigoHorario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Horarios_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  8. FUNCIONES CRUD DE TBL_CITASCONSULTAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultas_Agregar
(
    p_CodigoPaciente INT,
    p_CodigoColaborador INT,
    p_CodigoSucursal INT,
    p_CodigoEspecialidad INT,
    p_FechaHoraCita TIMESTAMP,
    p_TipoAtencion VARCHAR(30),
    p_MotivoConsulta VARCHAR(500),
    p_Sintomas VARCHAR(1000),
    p_ObservacionesMedicas VARCHAR(1000),
    p_TratamientoGeneral VARCHAR(1000),
    p_PresionArterial VARCHAR(20),
    p_Temperatura DECIMAL(5,2),
    p_Peso DECIMAL(6,2),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoCitaConsulta INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_CitasConsultas AS t
    (
        CodigoPaciente,
        CodigoColaborador,
        CodigoSucursal,
        CodigoEspecialidad,
        FechaHoraCita,
        TipoAtencion,
        MotivoConsulta,
        Sintomas,
        ObservacionesMedicas,
        TratamientoGeneral,
        PresionArterial,
        Temperatura,
        Peso,
        Estado
    )
    VALUES
    (
        p_CodigoPaciente,
        p_CodigoColaborador,
        p_CodigoSucursal,
        p_CodigoEspecialidad,
        p_FechaHoraCita,
        p_TipoAtencion,
        p_MotivoConsulta,
        p_Sintomas,
        p_ObservacionesMedicas,
        p_TratamientoGeneral,
        p_PresionArterial,
        p_Temperatura,
        p_Peso,
        p_Estado
    )
    RETURNING t.CodigoCitaConsulta INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultas_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultas_Editar
(
    p_CodigoCitaConsulta INT,
    p_CodigoPaciente INT,
    p_CodigoColaborador INT,
    p_CodigoSucursal INT,
    p_CodigoEspecialidad INT,
    p_FechaHoraCita TIMESTAMP,
    p_TipoAtencion VARCHAR(30),
    p_MotivoConsulta VARCHAR(500),
    p_Sintomas VARCHAR(1000),
    p_ObservacionesMedicas VARCHAR(1000),
    p_TratamientoGeneral VARCHAR(1000),
    p_PresionArterial VARCHAR(20),
    p_Temperatura DECIMAL(5,2),
    p_Peso DECIMAL(6,2),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_CitasConsultas
    SET CodigoPaciente = p_CodigoPaciente,
        CodigoColaborador = p_CodigoColaborador,
        CodigoSucursal = p_CodigoSucursal,
        CodigoEspecialidad = p_CodigoEspecialidad,
        FechaHoraCita = p_FechaHoraCita,
        TipoAtencion = p_TipoAtencion,
        MotivoConsulta = p_MotivoConsulta,
        Sintomas = p_Sintomas,
        ObservacionesMedicas = p_ObservacionesMedicas,
        TratamientoGeneral = p_TratamientoGeneral,
        PresionArterial = p_PresionArterial,
        Temperatura = p_Temperatura,
        Peso = p_Peso,
        Estado = p_Estado
    WHERE CodigoCitaConsulta = p_CodigoCitaConsulta;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultas_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultas_Eliminar
(
    p_CodigoCitaConsulta INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_CitasConsultas
    WHERE CodigoCitaConsulta = p_CodigoCitaConsulta;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultas_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultas_Consultar()
RETURNS TABLE
(
    CodigoCitaConsulta INT,
    CodigoPaciente INT,
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoEspecialidad INT,
    FechaHoraCita TIMESTAMP,
    TipoAtencion VARCHAR(30),
    MotivoConsulta VARCHAR(500),
    Sintomas VARCHAR(1000),
    ObservacionesMedicas VARCHAR(1000),
    TratamientoGeneral VARCHAR(1000),
    PresionArterial VARCHAR(20),
    Temperatura DECIMAL(5,2),
    Peso DECIMAL(6,2),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoCitaConsulta,
        t.CodigoPaciente,
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoEspecialidad,
        t.FechaHoraCita,
        t.TipoAtencion,
        t.MotivoConsulta,
        t.Sintomas,
        t.ObservacionesMedicas,
        t.TratamientoGeneral,
        t.PresionArterial,
        t.Temperatura,
        t.Peso,
        t.Estado
    FROM Tbl_CitasConsultas t
    ORDER BY t.CodigoCitaConsulta;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultas_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultas_Buscar
(
    p_CodigoCitaConsulta INT
)
RETURNS TABLE
(
    CodigoCitaConsulta INT,
    CodigoPaciente INT,
    CodigoColaborador INT,
    CodigoSucursal INT,
    CodigoEspecialidad INT,
    FechaHoraCita TIMESTAMP,
    TipoAtencion VARCHAR(30),
    MotivoConsulta VARCHAR(500),
    Sintomas VARCHAR(1000),
    ObservacionesMedicas VARCHAR(1000),
    TratamientoGeneral VARCHAR(1000),
    PresionArterial VARCHAR(20),
    Temperatura DECIMAL(5,2),
    Peso DECIMAL(6,2),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_CitasConsultas t
        WHERE t.CodigoCitaConsulta = p_CodigoCitaConsulta
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoCitaConsulta,
        t.CodigoPaciente,
        t.CodigoColaborador,
        t.CodigoSucursal,
        t.CodigoEspecialidad,
        t.FechaHoraCita,
        t.TipoAtencion,
        t.MotivoConsulta,
        t.Sintomas,
        t.ObservacionesMedicas,
        t.TratamientoGeneral,
        t.PresionArterial,
        t.Temperatura,
        t.Peso,
        t.Estado
    FROM Tbl_CitasConsultas t
    WHERE t.CodigoCitaConsulta = p_CodigoCitaConsulta;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultas_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  9. FUNCIONES CRUD DE TBL_CITASCONSULTASDETALLE
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultasDetalle_Agregar
(
    p_CodigoCitaConsulta INT,
    p_CodigoProducto INT,
    p_TipoDetalle VARCHAR(40),
    p_SubtipoDetalle VARCHAR(100),
    p_DescripcionDetalle VARCHAR(1000),
    p_Dosis VARCHAR(100),
    p_Frecuencia VARCHAR(100),
    p_Duracion VARCHAR(100),
    p_Indicaciones VARCHAR(500),
    p_Resultado VARCHAR(1000),
    p_Cantidad DECIMAL(12,2),
    p_FechaRegistro TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoDetalle INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_CitasConsultasDetalle AS t
    (
        CodigoCitaConsulta,
        CodigoProducto,
        TipoDetalle,
        SubtipoDetalle,
        DescripcionDetalle,
        Dosis,
        Frecuencia,
        Duracion,
        Indicaciones,
        Resultado,
        Cantidad,
        FechaRegistro,
        Estado
    )
    VALUES
    (
        p_CodigoCitaConsulta,
        p_CodigoProducto,
        p_TipoDetalle,
        p_SubtipoDetalle,
        p_DescripcionDetalle,
        p_Dosis,
        p_Frecuencia,
        p_Duracion,
        p_Indicaciones,
        p_Resultado,
        p_Cantidad,
        p_FechaRegistro,
        p_Estado
    )
    RETURNING t.CodigoDetalle INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultasDetalle_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultasDetalle_Editar
(
    p_CodigoDetalle INT,
    p_CodigoCitaConsulta INT,
    p_CodigoProducto INT,
    p_TipoDetalle VARCHAR(40),
    p_SubtipoDetalle VARCHAR(100),
    p_DescripcionDetalle VARCHAR(1000),
    p_Dosis VARCHAR(100),
    p_Frecuencia VARCHAR(100),
    p_Duracion VARCHAR(100),
    p_Indicaciones VARCHAR(500),
    p_Resultado VARCHAR(1000),
    p_Cantidad DECIMAL(12,2),
    p_FechaRegistro TIMESTAMP,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_CitasConsultasDetalle
    SET CodigoCitaConsulta = p_CodigoCitaConsulta,
        CodigoProducto = p_CodigoProducto,
        TipoDetalle = p_TipoDetalle,
        SubtipoDetalle = p_SubtipoDetalle,
        DescripcionDetalle = p_DescripcionDetalle,
        Dosis = p_Dosis,
        Frecuencia = p_Frecuencia,
        Duracion = p_Duracion,
        Indicaciones = p_Indicaciones,
        Resultado = p_Resultado,
        Cantidad = p_Cantidad,
        FechaRegistro = p_FechaRegistro,
        Estado = p_Estado
    WHERE CodigoDetalle = p_CodigoDetalle;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultasDetalle_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultasDetalle_Eliminar
(
    p_CodigoDetalle INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_CitasConsultasDetalle
    WHERE CodigoDetalle = p_CodigoDetalle;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultasDetalle_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultasDetalle_Consultar()
RETURNS TABLE
(
    CodigoDetalle INT,
    CodigoCitaConsulta INT,
    CodigoProducto INT,
    TipoDetalle VARCHAR(40),
    SubtipoDetalle VARCHAR(100),
    DescripcionDetalle VARCHAR(1000),
    Dosis VARCHAR(100),
    Frecuencia VARCHAR(100),
    Duracion VARCHAR(100),
    Indicaciones VARCHAR(500),
    Resultado VARCHAR(1000),
    Cantidad DECIMAL(12,2),
    FechaRegistro TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoDetalle,
        t.CodigoCitaConsulta,
        t.CodigoProducto,
        t.TipoDetalle,
        t.SubtipoDetalle,
        t.DescripcionDetalle,
        t.Dosis,
        t.Frecuencia,
        t.Duracion,
        t.Indicaciones,
        t.Resultado,
        t.Cantidad,
        t.FechaRegistro,
        t.Estado
    FROM Tbl_CitasConsultasDetalle t
    ORDER BY t.CodigoDetalle;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultasDetalle_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_CitasConsultasDetalle_Buscar
(
    p_CodigoDetalle INT
)
RETURNS TABLE
(
    CodigoDetalle INT,
    CodigoCitaConsulta INT,
    CodigoProducto INT,
    TipoDetalle VARCHAR(40),
    SubtipoDetalle VARCHAR(100),
    DescripcionDetalle VARCHAR(1000),
    Dosis VARCHAR(100),
    Frecuencia VARCHAR(100),
    Duracion VARCHAR(100),
    Indicaciones VARCHAR(500),
    Resultado VARCHAR(1000),
    Cantidad DECIMAL(12,2),
    FechaRegistro TIMESTAMP,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_CitasConsultasDetalle t
        WHERE t.CodigoDetalle = p_CodigoDetalle
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoDetalle,
        t.CodigoCitaConsulta,
        t.CodigoProducto,
        t.TipoDetalle,
        t.SubtipoDetalle,
        t.DescripcionDetalle,
        t.Dosis,
        t.Frecuencia,
        t.Duracion,
        t.Indicaciones,
        t.Resultado,
        t.Cantidad,
        t.FechaRegistro,
        t.Estado
    FROM Tbl_CitasConsultasDetalle t
    WHERE t.CodigoDetalle = p_CodigoDetalle;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_CitasConsultasDetalle_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  10. FUNCIONES CRUD DE TBL_HABITACIONES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Habitaciones_Agregar
(
    p_CodigoSucursal INT,
    p_NumeroHabitacion VARCHAR(20),
    p_CodigoCama VARCHAR(20),
    p_TipoHabitacion VARCHAR(50),
    p_Piso VARCHAR(20),
    p_Capacidad INT,
    p_TarifaDiaria DECIMAL(12,2),
    p_Descripcion VARCHAR(250),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoHabitacion INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Habitaciones AS t
    (
        CodigoSucursal,
        NumeroHabitacion,
        CodigoCama,
        TipoHabitacion,
        Piso,
        Capacidad,
        TarifaDiaria,
        Descripcion,
        Estado
    )
    VALUES
    (
        p_CodigoSucursal,
        p_NumeroHabitacion,
        p_CodigoCama,
        p_TipoHabitacion,
        p_Piso,
        p_Capacidad,
        p_TarifaDiaria,
        p_Descripcion,
        p_Estado
    )
    RETURNING t.CodigoHabitacion INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Habitaciones_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Habitaciones_Editar
(
    p_CodigoHabitacion INT,
    p_CodigoSucursal INT,
    p_NumeroHabitacion VARCHAR(20),
    p_CodigoCama VARCHAR(20),
    p_TipoHabitacion VARCHAR(50),
    p_Piso VARCHAR(20),
    p_Capacidad INT,
    p_TarifaDiaria DECIMAL(12,2),
    p_Descripcion VARCHAR(250),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Habitaciones
    SET CodigoSucursal = p_CodigoSucursal,
        NumeroHabitacion = p_NumeroHabitacion,
        CodigoCama = p_CodigoCama,
        TipoHabitacion = p_TipoHabitacion,
        Piso = p_Piso,
        Capacidad = p_Capacidad,
        TarifaDiaria = p_TarifaDiaria,
        Descripcion = p_Descripcion,
        Estado = p_Estado
    WHERE CodigoHabitacion = p_CodigoHabitacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Habitaciones_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Habitaciones_Eliminar
(
    p_CodigoHabitacion INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Habitaciones
    WHERE CodigoHabitacion = p_CodigoHabitacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Habitaciones_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Habitaciones_Consultar()
RETURNS TABLE
(
    CodigoHabitacion INT,
    CodigoSucursal INT,
    NumeroHabitacion VARCHAR(20),
    CodigoCama VARCHAR(20),
    TipoHabitacion VARCHAR(50),
    Piso VARCHAR(20),
    Capacidad INT,
    TarifaDiaria DECIMAL(12,2),
    Descripcion VARCHAR(250),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoHabitacion,
        t.CodigoSucursal,
        t.NumeroHabitacion,
        t.CodigoCama,
        t.TipoHabitacion,
        t.Piso,
        t.Capacidad,
        t.TarifaDiaria,
        t.Descripcion,
        t.Estado
    FROM Tbl_Habitaciones t
    ORDER BY t.CodigoHabitacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Habitaciones_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Habitaciones_Buscar
(
    p_CodigoHabitacion INT
)
RETURNS TABLE
(
    CodigoHabitacion INT,
    CodigoSucursal INT,
    NumeroHabitacion VARCHAR(20),
    CodigoCama VARCHAR(20),
    TipoHabitacion VARCHAR(50),
    Piso VARCHAR(20),
    Capacidad INT,
    TarifaDiaria DECIMAL(12,2),
    Descripcion VARCHAR(250),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Habitaciones t
        WHERE t.CodigoHabitacion = p_CodigoHabitacion
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoHabitacion,
        t.CodigoSucursal,
        t.NumeroHabitacion,
        t.CodigoCama,
        t.TipoHabitacion,
        t.Piso,
        t.Capacidad,
        t.TarifaDiaria,
        t.Descripcion,
        t.Estado
    FROM Tbl_Habitaciones t
    WHERE t.CodigoHabitacion = p_CodigoHabitacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Habitaciones_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  11. FUNCIONES CRUD DE TBL_HOSPITALIZACIONES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Hospitalizaciones_Agregar
(
    p_CodigoPaciente INT,
    p_CodigoSucursal INT,
    p_CodigoColaborador INT,
    p_CodigoCitaConsulta INT,
    p_CodigoHabitacion INT,
    p_FechaHoraIngreso TIMESTAMP,
    p_FechaHoraEgreso TIMESTAMP,
    p_MotivoIngreso VARCHAR(500),
    p_DiagnosticoIngreso VARCHAR(500),
    p_DiagnosticoEgreso VARCHAR(500),
    p_RecomendacionesEgreso VARCHAR(1000),
    p_Observaciones VARCHAR(1000),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoHospitalizacion INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Hospitalizaciones AS t
    (
        CodigoPaciente,
        CodigoSucursal,
        CodigoColaborador,
        CodigoCitaConsulta,
        CodigoHabitacion,
        FechaHoraIngreso,
        FechaHoraEgreso,
        MotivoIngreso,
        DiagnosticoIngreso,
        DiagnosticoEgreso,
        RecomendacionesEgreso,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoPaciente,
        p_CodigoSucursal,
        p_CodigoColaborador,
        p_CodigoCitaConsulta,
        p_CodigoHabitacion,
        p_FechaHoraIngreso,
        p_FechaHoraEgreso,
        p_MotivoIngreso,
        p_DiagnosticoIngreso,
        p_DiagnosticoEgreso,
        p_RecomendacionesEgreso,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoHospitalizacion INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Hospitalizaciones_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Hospitalizaciones_Editar
(
    p_CodigoHospitalizacion INT,
    p_CodigoPaciente INT,
    p_CodigoSucursal INT,
    p_CodigoColaborador INT,
    p_CodigoCitaConsulta INT,
    p_CodigoHabitacion INT,
    p_FechaHoraIngreso TIMESTAMP,
    p_FechaHoraEgreso TIMESTAMP,
    p_MotivoIngreso VARCHAR(500),
    p_DiagnosticoIngreso VARCHAR(500),
    p_DiagnosticoEgreso VARCHAR(500),
    p_RecomendacionesEgreso VARCHAR(1000),
    p_Observaciones VARCHAR(1000),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Hospitalizaciones
    SET CodigoPaciente = p_CodigoPaciente,
        CodigoSucursal = p_CodigoSucursal,
        CodigoColaborador = p_CodigoColaborador,
        CodigoCitaConsulta = p_CodigoCitaConsulta,
        CodigoHabitacion = p_CodigoHabitacion,
        FechaHoraIngreso = p_FechaHoraIngreso,
        FechaHoraEgreso = p_FechaHoraEgreso,
        MotivoIngreso = p_MotivoIngreso,
        DiagnosticoIngreso = p_DiagnosticoIngreso,
        DiagnosticoEgreso = p_DiagnosticoEgreso,
        RecomendacionesEgreso = p_RecomendacionesEgreso,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoHospitalizacion = p_CodigoHospitalizacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Hospitalizaciones_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Hospitalizaciones_Eliminar
(
    p_CodigoHospitalizacion INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Hospitalizaciones
    WHERE CodigoHospitalizacion = p_CodigoHospitalizacion;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Hospitalizaciones_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Hospitalizaciones_Consultar()
RETURNS TABLE
(
    CodigoHospitalizacion INT,
    CodigoPaciente INT,
    CodigoSucursal INT,
    CodigoColaborador INT,
    CodigoCitaConsulta INT,
    CodigoHabitacion INT,
    FechaHoraIngreso TIMESTAMP,
    FechaHoraEgreso TIMESTAMP,
    MotivoIngreso VARCHAR(500),
    DiagnosticoIngreso VARCHAR(500),
    DiagnosticoEgreso VARCHAR(500),
    RecomendacionesEgreso VARCHAR(1000),
    Observaciones VARCHAR(1000),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoHospitalizacion,
        t.CodigoPaciente,
        t.CodigoSucursal,
        t.CodigoColaborador,
        t.CodigoCitaConsulta,
        t.CodigoHabitacion,
        t.FechaHoraIngreso,
        t.FechaHoraEgreso,
        t.MotivoIngreso,
        t.DiagnosticoIngreso,
        t.DiagnosticoEgreso,
        t.RecomendacionesEgreso,
        t.Observaciones,
        t.Estado
    FROM Tbl_Hospitalizaciones t
    ORDER BY t.CodigoHospitalizacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Hospitalizaciones_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Hospitalizaciones_Buscar
(
    p_CodigoHospitalizacion INT
)
RETURNS TABLE
(
    CodigoHospitalizacion INT,
    CodigoPaciente INT,
    CodigoSucursal INT,
    CodigoColaborador INT,
    CodigoCitaConsulta INT,
    CodigoHabitacion INT,
    FechaHoraIngreso TIMESTAMP,
    FechaHoraEgreso TIMESTAMP,
    MotivoIngreso VARCHAR(500),
    DiagnosticoIngreso VARCHAR(500),
    DiagnosticoEgreso VARCHAR(500),
    RecomendacionesEgreso VARCHAR(1000),
    Observaciones VARCHAR(1000),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Hospitalizaciones t
        WHERE t.CodigoHospitalizacion = p_CodigoHospitalizacion
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoHospitalizacion,
        t.CodigoPaciente,
        t.CodigoSucursal,
        t.CodigoColaborador,
        t.CodigoCitaConsulta,
        t.CodigoHabitacion,
        t.FechaHoraIngreso,
        t.FechaHoraEgreso,
        t.MotivoIngreso,
        t.DiagnosticoIngreso,
        t.DiagnosticoEgreso,
        t.RecomendacionesEgreso,
        t.Observaciones,
        t.Estado
    FROM Tbl_Hospitalizaciones t
    WHERE t.CodigoHospitalizacion = p_CodigoHospitalizacion;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Hospitalizaciones_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  12. FUNCIONES CRUD DE TBL_PRODUCTOS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Productos_Agregar
(
    p_CodigoInterno VARCHAR(30),
    p_NombreProducto VARCHAR(150),
    p_TipoProducto VARCHAR(50),
    p_Categoria VARCHAR(100),
    p_Presentacion VARCHAR(100),
    p_UnidadMedida VARCHAR(50),
    p_PrincipioActivo VARCHAR(150),
    p_Concentracion VARCHAR(100),
    p_PrecioCompra DECIMAL(12,2),
    p_PrecioVenta DECIMAL(12,2),
    p_RequiereReceta BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoProducto INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Productos AS t
    (
        CodigoInterno,
        NombreProducto,
        TipoProducto,
        Categoria,
        Presentacion,
        UnidadMedida,
        PrincipioActivo,
        Concentracion,
        PrecioCompra,
        PrecioVenta,
        RequiereReceta,
        Estado
    )
    VALUES
    (
        p_CodigoInterno,
        p_NombreProducto,
        p_TipoProducto,
        p_Categoria,
        p_Presentacion,
        p_UnidadMedida,
        p_PrincipioActivo,
        p_Concentracion,
        p_PrecioCompra,
        p_PrecioVenta,
        p_RequiereReceta,
        p_Estado
    )
    RETURNING t.CodigoProducto INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Productos_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Productos_Editar
(
    p_CodigoProducto INT,
    p_CodigoInterno VARCHAR(30),
    p_NombreProducto VARCHAR(150),
    p_TipoProducto VARCHAR(50),
    p_Categoria VARCHAR(100),
    p_Presentacion VARCHAR(100),
    p_UnidadMedida VARCHAR(50),
    p_PrincipioActivo VARCHAR(150),
    p_Concentracion VARCHAR(100),
    p_PrecioCompra DECIMAL(12,2),
    p_PrecioVenta DECIMAL(12,2),
    p_RequiereReceta BOOLEAN,
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Productos
    SET CodigoInterno = p_CodigoInterno,
        NombreProducto = p_NombreProducto,
        TipoProducto = p_TipoProducto,
        Categoria = p_Categoria,
        Presentacion = p_Presentacion,
        UnidadMedida = p_UnidadMedida,
        PrincipioActivo = p_PrincipioActivo,
        Concentracion = p_Concentracion,
        PrecioCompra = p_PrecioCompra,
        PrecioVenta = p_PrecioVenta,
        RequiereReceta = p_RequiereReceta,
        Estado = p_Estado
    WHERE CodigoProducto = p_CodigoProducto;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Productos_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Productos_Eliminar
(
    p_CodigoProducto INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Productos
    WHERE CodigoProducto = p_CodigoProducto;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Productos_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Productos_Consultar()
RETURNS TABLE
(
    CodigoProducto INT,
    CodigoInterno VARCHAR(30),
    NombreProducto VARCHAR(150),
    TipoProducto VARCHAR(50),
    Categoria VARCHAR(100),
    Presentacion VARCHAR(100),
    UnidadMedida VARCHAR(50),
    PrincipioActivo VARCHAR(150),
    Concentracion VARCHAR(100),
    PrecioCompra DECIMAL(12,2),
    PrecioVenta DECIMAL(12,2),
    RequiereReceta BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoProducto,
        t.CodigoInterno,
        t.NombreProducto,
        t.TipoProducto,
        t.Categoria,
        t.Presentacion,
        t.UnidadMedida,
        t.PrincipioActivo,
        t.Concentracion,
        t.PrecioCompra,
        t.PrecioVenta,
        t.RequiereReceta,
        t.Estado
    FROM Tbl_Productos t
    ORDER BY t.CodigoProducto;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Productos_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Productos_Buscar
(
    p_CodigoProducto INT
)
RETURNS TABLE
(
    CodigoProducto INT,
    CodigoInterno VARCHAR(30),
    NombreProducto VARCHAR(150),
    TipoProducto VARCHAR(50),
    Categoria VARCHAR(100),
    Presentacion VARCHAR(100),
    UnidadMedida VARCHAR(50),
    PrincipioActivo VARCHAR(150),
    Concentracion VARCHAR(100),
    PrecioCompra DECIMAL(12,2),
    PrecioVenta DECIMAL(12,2),
    RequiereReceta BOOLEAN,
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Productos t
        WHERE t.CodigoProducto = p_CodigoProducto
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoProducto,
        t.CodigoInterno,
        t.NombreProducto,
        t.TipoProducto,
        t.Categoria,
        t.Presentacion,
        t.UnidadMedida,
        t.PrincipioActivo,
        t.Concentracion,
        t.PrecioCompra,
        t.PrecioVenta,
        t.RequiereReceta,
        t.Estado
    FROM Tbl_Productos t
    WHERE t.CodigoProducto = p_CodigoProducto;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Productos_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  13. FUNCIONES CRUD DE TBL_PROVEEDORES
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Proveedores_Agregar
(
    p_NIT VARCHAR(20),
    p_RazonSocial VARCHAR(150),
    p_NombreComercial VARCHAR(150),
    p_Direccion VARCHAR(200),
    p_Municipio VARCHAR(100),
    p_Departamento VARCHAR(100),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_PersonaContacto VARCHAR(150),
    p_TelefonoContacto VARCHAR(20),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoProveedor INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Proveedores AS t
    (
        NIT,
        RazonSocial,
        NombreComercial,
        Direccion,
        Municipio,
        Departamento,
        Telefono,
        CorreoElectronico,
        PersonaContacto,
        TelefonoContacto,
        Estado
    )
    VALUES
    (
        p_NIT,
        p_RazonSocial,
        p_NombreComercial,
        p_Direccion,
        p_Municipio,
        p_Departamento,
        p_Telefono,
        p_CorreoElectronico,
        p_PersonaContacto,
        p_TelefonoContacto,
        p_Estado
    )
    RETURNING t.CodigoProveedor INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Proveedores_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Proveedores_Editar
(
    p_CodigoProveedor INT,
    p_NIT VARCHAR(20),
    p_RazonSocial VARCHAR(150),
    p_NombreComercial VARCHAR(150),
    p_Direccion VARCHAR(200),
    p_Municipio VARCHAR(100),
    p_Departamento VARCHAR(100),
    p_Telefono VARCHAR(20),
    p_CorreoElectronico VARCHAR(120),
    p_PersonaContacto VARCHAR(150),
    p_TelefonoContacto VARCHAR(20),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Proveedores
    SET NIT = p_NIT,
        RazonSocial = p_RazonSocial,
        NombreComercial = p_NombreComercial,
        Direccion = p_Direccion,
        Municipio = p_Municipio,
        Departamento = p_Departamento,
        Telefono = p_Telefono,
        CorreoElectronico = p_CorreoElectronico,
        PersonaContacto = p_PersonaContacto,
        TelefonoContacto = p_TelefonoContacto,
        Estado = p_Estado
    WHERE CodigoProveedor = p_CodigoProveedor;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Proveedores_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Proveedores_Eliminar
(
    p_CodigoProveedor INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Proveedores
    WHERE CodigoProveedor = p_CodigoProveedor;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Proveedores_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Proveedores_Consultar()
RETURNS TABLE
(
    CodigoProveedor INT,
    NIT VARCHAR(20),
    RazonSocial VARCHAR(150),
    NombreComercial VARCHAR(150),
    Direccion VARCHAR(200),
    Municipio VARCHAR(100),
    Departamento VARCHAR(100),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    PersonaContacto VARCHAR(150),
    TelefonoContacto VARCHAR(20),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoProveedor,
        t.NIT,
        t.RazonSocial,
        t.NombreComercial,
        t.Direccion,
        t.Municipio,
        t.Departamento,
        t.Telefono,
        t.CorreoElectronico,
        t.PersonaContacto,
        t.TelefonoContacto,
        t.Estado
    FROM Tbl_Proveedores t
    ORDER BY t.CodigoProveedor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Proveedores_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Proveedores_Buscar
(
    p_CodigoProveedor INT
)
RETURNS TABLE
(
    CodigoProveedor INT,
    NIT VARCHAR(20),
    RazonSocial VARCHAR(150),
    NombreComercial VARCHAR(150),
    Direccion VARCHAR(200),
    Municipio VARCHAR(100),
    Departamento VARCHAR(100),
    Telefono VARCHAR(20),
    CorreoElectronico VARCHAR(120),
    PersonaContacto VARCHAR(150),
    TelefonoContacto VARCHAR(20),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Proveedores t
        WHERE t.CodigoProveedor = p_CodigoProveedor
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoProveedor,
        t.NIT,
        t.RazonSocial,
        t.NombreComercial,
        t.Direccion,
        t.Municipio,
        t.Departamento,
        t.Telefono,
        t.CorreoElectronico,
        t.PersonaContacto,
        t.TelefonoContacto,
        t.Estado
    FROM Tbl_Proveedores t
    WHERE t.CodigoProveedor = p_CodigoProveedor;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Proveedores_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  14. FUNCIONES CRUD DE TBL_MOVIMIENTOSINVENTARIO
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_MovimientosInventario_Agregar
(
    p_CodigoSucursal INT,
    p_CodigoProducto INT,
    p_CodigoProveedor INT,
    p_CodigoColaborador INT,
    p_FechaHoraMovimiento TIMESTAMP,
    p_TipoMovimiento VARCHAR(40),
    p_NumeroDocumento VARCHAR(50),
    p_Lote VARCHAR(50),
    p_FechaVencimiento DATE,
    p_CantidadEntrada DECIMAL(12,2),
    p_CantidadSalida DECIMAL(12,2),
    p_CostoUnitario DECIMAL(12,2),
    p_ExistenciaResultante DECIMAL(12,2),
    p_MotivoMovimiento VARCHAR(250),
    p_Observaciones VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoMovimientoInventario INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_MovimientosInventario AS t
    (
        CodigoSucursal,
        CodigoProducto,
        CodigoProveedor,
        CodigoColaborador,
        FechaHoraMovimiento,
        TipoMovimiento,
        NumeroDocumento,
        Lote,
        FechaVencimiento,
        CantidadEntrada,
        CantidadSalida,
        CostoUnitario,
        ExistenciaResultante,
        MotivoMovimiento,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoSucursal,
        p_CodigoProducto,
        p_CodigoProveedor,
        p_CodigoColaborador,
        p_FechaHoraMovimiento,
        p_TipoMovimiento,
        p_NumeroDocumento,
        p_Lote,
        p_FechaVencimiento,
        p_CantidadEntrada,
        p_CantidadSalida,
        p_CostoUnitario,
        p_ExistenciaResultante,
        p_MotivoMovimiento,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoMovimientoInventario INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_MovimientosInventario_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_MovimientosInventario_Editar
(
    p_CodigoMovimientoInventario INT,
    p_CodigoSucursal INT,
    p_CodigoProducto INT,
    p_CodigoProveedor INT,
    p_CodigoColaborador INT,
    p_FechaHoraMovimiento TIMESTAMP,
    p_TipoMovimiento VARCHAR(40),
    p_NumeroDocumento VARCHAR(50),
    p_Lote VARCHAR(50),
    p_FechaVencimiento DATE,
    p_CantidadEntrada DECIMAL(12,2),
    p_CantidadSalida DECIMAL(12,2),
    p_CostoUnitario DECIMAL(12,2),
    p_ExistenciaResultante DECIMAL(12,2),
    p_MotivoMovimiento VARCHAR(250),
    p_Observaciones VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_MovimientosInventario
    SET CodigoSucursal = p_CodigoSucursal,
        CodigoProducto = p_CodigoProducto,
        CodigoProveedor = p_CodigoProveedor,
        CodigoColaborador = p_CodigoColaborador,
        FechaHoraMovimiento = p_FechaHoraMovimiento,
        TipoMovimiento = p_TipoMovimiento,
        NumeroDocumento = p_NumeroDocumento,
        Lote = p_Lote,
        FechaVencimiento = p_FechaVencimiento,
        CantidadEntrada = p_CantidadEntrada,
        CantidadSalida = p_CantidadSalida,
        CostoUnitario = p_CostoUnitario,
        ExistenciaResultante = p_ExistenciaResultante,
        MotivoMovimiento = p_MotivoMovimiento,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoMovimientoInventario = p_CodigoMovimientoInventario;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_MovimientosInventario_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_MovimientosInventario_Eliminar
(
    p_CodigoMovimientoInventario INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_MovimientosInventario
    WHERE CodigoMovimientoInventario = p_CodigoMovimientoInventario;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_MovimientosInventario_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_MovimientosInventario_Consultar()
RETURNS TABLE
(
    CodigoMovimientoInventario INT,
    CodigoSucursal INT,
    CodigoProducto INT,
    CodigoProveedor INT,
    CodigoColaborador INT,
    FechaHoraMovimiento TIMESTAMP,
    TipoMovimiento VARCHAR(40),
    NumeroDocumento VARCHAR(50),
    Lote VARCHAR(50),
    FechaVencimiento DATE,
    CantidadEntrada DECIMAL(12,2),
    CantidadSalida DECIMAL(12,2),
    CostoUnitario DECIMAL(12,2),
    ExistenciaResultante DECIMAL(12,2),
    MotivoMovimiento VARCHAR(250),
    Observaciones VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoMovimientoInventario,
        t.CodigoSucursal,
        t.CodigoProducto,
        t.CodigoProveedor,
        t.CodigoColaborador,
        t.FechaHoraMovimiento,
        t.TipoMovimiento,
        t.NumeroDocumento,
        t.Lote,
        t.FechaVencimiento,
        t.CantidadEntrada,
        t.CantidadSalida,
        t.CostoUnitario,
        t.ExistenciaResultante,
        t.MotivoMovimiento,
        t.Observaciones,
        t.Estado
    FROM Tbl_MovimientosInventario t
    ORDER BY t.CodigoMovimientoInventario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_MovimientosInventario_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_MovimientosInventario_Buscar
(
    p_CodigoMovimientoInventario INT
)
RETURNS TABLE
(
    CodigoMovimientoInventario INT,
    CodigoSucursal INT,
    CodigoProducto INT,
    CodigoProveedor INT,
    CodigoColaborador INT,
    FechaHoraMovimiento TIMESTAMP,
    TipoMovimiento VARCHAR(40),
    NumeroDocumento VARCHAR(50),
    Lote VARCHAR(50),
    FechaVencimiento DATE,
    CantidadEntrada DECIMAL(12,2),
    CantidadSalida DECIMAL(12,2),
    CostoUnitario DECIMAL(12,2),
    ExistenciaResultante DECIMAL(12,2),
    MotivoMovimiento VARCHAR(250),
    Observaciones VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_MovimientosInventario t
        WHERE t.CodigoMovimientoInventario = p_CodigoMovimientoInventario
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoMovimientoInventario,
        t.CodigoSucursal,
        t.CodigoProducto,
        t.CodigoProveedor,
        t.CodigoColaborador,
        t.FechaHoraMovimiento,
        t.TipoMovimiento,
        t.NumeroDocumento,
        t.Lote,
        t.FechaVencimiento,
        t.CantidadEntrada,
        t.CantidadSalida,
        t.CostoUnitario,
        t.ExistenciaResultante,
        t.MotivoMovimiento,
        t.Observaciones,
        t.Estado
    FROM Tbl_MovimientosInventario t
    WHERE t.CodigoMovimientoInventario = p_CodigoMovimientoInventario;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_MovimientosInventario_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  15. FUNCIONES CRUD DE TBL_FACTURAS
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Facturas_Agregar
(
    p_CodigoPaciente INT,
    p_CodigoSucursal INT,
    p_CodigoColaborador INT,
    p_NumeroFactura VARCHAR(50),
    p_FechaHoraFactura TIMESTAMP,
    p_NombreFacturacion VARCHAR(150),
    p_NITFacturacion VARCHAR(20),
    p_DireccionFacturacion VARCHAR(200),
    p_Subtotal DECIMAL(12,2),
    p_Descuento DECIMAL(12,2),
    p_Impuesto DECIMAL(12,2),
    p_Total DECIMAL(12,2),
    p_SaldoPendiente DECIMAL(12,2),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoFactura INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_Facturas AS t
    (
        CodigoPaciente,
        CodigoSucursal,
        CodigoColaborador,
        NumeroFactura,
        FechaHoraFactura,
        NombreFacturacion,
        NITFacturacion,
        DireccionFacturacion,
        Subtotal,
        Descuento,
        Impuesto,
        Total,
        SaldoPendiente,
        Estado
    )
    VALUES
    (
        p_CodigoPaciente,
        p_CodigoSucursal,
        p_CodigoColaborador,
        p_NumeroFactura,
        p_FechaHoraFactura,
        p_NombreFacturacion,
        p_NITFacturacion,
        p_DireccionFacturacion,
        p_Subtotal,
        p_Descuento,
        p_Impuesto,
        p_Total,
        p_SaldoPendiente,
        p_Estado
    )
    RETURNING t.CodigoFactura INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Facturas_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Facturas_Editar
(
    p_CodigoFactura INT,
    p_CodigoPaciente INT,
    p_CodigoSucursal INT,
    p_CodigoColaborador INT,
    p_NumeroFactura VARCHAR(50),
    p_FechaHoraFactura TIMESTAMP,
    p_NombreFacturacion VARCHAR(150),
    p_NITFacturacion VARCHAR(20),
    p_DireccionFacturacion VARCHAR(200),
    p_Subtotal DECIMAL(12,2),
    p_Descuento DECIMAL(12,2),
    p_Impuesto DECIMAL(12,2),
    p_Total DECIMAL(12,2),
    p_SaldoPendiente DECIMAL(12,2),
    p_Estado VARCHAR(30)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_Facturas
    SET CodigoPaciente = p_CodigoPaciente,
        CodigoSucursal = p_CodigoSucursal,
        CodigoColaborador = p_CodigoColaborador,
        NumeroFactura = p_NumeroFactura,
        FechaHoraFactura = p_FechaHoraFactura,
        NombreFacturacion = p_NombreFacturacion,
        NITFacturacion = p_NITFacturacion,
        DireccionFacturacion = p_DireccionFacturacion,
        Subtotal = p_Subtotal,
        Descuento = p_Descuento,
        Impuesto = p_Impuesto,
        Total = p_Total,
        SaldoPendiente = p_SaldoPendiente,
        Estado = p_Estado
    WHERE CodigoFactura = p_CodigoFactura;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Facturas_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Facturas_Eliminar
(
    p_CodigoFactura INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_Facturas
    WHERE CodigoFactura = p_CodigoFactura;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Facturas_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Facturas_Consultar()
RETURNS TABLE
(
    CodigoFactura INT,
    CodigoPaciente INT,
    CodigoSucursal INT,
    CodigoColaborador INT,
    NumeroFactura VARCHAR(50),
    FechaHoraFactura TIMESTAMP,
    NombreFacturacion VARCHAR(150),
    NITFacturacion VARCHAR(20),
    DireccionFacturacion VARCHAR(200),
    Subtotal DECIMAL(12,2),
    Descuento DECIMAL(12,2),
    Impuesto DECIMAL(12,2),
    Total DECIMAL(12,2),
    SaldoPendiente DECIMAL(12,2),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoFactura,
        t.CodigoPaciente,
        t.CodigoSucursal,
        t.CodigoColaborador,
        t.NumeroFactura,
        t.FechaHoraFactura,
        t.NombreFacturacion,
        t.NITFacturacion,
        t.DireccionFacturacion,
        t.Subtotal,
        t.Descuento,
        t.Impuesto,
        t.Total,
        t.SaldoPendiente,
        t.Estado
    FROM Tbl_Facturas t
    ORDER BY t.CodigoFactura;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Facturas_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_Facturas_Buscar
(
    p_CodigoFactura INT
)
RETURNS TABLE
(
    CodigoFactura INT,
    CodigoPaciente INT,
    CodigoSucursal INT,
    CodigoColaborador INT,
    NumeroFactura VARCHAR(50),
    FechaHoraFactura TIMESTAMP,
    NombreFacturacion VARCHAR(150),
    NITFacturacion VARCHAR(20),
    DireccionFacturacion VARCHAR(200),
    Subtotal DECIMAL(12,2),
    Descuento DECIMAL(12,2),
    Impuesto DECIMAL(12,2),
    Total DECIMAL(12,2),
    SaldoPendiente DECIMAL(12,2),
    Estado VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_Facturas t
        WHERE t.CodigoFactura = p_CodigoFactura
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoFactura,
        t.CodigoPaciente,
        t.CodigoSucursal,
        t.CodigoColaborador,
        t.NumeroFactura,
        t.FechaHoraFactura,
        t.NombreFacturacion,
        t.NITFacturacion,
        t.DireccionFacturacion,
        t.Subtotal,
        t.Descuento,
        t.Impuesto,
        t.Total,
        t.SaldoPendiente,
        t.Estado
    FROM Tbl_Facturas t
    WHERE t.CodigoFactura = p_CodigoFactura;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_Facturas_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*==============================================================
  16. FUNCIONES CRUD DE TBL_FACTURASDETALLE
==============================================================*/

/*--------------------------------------------------------------
  AGREGAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_FacturasDetalle_Agregar
(
    p_CodigoFactura INT,
    p_TipoMovimiento VARCHAR(30),
    p_TipoCargo VARCHAR(50),
    p_Concepto VARCHAR(250),
    p_Cantidad DECIMAL(12,2),
    p_PrecioUnitario DECIMAL(12,2),
    p_Subtotal DECIMAL(12,2),
    p_MontoPago DECIMAL(12,2),
    p_FormaPago VARCHAR(50),
    p_ReferenciaPago VARCHAR(100),
    p_CodigoReferenciaOrigen INT,
    p_FechaHoraRegistro TIMESTAMP,
    p_Observaciones VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT,
    CodigoFacturaDetalle INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_CodigoGenerado INT;
BEGIN
    INSERT INTO Tbl_FacturasDetalle AS t
    (
        CodigoFactura,
        TipoMovimiento,
        TipoCargo,
        Concepto,
        Cantidad,
        PrecioUnitario,
        Subtotal,
        MontoPago,
        FormaPago,
        ReferenciaPago,
        CodigoReferenciaOrigen,
        FechaHoraRegistro,
        Observaciones,
        Estado
    )
    VALUES
    (
        p_CodigoFactura,
        p_TipoMovimiento,
        p_TipoCargo,
        p_Concepto,
        p_Cantidad,
        p_PrecioUnitario,
        p_Subtotal,
        p_MontoPago,
        p_FormaPago,
        p_ReferenciaPago,
        p_CodigoReferenciaOrigen,
        p_FechaHoraRegistro,
        p_Observaciones,
        p_Estado
    )
    RETURNING t.CodigoFacturaDetalle INTO v_CodigoGenerado;

    RETURN QUERY
    SELECT
        1,
        'Registro agregado correctamente.'::TEXT,
        v_CodigoGenerado;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_FacturasDetalle_Agregar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  EDITAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_FacturasDetalle_Editar
(
    p_CodigoFacturaDetalle INT,
    p_CodigoFactura INT,
    p_TipoMovimiento VARCHAR(30),
    p_TipoCargo VARCHAR(50),
    p_Concepto VARCHAR(250),
    p_Cantidad DECIMAL(12,2),
    p_PrecioUnitario DECIMAL(12,2),
    p_Subtotal DECIMAL(12,2),
    p_MontoPago DECIMAL(12,2),
    p_FormaPago VARCHAR(50),
    p_ReferenciaPago VARCHAR(100),
    p_CodigoReferenciaOrigen INT,
    p_FechaHoraRegistro TIMESTAMP,
    p_Observaciones VARCHAR(500),
    p_Estado VARCHAR(20)
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    UPDATE Tbl_FacturasDetalle
    SET CodigoFactura = p_CodigoFactura,
        TipoMovimiento = p_TipoMovimiento,
        TipoCargo = p_TipoCargo,
        Concepto = p_Concepto,
        Cantidad = p_Cantidad,
        PrecioUnitario = p_PrecioUnitario,
        Subtotal = p_Subtotal,
        MontoPago = p_MontoPago,
        FormaPago = p_FormaPago,
        ReferenciaPago = p_ReferenciaPago,
        CodigoReferenciaOrigen = p_CodigoReferenciaOrigen,
        FechaHoraRegistro = p_FechaHoraRegistro,
        Observaciones = p_Observaciones,
        Estado = p_Estado
    WHERE CodigoFacturaDetalle = p_CodigoFacturaDetalle;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro actualizado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_FacturasDetalle_Editar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  ELIMINAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_FacturasDetalle_Eliminar
(
    p_CodigoFacturaDetalle INT
)
RETURNS TABLE
(
    Exito INT,
    Mensaje TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_FilasAfectadas INT;
BEGIN
    DELETE FROM Tbl_FacturasDetalle
    WHERE CodigoFacturaDetalle = p_CodigoFacturaDetalle;

    GET DIAGNOSTICS v_FilasAfectadas = ROW_COUNT;

    IF v_FilasAfectadas = 0 THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        1,
        'Registro eliminado correctamente.'::TEXT;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_FacturasDetalle_Eliminar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  CONSULTAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_FacturasDetalle_Consultar()
RETURNS TABLE
(
    CodigoFacturaDetalle INT,
    CodigoFactura INT,
    TipoMovimiento VARCHAR(30),
    TipoCargo VARCHAR(50),
    Concepto VARCHAR(250),
    Cantidad DECIMAL(12,2),
    PrecioUnitario DECIMAL(12,2),
    Subtotal DECIMAL(12,2),
    MontoPago DECIMAL(12,2),
    FormaPago VARCHAR(50),
    ReferenciaPago VARCHAR(100),
    CodigoReferenciaOrigen INT,
    FechaHoraRegistro TIMESTAMP,
    Observaciones VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.CodigoFacturaDetalle,
        t.CodigoFactura,
        t.TipoMovimiento,
        t.TipoCargo,
        t.Concepto,
        t.Cantidad,
        t.PrecioUnitario,
        t.Subtotal,
        t.MontoPago,
        t.FormaPago,
        t.ReferenciaPago,
        t.CodigoReferenciaOrigen,
        t.FechaHoraRegistro,
        t.Observaciones,
        t.Estado
    FROM Tbl_FacturasDetalle t
    ORDER BY t.CodigoFacturaDetalle;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_FacturasDetalle_Consultar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;


/*--------------------------------------------------------------
  BUSCAR
--------------------------------------------------------------*/
CREATE OR REPLACE FUNCTION Usp_FacturasDetalle_Buscar
(
    p_CodigoFacturaDetalle INT
)
RETURNS TABLE
(
    CodigoFacturaDetalle INT,
    CodigoFactura INT,
    TipoMovimiento VARCHAR(30),
    TipoCargo VARCHAR(50),
    Concepto VARCHAR(250),
    Cantidad DECIMAL(12,2),
    PrecioUnitario DECIMAL(12,2),
    Subtotal DECIMAL(12,2),
    MontoPago DECIMAL(12,2),
    FormaPago VARCHAR(50),
    ReferenciaPago VARCHAR(100),
    CodigoReferenciaOrigen INT,
    FechaHoraRegistro TIMESTAMP,
    Observaciones VARCHAR(500),
    Estado VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS
    (
        SELECT 1
        FROM Tbl_FacturasDetalle t
        WHERE t.CodigoFacturaDetalle = p_CodigoFacturaDetalle
    ) THEN
        RAISE EXCEPTION 'No se encontró el registro solicitado.';
    END IF;

    RETURN QUERY
    SELECT
        t.CodigoFacturaDetalle,
        t.CodigoFactura,
        t.TipoMovimiento,
        t.TipoCargo,
        t.Concepto,
        t.Cantidad,
        t.PrecioUnitario,
        t.Subtotal,
        t.MontoPago,
        t.FormaPago,
        t.ReferenciaPago,
        t.CodigoReferenciaOrigen,
        t.FechaHoraRegistro,
        t.Observaciones,
        t.Estado
    FROM Tbl_FacturasDetalle t
    WHERE t.CodigoFacturaDetalle = p_CodigoFacturaDetalle;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION
            'Procedimiento: Usp_FacturasDetalle_Buscar | SQLSTATE: % | Mensaje: %',
            SQLSTATE,
            SQLERRM;
END;
$$;

/*==============================================================
  CONSULTAS DE VALIDACION
==============================================================*/

-- Cantidad esperada: 80 funciones CRUD Usp_
SELECT
    routine_name,
    routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND LOWER(routine_name) LIKE 'usp_%'
ORDER BY routine_name;

-- Ejemplos:
-- SELECT * FROM Usp_Sucursales_Consultar();
-- SELECT * FROM Usp_Sucursales_Buscar(1);
-- SELECT * FROM Usp_Roles_Consultar();
-- SELECT * FROM Usp_Pacientes_Buscar(1);
