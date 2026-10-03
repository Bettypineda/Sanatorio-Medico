'use client';

import { useState } from 'react';
import Link from 'next/link';
import { Users, Search, Pencil } from 'lucide-react';
import { Paciente } from '@/interfaces/pacientes/paciente.interface';
import { buscarPaciente } from '@/services/pacientes/pacientes.service';

export default function PacientesBuscarVista() {
  const [codigo, setCodigo] = useState('');
  const [resultado, setResultado] = useState<Paciente | null>(null);
  const [mensaje, setMensaje] = useState('');
  const [buscando, setBuscando] = useState(false);

  async function manejarBusqueda(e: React.FormEvent) {
    e.preventDefault();
    setBuscando(true);
    setMensaje('');
    setResultado(null);
    const respuesta = await buscarPaciente(Number(codigo));
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
            <Users size={24} strokeWidth={2} />
          </div>
          <h1>Buscar paciente</h1>
        </div>
      </div>

      <form className="form-card form-buscar" onSubmit={manejarBusqueda}>
        <div className="form-field">
          <label htmlFor="codigo">Código de paciente</label>
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
              <label>Número de expediente</label>
              <p className="form-valor">{String(resultado.numeroExpediente ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Tipo de documento</label>
              <p className="form-valor">{String(resultado.tipoDocumento ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Número de documento</label>
              <p className="form-valor">{String(resultado.numeroDocumento ?? '-')}</p>
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
              <label>Fecha de nacimiento</label>
              <p className="form-valor">{String(resultado.fechaNacimiento ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Género</label>
              <p className="form-valor">{String(resultado.genero ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Tipo de sangre</label>
              <p className="form-valor">{String(resultado.tipoSangre ?? '-')}</p>
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
              <label>Contacto de emergencia</label>
              <p className="form-valor">{String(resultado.contactoEmergencia ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Teléfono de emergencia</label>
              <p className="form-valor">{String(resultado.telefonoEmergencia ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Alergias</label>
              <p className="form-valor">{String(resultado.alergias ?? '-')}</p>
            </div>
            <div className="form-field">
              <label>Estado</label>
              <p className="form-valor">{String(resultado.estado ?? '-')}</p>
            </div>
          </div>
          <div className="form-actions">
            <Link href={`/pacientes/editar/${resultado.codigoPaciente}`} className="button-primary">
              <Pencil size={18} strokeWidth={2} />
              <span>Editar este registro</span>
            </Link>
          </div>
        </div>
      )}
    </section>
  );
}
