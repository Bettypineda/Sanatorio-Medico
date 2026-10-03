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
import { SucursalesService } from './sucursales.service.js';

@Controller('api')
export class SucursalesController {
  constructor(private readonly sucursalesService: SucursalesService) {}

  @Get('sucursalesConsultar')
  async consultar() {
    return this.sucursalesService.consultar();
  }

  @Get('sucursalesBuscar/:codigoSucursal')
  async buscar(@Param('codigoSucursal', ParseIntPipe) codigoSucursal: number) {
    return this.sucursalesService.buscar(codigoSucursal);
  }

  @Post('sucursalesAgregar')
  async agregar(@Body() datos: any) {
    return this.sucursalesService.agregar(datos);
  }

  @Put('sucursalesEditar/:codigoSucursal')
  async editar(
    @Param('codigoSucursal', ParseIntPipe) codigoSucursal: number,
    @Body() datos: any,
  ) {
    return this.sucursalesService.editar(codigoSucursal, datos);
  }

  @Delete('sucursalesEliminar/:codigoSucursal')
  async eliminar(@Param('codigoSucursal', ParseIntPipe) codigoSucursal: number) {
    return this.sucursalesService.eliminar(codigoSucursal);
  }
}
