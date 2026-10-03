export interface Cita {
  codigoCitaConsulta: number;
  codigoPaciente: number;
  codigoColaborador: number;
  codigoSucursal: number;
  codigoEspecialidad: number;
  fechaHoraCita: string;
  tipoAtencion: string;
  motivoConsulta: string;
  sintomas: string | null;
  observacionesMedicas: string | null;
  tratamientoGeneral: string | null;
  presionArterial: string | null;
  temperatura: number | null;
  peso: number | null;
  estado: string;
}

export interface RespuestaCitas {
  exito: number;
  mensaje: string;
  datos: Cita[];
}

export interface RespuestaAccionCitas {
  exito: number;
  mensaje: string;
  codigoCitaConsulta?: number;
}
