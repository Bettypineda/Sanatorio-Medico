'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  Stethoscope,
  CheckCircle2, PauseCircle, Search, Plus, Pencil, Trash2, ArrowUpDown,
} from 'lucide-react';
import { Colaborador } from '@/interfaces/colaboradores/colaborador.interface';
import { consultarColaboradores, eliminarColaborador } from '@/services/colaboradores/colaboradores.service';

export default function ColaboradoresConsultaVista() {
  const router = useRouter();
  const [items, setItems] = useState<Colaborador[]>([]);
  const [filtro, setFiltro] = useState('');
  const [mensaje, setMensaje] = useState('Cargando colaboradores...');

  async function cargar() {
    try {
      const respuesta = await consultarColaboradores();
      setItems(respuesta.datos);
      setMensaje(respuesta.datos.length === 0 ? 'No hay registros todavía.' : '');
    } catch {
      setMensaje('No fue posible consultar colaboradores.');
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    cargar();
  }, []);

  async function manejarEliminar(codigo: number, etiqueta: string) {
    if (!window.confirm(`¿Eliminar el registro "${etiqueta}"?`)) return;
    const respuesta = await eliminarColaborador(codigo);
    if (respuesta.exito) {
      cargar();
    } else {
      alert(respuesta.mensaje || 'No fue posible eliminar el registro.');
    }
  }

  const activos = items.filter((item: Colaborador) => item.estado === 'Activo').length;
  const inactivos = items.length - activos;
  const filtrados = items.filter((item: Colaborador) =>
    JSON.stringify(item).toLowerCase().includes(filtro.toLowerCase()),
  );

  return (
    <section className="sucursales-page">
      <div className="sucursales-hero">
        <div className="sucursales-hero-text">
          <h1>Colaboradores</h1>
          <p>Administra y consulta los registros de colaboradores.</p>
        </div>
      </div>

      <div className="summary-grid summary-grid-3">
        <article className="summary-card">
          <div className="summary-icon summary-icon-blue">
            <Stethoscope size={29} strokeWidth={2} aria-hidden="true" />
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
              <Stethoscope size={25} strokeWidth={2} aria-hidden="true" />
            </div>
            <h2>Listado de colaboradores</h2>
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
            <Link href="/colaboradores/buscar" className="button-secondary">
              <Search size={18} strokeWidth={2} />
              <span>Buscar por código</span>
            </Link>
            <Link href="/colaboradores/agregar" className="button-new-branch">
              <Plus size={21} strokeWidth={2.3} aria-hidden="true" />
              <span>Nuevo registro</span>
            </Link>
          </div>
        </div>

        <div className="branches-table-container">
          <table className="branches-table">
            <thead>
              <tr>
                <th><span>Código de sucursal<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Código de rol<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Nombres<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Apellidos<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Estado<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th className="actions-column">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtrados.map((item: Colaborador) => (
                <tr key={item.codigoColaborador}>
                  <td>{String(item.codigoSucursal ?? '-')}</td>
                  <td>{String(item.codigoRol ?? '-')}</td>
                  <td>{String(item.nombres ?? '-')}</td>
                  <td>{String(item.apellidos ?? '-')}</td>
                  <td>
                    <span className={item.estado === 'Activo' ? 'status-badge status-active' : 'status-badge status-inactive'}>
                      <span className="status-dot" aria-hidden="true" />
                      {item.estado === 'Activo' ? 'Activo' : 'Inactivo'}
                    </span>
                  </td>
                  <td>
                    <div className="table-actions">
                      <button
                        type="button"
                        className="action-button action-edit"
                        aria-label="Editar"
                        onClick={() => router.push(`/colaboradores/editar/${item.codigoColaborador}`)}
                      >
                        <Pencil size={18} strokeWidth={2.2} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        className="action-button action-delete"
                        aria-label="Eliminar"
                        onClick={() => manejarEliminar(item.codigoColaborador, String(item.codigoColaborador))}
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
