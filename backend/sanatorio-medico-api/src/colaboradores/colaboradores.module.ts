import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module.js';
import { ColaboradoresController } from './colaboradores.controller.js';
import { ColaboradoresService } from './colaboradores.service.js';

@Module({
  imports: [DatabaseModule],
  controllers: [ColaboradoresController],
  providers: [ColaboradoresService],
})
export class ColaboradoresModule {}
