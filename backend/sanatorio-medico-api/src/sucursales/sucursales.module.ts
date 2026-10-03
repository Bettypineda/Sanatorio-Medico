import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module.js';
import { SucursalesController } from './sucursales.controller.js';
import { SucursalesService } from './sucursales.service.js';

@Module({
  imports: [DatabaseModule],
  controllers: [SucursalesController],
  providers: [SucursalesService],
})
export class SucursalesModule {}
