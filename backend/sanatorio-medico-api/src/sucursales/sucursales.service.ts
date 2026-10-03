import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

const COLUMNAS_SUCURSALES = `
  codigosucursal      AS "codigoSucursal",
  nombresucursal      AS "nombreSucursal",
  direccion           AS "direccion",
  fechaapertura       AS "fechaApertura",
  horaapertura        AS "horaApertura",
  presupuestomensual  AS "presupuestoMensual",
  estado              AS "estado"
`;

@Injectable()
export class SucursalesService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT ${COLUMNAS_SUCURSALES}
        FROM Usp_Sucursales_Consultar();
      `);
      return {
        exito: 1,
        mensaje: 'Registros consultados correctamente.',
        datos: resultado.rows,
      };
    } catch (error) {
      const mensaje =
        error instanceof Error ? error.message : 'Error desconocido al consultar.';
      throw new InternalServerErrorException({ exito: 0, mensaje });
    }
  }

  async buscar(codigoSucursal: number) {
    try {
      if (!Number.isInteger(codigoSucursal) || codigoSucursal <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `
        SELECT ${COLUMNAS_SUCURSALES}
        FROM Usp_Sucursales_Buscar($1);
      `,
        [codigoSucursal],
      );
      return {
        exito: 1,
        mensaje: 'Registro encontrado correctamente.',
        datos: resultado.rows,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensajeCompleto =
        error instanceof Error ? error.message : 'Error desconocido al buscar.';
      const mensaje = mensajeCompleto.includes('No se encontró el registro solicitado.')
        ? 'No se encontró el registro solicitado.'
        : mensajeCompleto;
      throw new InternalServerErrorException({ exito: 0, mensaje });
    }
  }

  async agregar(datos: {
    nombreSucursal: string,
    direccion: string,
    fechaApertura: string,
    horaApertura: string,
    presupuestoMensual: number,
    estado: boolean;
  }) {
    try {
      if (
        !datos.nombreSucursal ||
        !datos.direccion ||
        !datos.fechaApertura ||
        !datos.horaApertura ||
        !datos.presupuestoMensual ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Sucursales_Agregar(
          $1, $2, $3, $4, $5, $6
        );
      `,
        [
          datos.nombreSucursal,
          datos.direccion,
          datos.fechaApertura,
          datos.horaApertura,
          datos.presupuestoMensual,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoSucursal: resultado.rows[0].codigosucursal,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensajeCompleto =
        error instanceof Error ? error.message : 'Error desconocido al agregar.';
      const mensaje = mensajeCompleto.includes('23503')
        ? 'Uno de los códigos relacionados no existe.'
        : mensajeCompleto;
      throw new InternalServerErrorException({ exito: 0, mensaje });
    }
  }

  async editar(
    codigoSucursal: number,
    datos: {
      nombreSucursal: string,
    direccion: string,
    fechaApertura: string,
    horaApertura: string,
    presupuestoMensual: number,
    estado: boolean;
    },
  ) {
    try {
      if (!Number.isInteger(codigoSucursal) || codigoSucursal <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      if (
        !datos.nombreSucursal ||
        !datos.direccion ||
        !datos.fechaApertura ||
        !datos.horaApertura ||
        !datos.presupuestoMensual ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Sucursales_Editar(
          $1, $2, $3, $4, $5, $6, $7
        );
      `,
        [
          codigoSucursal,
          datos.nombreSucursal,
          datos.direccion,
          datos.fechaApertura,
          datos.horaApertura,
          datos.presupuestoMensual,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensajeCompleto =
        error instanceof Error ? error.message : 'Error desconocido al editar.';
      let mensaje = mensajeCompleto;
      if (mensajeCompleto.includes('No se encontró el registro solicitado.')) {
        mensaje = 'No se encontró el registro solicitado.';
      } else if (mensajeCompleto.includes('23503')) {
        mensaje = 'Uno de los códigos relacionados no existe.';
      }
      throw new InternalServerErrorException({ exito: 0, mensaje });
    }
  }

  async eliminar(codigoSucursal: number) {
    try {
      if (!Number.isInteger(codigoSucursal) || codigoSucursal <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_Sucursales_Eliminar($1);`,
        [codigoSucursal],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
      };
    } catch (error) {
      if (error instanceof BadRequestException) throw error;
      const mensajeCompleto =
        error instanceof Error ? error.message : 'Error desconocido al eliminar.';
      let mensaje = mensajeCompleto;
      if (mensajeCompleto.includes('No se encontró el registro solicitado.')) {
        mensaje = 'No se encontró el registro solicitado.';
      } else if (mensajeCompleto.includes('23503')) {
        mensaje = 'No se puede eliminar porque tiene registros relacionados.';
      }
      throw new InternalServerErrorException({ exito: 0, mensaje });
    }
  }
}
