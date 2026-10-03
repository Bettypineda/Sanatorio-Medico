import MainLayout from '@/components/layout/MainLayout';
import PacientesFormVista from '@/components/pacientes/PacientesFormVista';

export default async function PacientesEditarPage({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return (
    <MainLayout>
      <PacientesFormVista modo="editar" codigoPaciente={Number(codigo)} />
    </MainLayout>
  );
}
