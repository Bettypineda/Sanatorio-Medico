/*==============================================================
  SCRIPT DML - DATOS DE PRUEBA
  BASE DE DATOS: db_SanatorioMedico
  MOTOR: PostgreSQL 18

  IMPORTANTE:
  - Ejecutar conectado directamente a db_sanatoriomedico.
  - PostgreSQL no utiliza USE ni GO.
  - Los campos BOOLEAN usan TRUE/FALSE.
  - Se conservan los mismos datos y el mismo orden de inserción
    del script utilizado anteriormente en SQL Server.
==============================================================*/

INSERT INTO Tbl_Sucursales
(
    NombreSucursal, Direccion, FechaApertura, HoraApertura,
    PresupuestoMensual, Estado
)
VALUES
('Sucursal Central Zona 10', '6a. Avenida 8-32, Zona 10, Ciudad de Guatemala', '2015-01-15', '06:00:00', 850000.00, TRUE),
('Sucursal Cuilapa', '2a. Avenida 3-45, Zona 1, Cuilapa, Santa Rosa', '2018-03-12', '07:00:00', 420000.00, TRUE),
('Sucursal Escuintla', '4a. Calle 6-20, Zona 1, Escuintla', '2019-07-08', '07:00:00', 475000.00, TRUE),
('Sucursal Quetzaltenango', '12 Avenida 5-60, Zona 3, Quetzaltenango', '2020-02-10', '06:30:00', 525000.00, TRUE),
('Sucursal Cobán', '1a. Calle 4-18, Zona 2, Cobán, Alta Verapaz', '2021-09-20', '07:00:00', 390000.00, TRUE);

INSERT INTO Tbl_Roles
(
    NombreRol, DescripcionRol, ModuloPrincipal,
    PermiteConsultar, PermiteAgregar, PermiteEditar,
    PermiteAnular, Estado
)
VALUES
('Administrador', 'Administra usuarios, catálogos y configuración general.', 'Administración', TRUE, TRUE, TRUE, TRUE, 'Activo'),
('Médico', 'Consulta expedientes y registra atenciones médicas.', 'Atención médica', TRUE, TRUE, TRUE, FALSE, 'Activo'),
('Recepción', 'Registra pacientes, citas y admisiones.', 'Recepción', TRUE, TRUE, TRUE, FALSE, 'Activo'),
('Farmacia', 'Gestiona productos y movimientos de inventario.', 'Farmacia', TRUE, TRUE, TRUE, FALSE, 'Activo'),
('Caja', 'Registra facturas, cargos y pagos.', 'Facturación', TRUE, TRUE, TRUE, TRUE, 'Activo');

INSERT INTO Tbl_Colaboradores
(
    CodigoSucursal, CodigoRol, Nombres, Apellidos, DPI,
    NumeroColegiado, TipoColaborador, Telefono, CorreoElectronico,
    Direccion, FechaContratacion, NombreUsuario, ClaveAcceso, Estado
)
VALUES
(1, 1, 'Andrea Lucía', 'Morales Pérez', '2567890140101', NULL, 'Administrativo', '5550-1001', 'andrea.morales@sanatorioumg.gt', 'Zona 12, Ciudad de Guatemala', '2020-01-10', 'amorales', 'Hash_Administrador_001', 'Activo'),
(1, 2, 'Carlos Roberto', 'Méndez López', '2689451200101', '14567', 'Médico', '5550-1002', 'carlos.mendez@sanatorioumg.gt', 'Zona 15, Ciudad de Guatemala', '2019-03-15', 'cmendez', 'Hash_Medico_002', 'Activo'),
(2, 2, 'María Fernanda', 'García Hernández', '2798456100601', '18754', 'Médico', '5550-1003', 'maria.garcia@sanatorioumg.gt', 'Cuilapa, Santa Rosa', '2021-02-01', 'mgarcia', 'Hash_Medico_003', 'Activo'),
(3, 2, 'José Alejandro', 'Ramírez Castillo', '3012456700501', '20118', 'Médico', '5550-1004', 'jose.ramirez@sanatorioumg.gt', 'Escuintla, Escuintla', '2022-06-20', 'jramirez', 'Hash_Medico_004', 'Activo'),
(4, 2, 'Sofía Isabel', 'Cabrera de León', '3123456700901', '22345', 'Médico', '5550-1005', 'sofia.cabrera@sanatorioumg.gt', 'Quetzaltenango, Quetzaltenango', '2020-08-05', 'scabrera', 'Hash_Medico_005', 'Activo'),
(5, 2, 'Luis Fernando', 'Choc Pop', '3234567801601', '23567', 'Médico', '5550-1006', 'luis.choc@sanatorioumg.gt', 'Cobán, Alta Verapaz', '2023-01-16', 'lchoc', 'Hash_Medico_006', 'Activo'),
(1, 3, 'Diana Carolina', 'Vásquez Soto', '3345678900101', NULL, 'Recepcionista', '5550-1007', 'diana.vasquez@sanatorioumg.gt', 'Mixco, Guatemala', '2022-04-11', 'dvasquez', 'Hash_Recepcion_007', 'Activo'),
(2, 3, 'Edgar Antonio', 'López Reyes', '3456789010601', NULL, 'Recepcionista', '5550-1008', 'edgar.lopez@sanatorioumg.gt', 'Barberena, Santa Rosa', '2023-05-22', 'elopez', 'Hash_Recepcion_008', 'Activo'),
(1, 4, 'Paola Alejandra', 'Santos Ruiz', '3567890120101', NULL, 'Farmacéutica', '5550-1009', 'paola.santos@sanatorioumg.gt', 'Villa Nueva, Guatemala', '2021-07-19', 'psantos', 'Hash_Farmacia_009', 'Activo'),
(1, 5, 'Miguel Ángel', 'Pérez Juárez', '3678901230101', NULL, 'Cajero', '5550-1010', 'miguel.perez@sanatorioumg.gt', 'Amatitlán, Guatemala', '2022-09-12', 'mperez', 'Hash_Caja_010', 'Activo');

INSERT INTO Tbl_Pacientes
(
    NumeroExpediente, TipoDocumento, NumeroDocumento, Nombres,
    Apellidos, FechaNacimiento, Genero, TipoSangre, Telefono,
    CorreoElectronico, Direccion, ContactoEmergencia,
    TelefonoEmergencia, Alergias, Estado
)
VALUES
('EXP-0001', 'DPI', '1987654320101', 'Juan Carlos', 'Gómez Pérez', '1985-04-12', 'Masculino', 'O+', '5512-1001', 'juan.gomez@gmail.com', 'Zona 7, Ciudad de Guatemala', 'Ana Pérez', '5512-2001', 'Penicilina', 'Activo'),
('EXP-0002', 'DPI', '2098765430601', 'María José', 'Hernández López', '1992-08-25', 'Femenino', 'A+', '5512-1002', 'maria.hernandez@gmail.com', 'Cuilapa, Santa Rosa', 'Carlos Hernández', '5512-2002', NULL, 'Activo'),
('EXP-0003', 'DPI', '2209876540501', 'Pedro Antonio', 'Ramírez García', '1978-11-03', 'Masculino', 'B+', '5512-1003', 'pedro.ramirez@gmail.com', 'Escuintla, Escuintla', 'Rosa García', '5512-2003', 'Sulfas', 'Activo'),
('EXP-0004', 'DPI', '2310987650901', 'Ana Lucía', 'Cifuentes Díaz', '2001-02-18', 'Femenino', 'O-', '5512-1004', 'ana.cifuentes@gmail.com', 'Quetzaltenango, Quetzaltenango', 'Luis Cifuentes', '5512-2004', NULL, 'Activo'),
('EXP-0005', 'DPI', '2421098761601', 'Manuel Enrique', 'Caal Tut', '1969-07-09', 'Masculino', 'A-', '5512-1005', NULL, 'Cobán, Alta Verapaz', 'Juana Tut', '5512-2005', 'Ibuprofeno', 'Activo'),
('EXP-0006', 'DPI', '2532109870101', 'Gabriela Fernanda', 'Soto Morales', '1996-10-14', 'Femenino', 'AB+', '5512-1006', 'gabriela.soto@gmail.com', 'Mixco, Guatemala', 'Mario Soto', '5512-2006', NULL, 'Activo'),
('EXP-0007', 'DPI', '2643210980601', 'Jorge Estuardo', 'López Marroquín', '1988-05-30', 'Masculino', 'O+', '5512-1007', 'jorge.lopez@gmail.com', 'Barberena, Santa Rosa', 'Patricia Marroquín', '5512-2007', 'Aspirina', 'Activo'),
('EXP-0008', 'Pasaporte', 'GT-PAS-87452', 'Emily Rose', 'Thompson', '1990-12-20', 'Femenino', 'A+', '5512-1008', 'emily.thompson@email.com', 'Antigua Guatemala, Sacatepéquez', 'Michael Thompson', '5512-2008', NULL, 'Activo'),
('EXP-0009', 'DPI', '2754321090101', 'Ricardo Andrés', 'Velásquez Cruz', '1975-09-17', 'Masculino', 'B-', '5512-1009', 'ricardo.velasquez@gmail.com', 'Villa Nueva, Guatemala', 'Marta Cruz', '5512-2009', 'Diclofenaco', 'Activo'),
('EXP-0010', 'Certificado de nacimiento', 'CN-2015-45871', 'Valeria Sofía', 'Martínez Rojas', '2015-06-11', 'Femenino', 'O+', '5512-1010', NULL, 'Jalapa, Jalapa', 'Claudia Rojas', '5512-2010', NULL, 'Activo');

INSERT INTO Tbl_Especialidades
(
    NombreEspecialidad, Descripcion, AreaMedica, DuracionConsulta,
    CostoConsulta, RequiereCita, Observaciones, Estado
)
VALUES
('Medicina General', 'Atención primaria y evaluación general del paciente.', 'Consulta externa', 30, 300.00, TRUE, 'Atiende pacientes adultos y adolescentes.', 'Activo'),
('Pediatría', 'Atención médica para niños y adolescentes.', 'Consulta externa', 30, 350.00, TRUE, 'Atiende pacientes menores de edad.', 'Activo'),
('Cardiología', 'Evaluación y tratamiento de enfermedades cardiovasculares.', 'Especialidades', 45, 550.00, TRUE, 'Puede requerir electrocardiograma.', 'Activo'),
('Traumatología', 'Atención de lesiones óseas, articulares y musculares.', 'Especialidades', 40, 500.00, TRUE, 'Incluye valoración inicial.', 'Activo'),
('Ginecología', 'Atención integral de la salud femenina.', 'Especialidades', 40, 450.00, TRUE, 'Consulta con cita previa.', 'Activo');

INSERT INTO Tbl_ColaboradoresEspecialidades
(
    CodigoColaborador, CodigoEspecialidad, FechaAsignacion,
    NumeroAutorizacion, InstitucionAcreditadora, FechaVencimiento,
    Observaciones, Estado
)
VALUES
(2, 1, '2019-03-15', 'AUT-2019-001', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Especialidad principal.', 'Activo'),
(2, 3, '2020-01-10', 'AUT-2020-015', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Subespecialidad cardiovascular.', 'Activo'),
(3, 1, '2021-02-01', 'AUT-2021-021', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención general.', 'Activo'),
(3, 2, '2021-02-01', 'AUT-2021-022', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención pediátrica.', 'Activo'),
(4, 1, '2022-06-20', 'AUT-2022-045', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención general.', 'Activo'),
(4, 4, '2022-06-20', 'AUT-2022-046', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Traumatología y ortopedia.', 'Activo'),
(5, 1, '2020-08-05', 'AUT-2020-063', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención general.', 'Activo'),
(5, 5, '2020-08-05', 'AUT-2020-064', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Ginecología.', 'Activo'),
(6, 1, '2023-01-16', 'AUT-2023-010', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención general.', 'Activo'),
(6, 2, '2023-01-16', 'AUT-2023-011', 'Colegio de Médicos y Cirujanos de Guatemala', '2027-12-31', 'Atención pediátrica.', 'Activo');

INSERT INTO Tbl_Horarios
(
    CodigoColaborador, CodigoSucursal, CodigoEspecialidad,
    DiaSemana, HoraInicio, HoraFin, DuracionCitaMinutos,
    Jornada, Observaciones, Estado
)
VALUES
(2, 1, 1, 'Lunes', '07:00:00', '12:00:00', 30, 'Matutina', 'Consulta externa.', 'Activo'),
(2, 1, 3, 'Miércoles', '14:00:00', '18:00:00', 45, 'Vespertina', 'Cardiología.', 'Activo'),
(3, 2, 1, 'Martes', '07:00:00', '12:00:00', 30, 'Matutina', 'Consulta general.', 'Activo'),
(3, 2, 2, 'Jueves', '13:00:00', '17:00:00', 30, 'Vespertina', 'Pediatría.', 'Activo'),
(4, 3, 1, 'Lunes', '08:00:00', '13:00:00', 30, 'Matutina', 'Consulta general.', 'Activo'),
(4, 3, 4, 'Viernes', '13:00:00', '17:00:00', 40, 'Vespertina', 'Traumatología.', 'Activo'),
(5, 4, 1, 'Martes', '08:00:00', '12:00:00', 30, 'Matutina', 'Consulta general.', 'Activo'),
(5, 4, 5, 'Jueves', '14:00:00', '18:00:00', 40, 'Vespertina', 'Ginecología.', 'Activo'),
(6, 5, 1, 'Miércoles', '07:00:00', '12:00:00', 30, 'Matutina', 'Consulta general.', 'Activo'),
(6, 5, 2, 'Sábado', '08:00:00', '13:00:00', 30, 'Matutina', 'Pediatría.', 'Activo');

INSERT INTO Tbl_CitasConsultas
(
    CodigoPaciente, CodigoColaborador, CodigoSucursal,
    CodigoEspecialidad, FechaHoraCita, TipoAtencion,
    MotivoConsulta, Sintomas, ObservacionesMedicas,
    TratamientoGeneral, PresionArterial, Temperatura,
    Peso, Estado
)
VALUES
(1, 2, 1, 1, '2026-07-06T08:00:00', 'Consulta', 'Dolor de cabeza frecuente.', 'Cefalea y cansancio.', 'Paciente estable.', 'Hidratación y analgésico.', '120/80', 36.70, 78.50, 'Atendida'),
(2, 3, 2, 2, '2026-07-07T09:00:00', 'Consulta', 'Fiebre y tos.', 'Fiebre, tos seca y congestión.', 'Sin dificultad respiratoria.', 'Reposo e hidratación.', '110/70', 38.10, 62.00, 'Atendida'),
(3, 4, 3, 4, '2026-07-10T14:00:00', 'Consulta', 'Dolor en rodilla derecha.', 'Dolor al caminar.', 'Posible lesión de menisco.', 'Reposo y estudio radiológico.', '125/82', 36.50, 84.20, 'Atendida'),
(4, 5, 4, 5, '2026-07-09T15:00:00', 'Consulta', 'Control ginecológico anual.', NULL, 'Evaluación preventiva.', 'Solicitar ultrasonido.', '115/75', 36.60, 58.40, 'Atendida'),
(5, 6, 5, 1, '2026-07-08T08:30:00', 'Consulta', 'Dolor abdominal.', 'Náusea y dolor epigástrico.', 'Probable gastritis.', 'Dieta blanda y protector gástrico.', '130/85', 37.00, 72.30, 'Atendida'),
(6, 2, 1, 3, '2026-07-08T15:00:00', 'Consulta', 'Palpitaciones.', 'Taquicardia ocasional.', 'Se solicita electrocardiograma.', 'Evitar cafeína.', '135/88', 36.80, 65.10, 'Atendida'),
(7, 3, 2, 2, '2026-07-09T14:00:00', 'Consulta', 'Dolor de garganta.', 'Fiebre leve y dolor al tragar.', 'Faringitis probable.', 'Tratamiento sintomático.', '112/72', 37.80, 70.00, 'Atendida'),
(8, 4, 3, 1, '2026-07-13T09:00:00', 'Consulta', 'Chequeo general.', 'Sin síntomas relevantes.', 'Paciente en buenas condiciones.', 'Control anual.', '118/76', 36.40, 59.80, 'Atendida'),
(9, 5, 4, 1, '2026-07-14T08:30:00', 'Emergencia', 'Dolor torácico.', 'Dolor agudo y sudoración.', 'Requiere observación hospitalaria.', 'Monitoreo y exámenes.', '145/92', 37.10, 90.50, 'Hospitalizada'),
(10, 6, 5, 2, '2026-07-18T10:00:00', 'Consulta', 'Fiebre infantil.', 'Fiebre de dos días.', 'Vigilancia y tratamiento.', 'Antipirético según peso.', '100/65', 38.50, 32.00, 'Atendida');

INSERT INTO Tbl_Productos
(
    CodigoInterno, NombreProducto, TipoProducto, Categoria,
    Presentacion, UnidadMedida, PrincipioActivo, Concentracion,
    PrecioCompra, PrecioVenta, RequiereReceta, Estado
)
VALUES
('MED-001', 'Acetaminofén', 'Medicamento', 'Analgésico', 'Caja de 20 tabletas', 'Caja', 'Paracetamol', '500 mg', 12.00, 20.00, FALSE, 'Activo'),
('MED-002', 'Amoxicilina', 'Medicamento', 'Antibiótico', 'Caja de 21 cápsulas', 'Caja', 'Amoxicilina', '500 mg', 35.00, 55.00, TRUE, 'Activo'),
('MED-003', 'Omeprazol', 'Medicamento', 'Gastrointestinal', 'Caja de 14 cápsulas', 'Caja', 'Omeprazol', '20 mg', 18.00, 30.00, FALSE, 'Activo'),
('INS-001', 'Jeringa descartable', 'Insumo', 'Material médico', 'Unidad estéril', 'Unidad', NULL, NULL, 1.25, 2.50, FALSE, 'Activo'),
('INS-002', 'Solución salina', 'Insumo', 'Soluciones intravenosas', 'Bolsa de 1000 ml', 'Bolsa', 'Cloruro de sodio', '0.9%', 10.00, 18.00, FALSE, 'Activo');

INSERT INTO Tbl_CitasConsultasDetalle
(
    CodigoCitaConsulta, CodigoProducto, TipoDetalle, SubtipoDetalle,
    DescripcionDetalle, Dosis, Frecuencia, Duracion, Indicaciones,
    Resultado, Cantidad, FechaRegistro, Estado
)
VALUES
(1, 1, 'Medicamento', 'Receta', 'Acetaminofén para control del dolor.', '500 mg', 'Cada 8 horas', '3 días', 'Tomar después de alimentos.', NULL, 1.00, '2026-07-06T08:35:00', 'Activo'),
(2, NULL, 'Diagnóstico', 'Diagnóstico clínico', 'Infección respiratoria superior.', NULL, NULL, NULL, 'Mantener hidratación.', NULL, NULL, '2026-07-07T09:30:00', 'Activo'),
(3, NULL, 'Examen', 'Radiología', 'Radiografía de rodilla derecha.', NULL, NULL, NULL, 'Realizar en posición frontal y lateral.', 'Pendiente', 1.00, '2026-07-10T14:40:00', 'Activo'),
(4, NULL, 'Examen', 'Ultrasonido', 'Ultrasonido pélvico.', NULL, NULL, NULL, 'Presentarse con vejiga llena.', 'Pendiente', 1.00, '2026-07-09T15:45:00', 'Activo'),
(5, 3, 'Medicamento', 'Receta', 'Omeprazol para probable gastritis.', '20 mg', 'Una vez al día', '14 días', 'Tomar antes del desayuno.', NULL, 1.00, '2026-07-08T09:00:00', 'Activo'),
(6, NULL, 'Examen', 'Cardiología', 'Electrocardiograma en reposo.', NULL, NULL, NULL, 'Evitar ejercicio previo.', 'Ritmo sinusal.', 1.00, '2026-07-08T15:50:00', 'Activo'),
(7, 2, 'Medicamento', 'Receta', 'Amoxicilina por infección bacteriana probable.', '500 mg', 'Cada 8 horas', '7 días', 'Completar el tratamiento.', NULL, 1.00, '2026-07-09T14:35:00', 'Activo'),
(8, NULL, 'Diagnóstico', 'Diagnóstico preventivo', 'Paciente clínicamente estable.', NULL, NULL, NULL, 'Control en un año.', NULL, NULL, '2026-07-13T09:30:00', 'Activo'),
(9, NULL, 'Procedimiento', 'Observación', 'Monitoreo cardíaco y control de signos vitales.', NULL, NULL, '6 horas', 'Mantener en observación.', NULL, 1.00, '2026-07-14T09:00:00', 'Activo'),
(10, 1, 'Medicamento', 'Receta pediátrica', 'Acetaminofén para fiebre.', '250 mg', 'Cada 6 horas', '3 días', 'Administrar según indicación médica.', NULL, 1.00, '2026-07-18T10:30:00', 'Activo');

INSERT INTO Tbl_Habitaciones
(
    CodigoSucursal, NumeroHabitacion, CodigoCama, TipoHabitacion,
    Piso, Capacidad, TarifaDiaria, Descripcion, Estado
)
VALUES
(1, '101', 'CAMA-101-A', 'Privada', 'Primer nivel', 1, 1200.00, 'Habitación privada con baño.', 'Disponible'),
(1, '102', 'CAMA-102-A', 'Semiprivada', 'Primer nivel', 2, 850.00, 'Habitación semiprivada.', 'Disponible'),
(2, '201', 'CAMA-201-A', 'General', 'Segundo nivel', 3, 500.00, 'Área general de hospitalización.', 'Disponible'),
(3, '301', 'CAMA-301-A', 'Privada', 'Tercer nivel', 1, 1000.00, 'Habitación privada.', 'Disponible'),
(4, '401', 'CAMA-401-A', 'Intensivo', 'Cuarto nivel', 1, 2200.00, 'Cama para cuidados intensivos.', 'Disponible');

INSERT INTO Tbl_Hospitalizaciones
(
    CodigoPaciente, CodigoSucursal, CodigoColaborador,
    CodigoCitaConsulta, CodigoHabitacion, FechaHoraIngreso,
    FechaHoraEgreso, MotivoIngreso, DiagnosticoIngreso,
    DiagnosticoEgreso, RecomendacionesEgreso, Observaciones, Estado
)
VALUES
(9, 4, 5, 9, 5, '2026-07-14T09:15:00', NULL, 'Dolor torácico y presión elevada.', 'Dolor torácico en estudio.', NULL, NULL, 'Paciente en observación.', 'Activa'),
(1, 1, 2, 1, 1, '2026-06-01T10:00:00', '2026-06-03T11:00:00', 'Cefalea persistente.', 'Migraña severa.', 'Paciente estable.', 'Control en consulta externa.', 'Evolución favorable.', 'Finalizada'),
(2, 2, 3, 2, 3, '2026-06-05T12:00:00', '2026-06-06T10:00:00', 'Fiebre persistente.', 'Infección respiratoria.', 'Mejoría clínica.', 'Continuar tratamiento oral.', 'Sin complicaciones.', 'Finalizada'),
(3, 3, 4, 3, 4, '2026-06-10T15:00:00', '2026-06-12T09:00:00', 'Lesión de rodilla.', 'Trauma de rodilla.', 'Dolor controlado.', 'Reposo y fisioterapia.', 'Se descarta fractura.', 'Finalizada'),
(4, 4, 5, 4, 5, '2026-06-15T16:00:00', '2026-06-16T08:00:00', 'Observación ginecológica.', 'Dolor pélvico.', 'Paciente estable.', 'Seguimiento ambulatorio.', 'Ultrasonido normal.', 'Finalizada'),
(5, 5, 6, 5, 3, '2026-06-20T09:00:00', '2026-06-21T12:00:00', 'Dolor abdominal.', 'Gastritis aguda.', 'Síntomas controlados.', 'Dieta y medicamento.', 'Sin complicaciones.', 'Finalizada'),
(6, 1, 2, 6, 2, '2026-06-22T17:00:00', '2026-06-24T10:00:00', 'Palpitaciones.', 'Arritmia en estudio.', 'Ritmo estable.', 'Control cardiológico.', 'Monitoreo satisfactorio.', 'Finalizada'),
(7, 2, 3, 7, 3, '2026-06-25T15:00:00', '2026-06-26T09:00:00', 'Faringitis con deshidratación.', 'Faringitis aguda.', 'Paciente hidratado.', 'Continuar antibiótico.', 'Mejoría clínica.', 'Finalizada'),
(8, 3, 4, 8, 4, '2026-06-27T11:00:00', '2026-06-28T10:00:00', 'Observación preventiva.', 'Mareo inespecífico.', 'Paciente estable.', 'Hidratación y descanso.', 'Exámenes normales.', 'Finalizada'),
(10, 5, 6, 10, 3, '2026-07-18T11:00:00', '2026-07-19T08:00:00', 'Fiebre infantil persistente.', 'Cuadro febril.', 'Temperatura controlada.', 'Control pediátrico.', 'Respuesta favorable.', 'Finalizada');

INSERT INTO Tbl_Proveedores
(
    NIT, RazonSocial, NombreComercial, Direccion, Municipio,
    Departamento, Telefono, CorreoElectronico, PersonaContacto,
    TelefonoContacto, Estado
)
VALUES
('5487963-1', 'Distribuidora Médica de Guatemala, S.A.', 'DIMED', 'Calzada Roosevelt 22-15, Zona 11', 'Guatemala', 'Guatemala', '2422-1001', 'ventas@dimed.com.gt', 'Mario Escobar', '5555-3001', 'Activo'),
('6798452-4', 'Farmacéutica Nacional, S.A.', 'FARNASA', 'Avenida Petapa 35-40, Zona 12', 'Guatemala', 'Guatemala', '2477-2002', 'pedidos@farnasa.com.gt', 'Claudia Méndez', '5555-3002', 'Activo'),
('7854123-6', 'Suministros Hospitalarios del Sur, S.A.', 'SUHOSUR', '3a. Avenida 5-20, Zona 1', 'Escuintla', 'Escuintla', '7889-3003', 'ventas@suhosur.com.gt', 'Jorge Lemus', '5555-3003', 'Activo'),
('8945216-8', 'Productos Médicos de Occidente, S.A.', 'PROMEO', '14 Avenida 2-40, Zona 3', 'Quetzaltenango', 'Quetzaltenango', '7765-4004', 'contacto@promeo.com.gt', 'Ana de León', '5555-3004', 'Activo'),
('9658741-2', 'Insumos Clínicos Verapaces, S.A.', 'INCVER', '2a. Calle 6-15, Zona 2', 'Cobán', 'Alta Verapaz', '7951-5005', 'pedidos@incver.com.gt', 'Tomás Caal', '5555-3005', 'Activo');

INSERT INTO Tbl_MovimientosInventario
(
    CodigoSucursal, CodigoProducto, CodigoProveedor,
    CodigoColaborador, FechaHoraMovimiento, TipoMovimiento,
    NumeroDocumento, Lote, FechaVencimiento, CantidadEntrada,
    CantidadSalida, CostoUnitario, ExistenciaResultante,
    MotivoMovimiento, Observaciones, Estado
)
VALUES
(1, 1, 1, 9, '2026-07-01T08:00:00', 'Compra', 'FAC-PROV-1001', 'LOT-AC-001', '2028-01-31', 100.00, NULL, 12.00, 100.00, 'Ingreso por compra', 'Producto recibido completo.', 'Activo'),
(1, 2, 2, 9, '2026-07-01T09:00:00', 'Compra', 'FAC-PROV-1002', 'LOT-AM-001', '2027-12-31', 80.00, NULL, 35.00, 80.00, 'Ingreso por compra', 'Antibiótico con receta.', 'Activo'),
(1, 3, 2, 9, '2026-07-01T10:00:00', 'Compra', 'FAC-PROV-1003', 'LOT-OM-001', '2028-03-31', 90.00, NULL, 18.00, 90.00, 'Ingreso por compra', 'Producto recibido.', 'Activo'),
(2, 4, 3, 9, '2026-07-02T08:30:00', 'Compra', 'FAC-PROV-1004', 'LOT-JE-001', '2029-06-30', 200.00, NULL, 1.25, 200.00, 'Ingreso por compra', 'Jeringas estériles.', 'Activo'),
(3, 5, 3, 9, '2026-07-02T09:30:00', 'Compra', 'FAC-PROV-1005', 'LOT-SS-001', '2027-08-31', 120.00, NULL, 10.00, 120.00, 'Ingreso por compra', 'Solución salina.', 'Activo'),
(1, 1, NULL, 9, '2026-07-06T09:00:00', 'Salida por receta', 'REC-0001', 'LOT-AC-001', '2028-01-31', NULL, 1.00, 12.00, 99.00, 'Despacho a paciente', 'Relacionado con consulta 1.', 'Activo'),
(2, 2, NULL, 9, '2026-07-09T15:00:00', 'Salida por receta', 'REC-0007', 'LOT-AM-001', '2027-12-31', NULL, 1.00, 35.00, 79.00, 'Despacho a paciente', 'Relacionado con consulta 7.', 'Activo'),
(5, 1, NULL, 9, '2026-07-18T11:00:00', 'Salida por receta', 'REC-0010', 'LOT-AC-001', '2028-01-31', NULL, 1.00, 12.00, 98.00, 'Despacho pediátrico', 'Relacionado con consulta 10.', 'Activo'),
(4, 5, 4, 9, '2026-07-03T10:00:00', 'Compra', 'FAC-PROV-1006', 'LOT-SS-002', '2027-10-31', 75.00, NULL, 10.50, 75.00, 'Ingreso por compra', 'Entrega en sucursal de Quetzaltenango.', 'Activo'),
(5, 4, 5, 9, '2026-07-04T11:00:00', 'Compra', 'FAC-PROV-1007', 'LOT-JE-002', '2029-12-31', 150.00, NULL, 1.30, 150.00, 'Ingreso por compra', 'Entrega en sucursal de Cobán.', 'Activo');

INSERT INTO Tbl_Facturas
(
    CodigoPaciente, CodigoSucursal, CodigoColaborador,
    NumeroFactura, FechaHoraFactura, NombreFacturacion,
    NITFacturacion, DireccionFacturacion, Subtotal,
    Descuento, Impuesto, Total, SaldoPendiente, Estado
)
VALUES
(1, 1, 10, 'FAC-2026-0001', '2026-07-06T09:00:00', 'Juan Carlos Gómez Pérez', '1987654-3', 'Zona 7, Ciudad de Guatemala', 320.00, 0.00, 0.00, 320.00, 0.00, 'Pagada'),
(2, 2, 10, 'FAC-2026-0002', '2026-07-07T10:00:00', 'María José Hernández López', 'CF', 'Cuilapa, Santa Rosa', 350.00, 0.00, 0.00, 350.00, 0.00, 'Pagada'),
(3, 3, 10, 'FAC-2026-0003', '2026-07-10T15:00:00', 'Pedro Antonio Ramírez García', '2209876-5', 'Escuintla, Escuintla', 650.00, 0.00, 0.00, 650.00, 200.00, 'Parcial'),
(4, 4, 10, 'FAC-2026-0004', '2026-07-09T16:00:00', 'Ana Lucía Cifuentes Díaz', 'CF', 'Quetzaltenango, Quetzaltenango', 700.00, 50.00, 0.00, 650.00, 0.00, 'Pagada'),
(5, 5, 10, 'FAC-2026-0005', '2026-07-08T10:00:00', 'Manuel Enrique Caal Tut', '2421098-7', 'Cobán, Alta Verapaz', 330.00, 0.00, 0.00, 330.00, 0.00, 'Pagada'),
(6, 1, 10, 'FAC-2026-0006', '2026-07-08T17:00:00', 'Gabriela Fernanda Soto Morales', 'CF', 'Mixco, Guatemala', 800.00, 0.00, 0.00, 800.00, 300.00, 'Parcial'),
(7, 2, 10, 'FAC-2026-0007', '2026-07-09T15:30:00', 'Jorge Estuardo López Marroquín', '2643210-9', 'Barberena, Santa Rosa', 405.00, 0.00, 0.00, 405.00, 0.00, 'Pagada'),
(8, 3, 10, 'FAC-2026-0008', '2026-07-13T10:00:00', 'Emily Rose Thompson', 'CF', 'Antigua Guatemala, Sacatepéquez', 300.00, 0.00, 0.00, 300.00, 0.00, 'Pagada'),
(9, 4, 10, 'FAC-2026-0009', '2026-07-14T10:00:00', 'Ricardo Andrés Velásquez Cruz', '2754321-0', 'Villa Nueva, Guatemala', 2750.00, 250.00, 0.00, 2500.00, 1500.00, 'Parcial'),
(10, 5, 10, 'FAC-2026-0010', '2026-07-18T11:30:00', 'Claudia Rojas', 'CF', 'Jalapa, Jalapa', 370.00, 0.00, 0.00, 370.00, 0.00, 'Pagada');

INSERT INTO Tbl_FacturasDetalle
(
    CodigoFactura, TipoMovimiento, TipoCargo, Concepto,
    Cantidad, PrecioUnitario, Subtotal, MontoPago,
    FormaPago, ReferenciaPago, CodigoReferenciaOrigen,
    FechaHoraRegistro, Observaciones, Estado
)
VALUES
(1, 'Cargo', 'Consulta', 'Consulta de medicina general y medicamento.', 1.00, 320.00, 320.00, NULL, NULL, NULL, 1, '2026-07-06T09:00:00', 'Cargo completo de la atención.', 'Activo'),
(2, 'Cargo', 'Consulta', 'Consulta pediátrica.', 1.00, 350.00, 350.00, NULL, NULL, NULL, 2, '2026-07-07T10:00:00', 'Consulta atendida.', 'Activo'),
(3, 'Cargo', 'Consulta y examen', 'Consulta de traumatología y radiografía.', 1.00, 650.00, 650.00, NULL, NULL, NULL, 3, '2026-07-10T15:00:00', 'Saldo pendiente de pago.', 'Activo'),
(4, 'Cargo', 'Consulta y examen', 'Consulta ginecológica y ultrasonido.', 1.00, 700.00, 700.00, NULL, NULL, NULL, 4, '2026-07-09T16:00:00', 'Descuento aplicado en encabezado.', 'Activo'),
(5, 'Cargo', 'Consulta y medicamento', 'Consulta general y omeprazol.', 1.00, 330.00, 330.00, NULL, NULL, NULL, 5, '2026-07-08T10:00:00', 'Atención ambulatoria.', 'Activo'),
(6, 'Pago', NULL, 'Abono por consulta cardiológica.', NULL, NULL, NULL, 500.00, 'Tarjeta', 'POS-458712', 6, '2026-07-08T17:10:00', 'Pago parcial.', 'Activo'),
(7, 'Pago', NULL, 'Pago total de factura.', NULL, NULL, NULL, 405.00, 'Efectivo', 'REC-0007', 7, '2026-07-09T15:40:00', 'Pago recibido en caja.', 'Activo'),
(8, 'Pago', NULL, 'Pago total de consulta general.', NULL, NULL, NULL, 300.00, 'Transferencia', 'TRX-20260713-08', 8, '2026-07-13T10:10:00', 'Transferencia confirmada.', 'Activo'),
(9, 'Pago', NULL, 'Abono por hospitalización.', NULL, NULL, NULL, 1000.00, 'Tarjeta', 'POS-784521', 9, '2026-07-14T10:15:00', 'Pago parcial.', 'Activo'),
(10, 'Pago', NULL, 'Pago total de consulta pediátrica.', NULL, NULL, NULL, 370.00, 'Efectivo', 'REC-0010', 10, '2026-07-18T11:40:00', 'Pago recibido.', 'Activo');

---   CONSULTAS DE VALIDACIÓN

SELECT 'Tbl_Sucursales' AS Tabla, COUNT(*) AS Cantidad FROM Tbl_Sucursales
UNION ALL SELECT 'Tbl_Roles', COUNT(*) FROM Tbl_Roles
UNION ALL SELECT 'Tbl_Colaboradores', COUNT(*) FROM Tbl_Colaboradores
UNION ALL SELECT 'Tbl_Pacientes', COUNT(*) FROM Tbl_Pacientes
UNION ALL SELECT 'Tbl_Especialidades', COUNT(*) FROM Tbl_Especialidades
UNION ALL SELECT 'Tbl_ColaboradoresEspecialidades', COUNT(*) FROM Tbl_ColaboradoresEspecialidades
UNION ALL SELECT 'Tbl_Horarios', COUNT(*) FROM Tbl_Horarios
UNION ALL SELECT 'Tbl_CitasConsultas', COUNT(*) FROM Tbl_CitasConsultas
UNION ALL SELECT 'Tbl_CitasConsultasDetalle', COUNT(*) FROM Tbl_CitasConsultasDetalle
UNION ALL SELECT 'Tbl_Habitaciones', COUNT(*) FROM Tbl_Habitaciones
UNION ALL SELECT 'Tbl_Hospitalizaciones', COUNT(*) FROM Tbl_Hospitalizaciones
UNION ALL SELECT 'Tbl_Productos', COUNT(*) FROM Tbl_Productos
UNION ALL SELECT 'Tbl_Proveedores', COUNT(*) FROM Tbl_Proveedores
UNION ALL SELECT 'Tbl_MovimientosInventario', COUNT(*) FROM Tbl_MovimientosInventario
UNION ALL SELECT 'Tbl_Facturas', COUNT(*) FROM Tbl_Facturas
UNION ALL SELECT 'Tbl_FacturasDetalle', COUNT(*) FROM Tbl_FacturasDetalle;
