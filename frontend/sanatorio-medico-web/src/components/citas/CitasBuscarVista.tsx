'use client';

import { useState } from 'react';
import Link from 'next/link';
import { CalendarDays, Search, Pencil } from 'lucide-react';
import { Cita } from '@/interfaces/citas/cita.interface';
import { buscarCita } from '@/services/citas/citas.service';

export default function CitasBuscarVista() {
  const [codigo, setCodigo] = useState('');
  const [resultado, setResultado] = useState<Cita | null>(null);
  const [mensaje, setMensaje] = useState('');
  const [buscando, setBuscando] = useState(false);

  async function manejarBusqueda(e: React.FormEvent) {
    e.preventDefault();
    setBuscando(true);
    setMensaje('');
    setResultado(null);
    const respuesta = await buscarCita(Number(codigo));
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
            <CalendarDays size={24} strokeWidth={2} />
          </div>
          <h1>Buscar cita</h1>
        </div>
      </div>

      <form className="form-card form-buscar" onSubmit={manejarBusqueda}>
        <div className="form-field">
          <label htmlFor="codigo">Código de cita</label>
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
              <label>Código de paciente</label>
              <p className="form-valor">{String(resultado.codigoPaciente ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Código de colaborador</label>
              <p className="form-valor">{String(resultado.codigoColaborador ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Código de sucursal</label>
              <p className="form-valor">{String(resultado.codigoSucursal ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Código de especialidad</label>
              <p className="form-valor">{String(resultado.codigoEspecialidad ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Fecha y hora de la cita</label>
              <p className="form-valor">{String(resultado.fechaHoraCita ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Tipo de atención</label>
              <p className="form-valor">{String(resultado.tipoAtencion ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Motivo de la consulta</label>
              <p className="form-valor">{String(resultado.motivoConsulta ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Síntomas</label>
              <p className="form-valor">{String(resultado.sintomas ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Observaciones médicas</label>
              <p className="form-valor">{String(resultado.observacionesMedicas ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Tratamiento general</label>
              <p className="form-valor">{String(resultado.tratamientoGeneral ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Presión arterial</label>
              <p className="form-valor">{String(resultado.presionArterial ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Temperatura (°C)</label>
              <p className="form-valor">{String(resultado.temperatura ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Peso (lb)</label>
              <p className="form-valor">{String(resultado.peso ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Estado</label>
              <p className="form-valor">{String(resultado.estado ?? '-')}</p>
            </div>
          </div>
          <div className="form-actions">
            <Link href={`/citas/editar/${(resultado as any).codigoCitaConsulta}`} className="button-primary">
              <Pencil size={18} strokeWidth={2} />
              <span>Editar este registro</span>
            </Link>
          </div>
        </div>
      )}
    </section>
  );
}
