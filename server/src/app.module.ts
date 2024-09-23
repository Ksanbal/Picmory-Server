import { Module } from '@nestjs/common';
import { AuthModule } from './module/auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { MembersModule } from './module/members/members.module';
import { MemoriesModule } from './module/memories/memories.module';
import { EventEmitterModule } from '@nestjs/event-emitter';
import { FileModule } from './module/file/file.module';
import { AlbumsModule } from './module/albums/albums.module';
import { QrCrawlerModule } from './module/qr-crawler/qr-crawler.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      cache: true,
      isGlobal: true,
    }),
    EventEmitterModule.forRoot(),
    AuthModule,
    MembersModule,
    MemoriesModule,
    FileModule,
    AlbumsModule,
    QrCrawlerModule,
  ],
})
export class AppModule {}
