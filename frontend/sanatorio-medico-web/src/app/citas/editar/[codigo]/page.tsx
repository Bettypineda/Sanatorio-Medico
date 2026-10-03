import MainLayout from '@/components/layout/MainLayout';
import CitasFormVista from '@/components/citas/CitasFormVista';

export default async function CitasEditarPage({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return (
    <MainLayout>
      <CitasFormVista modo="editar" codigoCitaConsulta={Number(codigo)} />
    </MainLayout>
  );
}
