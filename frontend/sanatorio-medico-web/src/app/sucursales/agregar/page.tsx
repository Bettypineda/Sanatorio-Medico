import MainLayout from '@/components/layout/MainLayout';
import SucursalesFormVista from '@/components/sucursales/SucursalesFormVista';

export default function SucursalesAgregarPage() {
  return (
    <MainLayout>
      <SucursalesFormVista modo="agregar" />
    </MainLayout>
  );
}
