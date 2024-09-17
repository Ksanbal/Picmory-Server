import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { AlbumsUpdateReqDto } from 'src/1-presentation/dto/albums/request/update.dto';
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

  // [x] 수정
  async update(dto: UpdateDto): Promise<void> {
    return await this.albumsService.update({
      memberId: dto.memberId,
      id: dto.id,
      name: dto.body.name,
    });
  }

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

type UpdateDto = {
  memberId: number;
  id: number;
  body: AlbumsUpdateReqDto;
};
