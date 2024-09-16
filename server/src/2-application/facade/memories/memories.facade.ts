import { BadRequestException, Injectable } from '@nestjs/common';
import { Memory, MemoryFile } from '@prisma/client';
import { MemoriesCreateReqDto } from 'src/1-presentation/dto/memories/request/create.dto';
import { MemoriesListReqDto } from 'src/1-presentation/dto/memories/request/list.dto';
import { FileService } from 'src/3-domain/service/file/file.service';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class MemoriesFacade {
  constructor(
    private readonly memoriesService: MemoriesService,
    private readonly fileService: FileService,
    private readonly prisma: PrismaService,
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

  /**
   * 생성
   */
  async create(dto: CreateDto) {
    const { sub, body } = dto;
    const { fileIds, ...data } = body;

    // 유효한 파일들인지 확인
    await this.memoriesService.validateFileIds({
      memberId: sub,
      ids: fileIds,
    });

    try {
      const newMemory = await this.prisma.$transaction(async (tx) => {
        // 기억 생성
        const newMemory = await this.memoriesService.create({
          tx,
          memberId: sub,
          ...data,
        });

        // 파일들 업데이트
        await this.memoriesService.linkMemoryFiles({
          tx,
          fileIds,
          memoryId: newMemory.id,
        });

        return newMemory;
      });

      return newMemory;
    } catch (error) {
      console.error('Error during transaction:', error);
      throw new BadRequestException(ERROR_MESSAGES.MEMORIES_FAILED_CREATE);
    }
  }

  /**
   * 목록 조회
   */
  async list(dto: ListDto): Promise<(Memory & { MemoryFile: MemoryFile[] })[]> {
    const { sub, query } = dto;
    const { like, albumId, page, limit } = query;

    return await this.memoriesService.list({
      memberId: sub,
      like,
      albumId,
      page,
      limit,
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

type CreateDto = {
  sub: number;
  body: MemoriesCreateReqDto;
};

type ListDto = {
  sub: number;
  query: MemoriesListReqDto;
};
