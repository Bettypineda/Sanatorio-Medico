import MainLayout from '@/components/layout/MainLayout';
import Link from 'next/link';
import { Building2, Users, Stethoscope, CalendarDays, ClipboardList } from 'lucide-react';

const modulos = [
  { nombre: 'Sucursales', ruta: '/sucursales/consultar', icono: Building2 },
  { nombre: 'Pacientes', ruta: '/pacientes/consultar', icono: Users },
  { nombre: 'Médicos', ruta: '/colaboradores/consultar', icono: Stethoscope },
  { nombre: 'Citas', ruta: '/citas/consultar', icono: CalendarDays },
  { nombre: 'Especialidades', ruta: '/especialidades/consultar', icono: ClipboardList },
];

export default function Home() {
  return (
    <MainLayout>
      <div>
        <h1>Dashboard</h1>
        <p>Bienvenido al Sistema Administrativo del Sanatorio Médico.</p>

        <div className="summary-grid summary-grid-3" style={{ marginTop: 24 }}>
          {modulos.map(({ nombre, ruta, icono: Icono }) => (
            <Link key={ruta} href={ruta} className="summary-card" style={{ textDecoration: 'none' }}>
              <div className="summary-icon summary-icon-blue">
                <Icono size={29} strokeWidth={2} aria-hidden="true" />
              </div>
              <div className="summary-info">
                <span className="summary-label">Ir a</span>
                <strong className="summary-value" style={{ fontSize: 20 }}>{nombre}</strong>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </MainLayout>
  );
}
