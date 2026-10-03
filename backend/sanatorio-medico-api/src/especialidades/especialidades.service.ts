import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

const COLUMNAS_ESPECIALIDADES = `
  codigoespecialidad  AS "codigoEspecialidad",
  nombreespecialidad  AS "nombreEspecialidad",
  descripcion         AS "descripcion",
  areamedica          AS "areaMedica",
  duracionconsulta    AS "duracionConsulta",
  costoconsulta       AS "costoConsulta",
  requierecita        AS "requiereCita",
  observaciones       AS "observaciones",
  estado              AS "estado"
`;

@Injectable()
export class EspecialidadesService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT ${COLUMNAS_ESPECIALIDADES}
        FROM Usp_Especialidades_Consultar();
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

  async buscar(codigoEspecialidad: number) {
    try {
      if (!Number.isInteger(codigoEspecialidad) || codigoEspecialidad <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `
        SELECT ${COLUMNAS_ESPECIALIDADES}
        FROM Usp_Especialidades_Buscar($1);
      `,
        [codigoEspecialidad],
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
    nombreEspecialidad: string,
    descripcion: string | null,
    areaMedica: string | null,
    duracionConsulta: number | null,
    costoConsulta: number | null,
    requiereCita: boolean,
    observaciones: string | null,
    estado: string;
  }) {
    try {
      if (
        !datos.nombreEspecialidad ||
        (datos.requiereCita === undefined || datos.requiereCita === null) ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Especialidades_Agregar(
          $1, $2, $3, $4, $5, $6, $7, $8
        );
      `,
        [
          datos.nombreEspecialidad,
          datos.descripcion ?? null,
          datos.areaMedica ?? null,
          datos.duracionConsulta ?? null,
          datos.costoConsulta ?? null,
          datos.requiereCita,
          datos.observaciones ?? null,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoEspecialidad: resultado.rows[0].codigoespecialidad,
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
    codigoEspecialidad: number,
    datos: {
      nombreEspecialidad: string,
    descripcion: string | null,
    areaMedica: string | null,
    duracionConsulta: number | null,
    costoConsulta: number | null,
    requiereCita: boolean,
    observaciones: string | null,
    estado: string;
    },
  ) {
    try {
      if (!Number.isInteger(codigoEspecialidad) || codigoEspecialidad <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      if (
        !datos.nombreEspecialidad ||
        (datos.requiereCita === undefined || datos.requiereCita === null) ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Especialidades_Editar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9
        );
      `,
        [
          codigoEspecialidad,
          datos.nombreEspecialidad,
          datos.descripcion ?? null,
          datos.areaMedica ?? null,
          datos.duracionConsulta ?? null,
          datos.costoConsulta ?? null,
          datos.requiereCita,
          datos.observaciones ?? null,
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

  async eliminar(codigoEspecialidad: number) {
    try {
      if (!Number.isInteger(codigoEspecialidad) || codigoEspecialidad <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_Especialidades_Eliminar($1);`,
        [codigoEspecialidad],
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
