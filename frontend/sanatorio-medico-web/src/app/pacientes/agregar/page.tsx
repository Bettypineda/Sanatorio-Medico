import MainLayout from '@/components/layout/MainLayout';
import PacientesFormVista from '@/components/pacientes/PacientesFormVista';

export default function PacientesAgregarPage() {
  return (
    <MainLayout>
      <PacientesFormVista modo="agregar" />
    </MainLayout>
  );
}
