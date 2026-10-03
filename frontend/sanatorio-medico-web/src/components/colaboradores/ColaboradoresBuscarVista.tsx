'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Stethoscope, Search, Pencil } from 'lucide-react';
import { Colaborador } from '@/interfaces/colaboradores/colaborador.interface';
import { buscarColaborador } from '@/services/colaboradores/colaboradores.service';

export default function ColaboradoresBuscarVista() {
  const [codigo, setCodigo] = useState('');
  const [resultado, setResultado] = useState<Colaborador | null>(null);
  const [mensaje, setMensaje] = useState('');
  const [buscando, setBuscando] = useState(false);

  async function manejarBusqueda(e: React.FormEvent) {
    e.preventDefault();
    setBuscando(true);
    setMensaje('');
    setResultado(null);
    const respuesta = await buscarColaborador(Number(codigo));
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
            <Stethoscope size={24} strokeWidth={2} />
          </div>
          <h1>Buscar colaborador</h1>
        </div>
      </div>

      <form className="form-card form-buscar" onSubmit={manejarBusqueda}>
        <div className="form-field">
          <label htmlFor="codigo">Código de colaborador</label>
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
              <label>Código de sucursal</label>
              <p className="form-valor">{String(resultado.codigoSucursal ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Código de rol</label>
              <p className="form-valor">{String(resultado.codigoRol ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Nombres</label>
              <p className="form-valor">{String(resultado.nombres ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Apellidos</label>
              <p className="form-valor">{String(resultado.apellidos ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>DPI</label>
              <p className="form-valor">{String(resultado.dpi ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Número de colegiado</label>
              <p className="form-valor">{String(resultado.numeroColegiado ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Tipo de colaborador</label>
              <p className="form-valor">{String(resultado.tipoColaborador ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Teléfono</label>
              <p className="form-valor">{String(resultado.telefono ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Correo electrónico</label>
              <p className="form-valor">{String(resultado.correoElectronico ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Dirección</label>
              <p className="form-valor">{String(resultado.direccion ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Fecha de contratación</label>
              <p className="form-valor">{String(resultado.fechaContratacion ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Nombre de usuario</label>
              <p className="form-valor">{String(resultado.nombreUsuario ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Clave de acceso</label>
              <p className="form-valor">{String(resultado.claveAcceso ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Estado</label>
              <p className="form-valor">{String(resultado.estado ?? '-')}</p>
            </div>
          </div>
          <div className="form-actions">
            <Link href={`/colaboradores/editar/${resultado.codigoColaborador}`} className="button-primary">
              <Pencil size={18} strokeWidth={2} />
              <span>Editar este registro</span>
            </Link>
          </div>
        </div>
      )}
    </section>
  );
}
