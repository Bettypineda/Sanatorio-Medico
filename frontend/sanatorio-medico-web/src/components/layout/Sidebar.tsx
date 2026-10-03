'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import {
  LayoutDashboard,
  Building2,
  FileText,
  Plus,
  Users,
  Stethoscope,
  CalendarDays,
  ClipboardList,
  Settings,
  ChevronDown,
} from 'lucide-react';

export default function Sidebar() {
  const pathname = usePathname();

  const [sucursalesAbierto, setSucursalesAbierto] = useState(
    pathname?.startsWith('/sucursales') ?? false,
  );

  const dashboardActivo = pathname === '/';
  const consultarActivo = pathname === '/sucursales/consultar';
  const agregarActivo = pathname === '/sucursales/agregar';

  function enlaceActivo(ruta: string) {
    return pathname?.startsWith(ruta) ? 'sidebar-link sidebar-link-active' : 'sidebar-link';
  }

  return (
    <aside className="sidebar">
      <nav className="sidebar-menu" aria-label="Menú principal">
        {/* DASHBOARD */}
        <Link href="/" className={dashboardActivo ? 'sidebar-link sidebar-link-active' : 'sidebar-link'}>
          <LayoutDashboard size={21} strokeWidth={2} aria-hidden="true" />
          <span>Dashboard</span>
        </Link>

        {/* MODULO SUCURSALES */}
        <div className="sidebar-module">
          <button
            type="button"
            className="sidebar-module-title"
            onClick={() => setSucursalesAbierto(!sucursalesAbierto)}
            aria-expanded={sucursalesAbierto}
            aria-controls="submenu-sucursales"
          >
            <Building2 size={21} strokeWidth={2} aria-hidden="true" />
            <span>Sucursales</span>
            <ChevronDown
              className={sucursalesAbierto ? 'sidebar-arrow sidebar-arrow-open' : 'sidebar-arrow'}
              size={18}
              strokeWidth={2}
              aria-hidden="true"
            />
          </button>
          {sucursalesAbierto && (
            <div id="submenu-sucursales" className="sidebar-submenu">
              <Link
                href="/sucursales/consultar"
                className={consultarActivo ? 'sidebar-sublink sidebar-sublink-active' : 'sidebar-sublink'}
              >
                <FileText size={19} strokeWidth={2} aria-hidden="true" />
                <span>Consultar</span>
              </Link>
              <Link
                href="/sucursales/agregar"
                className={agregarActivo ? 'sidebar-sublink sidebar-sublink-active' : 'sidebar-sublink'}
              >
                <Plus size={20} strokeWidth={2.2} aria-hidden="true" />
                <span>Agregar</span>
              </Link>
            </div>
          )}
        </div>

        <div className="sidebar-divider" aria-hidden="true" />

        {/* PACIENTES */}
        <Link href="/pacientes/consultar" className={enlaceActivo('/pacientes')}>
          <Users size={21} strokeWidth={2} aria-hidden="true" />
          <span>Pacientes</span>
        </Link>

        {/* MEDICOS (Colaboradores) */}
        <Link href="/colaboradores/consultar" className={enlaceActivo('/colaboradores')}>
          <Stethoscope size={21} strokeWidth={2} aria-hidden="true" />
          <span>Médicos</span>
        </Link>

        {/* CITAS */}
        <Link href="/citas/consultar" className={enlaceActivo('/citas')}>
          <CalendarDays size={21} strokeWidth={2} aria-hidden="true" />
          <span>Citas</span>
        </Link>

        {/* ESPECIALIDADES */}
        <Link href="/especialidades/consultar" className={enlaceActivo('/especialidades')}>
          <ClipboardList size={21} strokeWidth={2} aria-hidden="true" />
          <span>Especialidades</span>
        </Link>
      </nav>

      <div className="sidebar-footer">
        <Link href="#" className="sidebar-link">
          <Settings size={21} strokeWidth={2} aria-hidden="true" />
          <span>Configuración</span>
        </Link>
      </div>
    </aside>
  );
}
