'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { CalendarDays, Save, ArrowLeft } from 'lucide-react';
import { agregarCita, editarCita, buscarCita } from '@/services/citas/citas.service';

interface Props {
  modo: 'agregar' | 'editar';
  codigoCitaConsulta?: number;
}

interface DatosCitaForm {
  codigoPaciente: number | null,
  codigoColaborador: number | null,
  codigoSucursal: number | null,
  codigoEspecialidad: number | null,
  fechaHoraCita: string,
  tipoAtencion: string,
  motivoConsulta: string,
  sintomas: string | null,
  observacionesMedicas: string | null,
  tratamientoGeneral: string | null,
  presionArterial: string | null,
  temperatura: number | null,
  peso: number | null,
  estado: string
}

const valoresIniciales: DatosCitaForm = {
    codigoPaciente: 0,
    codigoColaborador: 0,
    codigoSucursal: 0,
    codigoEspecialidad: 0,
    fechaHoraCita: '',
    tipoAtencion: '',
    motivoConsulta: '',
    sintomas: null,
    observacionesMedicas: null,
    tratamientoGeneral: null,
    presionArterial: null,
    temperatura: null,
    peso: null,
    estado: 'Activo'
};

export default function CitasFormVista({ modo, codigoCitaConsulta }: Props) {
  const router = useRouter();
  const [form, setForm] = useState<DatosCitaForm>(valoresIniciales);
  const [cargando, setCargando] = useState(modo === 'editar');
  const [guardando, setGuardando] = useState(false);
  const [mensaje, setMensaje] = useState('');

  useEffect(() => {
    if (modo === 'editar' && codigoCitaConsulta) {
      buscarCita(codigoCitaConsulta).then((respuesta) => {
        if (respuesta.exito && respuesta.datos.length > 0) {
          setForm(respuesta.datos[0]);
        } else {
          setMensaje('No fue posible cargar el registro.');
        }
        setCargando(false);
      });
    }
  }, [modo, codigoCitaConsulta]);

  async function manejarEnvio(e: React.FormEvent) {
    e.preventDefault();
    setGuardando(true);
    setMensaje('');
    const datos = {
      codigoPaciente: form.codigoPaciente ?? 0,
      codigoColaborador: form.codigoColaborador ?? 0,
      codigoSucursal: form.codigoSucursal ?? 0,
      codigoEspecialidad: form.codigoEspecialidad ?? 0,
      fechaHoraCita: form.fechaHoraCita,
      tipoAtencion: form.tipoAtencion,
      motivoConsulta: form.motivoConsulta,
      sintomas: form.sintomas,
      observacionesMedicas: form.observacionesMedicas,
      tratamientoGeneral: form.tratamientoGeneral,
      presionArterial: form.presionArterial,
      temperatura: form.temperatura,
      peso: form.peso,
      estado: form.estado
    };
    const respuesta =
      modo === 'agregar'
        ? await agregarCita(datos)
        : await editarCita(codigoCitaConsulta!, datos);
    setGuardando(false);
    if (respuesta.exito) {
      router.push('/citas/consultar');
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
        <button type="button" className="button-back" onClick={() => router.push('/citas/consultar')}>
          <ArrowLeft size={18} strokeWidth={2} />
          <span>Volver</span>
        </button>
        <div className="form-page-title">
          <div className="form-page-icon">
            <CalendarDays size={24} strokeWidth={2} />
          </div>
          <h1>{modo === 'agregar' ? 'Nueva cita' : 'Editar cita'}</h1>
        </div>
      </div>

      <form className="form-card" onSubmit={manejarEnvio}>
        <div className="form-grid">
            <div className="form-field">
              <label htmlFor="codigoPaciente">Código de paciente</label>
              <input
                id="codigoPaciente"
                type="number"
                step="any"
                value={form.codigoPaciente ?? ''}
                onChange={(e) => setForm({ ...form, codigoPaciente: e.target.value === '' ? null : Number(e.target.value) })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="codigoColaborador">Código de colaborador</label>
              <input
                id="codigoColaborador"
                type="number"
                step="any"
                value={form.codigoColaborador ?? ''}
                onChange={(e) => setForm({ ...form, codigoColaborador: e.target.value === '' ? null : Number(e.target.value) })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="codigoSucursal">Código de sucursal</label>
              <input
                id="codigoSucursal"
                type="number"
                step="any"
                value={form.codigoSucursal ?? ''}
                onChange={(e) => setForm({ ...form, codigoSucursal: e.target.value === '' ? null : Number(e.target.value) })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="codigoEspecialidad">Código de especialidad</label>
              <input
                id="codigoEspecialidad"
                type="number"
                step="any"
                value={form.codigoEspecialidad ?? ''}
                onChange={(e) => setForm({ ...form, codigoEspecialidad: e.target.value === '' ? null : Number(e.target.value) })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="fechaHoraCita">Fecha y hora de la cita</label>
              <input
                id="fechaHoraCita"
                type="datetime-local"
                value={form.fechaHoraCita ?? ''}
                onChange={(e) => setForm({ ...form, fechaHoraCita: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="tipoAtencion">Tipo de atención</label>
              <input
                id="tipoAtencion"
                type="text"
                value={form.tipoAtencion ?? ''}
                onChange={(e) => setForm({ ...form, tipoAtencion: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="motivoConsulta">Motivo de la consulta</label>
              <input
                id="motivoConsulta"
                type="text"
                value={form.motivoConsulta ?? ''}
                onChange={(e) => setForm({ ...form, motivoConsulta: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="sintomas">Síntomas</label>
              <input
                id="sintomas"
                type="text"
                value={form.sintomas ?? ''}
                onChange={(e) => setForm({ ...form, sintomas: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="observacionesMedicas">Observaciones médicas</label>
              <input
                id="observacionesMedicas"
                type="text"
                value={form.observacionesMedicas ?? ''}
                onChange={(e) => setForm({ ...form, observacionesMedicas: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="tratamientoGeneral">Tratamiento general</label>
              <input
                id="tratamientoGeneral"
                type="text"
                value={form.tratamientoGeneral ?? ''}
                onChange={(e) => setForm({ ...form, tratamientoGeneral: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="presionArterial">Presión arterial</label>
              <input
                id="presionArterial"
                type="text"
                value={form.presionArterial ?? ''}
                onChange={(e) => setForm({ ...form, presionArterial: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="temperatura">Temperatura (°C)</label>
              <input
                id="temperatura"
                type="number"
                step="any"
                value={form.temperatura ?? ''}
                onChange={(e) => setForm({ ...form, temperatura: e.target.value === '' ? null : Number(e.target.value) })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="peso">Peso (lb)</label>
              <input
                id="peso"
                type="number"
                step="any"
                value={form.peso ?? ''}
                onChange={(e) => setForm({ ...form, peso: e.target.value === '' ? null : Number(e.target.value) })}
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
          <button type="button" className="button-secondary" onClick={() => router.push('/citas/consultar')}>
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
