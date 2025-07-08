import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Post,
  Put,
  Query,
  UseGuards,
} from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import {
  AddMemoriesDocs,
  AlbumsControllerDocs,
  CreateDocs,
  DeleteDocs,
  DeleteMemoriesDocs,
  ListDocs,
  RetrieveDocs,
  UpdateDocs,
} from 'src/1-presentation/docs/albums/albums.docs';
import { AblumsAddMemoriesReqDto } from 'src/1-presentation/dto/albums/request/add-memories.dto';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { AlbumsUpdateReqDto } from 'src/1-presentation/dto/albums/request/update.dto';
import { AlbumsCreateResDto } from 'src/1-presentation/dto/albums/response/create.dto';
import { AlbumsListResDto } from 'src/1-presentation/dto/albums/response/list.dto';
import { AlbumsRetrieveResDto } from 'src/1-presentation/dto/albums/response/retrieve.dto';
import { PaginationDto } from 'src/1-presentation/dto/common/pagination.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { AlbumsFacade } from 'src/2-application/facade/albums/albums.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@AlbumsControllerDocs()
@Controller('albums')
@UseGuards(JwtAuthGuard)
export class AlbumsController {
  constructor(private readonly albumsFacade: AlbumsFacade) {}

  // [x] 생성
  @CreateDocs()
  @Post()
  async create(
    @CurrentUser() sub: number,
    @Body() body: AlbumsCreateReqDto,
  ): Promise<AlbumsCreateResDto> {
    return plainToInstance(
      AlbumsCreateResDto,
      await this.albumsFacade.create({
        memberId: sub,
        body,
      }),
    );
  }

  // [x] 목록 조회
  @ListDocs()
  @Get()
  async list(
    @CurrentUser() sub: number,
    @Query() query: PaginationDto,
  ): Promise<AlbumsListResDto[]> {
    return plainToInstance(
      AlbumsListResDto,
      await this.albumsFacade.list({
        memberId: sub,
        query,
      }),
    );
  }

  // [x] 상세 조회
  @RetrieveDocs()
  @Get(':id')
  async retrieve(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
  ): Promise<AlbumsRetrieveResDto> {
    return plainToInstance(
      AlbumsRetrieveResDto,
      await this.albumsFacade.retrieve({
        memberId: sub,
        id,
      }),
    );
  }

  // [x] 수정
  @UpdateDocs()
  @Put(':id')
  async update(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
    @Body() body: AlbumsUpdateReqDto,
  ): Promise<void> {
    return await this.albumsFacade.update({
      memberId: sub,
      id,
      body,
    });
  }

  // [x] 삭제
  @DeleteDocs()
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async delete(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
  ): Promise<void> {
    return await this.albumsFacade.delete({
      memberId: sub,
      id,
    });
  }

  // [x] 앨범에 추억 추가
  @AddMemoriesDocs()
  @Post(':id/memories')
  async addMemories(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
    @Body() body: AblumsAddMemoriesReqDto,
  ) {
    return await this.albumsFacade.addMemory({
      memberId: sub,
      albumId: id,
      body,
    });
  }

  // [x] 앨범에서 추억 삭제
  @DeleteMemoriesDocs()
  @Delete(':id/memories/:memoryId')
  @HttpCode(HttpStatus.NO_CONTENT)
  async deleteMemory(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
    @Param('memoryId', ParseIntPipe) memoryId: number,
  ) {
    return await this.albumsFacade.deleteMemory({
      memberId: sub,
      albumId: id,
      memoryId,
    });
  }
}
