import { Injectable } from '@nestjs/common';
import { Album, PrismaClient } from '@prisma/client';
import { ITXClientDenyList } from '@prisma/client/runtime/library';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class AlbumRepository {
  constructor(private readonly prismaService: PrismaService) {}

  // [x] 생성
  async create(dto: CreateDto): Promise<Album> {
    return await this.prismaService.album.create({
      data: {
        memberId: dto.memberId,
        name: dto.name,
      },
    });
  }

  /**
   * lastAddAt desc로 정렬하여 memberId에 해당하는 앨범 목록을 조회합니다.
   */
  async findAllByMemberId(dto: ListDto): Promise<Album[]> {
    return await this.prismaService.album.findMany({
      where: {
        memberId: dto.memberId,
        deletedAt: null,
      },
      orderBy: {
        lastAddAt: 'desc',
      },
      take: dto.limit,
      skip: (dto.page - 1) * dto.limit,
    });
  }

  /**
   * 단일 조회
   */
  async findById(dto: FindByIdDto): Promise<Album | null> {
    return await this.prismaService.album.findUnique({
      where: {
        memberId: dto.memberId,
        id: dto.id,
      },
    });
  }

  /**
   * 수정
   */
  async update(dto: UpdateDto): Promise<Album> {
    return await this.prismaService.album.update({
      where: {
        id: dto.album.id,
      },
      data: {
        ...dto.album,
      },
    });
  }

  /**
   * 삭제
   */
  async delete(dto: DeleteDto): Promise<Album> {
    return await dto.tx.album.update({
      where: {
        id: dto.album.id,
      },
      data: {
        deletedAt: new Date(),
      },
    });
  }
}

type CreateDto = {
  memberId: number;
  name: string;
};

type ListDto = {
  memberId: number;
  page: number;
  limit: number;
};

type FindByIdDto = {
  memberId: number;
  id: number;
};

type UpdateDto = {
  album: Album;
};

type DeleteDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  album: Album;
};
