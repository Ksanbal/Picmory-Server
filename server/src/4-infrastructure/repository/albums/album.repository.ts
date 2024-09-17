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

  // [ ] 목록 조회
  // [ ] 단일 조회
  // [ ] 수정
  // [ ] 삭제
}

type CreateDto = {
  memberId: number;
  name: string;
};
