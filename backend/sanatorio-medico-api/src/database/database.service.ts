import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Pool } from 'pg';

@Injectable()
export class DatabaseService implements OnModuleDestroy {
  private readonly pool: Pool;

  constructor(private readonly configService: ConfigService) {
    this.pool = new Pool({
      host: this.configService.get<string>('DB_HOST'),
      port: Number(this.configService.get<string>('DB_PORT')),
      user: this.configService.get<string>('DB_USER'),
      password: this.configService.get<string>('DB_PASSWORD'),
      database: this.configService.get<string>('DB_NAME'),
    });
  }

  async query(text: string, params?: unknown[]) {
    return this.pool.query(text, params);
  }

  async probarConexion(): Promise<boolean> {
    const resultado = await this.pool.query(
      'SELECT NOW() AS fecha_servidor;',
    );

    return resultado.rowCount !== null && resultado.rowCount > 0;
  }

  async onModuleDestroy() {
    await this.pool.end();
  }
}


