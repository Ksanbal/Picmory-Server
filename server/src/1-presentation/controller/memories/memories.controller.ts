import {
  BadRequestException,
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
import { MemoriesUploadResDto } from 'src/1-presentation/dto/memories/response/upload.dto';
import { MemoriesCreateResDto } from 'src/1-presentation/dto/memories/response/create.dto';
import { MemoriesRetrieveResDto } from 'src/1-presentation/dto/memories/response/retrieve.dto';
import { MemoriesUpdateReqDto } from 'src/1-presentation/dto/memories/request/update.dto';
import {
  CreateDocs,
  DeleteDocs,
  ListDocs,
  MemoriesControllerDocs,
  RetrieveDocs,
  UpdateDocs,
  UploadDocs,
} from 'src/1-presentation/docs/memories/memories.docs';
import { MemoriesUploadReqDto } from 'src/1-presentation/dto/memories/request/upload.dto';

@MemoriesControllerDocs()
@Controller('memories')
@UseGuards(JwtAuthGuard)
export class MemoriesController {
  constructor(private readonly memoriesFacade: MemoriesFacade) {}

  // 파일 업로드
  @UploadDocs()
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
    @Body() body: MemoriesUploadReqDto,
  ): Promise<MemoriesUploadResDto> {
    if (!file) {
      throw new BadRequestException(['File is required']);
    }

    return plainToInstance(
      MemoriesUploadResDto,
      await this.memoriesFacade.upload({ sub, file, body }),
    );
  }

  // 생성
  @CreateDocs()
  @Post()
  async create(
    @CurrentUser() sub: number,
    @Body() body: MemoriesCreateReqDto,
  ): Promise<MemoriesCreateResDto> {
    return plainToInstance(
      MemoriesCreateResDto,
      await this.memoriesFacade.create({ sub, body }),
    );
  }

  // 목록 조회
  @ListDocs()
  @Get()
  async list(
    @CurrentUser() sub: number,
    @Query() query: MemoriesListReqDto,
  ): Promise<MemoriesListResDto[]> {
    return plainToInstance(
      MemoriesListResDto,
      await this.memoriesFacade.list({ sub, query }),
    );
  }

  // 상세 조회
  @RetrieveDocs()
  @Get(':id')
  async retrieve(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
  ): Promise<MemoriesRetrieveResDto> {
    return plainToInstance(
      MemoriesRetrieveResDto,
      await this.memoriesFacade.retrieve({ sub, id }),
    );
  }

  // 수정
  @UpdateDocs()
  @Put(':id')
  async update(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
    @Body() body: MemoriesUpdateReqDto,
  ): Promise<void> {
    return await this.memoriesFacade.update({ sub, id, body });
  }

  // 삭제
  @DeleteDocs()
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async delete(
    @CurrentUser() sub: number,
    @Param('id', ParseIntPipe) id: number,
  ): Promise<void> {
    return await this.memoriesFacade.delete({ sub, id });
  }
}
