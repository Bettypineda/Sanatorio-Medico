'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  ClipboardList,
  CheckCircle2, PauseCircle, Search, Plus, Pencil, Trash2, ArrowUpDown,
} from 'lucide-react';
import { Especialidad } from '@/interfaces/especialidades/especialidad.interface';
import { consultarEspecialidades, eliminarEspecialidad } from '@/services/especialidades/especialidades.service';

export default function EspecialidadesConsultaVista() {
  const router = useRouter();
  const [items, setItems] = useState<Especialidad[]>([]);
  const [filtro, setFiltro] = useState('');
  const [mensaje, setMensaje] = useState('Cargando especialidades...');

  async function cargar() {
    try {
      const respuesta = await consultarEspecialidades();
      setItems(respuesta.datos);
      setMensaje(respuesta.datos.length === 0 ? 'No hay registros todavía.' : '');
    } catch {
      setMensaje('No fue posible consultar especialidades.');
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    cargar();
  }, []);

  async function manejarEliminar(codigo: number, etiqueta: string) {
    if (!window.confirm(`¿Eliminar el registro "${etiqueta}"?`)) return;
    const respuesta = await eliminarEspecialidad(codigo);
    if (respuesta.exito) {
      cargar();
    } else {
      alert(respuesta.mensaje || 'No fue posible eliminar el registro.');
    }
  }

  const activos = items.filter((item: Especialidad) => item.estado === 'Activo').length;
  const inactivos = items.length - activos;
  const filtrados = items.filter((item: Especialidad) =>
    JSON.stringify(item).toLowerCase().includes(filtro.toLowerCase()),
  );

  return (
    <section className="sucursales-page">
      <div className="sucursales-hero">
        <div className="sucursales-hero-text">
          <h1>Especialidades</h1>
          <p>Administra y consulta los registros de especialidades.</p>
        </div>
      </div>

      <div className="summary-grid summary-grid-3">
        <article className="summary-card">
          <div className="summary-icon summary-icon-blue">
            <ClipboardList size={29} strokeWidth={2} aria-hidden="true" />
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
              <ClipboardList size={25} strokeWidth={2} aria-hidden="true" />
            </div>
            <h2>Listado de especialidades</h2>
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
            <Link href="/especialidades/buscar" className="button-secondary">
              <Search size={18} strokeWidth={2} />
              <span>Buscar por código</span>
            </Link>
            <Link href="/especialidades/agregar" className="button-new-branch">
              <Plus size={21} strokeWidth={2.3} aria-hidden="true" />
              <span>Nuevo registro</span>
            </Link>
          </div>
        </div>

        <div className="branches-table-container">
          <table className="branches-table">
            <thead>
              <tr>
                <th><span>Nombre de la especialidad<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Descripción<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Área médica<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Duración de consulta (min)<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Estado<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th className="actions-column">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtrados.map((item: Especialidad) => (
                <tr key={item.codigoEspecialidad}>
                  <td>{String(item.nombreEspecialidad ?? '-')}</td>
                  <td>{String(item.descripcion ?? '-')}</td>
                  <td>{String(item.areaMedica ?? '-')}</td>
                  <td>{String(item.duracionConsulta ?? '-')}</td>
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
                        onClick={() => router.push(`/especialidades/editar/${item.codigoEspecialidad}`)}
                      >
                        <Pencil size={18} strokeWidth={2.2} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        className="action-button action-delete"
                        aria-label="Eliminar"
                        onClick={() => manejarEliminar(item.codigoEspecialidad, String(item.codigoEspecialidad))}
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
