import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { PaginationDto } from 'src/1-presentation/dto/common/pagination.dto';
import { AlbumForListModel } from 'src/3-domain/model/albums/album-for-list.model';
import { AlbumsService } from 'src/3-domain/service/albums/albums.service';

@Injectable()
export class AlbumsFacade {
  constructor(private readonly albumsService: AlbumsService) {}

  // [x] 생성
  async create(dto: CreateDto): Promise<Album> {
    return await this.albumsService.create({
      memberId: dto.memberId,
      name: dto.body.name,
    });
  }

  // [x] 목록 조회
  async list(dto: ListDto): Promise<AlbumForListModel[]> {
    return await this.albumsService.list({
      memberId: dto.memberId,
      page: dto.query.page,
      limit: dto.query.limit,
    });
  }

  // [ ] 수정
  // [ ] 삭제
  // [ ] 앨범에 추억 추가
}

type CreateDto = {
  memberId: number;
  body: AlbumsCreateReqDto;
};

type ListDto = {
  memberId: number;
  query: PaginationDto;
};
