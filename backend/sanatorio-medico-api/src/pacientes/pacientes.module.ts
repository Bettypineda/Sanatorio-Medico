import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module.js';
import { PacientesController } from './pacientes.controller.js';
import { PacientesService } from './pacientes.service.js';

@Module({
  imports: [DatabaseModule],
  controllers: [PacientesController],
  providers: [PacientesService],
})
export class PacientesModule {}
