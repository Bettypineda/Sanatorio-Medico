import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module.js';
import { EspecialidadesController } from './especialidades.controller.js';
import { EspecialidadesService } from './especialidades.service.js';

@Module({
  imports: [DatabaseModule],
  controllers: [EspecialidadesController],
  providers: [EspecialidadesService],
})
export class EspecialidadesModule {}
