import MainLayout from '@/components/layout/MainLayout';
import CitasFormVista from '@/components/citas/CitasFormVista';

export default function CitasAgregarPage() {
  return (
    <MainLayout>
      <CitasFormVista modo="agregar" />
    </MainLayout>
  );
}
