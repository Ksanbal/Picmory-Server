import { Injectable } from '@nestjs/common';
import { MemoryFileType } from '@prisma/client';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class AlbumsOnMemoryRepository {
  constructor(private readonly prismaService: PrismaService) {}

  /**
   * 앨범별 추억 개수를 조회합니다.
   */
  async countByAlbumIds(dto: CountByAlbumIdsDto) {
    return await this.prismaService.albumsOnMemory.groupBy({
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
    return await this.prismaService.albumsOnMemory.findMany({
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
}

type CountByAlbumIdsDto = {
  albumIds: number[];
};

type FindLastMemoryByAlbumIdsDto = {
  albumIds: number[];
};
