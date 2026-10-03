'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  Building2,
  CheckCircle2, PauseCircle, Search, Plus, Pencil, Trash2, ArrowUpDown,
} from 'lucide-react';
import { Sucursal } from '@/interfaces/sucursales/sucursal.interface';
import { consultarSucursales, eliminarSucursal } from '@/services/sucursales/sucursales.service';

export default function SucursalesConsultaVista() {
  const router = useRouter();
  const [items, setItems] = useState<Sucursal[]>([]);
  const [filtro, setFiltro] = useState('');
  const [mensaje, setMensaje] = useState('Cargando sucursales...');

  async function cargar() {
    try {
      const respuesta = await consultarSucursales();
      setItems(respuesta.datos);
      setMensaje(respuesta.datos.length === 0 ? 'No hay registros todavía.' : '');
    } catch {
      setMensaje('No fue posible consultar sucursales.');
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    cargar();
  }, []);

  async function manejarEliminar(codigo: number, etiqueta: string) {
    if (!window.confirm(`¿Eliminar el registro "${etiqueta}"?`)) return;
    const respuesta = await eliminarSucursal(codigo);
    if (respuesta.exito) {
      cargar();
    } else {
      alert(respuesta.mensaje || 'No fue posible eliminar el registro.');
    }
  }

  const activos = items.filter((item: Sucursal) => item.estado).length;
  const inactivos = items.length - activos;
  const filtrados = items.filter((item: Sucursal) =>
    JSON.stringify(item).toLowerCase().includes(filtro.toLowerCase()),
  );

  return (
    <section className="sucursales-page">
      <div className="sucursales-hero">
        <div className="sucursales-hero-text">
          <h1>Sucursales</h1>
          <p>Administra y consulta los registros de sucursales.</p>
        </div>
      </div>

      <div className="summary-grid summary-grid-3">
        <article className="summary-card">
          <div className="summary-icon summary-icon-blue">
            <Building2 size={29} strokeWidth={2} aria-hidden="true" />
          </div>
          <div className="summary-info">
            <span className="summary-label">Total registrados</span>
            <strong className="summary-value">{items.length}</strong>
          </div>
        </article>
        <article className="summary-card">
          <div className="summary-icon summary-icon-green">
            <CheckCircle2 size={29} strokeWidth={2} aria-hidden="true" />
          </div>
          <div className="summary-info">
            <span className="summary-label">Activos</span>
            <strong className="summary-value">{activos}</strong>
          </div>
        </article>
        <article className="summary-card">
          <div className="summary-icon summary-icon-yellow">
            <PauseCircle size={29} strokeWidth={2} aria-hidden="true" />
          </div>
          <div className="summary-info">
            <span className="summary-label">Inactivos</span>
            <strong className="summary-value">{inactivos}</strong>
          </div>
        </article>
      </div>

      <section className="branches-panel">
        <div className="branches-panel-header">
          <div className="branches-panel-title">
            <div className="branches-title-icon">
              <Building2 size={25} strokeWidth={2} aria-hidden="true" />
            </div>
            <h2>Listado de sucursales</h2>
          </div>
          <div className="branches-toolbar">
            <div className="branches-search">
              <Search size={20} strokeWidth={2} aria-hidden="true" />
              <input
                type="search"
                placeholder="Buscar en la tabla..."
                value={filtro}
                onChange={(e) => setFiltro(e.target.value)}
              />
            </div>
            <Link href="/sucursales/buscar" className="button-secondary">
              <Search size={18} strokeWidth={2} />
              <span>Buscar por código</span>
            </Link>
            <Link href="/sucursales/agregar" className="button-new-branch">
              <Plus size={21} strokeWidth={2.3} aria-hidden="true" />
              <span>Nuevo registro</span>
            </Link>
          </div>
        </div>

        <div className="branches-table-container">
          <table className="branches-table">
            <thead>
              <tr>
                <th><span>Nombre de la sucursal<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Dirección<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Fecha de apertura<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Hora de apertura<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Estado<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th className="actions-column">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtrados.map((item: Sucursal) => (
                <tr key={item.codigoSucursal}>
                  <td>{String(item.nombreSucursal ?? '-')}</td>
                  <td>{String(item.direccion ?? '-')}</td>
                  <td>{String(item.fechaApertura ?? '-')}</td>
                  <td>{String(item.horaApertura ?? '-')}</td>
                  <td>
                    <span className={item.estado ? 'status-badge status-active' : 'status-badge status-inactive'}>
                      <span className="status-dot" aria-hidden="true" />
                      {item.estado ? 'Activo' : 'Inactivo'}
                    </span>
                  </td>
                  <td>
                    <div className="table-actions">
                      <button
                        type="button"
                        className="action-button action-edit"
                        aria-label="Editar"
                        onClick={() => router.push(`/sucursales/editar/${item.codigoSucursal}`)}
                      >
                        <Pencil size={18} strokeWidth={2.2} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        className="action-button action-delete"
                        aria-label="Eliminar"
                        onClick={() => manejarEliminar(item.codigoSucursal, String(item.codigoSucursal))}
                      >
                        <Trash2 size={18} strokeWidth={2.2} aria-hidden="true" />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="branches-table-footer">
          <p>{mensaje || `Mostrando ${filtrados.length} de ${items.length} resultados`}</p>
        </div>
      </section>
    </section>
  );
}
