import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module.js';
import { CitasConsultasController } from './citas.controller.js';
import { CitasConsultasService } from './citas.service.js';

@Module({
  imports: [DatabaseModule],
  controllers: [CitasConsultasController],
  providers: [CitasConsultasService],
})
export class CitasConsultasModule {}
