import MainLayout from '@/components/layout/MainLayout';
import ColaboradoresFormVista from '@/components/colaboradores/ColaboradoresFormVista';

export default function ColaboradoresAgregarPage() {
  return (
    <MainLayout>
      <ColaboradoresFormVista modo="agregar" />
    </MainLayout>
  );
}
