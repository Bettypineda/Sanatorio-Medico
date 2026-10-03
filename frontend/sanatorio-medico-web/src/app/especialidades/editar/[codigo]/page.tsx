import MainLayout from '@/components/layout/MainLayout';
import EspecialidadesFormVista from '@/components/especialidades/EspecialidadesFormVista';

export default async function EspecialidadesEditarPage({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return (
    <MainLayout>
      <EspecialidadesFormVista modo="editar" codigoEspecialidad={Number(codigo)} />
    </MainLayout>
  );
}
