'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Building2, Search, Pencil } from 'lucide-react';
import { Sucursal } from '@/interfaces/sucursales/sucursal.interface';
import { buscarSucursal } from '@/services/sucursales/sucursales.service';

export default function SucursalesBuscarVista() {
  const [codigo, setCodigo] = useState('');
  const [resultado, setResultado] = useState<Sucursal | null>(null);
  const [mensaje, setMensaje] = useState('');
  const [buscando, setBuscando] = useState(false);

  async function manejarBusqueda(e: React.FormEvent) {
    e.preventDefault();
    setBuscando(true);
    setMensaje('');
    setResultado(null);
    const respuesta = await buscarSucursal(Number(codigo));
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
            <Building2 size={24} strokeWidth={2} />
          </div>
          <h1>Buscar sucursal</h1>
        </div>
      </div>

      <form className="form-card form-buscar" onSubmit={manejarBusqueda}>
        <div className="form-field">
          <label htmlFor="codigo">Código de sucursal</label>
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
              <label>Nombre de la sucursal</label>
              <p className="form-valor">{String(resultado.nombreSucursal ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Dirección</label>
              <p className="form-valor">{String(resultado.direccion ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Fecha de apertura</label>
              <p className="form-valor">{String(resultado.fechaApertura ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Hora de apertura</label>
              <p className="form-valor">{String(resultado.horaApertura ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Presupuesto mensual (Q)</label>
              <p className="form-valor">{String(resultado.presupuestoMensual ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Estado</label>
              <p className="form-valor">{String(resultado.estado ?? '-')}</p>
            </div>
          </div>
          <div className="form-actions">
            <Link href={`/sucursales/editar/${resultado.codigoSucursal}`} className="button-primary">
              <Pencil size={18} strokeWidth={2} />
              <span>Editar este registro</span>
            </Link>
          </div>
        </div>
      )}
    </section>
  );
}
