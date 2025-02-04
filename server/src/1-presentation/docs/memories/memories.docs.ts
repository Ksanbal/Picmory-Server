import { applyDecorators } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { MemioresCreateUploadUrlReqDto } from 'src/1-presentation/dto/memories/request/get-upload-url.dto';
import { MemoriesCreateResDto } from 'src/1-presentation/dto/memories/response/create.dto';
import { MemoriesListResDto } from 'src/1-presentation/dto/memories/response/list.dto';
import { MemoriesRetrieveResDto } from 'src/1-presentation/dto/memories/response/retrieve.dto';
import { MemoriesUploadResDto } from 'src/1-presentation/dto/memories/response/upload.dto';
import { MemoryFileType } from 'src/lib/enums/memory-file-type.enum';

export function MemoriesControllerDocs() {
  return applyDecorators(
    ApiTags('Memories 추억'),
    ApiBearerAuth(),
    ApiUnauthorizedResponse(),
    ApiForbiddenResponse(),
  );
}

export function UploadDocs() {
  return applyDecorators(
    ApiOperation({ summary: '파일 업로드' }),
    ApiConsumes('multipart/form-data'),
    ApiBody({
      schema: {
        type: 'object',
        properties: {
          file: {
            type: 'string',
            format: 'binary',
          },
          type: {
            type: 'string',
            enum: Object.values(MemoryFileType),
          },
        },
        required: ['file', 'type'],
      },
    }),
    ApiCreatedResponse({
      type: MemoriesUploadResDto,
    }),
    ApiBadRequestResponse(),
  );
}

export function CreateUploadUrlDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '파일 업로드 URL 생성',
    }),
    ApiCreatedResponse({
      type: MemioresCreateUploadUrlReqDto,
    }),
    ApiBadRequestResponse(),
  );
}

export function CreateDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '추억 생성',
    }),
    ApiCreatedResponse({
      type: MemoriesCreateResDto,
    }),
    ApiBadRequestResponse(),
  );
}

export function ListDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '추억 목록 조회',
    }),
    ApiOkResponse({
      type: [MemoriesListResDto],
    }),
  );
}

export function RetrieveDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '추억 상세 조회',
    }),
    ApiOkResponse({
      type: MemoriesRetrieveResDto,
    }),
    ApiNotFoundResponse(),
  );
}

export function UpdateDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '추억 수정',
    }),
    ApiBadRequestResponse(),
    ApiNotFoundResponse(),
  );
}

export function DeleteDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '추억 삭제',
    }),
    ApiNotFoundResponse(),
  );
}
