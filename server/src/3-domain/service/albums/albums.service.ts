import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
import { AlbumRepository } from 'src/4-infrastructure/repository/albums/album.repository';

@Injectable()
export class AlbumsService {
  constructor(private readonly albumRepository: AlbumRepository) {}

  // [x] 생성
  async create(dto: CreateDto): Promise<Album> {
    return await this.albumRepository.create({
      memberId: dto.memberId,
      name: dto.name,
    });
  }

  // [ ] 목록 조회
  // [ ] 수정
  // [ ] 삭제
  // [ ] 앨범에 추억 추가
}

type CreateDto = {
  memberId: number;
  name: string;
};
