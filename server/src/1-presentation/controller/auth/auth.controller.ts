import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { plainToClass } from 'class-transformer';
import { AuthSigninReqDto } from 'src/1-presentation/dto/auth/request/signin.dto';
import { SigninResDto } from 'src/1-presentation/dto/auth/response/signin.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { AuthFacade } from 'src/2-application/facade/auth/auth.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authFacade: AuthFacade) {}
  // [x] 로그인
  @Post('signin')
  async signin(@Body() body: AuthSigninReqDto): Promise<SigninResDto> {
    return plainToClass(SigninResDto, await this.authFacade.signin({ body }));
  }

  // [ ] 로그아웃
  @UseGuards(JwtAuthGuard)
  @Post('signout')
  async signout(@CurrentUser() sub: number) {
    return await this.authFacade.signout({ sub });
  }

  // [ ] 토큰 갱신
  @Post('refresh')
  refresh() {}
}
