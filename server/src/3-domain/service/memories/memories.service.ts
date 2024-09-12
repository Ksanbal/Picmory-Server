import { Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MemoryFile, MemoryFileType } from '@prisma/client';
import { MemoryFileRepository } from 'src/4-infrastructure/repository/memories/memory-file.repository';

@Injectable()
export class MemoriesService {
  constructor(
    private readonly memoryFileRepository: MemoryFileRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  /**
   * 파일 업로드
   */
  async upload(dto: UploadDto): Promise<MemoryFile> {
    const { sub, file } = dto;

    const type = file.mimetype.includes('image')
      ? MemoryFileType.IMAGE
      : MemoryFileType.VIDEO;

    // 파일 정보 저장
    const newFile = await this.memoryFileRepository.create({
      memberId: sub,
      type,
      originalName: file.originalname,
      size: file.size,
      path: file.path,
    });

    // 파일 생성 이벤트 발행
    // this.eventEmitter.emit(EVENT_NAMES.MEMORIES_FILE_CREATED, newFile);

    return newFile;
  }
}

type UploadDto = {
  sub: number;
  file: Express.Multer.File;
};
