'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Building2, Save, ArrowLeft } from 'lucide-react';
import { Sucursal } from '@/interfaces/sucursales/sucursal.interface';
import { agregarSucursal, editarSucursal, buscarSucursal } from '@/services/sucursales/sucursales.service';

interface Props {
  modo: 'agregar' | 'editar';
  codigoSucursal?: number;
}

const valoresIniciales = {
    nombreSucursal: '',
    direccion: '',
    fechaApertura: '',
    horaApertura: '',
    presupuestoMensual: 0,
    estado: true
};

export default function SucursalesFormVista({ modo, codigoSucursal }: Props) {
  const router = useRouter();
  const [form, setForm] = useState<any>(valoresIniciales);
  const [cargando, setCargando] = useState(modo === 'editar');
  const [guardando, setGuardando] = useState(false);
  const [mensaje, setMensaje] = useState('');

  useEffect(() => {
    if (modo === 'editar' && codigoSucursal) {
      buscarSucursal(codigoSucursal).then((respuesta) => {
        if (respuesta.exito && respuesta.datos.length > 0) {
          setForm(respuesta.datos[0]);
        } else {
          setMensaje('No fue posible cargar el registro.');
        }
        setCargando(false);
      });
    }
  }, [modo, codigoSucursal]);

  async function manejarEnvio(e: React.FormEvent) {
    e.preventDefault();
    setGuardando(true);
    setMensaje('');
    const datos = {
      nombreSucursal,
      direccion,
      fechaApertura,
      horaApertura,
      presupuestoMensual,
      estado
    };
    const respuesta =
      modo === 'agregar'
        ? await agregarSucursal(datos)
        : await editarSucursal(codigoSucursal!, datos);
    setGuardando(false);
    if (respuesta.exito) {
      router.push('/sucursales/consultar');
    } else {
      setMensaje(respuesta.mensaje || 'Ocurrió un error al guardar.');
    }
  }

  if (cargando) {
    return <section className="form-page"><p>Cargando...</p></section>;
  }

  return (
    <section className="form-page">
      <div className="form-page-header">
        <button type="button" className="button-back" onClick={() => router.push('/sucursales/consultar')}>
          <ArrowLeft size={18} strokeWidth={2} />
          <span>Volver</span>
        </button>
        <div className="form-page-title">
          <div className="form-page-icon">
            <Building2 size={24} strokeWidth={2} />
          </div>
          <h1>{modo === 'agregar' ? 'Nueva sucursal' : 'Editar sucursal'}</h1>
        </div>
      </div>

      <form className="form-card" onSubmit={manejarEnvio}>
        <div className="form-grid">
            <div className="form-field">
              <label htmlFor="nombreSucursal">Nombre de la sucursal</label>
              <input
                id="nombreSucursal"
                type="text"
                value={form.nombreSucursal ?? ''}
                onChange={(e) => setForm({ ...form, nombreSucursal: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="direccion">Dirección</label>
              <input
                id="direccion"
                type="text"
                value={form.direccion ?? ''}
                onChange={(e) => setForm({ ...form, direccion: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="fechaApertura">Fecha de apertura</label>
              <input
                id="fechaApertura"
                type="date"
                value={form.fechaApertura ?? ''}
                onChange={(e) => setForm({ ...form, fechaApertura: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="horaApertura">Hora de apertura</label>
              <input
                id="horaApertura"
                type="time"
                value={form.horaApertura ?? ''}
                onChange={(e) => setForm({ ...form, horaApertura: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="presupuestoMensual">Presupuesto mensual (Q)</label>
              <input
                id="presupuestoMensual"
                type="number"
                step="any"
                value={form.presupuestoMensual ?? ''}
                onChange={(e) => setForm({ ...form, presupuestoMensual: e.target.value === '' ? null : Number(e.target.value) })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="estado">Estado</label>
              <select
                id="estado"
                value={form.estado ? 'true' : 'false'}
                onChange={(e) => setForm({ ...form, estado: e.target.value === 'true' })}
              >
                <option value="true">Activo</option>
                <option value="false">Inactivo</option>
              </select>
            </div>
        </div>

        {mensaje && <p className="form-mensaje">{mensaje}</p>}

        <div className="form-actions">
          <button type="button" className="button-secondary" onClick={() => router.push('/sucursales/consultar')}>
            Cancelar
          </button>
          <button type="submit" className="button-primary" disabled={guardando}>
            <Save size={18} strokeWidth={2} />
            <span>{guardando ? 'Guardando...' : 'Guardar'}</span>
          </button>
        </div>
      </form>
    </section>
  );
}
