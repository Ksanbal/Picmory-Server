import { Module } from '@nestjs/common';
import { MemoriesController } from 'src/1-presentation/controller/memories/memories.controller';
import { MemoriesFacade } from 'src/2-application/facade/memories/memories.facade';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';
import { MemoryFileRepository } from 'src/4-infrastructure/repository/memories/memory-file.repository';
import { PrismaService } from 'src/lib/database/prisma.service';
import { FileModule } from '../file/file.module';
import { MemoriesEventHandler } from 'src/1-presentation/event/memories/memories.event';
import { MemoryRepository } from 'src/4-infrastructure/repository/memories/memory.repository';
import { AlbumsService } from 'src/3-domain/service/albums/albums.service';
import { AlbumRepository } from 'src/4-infrastructure/repository/albums/album.repository';
import { AlbumMemoryRepository } from 'src/4-infrastructure/repository/albums/album-memory.repository';
import { StorageClient } from 'src/4-infrastructure/client/storage/storage.client';

@Module({
  imports: [FileModule],
  controllers: [MemoriesController],
  providers: [
    PrismaService,
    MemoriesFacade,
    MemoriesService,
    MemoryFileRepository,
    MemoryRepository,
    MemoriesEventHandler,
    AlbumsService,
    AlbumRepository,
    AlbumMemoryRepository,
    StorageClient,
  ],
  exports: [MemoriesService],
})
export class MemoriesModule {}
