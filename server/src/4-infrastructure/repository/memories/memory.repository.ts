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
   * ids로 기억 목록 조회
   */
  async findAllByIds(dto: FindAllByIdsDto): Promise<Memory[]> {
    return await this.prismaService.memory.findMany({
      where: {
        id: {
          in: dto.ids,
        },
        memberId: dto.memberId,
        deletedAt: null,
      },
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

  /**
   * 기억 상세 조회
   */
  async findById(
    dto: FindByIdDto,
  ): Promise<(Memory & { MemoryFile: MemoryFile[] }) | null> {
    return await this.prismaService.memory.findFirst({
      include: {
        MemoryFile: true,
      },
      where: {
        id: dto.id,
        memberId: dto.memberId,
        deletedAt: null,
      },
    });
  }

  /**
   * 기억 수정
   */
  async update(dto: UpdateDto): Promise<void> {
    await this.prismaService.memory.update({
      where: {
        id: dto.memory.id,
      },
      data: {
        ...dto.memory,
      },
    });
  }

  /**
   * 기억 삭제
   */
  async delete(dto: DeleteDto): Promise<void> {
    await dto.tx.memory.update({
      where: {
        id: dto.memory.id,
      },
      data: {
        deletedAt: new Date(),
      },
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

type FindAllByIdsDto = {
  memberId: number;
  ids: number[];
};

type FindAllInAlbumDto = {
  memberId: number;
  albumId: number;
  page: number;
  limit: number;
};

type FindByIdDto = {
  memberId: number;
  id: number;
};

type UpdateDto = {
  memory: Memory;
};

type DeleteDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  memory: Memory;
};
