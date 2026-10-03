'use client';

import { useState } from 'react';
import Link from 'next/link';
import { ClipboardList, Search, Pencil } from 'lucide-react';
import { Especialidad } from '@/interfaces/especialidades/especialidad.interface';
import { buscarEspecialidad } from '@/services/especialidades/especialidades.service';

export default function EspecialidadesBuscarVista() {
  const [codigo, setCodigo] = useState('');
  const [resultado, setResultado] = useState<Especialidad | null>(null);
  const [mensaje, setMensaje] = useState('');
  const [buscando, setBuscando] = useState(false);

  async function manejarBusqueda(e: React.FormEvent) {
    e.preventDefault();
    setBuscando(true);
    setMensaje('');
    setResultado(null);
    const respuesta = await buscarEspecialidad(Number(codigo));
    setBuscando(false);
    if (respuesta.exito && respuesta.datos.length > 0) {
      setResultado(respuesta.datos[0]);
    } else {
      setMensaje(respuesta.mensaje || 'No se encontró el registro solicitado.');
    }
  }

  return (
    <section className="form-page">
      <div className="form-page-header">
        <div className="form-page-title">
          <div className="form-page-icon">
            <ClipboardList size={24} strokeWidth={2} />
          </div>
          <h1>Buscar especialidad</h1>
        </div>
      </div>

      <form className="form-card form-buscar" onSubmit={manejarBusqueda}>
        <div className="form-field">
          <label htmlFor="codigo">Código de especialidad</label>
          <input
            id="codigo"
            type="number"
            value={codigo}
            onChange={(e) => setCodigo(e.target.value)}
            required
          />
        </div>
        <button type="submit" className="button-primary" disabled={buscando}>
          <Search size={18} strokeWidth={2} />
          <span>{buscando ? 'Buscando...' : 'Buscar'}</span>
        </button>
      </form>

      {mensaje && <p className="form-mensaje">{mensaje}</p>}

      {resultado && (
        <div className="form-card">
          <div className="form-grid">
            <div className="form-field">
              <label>Nombre de la especialidad</label>
              <p className="form-valor">{String(resultado.nombreEspecialidad ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Descripción</label>
              <p className="form-valor">{String(resultado.descripcion ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Área médica</label>
              <p className="form-valor">{String(resultado.areaMedica ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Duración de consulta (min)</label>
              <p className="form-valor">{String(resultado.duracionConsulta ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Costo de consulta (Q)</label>
              <p className="form-valor">{String(resultado.costoConsulta ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>¿Requiere cita?</label>
              <p className="form-valor">{String(resultado.requiereCita ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Observaciones</label>
              <p className="form-valor">{String(resultado.observaciones ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Estado</label>
              <p className="form-valor">{String(resultado.estado ?? '-')}</p>
            </div>
          </div>
          <div className="form-actions">
            <Link href={`/especialidades/editar/${resultado.codigoEspecialidad}`} className="button-primary">
              <Pencil size={18} strokeWidth={2} />
              <span>Editar este registro</span>
            </Link>
          </div>
        </div>
      )}
    </section>
  );
}
