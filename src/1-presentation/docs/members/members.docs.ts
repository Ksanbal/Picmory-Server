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
import { MembersGetMeResDto } from 'src/1-presentation/dto/members/response/get-me.dto';

export function MembersControllerDocs() {
  return applyDecorators(ApiTags('Members 회원'));
}

export function RegisterDocs() {
  return applyDecorators(
    ApiOperation({ summary: '회원가입' }),
    ApiCreatedResponse(),
    ApiBadRequestResponse(),
  );
}

export function GetMeDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '내 정보 조회',
    }),
    ApiBearerAuth(),
    ApiOkResponse({
      type: MembersGetMeResDto,
    }),
    ApiUnauthorizedResponse(),
    ApiForbiddenResponse(),
    ApiNotFoundResponse(),
  );
}

export function DeleteMeDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '회원탈퇴',
    }),
    ApiBearerAuth(),
    ApiOkResponse(),
    ApiUnauthorizedResponse(),
    ApiForbiddenResponse(),
    ApiNotFoundResponse(),
  );
}
