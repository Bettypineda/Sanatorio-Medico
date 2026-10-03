import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller.js';
import { AppService } from './app.service.js';
import { DatabaseModule } from './database/database.module.js';
import { SucursalesModule } from './sucursales/sucursales.module.js';
import { PacientesModule } from './pacientes/pacientes.module.js';
import { ColaboradoresModule } from './colaboradores/colaboradores.module.js';
import { CitasConsultasModule } from './citas/citas.module.js';
import { EspecialidadesModule } from './especialidades/especialidades.module.js';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    DatabaseModule,
    SucursalesModule,
    PacientesModule,
    ColaboradoresModule,
    CitasConsultasModule,
    EspecialidadesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
