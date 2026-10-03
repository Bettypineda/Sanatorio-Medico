import MainLayout from '@/components/layout/MainLayout';
import ColaboradoresFormVista from '@/components/colaboradores/ColaboradoresFormVista';

export default async function ColaboradoresEditarPage({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return (
    <MainLayout>
      <ColaboradoresFormVista modo="editar" codigoColaborador={Number(codigo)} />
    </MainLayout>
  );
}
