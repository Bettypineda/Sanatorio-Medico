SELECT * FROM Usp_Sucursales_Consultar();
SELECT * FROM Usp_Sucursales_Consultar();
SELECT * FROM Usp_Sucursales_Agregar
(
    'Sucursal Prueba',
    'Zona 1, Ciudad de Guatemala',
    '2026-08-30',
    '08:00:00',
    250000.00,
    TRUE
);

SELECT * FROM Usp_Sucursales_Editar
(
    6,
    'Sucursal Prueba Modificada',
    'Zona 10, Ciudad de Guatemala',
    '2026-08-30',
    '09:00:00',
    300000.00,
    TRUE
);

SELECT * FROM Usp_Sucursales_Eliminar(6);

SELECT * FROM Usp_Sucursales_Consultar();

SELECT * FROM Usp_Sucursales_Buscar(9999);
SELECT * FROM Usp_Sucursales_Buscar(2);

