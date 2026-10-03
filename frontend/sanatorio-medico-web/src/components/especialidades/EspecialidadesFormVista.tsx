'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { ClipboardList, Save, ArrowLeft } from 'lucide-react';
import { agregarEspecialidad, editarEspecialidad, buscarEspecialidad } from '@/services/especialidades/especialidades.service';

interface Props {
  modo: 'agregar' | 'editar';
  codigoEspecialidad?: number;
}

interface DatosEspecialidadForm {
  nombreEspecialidad: string,
  descripcion: string | null,
  areaMedica: string | null,
  duracionConsulta: number | null,
  costoConsulta: number | null,
  requiereCita: boolean,
  observaciones: string | null,
  estado: string
}

const valoresIniciales: DatosEspecialidadForm = {
    nombreEspecialidad: '',
    descripcion: null,
    areaMedica: null,
    duracionConsulta: null,
    costoConsulta: null,
    requiereCita: true,
    observaciones: null,
    estado: 'Activo'
};

export default function EspecialidadesFormVista({ modo, codigoEspecialidad }: Props) {
  const router = useRouter();
  const [form, setForm] = useState<DatosEspecialidadForm>(valoresIniciales);
  const [cargando, setCargando] = useState(modo === 'editar');
  const [guardando, setGuardando] = useState(false);
  const [mensaje, setMensaje] = useState('');

  useEffect(() => {
    if (modo === 'editar' && codigoEspecialidad) {
      buscarEspecialidad(codigoEspecialidad).then((respuesta) => {
        if (respuesta.exito && respuesta.datos.length > 0) {
          setForm(respuesta.datos[0]);
        } else {
          setMensaje('No fue posible cargar el registro.');
        }
        setCargando(false);
      });
    }
  }, [modo, codigoEspecialidad]);

  async function manejarEnvio(e: React.FormEvent) {
    e.preventDefault();
    setGuardando(true);
    setMensaje('');
    const datos = {
      nombreEspecialidad: form.nombreEspecialidad,
      descripcion: form.descripcion,
      areaMedica: form.areaMedica,
      duracionConsulta: form.duracionConsulta,
      costoConsulta: form.costoConsulta,
      requiereCita: form.requiereCita,
      observaciones: form.observaciones,
      estado: form.estado
    };
    const respuesta =
      modo === 'agregar'
        ? await agregarEspecialidad(datos)
        : await editarEspecialidad(codigoEspecialidad!, datos);
    setGuardando(false);
    if (respuesta.exito) {
      router.push('/especialidades/consultar');
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
        <button type="button" className="button-back" onClick={() => router.push('/especialidades/consultar')}>
          <ArrowLeft size={18} strokeWidth={2} />
          <span>Volver</span>
        </button>
        <div className="form-page-title">
          <div className="form-page-icon">
            <ClipboardList size={24} strokeWidth={2} />
          </div>
          <h1>{modo === 'agregar' ? 'Nueva especialidad' : 'Editar especialidad'}</h1>
        </div>
      </div>

      <form className="form-card" onSubmit={manejarEnvio}>
        <div className="form-grid">
            <div className="form-field">
              <label htmlFor="nombreEspecialidad">Nombre de la especialidad</label>
              <input
                id="nombreEspecialidad"
                type="text"
                value={form.nombreEspecialidad ?? ''}
                onChange={(e) => setForm({ ...form, nombreEspecialidad: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="descripcion">Descripción</label>
              <input
                id="descripcion"
                type="text"
                value={form.descripcion ?? ''}
                onChange={(e) => setForm({ ...form, descripcion: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="areaMedica">Área médica</label>
              <input
                id="areaMedica"
                type="text"
                value={form.areaMedica ?? ''}
                onChange={(e) => setForm({ ...form, areaMedica: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="duracionConsulta">Duración de consulta (min)</label>
              <input
                id="duracionConsulta"
                type="number"
                step="any"
                value={form.duracionConsulta ?? ''}
                onChange={(e) => setForm({ ...form, duracionConsulta: e.target.value === '' ? null : Number(e.target.value) })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="costoConsulta">Costo de consulta (Q)</label>
              <input
                id="costoConsulta"
                type="number"
                step="any"
                value={form.costoConsulta ?? ''}
                onChange={(e) => setForm({ ...form, costoConsulta: e.target.value === '' ? null : Number(e.target.value) })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="requiereCita">¿Requiere cita?</label>
              <select
                id="requiereCita"
                value={form.requiereCita ? 'true' : 'false'}
                onChange={(e) => setForm({ ...form, requiereCita: e.target.value === 'true' })}
              >
                <option value="true">Activo</option>
                <option value="false">Inactivo</option>
              </select>
            </div>

            <div className="form-field">
              <label htmlFor="observaciones">Observaciones</label>
              <input
                id="observaciones"
                type="text"
                value={form.observaciones ?? ''}
                onChange={(e) => setForm({ ...form, observaciones: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="estado">Estado</label>
              <select
                id="estado"
                value={form.estado}
                onChange={(e) => setForm({ ...form, estado: e.target.value })}
              >
                <option value="Activo">Activo</option>
                <option value="Inactivo">Inactivo</option>
              </select>
            </div>
        </div>

        {mensaje && <p className="form-mensaje">{mensaje}</p>}

        <div className="form-actions">
          <button type="button" className="button-secondary" onClick={() => router.push('/especialidades/consultar')}>
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
