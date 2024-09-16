import { Injectable } from '@nestjs/common';
import { Memory, MemoryFile, PrismaClient } from '@prisma/client';
import { ITXClientDenyList } from '@prisma/client/runtime/library';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class MemoryRepository {
  constructor(private readonly prismaService: PrismaService) {}

  async create(dto: CreateDto): Promise<Memory | null> {
    return await dto.tx.memory.create({
      data: {
        memberId: dto.memberId,
        brandName: dto.brandName,
        date: dto.date,
      },
    });
  }

  /**
   * 기억 목록 조회
   */
  async findAll(
    dto: FindAllDto,
  ): Promise<(Memory & { MemoryFile: MemoryFile[] })[]> {
    return await this.prismaService.memory.findMany({
      include: {
        MemoryFile: true,
      },
      where: {
        memberId: dto.memberId,
        like: dto.like ?? undefined,
        deletedAt: null,
      },
      orderBy: {
        id: 'desc',
      },
      skip: (dto.page - 1) * dto.limit,
      take: dto.limit,
    });
  }

  /**
   * 앨범에 속한 기억 목록 조회
   */
  async findAllInAlbum(
    dto: FindAllInAlbumDto,
  ): Promise<(Memory & { MemoryFile: MemoryFile[] })[]> {
    return await this.prismaService.memory.findMany({
      include: {
        MemoryFile: true,
      },
      where: {
        memberId: dto.memberId,
        deletedAt: null,
        AlbumsOnMemory: {
          some: {
            albumId: dto.albumId,
          },
        },
      },
      orderBy: {
        id: 'desc',
      },
      skip: (dto.page - 1) * dto.limit,
      take: dto.limit,
    });
  }
}

type CreateDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  memberId: number;
  brandName: string;
  date: Date;
};

type FindAllDto = {
  memberId: number;
  like: boolean | null;
  page: number;
  limit: number;
};

type FindAllInAlbumDto = {
  memberId: number;
  albumId: number;
  page: number;
  limit: number;
};
