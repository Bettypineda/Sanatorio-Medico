export interface Paciente {
  codigoPaciente: number;
  numeroExpediente: string;
  tipoDocumento: string;
  numeroDocumento: string;
  nombres: string;
  apellidos: string;
  fechaNacimiento: string;
  genero: string;
  tipoSangre: string | null;
  telefono: string;
  correoElectronico: string | null;
  direccion: string;
  contactoEmergencia: string | null;
  telefonoEmergencia: string | null;
  alergias: string | null;
  estado: string;
}

export interface RespuestaPacientes {
  exito: number;
  mensaje: string;
  datos: Paciente[];
}

export interface RespuestaAccionPacientes {
  exito: number;
  mensaje: string;
  codigoPaciente?: number;
}
