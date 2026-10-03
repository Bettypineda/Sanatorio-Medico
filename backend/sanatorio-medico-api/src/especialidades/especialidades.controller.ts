import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { EspecialidadesService } from './especialidades.service.js';

@Controller('api')
export class EspecialidadesController {
  constructor(private readonly especialidadesService: EspecialidadesService) {}

  @Get('especialidadesConsultar')
  async consultar() {
    return this.especialidadesService.consultar();
  }

  @Get('especialidadesBuscar/:codigoEspecialidad')
  async buscar(@Param('codigoEspecialidad', ParseIntPipe) codigoEspecialidad: number) {
    return this.especialidadesService.buscar(codigoEspecialidad);
  }

  @Post('especialidadesAgregar')
  async agregar(@Body() datos: any) {
    return this.especialidadesService.agregar(datos);
  }

  @Put('especialidadesEditar/:codigoEspecialidad')
  async editar(
    @Param('codigoEspecialidad', ParseIntPipe) codigoEspecialidad: number,
    @Body() datos: any,
  ) {
    return this.especialidadesService.editar(codigoEspecialidad, datos);
  }

  @Delete('especialidadesEliminar/:codigoEspecialidad')
  async eliminar(@Param('codigoEspecialidad', ParseIntPipe) codigoEspecialidad: number) {
    return this.especialidadesService.eliminar(codigoEspecialidad);
  }
}
