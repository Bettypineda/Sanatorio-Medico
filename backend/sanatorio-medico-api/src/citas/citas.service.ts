import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

const COLUMNAS_CITASCONSULTAS = `
  codigocitaconsulta  AS "codigoCitaConsulta",
  codigopaciente      AS "codigoPaciente",
  codigocolaborador   AS "codigoColaborador",
  codigosucursal      AS "codigoSucursal",
  codigoespecialidad  AS "codigoEspecialidad",
  fechahoracita       AS "fechaHoraCita",
  tipoatencion        AS "tipoAtencion",
  motivoconsulta      AS "motivoConsulta",
  sintomas            AS "sintomas",
  observacionesmedicas AS "observacionesMedicas",
  tratamientogeneral  AS "tratamientoGeneral",
  presionarterial     AS "presionArterial",
  temperatura         AS "temperatura",
  peso                AS "peso",
  estado              AS "estado"
`;

@Injectable()
export class CitasConsultasService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT ${COLUMNAS_CITASCONSULTAS}
        FROM Usp_CitasConsultas_Consultar();
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

  async buscar(codigoCitaConsulta: number) {
    try {
      if (!Number.isInteger(codigoCitaConsulta) || codigoCitaConsulta <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `
        SELECT ${COLUMNAS_CITASCONSULTAS}
        FROM Usp_CitasConsultas_Buscar($1);
      `,
        [codigoCitaConsulta],
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
    codigoPaciente: number,
    codigoColaborador: number,
    codigoSucursal: number,
    codigoEspecialidad: number,
    fechaHoraCita: string,
    tipoAtencion: string,
    motivoConsulta: string,
    sintomas: string | null,
    observacionesMedicas: string | null,
    tratamientoGeneral: string | null,
    presionArterial: string | null,
    temperatura: number | null,
    peso: number | null,
    estado: string;
  }) {
    try {
      if (
        !datos.codigoPaciente ||
        !datos.codigoColaborador ||
        !datos.codigoSucursal ||
        !datos.codigoEspecialidad ||
        !datos.fechaHoraCita ||
        !datos.tipoAtencion ||
        !datos.motivoConsulta ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_CitasConsultas_Agregar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
        );
      `,
        [
          datos.codigoPaciente,
          datos.codigoColaborador,
          datos.codigoSucursal,
          datos.codigoEspecialidad,
          datos.fechaHoraCita,
          datos.tipoAtencion,
          datos.motivoConsulta,
          datos.sintomas ?? null,
          datos.observacionesMedicas ?? null,
          datos.tratamientoGeneral ?? null,
          datos.presionArterial ?? null,
          datos.temperatura ?? null,
          datos.peso ?? null,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoCitaConsulta: resultado.rows[0].codigocitaconsulta,
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
    codigoCitaConsulta: number,
    datos: {
      codigoPaciente: number,
    codigoColaborador: number,
    codigoSucursal: number,
    codigoEspecialidad: number,
    fechaHoraCita: string,
    tipoAtencion: string,
    motivoConsulta: string,
    sintomas: string | null,
    observacionesMedicas: string | null,
    tratamientoGeneral: string | null,
    presionArterial: string | null,
    temperatura: number | null,
    peso: number | null,
    estado: string;
    },
  ) {
    try {
      if (!Number.isInteger(codigoCitaConsulta) || codigoCitaConsulta <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      if (
        !datos.codigoPaciente ||
        !datos.codigoColaborador ||
        !datos.codigoSucursal ||
        !datos.codigoEspecialidad ||
        !datos.fechaHoraCita ||
        !datos.tipoAtencion ||
        !datos.motivoConsulta ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_CitasConsultas_Editar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
        );
      `,
        [
          codigoCitaConsulta,
          datos.codigoPaciente,
          datos.codigoColaborador,
          datos.codigoSucursal,
          datos.codigoEspecialidad,
          datos.fechaHoraCita,
          datos.tipoAtencion,
          datos.motivoConsulta,
          datos.sintomas ?? null,
          datos.observacionesMedicas ?? null,
          datos.tratamientoGeneral ?? null,
          datos.presionArterial ?? null,
          datos.temperatura ?? null,
          datos.peso ?? null,
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

  async eliminar(codigoCitaConsulta: number) {
    try {
      if (!Number.isInteger(codigoCitaConsulta) || codigoCitaConsulta <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_CitasConsultas_Eliminar($1);`,
        [codigoCitaConsulta],
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
