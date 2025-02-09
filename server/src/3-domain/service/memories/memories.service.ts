import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { Memory, MemoryFile, PrismaClient } from '@prisma/client';
import { ITXClientDenyList } from '@prisma/client/runtime/library';
import * as dayjs from 'dayjs';
import { UploadUrlModel } from 'src/3-domain/model/memories/upload-url.model';
import { StorageClient } from 'src/4-infrastructure/client/storage/storage.client';
import { MemoryFileRepository } from 'src/4-infrastructure/repository/memories/memory-file.repository';
import { MemoryRepository } from 'src/4-infrastructure/repository/memories/memory.repository';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { EVENT_NAMES } from 'src/lib/constants/event-names';
import { MemoryFileType } from 'src/lib/enums/memory-file-type.enum';

@Injectable()
export class MemoriesService {
  constructor(
    private readonly memoryFileRepository: MemoryFileRepository,
    private readonly memoryRepository: MemoryRepository,
    private readonly eventEmitter: EventEmitter2,
    private readonly storageClient: StorageClient,
  ) {}

  /**
   * 파일 업로드
   */
  async upload(dto: UploadDto): Promise<MemoryFile> {
    const { sub, file, type } = dto;

    // 파일 정보 저장
    const newFile = await this.memoryFileRepository.create({
      memberId: sub,
      type,
      originalName: file.originalname,
      size: file.size,
      path: file.path,
    });

    // 파일 생성 이벤트 발행
    this.eventEmitter.emit(EVENT_NAMES.MEMORIES_FILE_CREATED, {
      memoryFile: newFile,
    });

    return newFile;
  }

  /**
   * 파일 업로드 URL 생성
   */
  async createUploadUrl(dto: GetUploadDto): Promise<UploadUrlModel> {
    const { sub, filename } = dto;

    // 파일 경로명
    const now = dayjs();
    const key = `uploads/${sub}/${now.year()}/${now.month() + 1}/${now.date()}/${filename}`;

    // 파일 타입
    let contentType = '';
    switch (filename.split('.').pop().toLowerCase()) {
      case 'png':
        contentType = 'image/png';
        break;
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'mp4':
        contentType = 'video/mp4';
        break;
      case 'mov':
        contentType = 'video/quicktime';
        break;
      default:
        throw new BadRequestException(
          ERROR_MESSAGES.MEMORIES_INVALID_FILE_TYPE,
        );
    }

    const url = await this.storageClient.generatePresignedUrl({
      key,
      contentType,
      expiresIn: 3600, // 1시간 동안 유효한 링크 생성
    });

    return {
      url,
      key,
    };
  }

  /**
   * 파일 생성
   */
  async createMemoryFiles(dto: CreateMemoryFiles) {
    const { tx, fileKeys, memberId, memoryId } = dto;

    // 파일 정보 저장
    await this.memoryFileRepository.createMany({
      tx,
      memories: fileKeys.map((key) => {
        let type = MemoryFileType.IMAGE;
        const ext = key.split('.').pop().toLowerCase();
        if (ext == 'mp4' || ext == 'mov') {
          type = MemoryFileType.VIDEO;
        }

        return {
          memberId,
          memoryId,
          type,
          originalName: key.split('/').pop() as string,
          path: key,
        };
      }),
    });
  }

  /**
   * 파일 정보 업데이트
   */
  async updateMemoryFileThumbnailPath(
    dto: UpdateMemoryFileThumbnailPathDto,
  ): Promise<void> {
    await this.memoryFileRepository.updateWithId({
      id: dto.memoryFile.id,
      data: {
        thumbnailPath: dto.memoryFile.thumbnailPath,
      },
    });
  }

  /**
   * 유효한 파일 아이디인지 확인
   */
  async validateFileIds(dto: ValidateFileIdsDto): Promise<void> {
    const { memberId, ids } = dto;

    const files = await this.memoryFileRepository.findAllByIds({
      memberId,
      ids,
    });

    if (files.length !== ids.length) {
      throw new BadRequestException(ERROR_MESSAGES.MEMORIES_INVALID_FILE_IDS);
    }
  }

  /**
   * 기억 생성
   */
  async create(dto: CreateDto): Promise<Memory> {
    const { tx, memberId, brandName, date } = dto;

    const newMemory = await this.memoryRepository.create({
      tx,
      memberId,
      brandName,
      date,
    });

    if (newMemory == null) {
      throw new BadRequestException(ERROR_MESSAGES.MEMORIES_FAILED_CREATE);
    }

    return newMemory;
  }

  /**
   * linkMemoryFiles
   */
  async linkMemoryFiles(dto: LinkMemoryFilesDto): Promise<void> {
    const { tx, fileIds, memoryId } = dto;

    await this.memoryFileRepository.linkManyToMemory({
      tx,
      fileIds,
      memoryId,
    });
  }

  /**
   * 기억 목록 조회
   */
  async list(dto: ListDto) {
    const { memberId, like, albumId, page, limit } = dto;

    let memories: (Memory & { MemoryFile: MemoryFile[] })[] = [];
    if (albumId) {
      memories = await this.memoryRepository.findAllInAlbum({
        memberId,
        albumId,
        page,
        limit,
      });
    } else {
      memories = await this.memoryRepository.findAll({
        memberId,
        like,
        page,
        limit,
      });
    }

    return memories;
  }

  /**
   * 기억 상세 조회
   */
  async retrieve(
    dto: RetrieveDto,
  ): Promise<Memory & { MemoryFile: MemoryFile[] }> {
    const memory = await this.memoryRepository.findById({
      memberId: dto.memberId,
      id: dto.id,
    });

    if (memory == null) {
      throw new NotFoundException(ERROR_MESSAGES.MEMORIES_NOT_FOUND);
    }

    return memory;
  }

  /**
   * 기억 수정
   */
  async update(dto: UpdateDto) {
    const memory = await this.memoryRepository.findById({
      memberId: dto.memberId,
      id: dto.id,
    });

    if (memory == null) {
      throw new NotFoundException(ERROR_MESSAGES.MEMORIES_NOT_FOUND);
    }

    Object.assign(memory, dto.data);
    delete memory.MemoryFile;

    await this.memoryRepository.update({
      memory,
    });
  }

  /**
   * 기억 삭제
   */
  async delete(dto: DeleteDto): Promise<void> {
    const { tx, memory } = dto;

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { MemoryFile, ...memoryOnly } = memory;

    // 기억 삭제
    await this.memoryRepository.delete({
      tx,
      memory: memoryOnly,
    });

    // 기억 파일 삭제
    await this.memoryFileRepository.deleteManyByMemoryId({
      tx,
      memoryId: memory.id,
    });
  }
}

type UploadDto = {
  sub: number;
  file: Express.Multer.File;
  type: MemoryFileType;
};

type GetUploadDto = {
  sub: number;
  filename: string;
};

type CreateMemoryFiles = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  fileKeys: string[];
  memberId: number;
  memoryId: number;
};

type UpdateMemoryFileThumbnailPathDto = {
  memoryFile: MemoryFile;
};

type ValidateFileIdsDto = {
  memberId: number;
  ids: number[];
};

type CreateDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  memberId: number;
  brandName: string;
  date: Date;
};

type LinkMemoryFilesDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  fileIds: number[];
  memoryId: number;
};

type ListDto = {
  memberId: number;
  like: boolean;
  albumId: number;

  page: number;
  limit: number;
};

type RetrieveDto = {
  memberId: number;
  id: number;
};

type UpdateDto = {
  memberId: number;
  id: number;
  data: {
    brandName: string | null;
    date: Date | null;
    like: boolean | null;
  };
};

type DeleteDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  memory: Memory & { MemoryFile: MemoryFile[] };
};
