import {
  RespuestaSucursales,
  RespuestaAccionSucursales,
} from '@/interfaces/sucursales/sucursal.interface';

const API_URL = 'http://localhost:3000/api';

export async function consultarSucursales(): Promise<RespuestaSucursales> {
  const respuesta = await fetch(`${API_URL}/sucursalesConsultar`, {
    method: 'GET',
    cache: 'no-store',
  });
  if (!respuesta.ok) {
    throw new Error('Error al consultar sucursales.');
  }
  return respuesta.json();
}

export async function buscarSucursal(codigoSucursal: number): Promise<RespuestaSucursales> {
  const respuesta = await fetch(`${API_URL}/sucursalesBuscar/${codigoSucursal}`, {
    method: 'GET',
    cache: 'no-store',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible buscar el registro.', datos: [] };
  }
  return data;
}

export async function agregarSucursal(datos: {
  nombreSucursal: string,
  direccion: string,
  fechaApertura: string,
  horaApertura: string,
  presupuestoMensual: number,
  estado: boolean
}): Promise<RespuestaAccionSucursales> {
  const respuesta = await fetch(`${API_URL}/sucursalesAgregar`, {
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

export async function editarSucursal(codigoSucursal: number, datos: {
  nombreSucursal: string,
  direccion: string,
  fechaApertura: string,
  horaApertura: string,
  presupuestoMensual: number,
  estado: boolean
}): Promise<RespuestaAccionSucursales> {
  const respuesta = await fetch(`${API_URL}/sucursalesEditar/${codigoSucursal}`, {
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

export async function eliminarSucursal(codigoSucursal: number): Promise<RespuestaAccionSucursales> {
  const respuesta = await fetch(`${API_URL}/sucursalesEliminar/${codigoSucursal}`, {
    method: 'DELETE',
  });
  const data = await respuesta.json();
  if (!respuesta.ok) {
    return { exito: 0, mensaje: data?.mensaje || 'No fue posible eliminar el registro.' };
  }
  return data;
}
