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
import { AblumsAddMemoriesReqDto } from 'src/1-presentation/dto/albums/request/add-memories.dto';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { AlbumsUpdateReqDto } from 'src/1-presentation/dto/albums/request/update.dto';
import { AlbumsCreateResDto } from 'src/1-presentation/dto/albums/response/create.dto';
import { AlbumsListResDto } from 'src/1-presentation/dto/albums/response/list.dto';
import { PaginationDto } from 'src/1-presentation/dto/common/pagination.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { AlbumsFacade } from 'src/2-application/facade/albums/albums.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@Controller('albums')
@UseGuards(JwtAuthGuard)
export class AlbumsController {
  constructor(private readonly albumsFacade: AlbumsFacade) {}

  // [x] 생성
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

  // [x] 수정
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
  @Post(':id/memories')
  async addMemories(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
    @Body() body: AblumsAddMemoriesReqDto,
  ) {
    return await this.albumsFacade.addMemories({
      memberId: sub,
      albumId: id,
      body,
    });
  }

  // [x] 앨범에서 추억 삭제
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
