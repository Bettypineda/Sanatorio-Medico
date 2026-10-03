import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
} from '@nestjs/common';
import { DatabaseService } from '../database/database.service.js';

const COLUMNAS_PACIENTES = `
  codigopaciente      AS "codigoPaciente",
  numeroexpediente    AS "numeroExpediente",
  tipodocumento       AS "tipoDocumento",
  numerodocumento     AS "numeroDocumento",
  nombres             AS "nombres",
  apellidos           AS "apellidos",
  fechanacimiento     AS "fechaNacimiento",
  genero              AS "genero",
  tiposangre          AS "tipoSangre",
  telefono            AS "telefono",
  correoelectronico   AS "correoElectronico",
  direccion           AS "direccion",
  contactoemergencia  AS "contactoEmergencia",
  telefonoemergencia  AS "telefonoEmergencia",
  alergias            AS "alergias",
  estado              AS "estado"
`;

@Injectable()
export class PacientesService {
  constructor(private readonly databaseService: DatabaseService) {}

  async consultar() {
    try {
      const resultado = await this.databaseService.query(`
        SELECT ${COLUMNAS_PACIENTES}
        FROM Usp_Pacientes_Consultar();
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

  async buscar(codigoPaciente: number) {
    try {
      if (!Number.isInteger(codigoPaciente) || codigoPaciente <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `
        SELECT ${COLUMNAS_PACIENTES}
        FROM Usp_Pacientes_Buscar($1);
      `,
        [codigoPaciente],
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
    numeroExpediente: string,
    tipoDocumento: string,
    numeroDocumento: string,
    nombres: string,
    apellidos: string,
    fechaNacimiento: string,
    genero: string,
    tipoSangre: string | null,
    telefono: string,
    correoElectronico: string | null,
    direccion: string,
    contactoEmergencia: string | null,
    telefonoEmergencia: string | null,
    alergias: string | null,
    estado: string;
  }) {
    try {
      if (
        !datos.numeroExpediente ||
        !datos.tipoDocumento ||
        !datos.numeroDocumento ||
        !datos.nombres ||
        !datos.apellidos ||
        !datos.fechaNacimiento ||
        !datos.genero ||
        !datos.telefono ||
        !datos.direccion ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Pacientes_Agregar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
        );
      `,
        [
          datos.numeroExpediente,
          datos.tipoDocumento,
          datos.numeroDocumento,
          datos.nombres,
          datos.apellidos,
          datos.fechaNacimiento,
          datos.genero,
          datos.tipoSangre ?? null,
          datos.telefono,
          datos.correoElectronico ?? null,
          datos.direccion,
          datos.contactoEmergencia ?? null,
          datos.telefonoEmergencia ?? null,
          datos.alergias ?? null,
          datos.estado
        ],
      );
      return {
        exito: resultado.rows[0].exito,
        mensaje: resultado.rows[0].mensaje,
        codigoPaciente: resultado.rows[0].codigopaciente,
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
    codigoPaciente: number,
    datos: {
      numeroExpediente: string,
    tipoDocumento: string,
    numeroDocumento: string,
    nombres: string,
    apellidos: string,
    fechaNacimiento: string,
    genero: string,
    tipoSangre: string | null,
    telefono: string,
    correoElectronico: string | null,
    direccion: string,
    contactoEmergencia: string | null,
    telefonoEmergencia: string | null,
    alergias: string | null,
    estado: string;
    },
  ) {
    try {
      if (!Number.isInteger(codigoPaciente) || codigoPaciente <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      if (
        !datos.numeroExpediente ||
        !datos.tipoDocumento ||
        !datos.numeroDocumento ||
        !datos.nombres ||
        !datos.apellidos ||
        !datos.fechaNacimiento ||
        !datos.genero ||
        !datos.telefono ||
        !datos.direccion ||
        !datos.estado
      ) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'Debe ingresar todos los datos obligatorios.',
        });
      }

      const resultado = await this.databaseService.query(
        `
        SELECT * FROM Usp_Pacientes_Editar(
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16
        );
      `,
        [
          codigoPaciente,
          datos.numeroExpediente,
          datos.tipoDocumento,
          datos.numeroDocumento,
          datos.nombres,
          datos.apellidos,
          datos.fechaNacimiento,
          datos.genero,
          datos.tipoSangre ?? null,
          datos.telefono,
          datos.correoElectronico ?? null,
          datos.direccion,
          datos.contactoEmergencia ?? null,
          datos.telefonoEmergencia ?? null,
          datos.alergias ?? null,
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

  async eliminar(codigoPaciente: number) {
    try {
      if (!Number.isInteger(codigoPaciente) || codigoPaciente <= 0) {
        throw new BadRequestException({
          exito: 0,
          mensaje: 'El código debe ser un número entero mayor que cero.',
        });
      }
      const resultado = await this.databaseService.query(
        `SELECT * FROM Usp_Pacientes_Eliminar($1);`,
        [codigoPaciente],
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
