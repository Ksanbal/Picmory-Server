import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import {
  ClassSerializerInterceptor,
  Logger,
  ValidationPipe,
} from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as expressBasicAuth from 'express-basic-auth';
import { ConfigService } from '@nestjs/config';
import { apiReference } from '@scalar/nestjs-api-reference';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
    }),
  );

  // for response dto
  app.useGlobalInterceptors(
    new ClassSerializerInterceptor(app.get('Reflector'), {
      strategy: 'excludeAll',
      excludeExtraneousValues: true,
    }),
  );

  // Swagger
  app.use(
    [configService.get<string>('DOCS_PATH')],
    expressBasicAuth({
      challenge: true,
      users: {
        [configService.get<string>('DOCS_USER')]:
          configService.get<string>('DOCS_PASSWORD'),
      },
    }),
  );

  app.use(
    configService.get<string>('DOCS_PATH'),
    apiReference({
      spec: {
        content: SwaggerModule.createDocument(
          app,
          new DocumentBuilder()
            .setTitle('Picmory API')
            .setContact(
              'dev.ksanbal',
              'https://github.com/Ksanbal',
              'dev.ksanbal@gmail.com',
            )
            .setVersion('1.0')
            .addBearerAuth()
            .build(),
        ),
      },
    }),
  );

  await app.listen(3000, () => {
    if (process.send) {
      process.send('ready');
      Logger.log(`application is listening on port ${process.env.PORT}...`);
    }
  });

  process.on('SIGINT', () => {
    Logger.error('server closed');
    app.close();
  });
}

bootstrap();
