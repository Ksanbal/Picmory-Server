import { Module } from '@nestjs/common';
import { FileService } from 'src/3-domain/service/file/file.service';

@Module({
  providers: [FileService],
  exports: [FileService],
})
export class FileModule {}
