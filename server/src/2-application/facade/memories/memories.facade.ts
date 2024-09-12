import { Injectable } from '@nestjs/common';
import { MemoryFile } from '@prisma/client';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';

@Injectable()
export class MemoriesFacade {
  constructor(private readonly memoriesService: MemoriesService) {}

  /**
   * 파일 업로드
   */
  async upload(dto: UploadDto): Promise<MemoryFile> {
    return await this.memoriesService.upload(dto);
  }
}

type UploadDto = {
  sub: number;
  file: Express.Multer.File;
};
