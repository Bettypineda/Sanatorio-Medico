import {
  Colaborador,
  RespuestaColaboradores,
  RespuestaAccionColaboradores,
} from '@/interfaces/colaboradores/colaborador.interface';

const API_URL = 'http://localhost:3000/api';

export async function consultarColaboradores(): Promise<RespuestaColaboradores> {
  const respuesta = await fetch(`${API_URL}/colaboradoresConsultar`, {
    method: 'GET',
    cache: 'no-store',
  });
  if (!respuesta.ok) {
    throw new Error('Error al consultar colaboradors.');
  }
  return respuesta.json();
}

export async function buscarColaborador(codigoColaborador: number): Promise<RespuestaColaboradores> {
  const respuesta = await fetch(`${API_URL}/colaboradoresBuscar/${codigoColaborador}`, {
    method: 'GET',
    cache: 'no-store',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible buscar el registro.', datos: [] };
  }
  return data;
}

export async function agregarColaborador(datos: {
  codigoSucursal,
      codigoRol,
      nombres,
      apellidos,
      dpi,
      numeroColegiado,
      tipoColaborador,
      telefono,
      correoElectronico,
      direccion,
      fechaContratacion,
      nombreUsuario,
      claveAcceso,
      estado
}): Promise<RespuestaAccionColaboradores> {
  const respuesta = await fetch(`${API_URL}/colaboradoresAgregar`, {
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

export async function editarColaborador(codigoColaborador: number, datos: {
  codigoSucursal,
      codigoRol,
      nombres,
      apellidos,
      dpi,
      numeroColegiado,
      tipoColaborador,
      telefono,
      correoElectronico,
      direccion,
      fechaContratacion,
      nombreUsuario,
      claveAcceso,
      estado
}): Promise<RespuestaAccionColaboradores> {
  const respuesta = await fetch(`${API_URL}/colaboradoresEditar/${codigoColaborador}`, {
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

export async function eliminarColaborador(codigoColaborador: number): Promise<RespuestaAccionColaboradores> {
  const respuesta = await fetch(`${API_URL}/colaboradoresEliminar/${codigoColaborador}`, {
    method: 'DELETE',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible eliminar el registro.' };
  }
  return data;
}
