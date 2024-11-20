import { BadRequestException, Injectable } from '@nestjs/common';
import { Memory, MemoryFile } from '@prisma/client';
import { MemoriesCreateReqDto } from 'src/1-presentation/dto/memories/request/create.dto';
import { MemoriesListReqDto } from 'src/1-presentation/dto/memories/request/list.dto';
import { MemoriesUpdateReqDto } from 'src/1-presentation/dto/memories/request/update.dto';
import { MemoriesUploadReqDto } from 'src/1-presentation/dto/memories/request/upload.dto';
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
    return await this.memoriesService.upload({
      sub: dto.sub,
      file: dto.file,
      type: dto.body.type,
    });
  }

  /**
   * 썸네일 생성
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<void> {
    const { memoryFile } = dto;

    // 파일을 읽어 썸네일 생성
    const thumbnailPath = await this.fileService.createThumbnail({
      filePath: memoryFile.path,
      type: memoryFile.type,
    });

    if (thumbnailPath == null) {
      return;
    }

    memoryFile.thumbnailPath = thumbnailPath;

    // 파일을 업데이트
    await this.memoriesService.updateMemoryFileThumbnailPath({
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

  /**
   * 상세 조회
   */
  async retrieve(
    dto: RetrieveDto,
  ): Promise<Memory & { MemoryFile: MemoryFile[] }> {
    const { sub, id } = dto;

    return await this.memoriesService.retrieve({
      memberId: sub,
      id,
    });
  }

  /**
   * 수정
   */
  async update(dto: UpdateDto): Promise<void> {
    return await this.memoriesService.update({
      memberId: dto.sub,
      id: dto.id,
      data: {
        brandName: dto.body.brandName,
        date: dto.body.date,
        like: dto.body.like,
      },
    });
  }

  /**
   * 삭제
   */
  async delete(dto: DeleteDto): Promise<void> {
    const { sub, id } = dto;

    const memory = await this.memoriesService.retrieve({
      memberId: sub,
      id,
    });

    await this.prisma.$transaction(async (tx) => {
      // 기억 삭제
      await this.memoriesService.delete({
        tx,
        memory,
      });
    });

    // 기억 파일들 삭제
    const filePaths = [];
    memory.MemoryFile.forEach((file) => {
      filePaths.push(file.path);

      if (file.thumbnailPath != null) {
        filePaths.push(file.thumbnailPath);
      }
    });

    await this.fileService.delete({
      filePaths,
    });
  }
}

type UploadDto = {
  sub: number;
  file: Express.Multer.File;
  body: MemoriesUploadReqDto;
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

type RetrieveDto = {
  sub: number;
  id: number;
};

type UpdateDto = {
  sub: number;
  id: number;
  body: MemoriesUpdateReqDto;
};

type DeleteDto = {
  sub: number;
  id: number;
};
