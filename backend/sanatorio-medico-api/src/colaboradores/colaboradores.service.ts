import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

const COLUMNAS_COLABORADORES = `
  codigocolaborador   AS "codigoColaborador",
  codigosucursal      AS "codigoSucursal",
  codigorol           AS "codigoRol",
  nombres             AS "nombres",
  apellidos           AS "apellidos",
  dpi                 AS "dpi",
  numerocolegiado     AS "numeroColegiado",
  tipocolaborador     AS "tipoColaborador",
  telefono            AS "telefono",
  correoelectronico   AS "correoElectronico",
  direccion           AS "direccion",
  fechacontratacion   AS "fechaContratacion",
  nombreusuario       AS "nombreUsuario",
  claveacceso         AS "claveAcceso",
  estado              AS "estado"
`;

@Injectable()
export class ColaboradoresService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT ${COLUMNAS_COLABORADORES}
        FROM Usp_Colaboradores_Consultar();
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

  async buscar(codigoColaborador: number) {
    try {
      if (!Number.isInteger(codigoColaborador) || codigoColaborador <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `
        SELECT ${COLUMNAS_COLABORADORES}
        FROM Usp_Colaboradores_Buscar($1);
      `,
        [codigoColaborador],
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
    codigoSucursal: number,
    codigoRol: number,
    nombres: string,
    apellidos: string,
    dpi: string,
    numeroColegiado: string | null,
    tipoColaborador: string,
    telefono: string,
    correoElectronico: string | null,
    direccion: string | null,
    fechaContratacion: string,
    nombreUsuario: string,
    claveAcceso: string,
    estado: string;
  }) {
    try {
      if (
        !datos.codigoSucursal ||
        !datos.codigoRol ||
        !datos.nombres ||
        !datos.apellidos ||
        !datos.dpi ||
        !datos.tipoColaborador ||
        !datos.telefono ||
        !datos.fechaContratacion ||
        !datos.nombreUsuario ||
        !datos.claveAcceso ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Colaboradores_Agregar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
        );
      `,
        [
          datos.codigoSucursal,
          datos.codigoRol,
          datos.nombres,
          datos.apellidos,
          datos.dpi,
          datos.numeroColegiado ?? null,
          datos.tipoColaborador,
          datos.telefono,
          datos.correoElectronico ?? null,
          datos.direccion ?? null,
          datos.fechaContratacion,
          datos.nombreUsuario,
          datos.claveAcceso,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoColaborador: resultado.rows[0].codigocolaborador,
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
    codigoColaborador: number,
    datos: {
      codigoSucursal: number,
    codigoRol: number,
    nombres: string,
    apellidos: string,
    dpi: string,
    numeroColegiado: string | null,
    tipoColaborador: string,
    telefono: string,
    correoElectronico: string | null,
    direccion: string | null,
    fechaContratacion: string,
    nombreUsuario: string,
    claveAcceso: string,
    estado: string;
    },
  ) {
    try {
      if (!Number.isInteger(codigoColaborador) || codigoColaborador <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      if (
        !datos.codigoSucursal ||
        !datos.codigoRol ||
        !datos.nombres ||
        !datos.apellidos ||
        !datos.dpi ||
        !datos.tipoColaborador ||
        !datos.telefono ||
        !datos.fechaContratacion ||
        !datos.nombreUsuario ||
        !datos.claveAcceso ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Colaboradores_Editar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
        );
      `,
        [
          codigoColaborador,
          datos.codigoSucursal,
          datos.codigoRol,
          datos.nombres,
          datos.apellidos,
          datos.dpi,
          datos.numeroColegiado ?? null,
          datos.tipoColaborador,
          datos.telefono,
          datos.correoElectronico ?? null,
          datos.direccion ?? null,
          datos.fechaContratacion,
          datos.nombreUsuario,
          datos.claveAcceso,
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

  async eliminar(codigoColaborador: number) {
    try {
      if (!Number.isInteger(codigoColaborador) || codigoColaborador <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_Colaboradores_Eliminar($1);`,
        [codigoColaborador],
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
