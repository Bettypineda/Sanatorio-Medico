'use client';

import { useEffect, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import {
  CalendarDays,
  CheckCircle2, PauseCircle, Search, Plus, Pencil, Trash2, ArrowUpDown,
} from 'lucide-react';
import { Cita } from '@/interfaces/citas/cita.interface';
import { consultarCitas, eliminarCita } from '@/services/citas/citas.service';

export default function CitasConsultaVista() {
  const router = useRouter();
  const [items, setItems] = useState<Cita[]>([]);
  const [filtro, setFiltro] = useState('');
  const [mensaje, setMensaje] = useState('Cargando citas...');

  async function cargar() {
    try {
      const respuesta = await consultarCitas();
      setItems(respuesta.datos);
      setMensaje(respuesta.datos.length === 0 ? 'No hay registros todavía.' : '');
    } catch {
      setMensaje('No fue posible consultar citas.');
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect
    cargar();
  }, []);

  async function manejarEliminar(codigo: number, etiqueta: string) {
    if (!window.confirm(`¿Eliminar el registro "${etiqueta}"?`)) return;
    const respuesta = await eliminarCita(codigo);
    if (respuesta.exito) {
      cargar();
    } else {
      alert(respuesta.mensaje || 'No fue posible eliminar el registro.');
    }
  }

  const activos = items.filter((item: Cita) => item.estado === 'Activo').length;
  const inactivos = items.length - activos;
  const filtrados = items.filter((item: Cita) =>
    JSON.stringify(item).toLowerCase().includes(filtro.toLowerCase()),
  );

  return (
    <section className="sucursales-page">
      <div className="sucursales-hero">
        <div className="sucursales-hero-text">
          <h1>Citas</h1>
          <p>Administra y consulta los registros de citas.</p>
        </div>
      </div>

      <div className="summary-grid summary-grid-3">
        <article className="summary-card">
          <div className="summary-icon summary-icon-blue">
            <CalendarDays size={29} strokeWidth={2} aria-hidden="true" />
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
              <CalendarDays size={25} strokeWidth={2} aria-hidden="true" />
            </div>
            <h2>Listado de citas</h2>
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
            <Link href="/citas/buscar" className="button-secondary">
              <Search size={18} strokeWidth={2} />
              <span>Buscar por código</span>
            </Link>
            <Link href="/citas/agregar" className="button-new-branch">
              <Plus size={21} strokeWidth={2.3} aria-hidden="true" />
              <span>Nuevo registro</span>
            </Link>
          </div>
        </div>

        <div className="branches-table-container">
          <table className="branches-table">
            <thead>
              <tr>
                <th><span>Código de paciente<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Código de colaborador<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Código de sucursal<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Código de especialidad<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th><span>Estado<ArrowUpDown size={14} aria-hidden="true" /></span></th>
                <th className="actions-column">Acciones</th>
              </tr>
            </thead>
            <tbody>
              {filtrados.map((item: Cita) => (
                <tr key={item.codigoCitaConsulta}>
                  <td>{String(item.codigoPaciente ?? '-')}</td>
                  <td>{String(item.codigoColaborador ?? '-')}</td>
                  <td>{String(item.codigoSucursal ?? '-')}</td>
                  <td>{String(item.codigoEspecialidad ?? '-')}</td>
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
                        onClick={() => router.push(`/citas/editar/${item.codigoCitaConsulta}`)}
                      >
                        <Pencil size={18} strokeWidth={2.2} aria-hidden="true" />
                      </button>
                      <button
                        type="button"
                        className="action-button action-delete"
                        aria-label="Eliminar"
                        onClick={() => manejarEliminar(item.codigoCitaConsulta, String(item.codigoCitaConsulta))}
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
