import { Injectable, NotFoundException } from '@nestjs/common';
import { Album, AlbumsOnMemory, Memory } from '@prisma/client';
import { AlbumForListModel } from 'src/3-domain/model/albums/album-for-list.model';
import { AlbumRepository } from 'src/4-infrastructure/repository/albums/album.repository';
import { AlbumsOnMemoryRepository } from 'src/4-infrastructure/repository/albums/albums-on-memory.repository';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class AlbumsService {
  constructor(
    private readonly albumRepository: AlbumRepository,
    private readonly albumsOnMemoryRepository: AlbumsOnMemoryRepository,
    private readonly prismaService: PrismaService,
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

  // [x] 단일 조회
  async retrieve(dto: RetrieveDto): Promise<Album> {
    const { memberId, id } = dto;

    const album = await this.albumRepository.findById({
      memberId,
      id,
    });
    if (album == null) {
      throw new NotFoundException(ERROR_MESSAGES.ALBUMS_NOT_FOUND);
    }

    return album;
  }

  // [x] 수정
  async update(dto: UpdateDto): Promise<void> {
    const { memberId, id, ...data } = dto;

    const album = await this.albumRepository.findById({
      memberId,
      id,
    });

    if (album == null) {
      throw new NotFoundException(ERROR_MESSAGES.ALBUMS_NOT_FOUND);
    }

    Object.assign(album, data);

    await this.albumRepository.update({
      album,
    });
  }

  // [x] 삭제
  async delete(dto: DeleteDto): Promise<void> {
    const { memberId, id } = dto;

    const album = await this.albumRepository.findById({
      memberId,
      id,
    });

    if (album == null) {
      throw new NotFoundException(ERROR_MESSAGES.ALBUMS_NOT_FOUND);
    }

    await this.prismaService.$transaction(async (tx) => {
      // 앨범 삭제
      await this.albumRepository.delete({
        tx,
        album,
      });

      // 앨범에 속한 추억 삭제
      await this.albumsOnMemoryRepository.deleteByAlbumId({
        tx,
        albumId: album.id,
      });
    });
  }

  // [x] 앨범에 추억 추가
  async addMemories(dto: AddMemoriesDto): Promise<void> {
    // 이미 추가된 추억이 있는지 확인
    const count = await this.albumsOnMemoryRepository.countByMemoryIds({
      album: dto.album,
      memories: dto.memories,
    });

    if (count > 0) {
      throw new Error(ERROR_MESSAGES.ALBUMS_ON_MEMORY_ALREADY_EXISTS);
    }

    const albumOnMemories = dto.memories.map((memory) => ({
      albumId: dto.album.id,
      memoryId: memory.id,
    }));

    await this.albumsOnMemoryRepository.createMany(albumOnMemories);

    // 앨범의 추가된 날짜 수정
    dto.album.lastAddAt = new Date();
    await this.albumRepository.update({ album: dto.album });
  }

  // [ ] 앨범에서 추억 조회
  async retrieveMemoryFromAlbum(
    dto: RetrieveMemoryFromAlbumDto,
  ): Promise<AlbumsOnMemory> {
    const { albumId, memoryId } = dto;

    const albumOnMemory = await this.albumsOnMemoryRepository.findUnique({
      albumId,
      memoryId,
    });

    if (albumOnMemory == null) {
      throw new NotFoundException(ERROR_MESSAGES.ALBUMS_ON_MEMORY_NOT_FOUND);
    }

    return albumOnMemory;
  }

  // [x] 앨범에서 추억 삭제
  async deleteMemoriesFromAlbum(
    dto: DeleteMemoriesFromAlbumDto,
  ): Promise<void> {
    const { memberId, albumId, memoryId } = dto;

    const album = await this.retrieve({
      memberId,
      id: albumId,
    });

    const albumOnMemory = await this.albumsOnMemoryRepository.findUnique({
      albumId: album.id,
      memoryId,
    });

    if (albumOnMemory == null) {
      throw new NotFoundException(ERROR_MESSAGES.ALBUMS_ON_MEMORY_NOT_FOUND);
    }

    return await this.albumsOnMemoryRepository.delete({
      albumOnMemory,
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

type RetrieveDto = {
  memberId: number;
  id: number;
};

type UpdateDto = {
  memberId: number;
  id: number;
  name: string;
};

type DeleteDto = {
  memberId: number;
  id: number;
};

type AddMemoriesDto = {
  album: Album;
  memories: Memory[];
};

type RetrieveMemoryFromAlbumDto = {
  albumId: number;
  memoryId: number;
};

type DeleteMemoriesFromAlbumDto = {
  memberId: number;
  albumId: number;
  memoryId: number;
};
