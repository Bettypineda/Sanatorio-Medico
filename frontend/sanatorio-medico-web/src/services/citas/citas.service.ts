import {
  RespuestaCitas,
  RespuestaAccionCitas,
} from '@/interfaces/citas/cita.interface';

const API_URL = 'http://localhost:3000/api';

export async function consultarCitas(): Promise<RespuestaCitas> {
  const respuesta = await fetch(`${API_URL}/citasConsultar`, {
    method: 'GET',
    cache: 'no-store',
  });
  if (!respuesta.ok) {
    throw new Error('Error al consultar citas.');
  }
  return respuesta.json();
}

export async function buscarCita(codigoCitaConsulta: number): Promise<RespuestaCitas> {
  const respuesta = await fetch(`${API_URL}/citasBuscar/${codigoCitaConsulta}`, {
    method: 'GET',
    cache: 'no-store',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible buscar el registro.', datos: [] };
  }
  return data;
}

export async function agregarCita(datos: {
  codigoPaciente: number,
  codigoColaborador: number,
  codigoSucursal: number,
  codigoEspecialidad: number,
  fechaHoraCita: string,
  tipoAtencion: string,
  motivoConsulta: string,
  sintomas: string | null,
  observacionesMedicas: string | null,
  tratamientoGeneral: string | null,
  presionArterial: string | null,
  temperatura: number | null,
  peso: number | null,
  estado: string
}): Promise<RespuestaAccionCitas> {
  const respuesta = await fetch(`${API_URL}/citasAgregar`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(datos),
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible agregar el registro.' };
  }
  return data;
}

export async function editarCita(codigoCitaConsulta: number, datos: {
  codigoPaciente: number,
  codigoColaborador: number,
  codigoSucursal: number,
  codigoEspecialidad: number,
  fechaHoraCita: string,
  tipoAtencion: string,
  motivoConsulta: string,
  sintomas: string | null,
  observacionesMedicas: string | null,
  tratamientoGeneral: string | null,
  presionArterial: string | null,
  temperatura: number | null,
  peso: number | null,
  estado: string
}): Promise<RespuestaAccionCitas> {
  const respuesta = await fetch(`${API_URL}/citasEditar/${codigoCitaConsulta}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(datos),
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible editar el registro.' };
  }
  return data;
}

export async function eliminarCita(codigoCitaConsulta: number): Promise<RespuestaAccionCitas> {
  const respuesta = await fetch(`${API_URL}/citasEliminar/${codigoCitaConsulta}`, {
    method: 'DELETE',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible eliminar el registro.' };
  }
  return data;
}
