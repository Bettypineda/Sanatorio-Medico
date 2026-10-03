import MainLayout from '@/components/layout/MainLayout';
import SucursalesFormVista from '@/components/sucursales/SucursalesFormVista';

export default async function SucursalesEditarPage({ params }: { params: Promise<{ codigo: string }> }) {
  const { codigo } = await params;
  return (
    <MainLayout>
      <SucursalesFormVista modo="editar" codigoSucursal={Number(codigo)} />
    </MainLayout>
  );
}
