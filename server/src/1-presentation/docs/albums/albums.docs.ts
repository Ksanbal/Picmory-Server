import { applyDecorators } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { AlbumsCreateResDto } from 'src/1-presentation/dto/albums/response/create.dto';
import { AlbumsListResDto } from 'src/1-presentation/dto/albums/response/list.dto';

export function AlbumsControllerDocs() {
  return applyDecorators(
    ApiTags('Albums 앨범'),
    ApiBearerAuth(),
    ApiUnauthorizedResponse(),
    ApiForbiddenResponse(),
  );
}

export function CreateDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범 생성',
    }),
    ApiCreatedResponse({
      type: AlbumsCreateResDto,
    }),
    ApiBadRequestResponse(),
  );
}

export function ListDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범 목록 조회',
    }),
    ApiOkResponse({
      type: [AlbumsListResDto],
    }),
  );
}

export function UpdateDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범 수정',
    }),
    ApiBadRequestResponse(),
    ApiNotFoundResponse(),
  );
}

export function DeleteDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범 삭제',
    }),
  );
}

export function AddMemoriesDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범에 추억 추가',
      description:
        '앨범에 추억을 추가합니다. 이미 추가된 추억은 중복으로 추가되지 않습니다.',
    }),
    ApiBadRequestResponse(),
    ApiNotFoundResponse(),
  );
}

export function DeleteMemoriesDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '앨범에서 추억 삭제',
    }),
    ApiNotFoundResponse(),
  );
}
