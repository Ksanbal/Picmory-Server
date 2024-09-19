import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
import { AblumsAddMemoriesReqDto } from 'src/1-presentation/dto/albums/request/add-memories.dto';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { AlbumsUpdateReqDto } from 'src/1-presentation/dto/albums/request/update.dto';
import { PaginationDto } from 'src/1-presentation/dto/common/pagination.dto';
import { AlbumForListModel } from 'src/3-domain/model/albums/album-for-list.model';
import { AlbumsService } from 'src/3-domain/service/albums/albums.service';
import { MemoriesService } from 'src/3-domain/service/memories/memories.service';

@Injectable()
export class AlbumsFacade {
  constructor(
    private readonly albumsService: AlbumsService,
    private readonly memoriesService: MemoriesService,
  ) {}

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

  // [x] 삭제
  async delete(dto: DeleteDto): Promise<void> {
    return await this.albumsService.delete({
      memberId: dto.memberId,
      id: dto.id,
    });
  }

  // [x] 앨범에 추억 추가
  async addMemories(dto: AddMemoriesDto): Promise<void> {
    const { memberId, albumId, body } = dto;

    // 앨범 조회
    const album = await this.albumsService.retrieve({
      memberId,
      id: albumId,
    });

    // 메모리 목록 조회
    const memories = await this.memoriesService.listByIds({
      memberId,
      ids: body.ids,
    });

    // 앨범에 메모리 추가
    return await this.albumsService.addMemories({
      album,
      memories,
    });
  }

  // [x] 앨범에서 추억 삭제
  async deleteMemory(dto: DeleteMemoriesDto): Promise<void> {
    const { memberId, albumId, memoryId } = dto;

    // 앨범에서 메모리 삭제
    return await this.albumsService.deleteMemoriesFromAlbum({
      memberId,
      albumId,
      memoryId,
    });
  }
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

type DeleteDto = {
  memberId: number;
  id: number;
};

type AddMemoriesDto = {
  memberId: number;
  albumId: number;
  body: AblumsAddMemoriesReqDto;
};

type DeleteMemoriesDto = {
  memberId: number;
  albumId: number;
  memoryId: number;
};
