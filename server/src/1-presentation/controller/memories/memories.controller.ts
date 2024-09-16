import {
  Body,
  Controller,
  Delete,
  Get,
  Post,
  Put,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { MemoriesFacade } from 'src/2-application/facade/memories/memories.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';
import * as path from 'path';
import * as fs from 'fs';
import { MemoriesCreateReqDto } from 'src/1-presentation/dto/memories/request/create.dto';
import { MemoriesListReqDto } from 'src/1-presentation/dto/memories/request/list.dto';
import { MemoriesListResDto } from 'src/1-presentation/dto/memories/response/list.dto';
import { plainToInstance } from 'class-transformer';

@Controller('memories')
@UseGuards(JwtAuthGuard)
export class MemoriesController {
  constructor(private readonly memoriesFacade: MemoriesFacade) {}

  // 파일 업로드
  @Post('upload')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: (req, file, cb) => {
          const now = new Date();
          const year = now.getFullYear();
          const month = String(now.getMonth() + 1).padStart(2, '0');
          const day = String(now.getDate()).padStart(2, '0');
          const uploadPath = path.join('uploads', year.toString(), month, day);

          // 디렉토리가 존재하지 않으면 생성
          fs.mkdirSync(uploadPath, { recursive: true });

          cb(null, uploadPath);
        },
        filename: (req, file, cb) => {
          const uniqueSuffix =
            Date.now() + '-' + Math.round(Math.random() * 1e9);
          const ext = path.extname(file.originalname);
          const filename = `${file.fieldname}-${uniqueSuffix}${ext}`;
          cb(null, filename);
        },
      }),
    }),
  )
  async upload(
    @CurrentUser() sub: number,
    @UploadedFile() file: Express.Multer.File,
  ) {
    return await this.memoriesFacade.upload({ sub, file });
  }

  // 생성
  @Post()
  async create(@CurrentUser() sub: number, @Body() body: MemoriesCreateReqDto) {
    return await this.memoriesFacade.create({ sub, body });
  }

  // 목록 조회
  @Get()
  async list(@CurrentUser() sub: number, @Query() query: MemoriesListReqDto) {
    return plainToInstance(
      MemoriesListResDto,
      await this.memoriesFacade.list({ sub, query }),
    );
  }

  // 상세 조회
  @Get(':id')
  async retrieve() {}

  // 수정
  @Put(':id')
  async update() {}

  // 삭제
  @Delete(':id')
  async delete() {}
}
