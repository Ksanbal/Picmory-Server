import { Injectable } from '@nestjs/common';
import { Album } from '@prisma/client';
import { AlbumForListModel } from 'src/3-domain/model/albums/album-for-list.model';
import { AlbumRepository } from 'src/4-infrastructure/repository/albums/album.repository';
import { AlbumsOnMemoryRepository } from 'src/4-infrastructure/repository/albums/albums-on-memory.repository';

@Injectable()
export class AlbumsService {
  constructor(
    private readonly albumRepository: AlbumRepository,
    private readonly albumsOnMemoryRepository: AlbumsOnMemoryRepository,
  ) {}

  // [x] 생성
  async create(dto: CreateDto): Promise<Album> {
    return await this.albumRepository.create({
      memberId: dto.memberId,
      name: dto.name,
    });
  }

  // [x] 목록 조회
  async list(dto: ListDto): Promise<AlbumForListModel[]> {
    // 추억이 추가된 순서로 앨범 목록 조회
    const albums = await this.albumRepository.findAllByMemberId({
      memberId: dto.memberId,
      page: dto.page,
      limit: dto.limit,
    });

    const albumIds = albums.map((album) => album.id);

    // 각 앨범별 추억 개수 조회
    const memoryCountsByAlbum =
      await this.albumsOnMemoryRepository.countByAlbumIds({
        albumIds,
      });

    // 각 앨범별 대표 추억 조회
    const memoriesByAlbum =
      await this.albumsOnMemoryRepository.findLastMemoryByAlbumIds({
        albumIds,
      });

    const result = albums.map((album) => {
      return {
        ...album,
        memoryCount:
          memoryCountsByAlbum.find(
            (memoryCount) => memoryCount.albumId === album.id,
          )?._count._all ?? 0,
        lastMemoryFile:
          memoriesByAlbum.find((memory) => memory.albumId === album.id)?.Memory
            .MemoryFile[0] ?? null,
      };
    });

    return result;
  }

  // [ ] 수정
  // [ ] 삭제
  // [ ] 앨범에 추억 추가
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
