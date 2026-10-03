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
import { PacientesService } from './pacientes.service.js';

@Controller('api')
export class PacientesController {
  constructor(private readonly pacientesService: PacientesService) {}

  @Get('pacientesConsultar')
  async consultar() {
    return this.pacientesService.consultar();
  }

  @Get('pacientesBuscar/:codigoPaciente')
  async buscar(@Param('codigoPaciente', ParseIntPipe) codigoPaciente: number) {
    return this.pacientesService.buscar(codigoPaciente);
  }

  @Post('pacientesAgregar')
  async agregar(@Body() datos: any) {
    return this.pacientesService.agregar(datos);
  }

  @Put('pacientesEditar/:codigoPaciente')
  async editar(
    @Param('codigoPaciente', ParseIntPipe) codigoPaciente: number,
    @Body() datos: any,
  ) {
    return this.pacientesService.editar(codigoPaciente, datos);
  }

  @Delete('pacientesEliminar/:codigoPaciente')
  async eliminar(@Param('codigoPaciente', ParseIntPipe) codigoPaciente: number) {
    return this.pacientesService.eliminar(codigoPaciente);
  }
}
