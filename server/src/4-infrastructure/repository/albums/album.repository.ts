import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
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
      },
      orderBy: {
        lastAddAt: 'desc',
      },
      take: dto.limit,
      skip: (dto.page - 1) * dto.limit,
    });
  }

  // [ ] 단일 조회
  // [ ] 수정
  // [ ] 삭제
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
