export interface Especialidad {
  codigoEspecialidad: number;
  nombreEspecialidad: string;
  descripcion: string | null;
  areaMedica: string | null;
  duracionConsulta: number | null;
  costoConsulta: number | null;
  requiereCita: boolean;
  observaciones: string | null;
  estado: string;
}

export interface RespuestaEspecialidades {
  exito: number;
  mensaje: string;
  datos: Especialidad[];
}

export interface RespuestaAccionEspecialidades {
  exito: number;
  mensaje: string;
  codigoEspecialidad?: number;
}
