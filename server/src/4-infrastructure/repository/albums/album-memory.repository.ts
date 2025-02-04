import { Injectable } from '@nestjs/common';
import { Album, AlbumMemory, Memory, PrismaClient } from '@prisma/client';
import { ITXClientDenyList } from '@prisma/client/runtime/library';
import { PrismaService } from 'src/lib/database/prisma.service';
import { MemoryFileType } from 'src/lib/enums/memory-file-type.enum';

@Injectable()
export class AlbumMemoryRepository {
  constructor(private readonly prismaService: PrismaService) {}

  /**
   * 앨범에 추억을 추가
   */
  async create(dto: CreateDto): Promise<void> {
    await this.prismaService.albumMemory.create({
      data: {
        albumId: dto.album.id,
        memoryId: dto.memory.id,
      },
    });
  }

  /**
   * 앨범별 추억 개수를 조회합니다.
   */
  async countByAlbumIds(dto: CountByAlbumIdsDto) {
    return await this.prismaService.albumMemory.groupBy({
      by: ['albumId'],
      where: {
        albumId: {
          in: dto.albumIds,
        },
      },
      _count: {
        _all: true,
      },
    });
  }

  async findLastMemoryByAlbumIds(dto: FindLastMemoryByAlbumIdsDto) {
    return await this.prismaService.albumMemory.findMany({
      include: {
        Memory: {
          include: {
            MemoryFile: {
              where: {
                type: MemoryFileType.IMAGE,
              },
              take: 1,
            },
          },
        },
      },
      distinct: ['albumId'],
      where: {
        albumId: {
          in: dto.albumIds,
        },
      },
      orderBy: {
        id: 'desc',
      },
    });
  }

  async deleteByAlbumId(dto: DeleteByAlbumIdDto): Promise<void> {
    await dto.tx.albumMemory.deleteMany({
      where: {
        albumId: dto.albumId,
      },
    });
  }

  /**
   * 앨범에 추가된 추억 조회
   */
  async findUnique(dto: FindUniqueDto): Promise<AlbumMemory | null> {
    return await this.prismaService.albumMemory.findFirst({
      where: {
        albumId: dto.albumId,
        memoryId: dto.memoryId,
      },
    });
  }

  /**
   * 앨범에서 추억 삭제
   */
  async delete(dto: DeleteDto): Promise<void> {
    await this.prismaService.albumMemory.delete({
      where: {
        id: dto.albumMemory.id,
      },
    });
  }

  /**
   * 추억 id로 앨범에서 추억 삭제
   */
  async deleteByMemoryId(dto: DeleteByMemoryIdDto): Promise<void> {
    await this.prismaService.albumMemory.deleteMany({
      where: {
        memoryId: dto.memoryId,
      },
    });
  }

  /**
   * 앨범내의 추억 ids의 개수를 조회합니다.
   */
  async countByMemoryIds(dto: CountByMemoryIdsDto): Promise<number> {
    return await this.prismaService.albumMemory.count({
      where: {
        albumId: dto.album.id,
        memoryId: {
          in: dto.memories.map((memory) => memory.id),
        },
      },
    });
  }
}

type CreateDto = {
  album: Album;
  memory: Memory;
};

type CountByAlbumIdsDto = {
  albumIds: number[];
};

type FindLastMemoryByAlbumIdsDto = {
  albumIds: number[];
};

type DeleteByAlbumIdDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  albumId: number;
};

type FindUniqueDto = {
  albumId: number;
  memoryId: number;
};

type DeleteDto = {
  albumMemory: AlbumMemory;
};

type DeleteByMemoryIdDto = {
  memoryId: number;
};

type CountByMemoryIdsDto = {
  album: Album;
  memories: Memory[];
};
