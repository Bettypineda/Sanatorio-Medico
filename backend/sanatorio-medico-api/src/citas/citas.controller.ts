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
import { CitasConsultasService } from './citas.service.js';

@Controller('api')
export class CitasConsultasController {
  constructor(private readonly citasService: CitasConsultasService) {}

  @Get('citasConsultar')
  async consultar() {
    return this.citasService.consultar();
  }

  @Get('citasBuscar/:codigoCitaConsulta')
  async buscar(@Param('codigoCitaConsulta', ParseIntPipe) codigoCitaConsulta: number) {
    return this.citasService.buscar(codigoCitaConsulta);
  }

  @Post('citasAgregar')
  async agregar(@Body() datos: any) {
    return this.citasService.agregar(datos);
  }

  @Put('citasEditar/:codigoCitaConsulta')
  async editar(
    @Param('codigoCitaConsulta', ParseIntPipe) codigoCitaConsulta: number,
    @Body() datos: any,
  ) {
    return this.citasService.editar(codigoCitaConsulta, datos);
  }

  @Delete('citasEliminar/:codigoCitaConsulta')
  async eliminar(@Param('codigoCitaConsulta', ParseIntPipe) codigoCitaConsulta: number) {
    return this.citasService.eliminar(codigoCitaConsulta);
  }
}
