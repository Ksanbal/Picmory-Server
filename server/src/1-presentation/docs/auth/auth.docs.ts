import { applyDecorators } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { RefreshResDto } from 'src/1-presentation/dto/auth/response/refresh.dto';
import { SigninResDto } from 'src/1-presentation/dto/auth/response/signin.dto';

export function AuthControllerDocs() {
  return applyDecorators(ApiTags('Auth 인증'));
}

export function SigninDocs() {
  return applyDecorators(
    ApiOperation({ summary: '로그인' }),
    ApiCreatedResponse({
      type: SigninResDto,
    }),
    ApiBadRequestResponse(),
    ApiNotFoundResponse(),
  );
}

export function SignoutDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '로그아웃',
    }),
    ApiBearerAuth(),
    ApiForbiddenResponse(),
    ApiUnauthorizedResponse(),
    ApiNotFoundResponse(),
  );
}

export function RefreshDocs() {
  return applyDecorators(
    ApiOperation({
      summary: 'refresh토큰으로 access 토큰 갱신',
    }),
    ApiCreatedResponse({
      type: RefreshResDto,
    }),
    ApiUnauthorizedResponse(),
    ApiForbiddenResponse(),
  );
}
