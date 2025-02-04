import { BadRequestException, Injectable } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { Memory, MemoryFile } from '@prisma/client';
import { MemoriesCreateReqDto } from 'src/1-presentation/dto/memories/request/create.dto';
import { MemioresCreateUploadUrlReqDto } from 'src/1-presentation/dto/memories/request/get-upload-url.dto';
import { MemoriesListReqDto } from 'src/1-presentation/dto/memories/request/list.dto';
import { MemoriesUpdateReqDto } from 'src/1-presentation/dto/memories/request/update.dto';
import { MemoriesUploadReqDto } from 'src/1-presentation/dto/memories/request/upload.dto';
import { UploadUrlModel } from 'src/3-domain/model/memories/upload-url.model';
import { AlbumsService } from 'src/3-domain/service/albums/albums.service';
import { FileService } from 'src/3-domain/service/file/file.service';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { EVENT_NAMES } from 'src/lib/constants/event-names';
import { PrismaService } from 'src/lib/database/prisma.service';
import { MemoryFileType } from 'src/lib/enums/memory-file-type.enum';

@Injectable()
export class MemoriesFacade {
  constructor(
    private readonly memoriesService: MemoriesService,
    private readonly albumsService: AlbumsService,
    private readonly fileService: FileService,
    private readonly prisma: PrismaService,
    private readonly eventEmitter: EventEmitter2,
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
   * 파일 업로드 URL 생성
   */
  async createUploadUrl(dto: GetUploadUrlDto): Promise<UploadUrlModel> {
    return await this.memoriesService.createUploadUrl({
      sub: dto.sub,
      filename: dto.body.filename,
    });
  }

  /**
   * 썸네일 생성
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<void> {
    const { memory: newMemory } = dto;

    // 추억 파일 목록 조회
    const memory = await this.memoriesService.retrieve({
      memberId: newMemory.memberId,
      id: newMemory.id,
    });

    // 각 추억 파일의 썸네일 생성
    const thumbnailPathsPromises = memory.MemoryFile.filter(
      (memoryFile) => memoryFile.type == MemoryFileType.IMAGE, // 이미지 파일만 생성하도록 적용
    ).map(async (memoryFile) => {
      const thumbnailPath = await this.fileService.createThumbnail({
        filePath: memoryFile.path,
      });

      // 파일 업데이트
      memoryFile.thumbnailPath = thumbnailPath;
      await this.memoriesService.updateMemoryFileThumbnailPath({
        memoryFile,
      });
    });

    await Promise.all(thumbnailPathsPromises);
  }

  /**
   * 생성
   */
  async create(dto: CreateDto) {
    const { sub, body } = dto;
    const { fileKeys, ...data } = body;

    try {
      const newMemory = await this.prisma.$transaction(async (tx) => {
        // 기억 생성
        const newMemory = await this.memoriesService.create({
          tx,
          memberId: sub,
          ...data,
        });

        // 파일 생성
        await this.memoriesService.createMemoryFiles({
          tx,
          fileKeys,
          memberId: sub,
          memoryId: newMemory.id,
        });

        return newMemory;
      });

      // 추억 생성 이벤트 발생
      this.eventEmitter.emit(EVENT_NAMES.MEMORY_CREATED, {
        memory: newMemory,
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

      // 앨범에 속한 기억 삭제
      await this.albumsService.deleteMemoriesFromAlbumWithMemoryId({
        memoryId: id,
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

type GetUploadUrlDto = {
  sub: number;
  body: MemioresCreateUploadUrlReqDto;
};

type CreateThumbnailDto = {
  memory: Memory;
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
