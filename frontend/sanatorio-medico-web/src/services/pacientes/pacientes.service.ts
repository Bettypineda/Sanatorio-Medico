import {
  Paciente,
  RespuestaPacientes,
  RespuestaAccionPacientes,
} from '@/interfaces/pacientes/paciente.interface';

const API_URL = 'http://localhost:3000/api';

export async function consultarPacientes(): Promise<RespuestaPacientes> {
  const respuesta = await fetch(`${API_URL}/pacientesConsultar`, {
    method: 'GET',
    cache: 'no-store',
  });
  if (!respuesta.ok) {
    throw new Error('Error al consultar pacientes.');
  }
  return respuesta.json();
}

export async function buscarPaciente(codigoPaciente: number): Promise<RespuestaPacientes> {
  const respuesta = await fetch(`${API_URL}/pacientesBuscar/${codigoPaciente}`, {
    method: 'GET',
    cache: 'no-store',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible buscar el registro.', datos: [] };
  }
  return data;
}

export async function agregarPaciente(datos: {
  numeroExpediente,
      tipoDocumento,
      numeroDocumento,
      nombres,
      apellidos,
      fechaNacimiento,
      genero,
      tipoSangre,
      telefono,
      correoElectronico,
      direccion,
      contactoEmergencia,
      telefonoEmergencia,
      alergias,
      estado
}): Promise<RespuestaAccionPacientes> {
  const respuesta = await fetch(`${API_URL}/pacientesAgregar`, {
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

export async function editarPaciente(codigoPaciente: number, datos: {
  numeroExpediente,
      tipoDocumento,
      numeroDocumento,
      nombres,
      apellidos,
      fechaNacimiento,
      genero,
      tipoSangre,
      telefono,
      correoElectronico,
      direccion,
      contactoEmergencia,
      telefonoEmergencia,
      alergias,
      estado
}): Promise<RespuestaAccionPacientes> {
  const respuesta = await fetch(`${API_URL}/pacientesEditar/${codigoPaciente}`, {
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

export async function eliminarPaciente(codigoPaciente: number): Promise<RespuestaAccionPacientes> {
  const respuesta = await fetch(`${API_URL}/pacientesEliminar/${codigoPaciente}`, {
    method: 'DELETE',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible eliminar el registro.' };
  }
  return data;
}
