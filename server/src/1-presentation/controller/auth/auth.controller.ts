import { Body, Controller, Get, Post } from '@nestjs/common';
import { plainToClass } from 'class-transformer';
import { AuthSigninReqDto } from 'src/1-presentation/dto/auth/request/signin.dto';
import { SigninResDto } from 'src/1-presentation/dto/auth/response/signin.dto';
import { AuthFacade } from 'src/2-application/facade/auth/auth.facade';

@Controller('auth')
export class AuthController {
  constructor(private readonly authFacade: AuthFacade) {}
  // [x] 로그인
  @Post('signin')
  async signin(@Body() body: AuthSigninReqDto): Promise<SigninResDto> {
    return plainToClass(SigninResDto, await this.authFacade.signin(body));
  }

  // [ ] 로그아웃
  @Post('signout')
  signout() {}

  // [ ] 토큰 유효성 검사
  @Get('validate')
  validate() {}

  // [ ] 토큰 갱신
  @Post('refresh')
  refresh() {}
}
