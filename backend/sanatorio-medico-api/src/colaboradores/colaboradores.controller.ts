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
import { ColaboradoresService } from './colaboradores.service.js';

@Controller('api')
export class ColaboradoresController {
  constructor(private readonly colaboradoresService: ColaboradoresService) {}

  @Get('colaboradoresConsultar')
  async consultar() {
    return this.colaboradoresService.consultar();
  }

  @Get('colaboradoresBuscar/:codigoColaborador')
  async buscar(@Param('codigoColaborador', ParseIntPipe) codigoColaborador: number) {
    return this.colaboradoresService.buscar(codigoColaborador);
  }

  @Post('colaboradoresAgregar')
  async agregar(@Body() datos: any) {
    return this.colaboradoresService.agregar(datos);
  }

  @Put('colaboradoresEditar/:codigoColaborador')
  async editar(
    @Param('codigoColaborador', ParseIntPipe) codigoColaborador: number,
    @Body() datos: any,
  ) {
    return this.colaboradoresService.editar(codigoColaborador, datos);
  }

  @Delete('colaboradoresEliminar/:codigoColaborador')
  async eliminar(@Param('codigoColaborador', ParseIntPipe) codigoColaborador: number) {
    return this.colaboradoresService.eliminar(codigoColaborador);
  }
}
