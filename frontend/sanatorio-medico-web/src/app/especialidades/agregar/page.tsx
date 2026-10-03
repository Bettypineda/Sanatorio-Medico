import MainLayout from '@/components/layout/MainLayout';
import EspecialidadesFormVista from '@/components/especialidades/EspecialidadesFormVista';

export default function EspecialidadesAgregarPage() {
  return (
    <MainLayout>
      <EspecialidadesFormVista modo="agregar" />
    </MainLayout>
  );
}
