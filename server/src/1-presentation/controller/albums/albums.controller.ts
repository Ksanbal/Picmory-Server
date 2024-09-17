import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { AlbumsCreateReqDto } from 'src/1-presentation/dto/albums/request/create.dto';
import { AlbumsCreateResDto } from 'src/1-presentation/dto/albums/response/create.dto';
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

  // [ ] 목록 조회
  // [ ] 수정
  // [ ] 삭제
  // [ ] 앨범에 추억 추가
}
