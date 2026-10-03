'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { Stethoscope, Save, ArrowLeft } from 'lucide-react';
import { agregarColaborador, editarColaborador, buscarColaborador } from '@/services/colaboradores/colaboradores.service';

interface Props {
  modo: 'agregar' | 'editar';
  codigoColaborador?: number;
}

interface DatosColaboradorForm {
  codigoSucursal: number | null,
  codigoRol: number | null,
  nombres: string,
  apellidos: string,
  dpi: string,
  numeroColegiado: string | null,
  tipoColaborador: string,
  telefono: string,
  correoElectronico: string | null,
  direccion: string | null,
  fechaContratacion: string,
  nombreUsuario: string,
  claveAcceso: string,
  estado: string
}

const valoresIniciales: DatosColaboradorForm = {
    codigoSucursal: 0,
    codigoRol: 0,
    nombres: '',
    apellidos: '',
    dpi: '',
    numeroColegiado: null,
    tipoColaborador: '',
    telefono: '',
    correoElectronico: null,
    direccion: null,
    fechaContratacion: '',
    nombreUsuario: '',
    claveAcceso: '',
    estado: 'Activo'
};

export default function ColaboradoresFormVista({ modo, codigoColaborador }: Props) {
  const router = useRouter();
  const [form, setForm] = useState<DatosColaboradorForm>(valoresIniciales);
  const [cargando, setCargando] = useState(modo === 'editar');
  const [guardando, setGuardando] = useState(false);
  const [mensaje, setMensaje] = useState('');

  useEffect(() => {
    if (modo === 'editar' && codigoColaborador) {
      buscarColaborador(codigoColaborador).then((respuesta) => {
        if (respuesta.exito && respuesta.datos.length > 0) {
          setForm(respuesta.datos[0]);
        } else {
          setMensaje('No fue posible cargar el registro.');
        }
        setCargando(false);
      });
    }
  }, [modo, codigoColaborador]);

  async function manejarEnvio(e: React.FormEvent) {
    e.preventDefault();
    setGuardando(true);
    setMensaje('');
    const datos = {
      codigoSucursal: form.codigoSucursal ?? 0,
      codigoRol: form.codigoRol ?? 0,
      nombres: form.nombres,
      apellidos: form.apellidos,
      dpi: form.dpi,
      numeroColegiado: form.numeroColegiado,
      tipoColaborador: form.tipoColaborador,
      telefono: form.telefono,
      correoElectronico: form.correoElectronico,
      direccion: form.direccion,
      fechaContratacion: form.fechaContratacion,
      nombreUsuario: form.nombreUsuario,
      claveAcceso: form.claveAcceso,
      estado: form.estado
    };
    const respuesta =
      modo === 'agregar'
        ? await agregarColaborador(datos)
        : await editarColaborador(codigoColaborador!, datos);
    setGuardando(false);
    if (respuesta.exito) {
      router.push('/colaboradores/consultar');
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
        <button type="button" className="button-back" onClick={() => router.push('/colaboradores/consultar')}>
          <ArrowLeft size={18} strokeWidth={2} />
          <span>Volver</span>
        </button>
        <div className="form-page-title">
          <div className="form-page-icon">
            <Stethoscope size={24} strokeWidth={2} />
          </div>
          <h1>{modo === 'agregar' ? 'Nueva colaborador' : 'Editar colaborador'}</h1>
        </div>
      </div>

      <form className="form-card" onSubmit={manejarEnvio}>
        <div className="form-grid">
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
              <label htmlFor="codigoRol">Código de rol</label>
              <input
                id="codigoRol"
                type="number"
                step="any"
                value={form.codigoRol ?? ''}
                onChange={(e) => setForm({ ...form, codigoRol: e.target.value === '' ? null : Number(e.target.value) })} required
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
              <label htmlFor="dpi">DPI</label>
              <input
                id="dpi"
                type="text"
                value={form.dpi ?? ''}
                onChange={(e) => setForm({ ...form, dpi: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="numeroColegiado">Número de colegiado</label>
              <input
                id="numeroColegiado"
                type="text"
                value={form.numeroColegiado ?? ''}
                onChange={(e) => setForm({ ...form, numeroColegiado: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="tipoColaborador">Tipo de colaborador</label>
              <input
                id="tipoColaborador"
                type="text"
                value={form.tipoColaborador ?? ''}
                onChange={(e) => setForm({ ...form, tipoColaborador: e.target.value })} required
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
                onChange={(e) => setForm({ ...form, direccion: e.target.value })}
              />
            </div>

            <div className="form-field">
              <label htmlFor="fechaContratacion">Fecha de contratación</label>
              <input
                id="fechaContratacion"
                type="date"
                value={form.fechaContratacion ?? ''}
                onChange={(e) => setForm({ ...form, fechaContratacion: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="nombreUsuario">Nombre de usuario</label>
              <input
                id="nombreUsuario"
                type="text"
                value={form.nombreUsuario ?? ''}
                onChange={(e) => setForm({ ...form, nombreUsuario: e.target.value })} required
              />
            </div>

            <div className="form-field">
              <label htmlFor="claveAcceso">Clave de acceso</label>
              <input
                id="claveAcceso"
                type="text"
                value={form.claveAcceso ?? ''}
                onChange={(e) => setForm({ ...form, claveAcceso: e.target.value })} required
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
          <button type="button" className="button-secondary" onClick={() => router.push('/colaboradores/consultar')}>
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
