export interface Sucursal {
  codigoSucursal: number;
  nombreSucursal: string;
  direccion: string;
  fechaApertura: string;
  horaApertura: string;
  presupuestoMensual: number;
  estado: boolean;
}

export interface RespuestaSucursales {
  exito: number;
  mensaje: string;
  datos: Sucursal[];
}

export interface RespuestaAccionSucursales {
  exito: number;
  mensaje: string;
  codigoSucursal?: number;
}
