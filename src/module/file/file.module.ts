import { Module } from '@nestjs/common';
import { FileService } from 'src/3-domain/service/file/file.service';
import { StorageClient } from 'src/4-infrastructure/client/storage/storage.client';

@Module({
  providers: [FileService, StorageClient],
  exports: [FileService],
})
export class FileModule {}
