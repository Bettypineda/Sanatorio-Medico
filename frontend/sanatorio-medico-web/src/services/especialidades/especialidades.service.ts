import {
  Especialidad,
  RespuestaEspecialidades,
  RespuestaAccionEspecialidades,
} from '@/interfaces/especialidades/especialidad.interface';

const API_URL = 'http://localhost:3000/api';

export async function consultarEspecialidades(): Promise<RespuestaEspecialidades> {
  const respuesta = await fetch(`${API_URL}/especialidadesConsultar`, {
    method: 'GET',
    cache: 'no-store',
  });
  if (!respuesta.ok) {
    throw new Error('Error al consultar especialidads.');
  }
  return respuesta.json();
}

export async function buscarEspecialidad(codigoEspecialidad: number): Promise<RespuestaEspecialidades> {
  const respuesta = await fetch(`${API_URL}/especialidadesBuscar/${codigoEspecialidad}`, {
    method: 'GET',
    cache: 'no-store',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible buscar el registro.', datos: [] };
  }
  return data;
}

export async function agregarEspecialidad(datos: {
  nombreEspecialidad,
      descripcion,
      areaMedica,
      duracionConsulta,
      costoConsulta,
      requiereCita,
      observaciones,
      estado
}): Promise<RespuestaAccionEspecialidades> {
  const respuesta = await fetch(`${API_URL}/especialidadesAgregar`, {
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

export async function editarEspecialidad(codigoEspecialidad: number, datos: {
  nombreEspecialidad,
      descripcion,
      areaMedica,
      duracionConsulta,
      costoConsulta,
      requiereCita,
      observaciones,
      estado
}): Promise<RespuestaAccionEspecialidades> {
  const respuesta = await fetch(`${API_URL}/especialidadesEditar/${codigoEspecialidad}`, {
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

export async function eliminarEspecialidad(codigoEspecialidad: number): Promise<RespuestaAccionEspecialidades> {
  const respuesta = await fetch(`${API_URL}/especialidadesEliminar/${codigoEspecialidad}`, {
    method: 'DELETE',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible eliminar el registro.' };
  }
  return data;
}
