'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Users, Save, ArrowLeft } from 'lucide-react';
import { Paciente } from '@/interfaces/pacientes/paciente.interface';
import { agregarPaciente, editarPaciente, buscarPaciente } from '@/services/pacientes/pacientes.service';

interface Props {
  modo: 'agregar' | 'editar';
  codigoPaciente?: number;
}

const valoresIniciales = {
    numeroExpediente: '',
    tipoDocumento: '',
    numeroDocumento: '',
    nombres: '',
    apellidos: '',
    fechaNacimiento: '',
    genero: '',
    tipoSangre: null,
    telefono: '',
    correoElectronico: null,
    direccion: '',
    contactoEmergencia: null,
    telefonoEmergencia: null,
    alergias: null,
    estado: 'Activo'
};

export default function PacientesFormVista({ modo, codigoPaciente }: Props) {
  const router = useRouter();
  const [form, setForm] = useState<any>(valoresIniciales);
  const [cargando, setCargando] = useState(modo === 'editar');
  const [guardando, setGuardando] = useState(false);
  const [mensaje, setMensaje] = useState('');

  useEffect(() => {
    if (modo === 'editar' && codigoPaciente) {
      buscarPaciente(codigoPaciente).then((respuesta) => {
        if (respuesta.exito && respuesta.datos.length > 0) {
          setForm(respuesta.datos[0]);
        } else {
          setMensaje('No fue posible cargar el registro.');
        }
        setCargando(false);
      });
    }
  }, [modo, codigoPaciente]);

  async function manejarEnvio(e: React.FormEvent) {
    e.preventDefault();
    setGuardando(true);
    setMensaje('');
    const datos = {
      numeroExpediente,
      tipoDocumento,
      numeroDocumento,
      nombres,
      apellidos,
      fechaNacimiento,
      genero,
      tipoSangre,
      telefono,
      correoElectronico,
      direccion,
      contactoEmergencia,
      telefonoEmergencia,
      alergias,
      estado
    };
    const respuesta =
      modo === 'agregar'
        ? await agregarPaciente(datos)
        : await editarPaciente(codigoPaciente!, datos);
    setGuardando(false);
    if (respuesta.exito) {
      router.push('/pacientes/consultar');
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
        <button type="button" className="button-back" onClick={() => router.push('/pacientes/consultar')}>
          <ArrowLeft size={18} strokeWidth={2} />
          <span>Volver</span>
        </button>
        <div className="form-page-title">
          <div className="form-page-icon">
            <Users size={24} strokeWidth={2} />
          </div>
          <h1>{modo === 'agregar' ? 'Nueva paciente' : 'Editar paciente'}</h1>
        </div>
      </div>

      <form className="form-card" onSubmit={manejarEnvio}>
        <div className="form-grid">
            <div className="form-field">
              <label htmlFor="numeroExpediente">Número de expediente</label>
              <input
                id="numeroExpediente"
                type="text"
                value={form.numeroExpediente ?? ''}
                onChange={(e) => setForm({ ...form, numeroExpediente: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="tipoDocumento">Tipo de documento</label>
              <input
                id="tipoDocumento"
                type="text"
                value={form.tipoDocumento ?? ''}
                onChange={(e) => setForm({ ...form, tipoDocumento: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="numeroDocumento">Número de documento</label>
              <input
                id="numeroDocumento"
                type="text"
                value={form.numeroDocumento ?? ''}
                onChange={(e) => setForm({ ...form, numeroDocumento: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="nombres">Nombres</label>
              <input
                id="nombres"
                type="text"
                value={form.nombres ?? ''}
                onChange={(e) => setForm({ ...form, nombres: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="apellidos">Apellidos</label>
              <input
                id="apellidos"
                type="text"
                value={form.apellidos ?? ''}
                onChange={(e) => setForm({ ...form, apellidos: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="fechaNacimiento">Fecha de nacimiento</label>
              <input
                id="fechaNacimiento"
                type="date"
                value={form.fechaNacimiento ?? ''}
                onChange={(e) => setForm({ ...form, fechaNacimiento: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="genero">Género</label>
              <input
                id="genero"
                type="text"
                value={form.genero ?? ''}
                onChange={(e) => setForm({ ...form, genero: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="tipoSangre">Tipo de sangre</label>
              <input
                id="tipoSangre"
                type="text"
                value={form.tipoSangre ?? ''}
                onChange={(e) => setForm({ ...form, tipoSangre: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="telefono">Teléfono</label>
              <input
                id="telefono"
                type="text"
                value={form.telefono ?? ''}
                onChange={(e) => setForm({ ...form, telefono: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="correoElectronico">Correo electrónico</label>
              <input
                id="correoElectronico"
                type="text"
                value={form.correoElectronico ?? ''}
                onChange={(e) => setForm({ ...form, correoElectronico: e.target.value })}
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
              <label htmlFor="contactoEmergencia">Contacto de emergencia</label>
              <input
                id="contactoEmergencia"
                type="text"
                value={form.contactoEmergencia ?? ''}
                onChange={(e) => setForm({ ...form, contactoEmergencia: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="telefonoEmergencia">Teléfono de emergencia</label>
              <input
                id="telefonoEmergencia"
                type="text"
                value={form.telefonoEmergencia ?? ''}
                onChange={(e) => setForm({ ...form, telefonoEmergencia: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="alergias">Alergias</label>
              <input
                id="alergias"
                type="text"
                value={form.alergias ?? ''}
                onChange={(e) => setForm({ ...form, alergias: e.target.value })}
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
          <button type="button" className="button-secondary" onClick={() => router.push('/pacientes/consultar')}>
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
