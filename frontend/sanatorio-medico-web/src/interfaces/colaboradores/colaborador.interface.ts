export interface Colaborador {
  codigoColaborador: number;
  codigoSucursal: number;
  codigoRol: number;
  nombres: string;
  apellidos: string;
  dpi: string;
  numeroColegiado: string | null;
  tipoColaborador: string;
  telefono: string;
  correoElectronico: string | null;
  direccion: string | null;
  fechaContratacion: string;
  nombreUsuario: string;
  claveAcceso: string;
  estado: string;
}

export interface RespuestaColaboradores {
  exito: number;
  mensaje: string;
  datos: Colaborador[];
}

export interface RespuestaAccionColaboradores {
  exito: number;
  mensaje: string;
  codigoColaborador?: number;
}
