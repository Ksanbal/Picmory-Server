import { Injectable } from '@nestjs/common';
import { MemoryFile } from '@prisma/client';
import { FileService } from 'src/3-domain/service/file/file.service';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';

@Injectable()
export class MemoriesFacade {
  constructor(
    private readonly memoriesService: MemoriesService,
    private readonly fileService: FileService,
  ) {}

  /**
   * 파일 업로드
   */
  async upload(dto: UploadDto): Promise<MemoryFile> {
    return await this.memoriesService.upload(dto);
  }

  /**
   * 썸네일 생성
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<void> {
    const { memoryFile } = dto;

    // 파일을 읽어 썸네일 생성
    const thumbnailPath = await this.fileService.createThumbnail({
      filePath: memoryFile.path,
    });

    if (thumbnailPath == null) {
      return;
    }

    memoryFile.thumbnailPath = thumbnailPath;

    // 파일을 업데이트
    await this.memoriesService.updateMemoryFile({
      memoryFile,
    });
  }
}

type UploadDto = {
  sub: number;
  file: Express.Multer.File;
};

type CreateThumbnailDto = {
  memoryFile: MemoryFile;
};
