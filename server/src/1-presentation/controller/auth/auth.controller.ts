import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { plainToClass, plainToInstance } from 'class-transformer';
import {
  AuthControllerDocs,
  RefreshDocs,
  SigninDocs,
  SignoutDocs,
} from 'src/1-presentation/docs/auth/auth.docs';
import { AuthRefreshReqDto } from 'src/1-presentation/dto/auth/request/refresh.dto';
import { AuthSigninReqDto } from 'src/1-presentation/dto/auth/request/signin.dto';
import { RefreshResDto } from 'src/1-presentation/dto/auth/response/refresh.dto';
import { SigninResDto } from 'src/1-presentation/dto/auth/response/signin.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { AuthFacade } from 'src/2-application/facade/auth/auth.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@AuthControllerDocs()
@Controller('auth')
export class AuthController {
  constructor(private readonly authFacade: AuthFacade) {}
  // [x] 로그인
  @SigninDocs()
  @Post('signin')
  async signin(@Body() body: AuthSigninReqDto): Promise<SigninResDto> {
    return plainToClass(SigninResDto, await this.authFacade.signin({ body }));
  }

  // [x] 로그아웃
  @SignoutDocs()
  @Post('signout')
  @UseGuards(JwtAuthGuard)
  async signout(@CurrentUser() sub: number): Promise<void> {
    return await this.authFacade.signout({ sub });
  }

  // [x] 토큰 갱신
  @RefreshDocs()
  @Post('refresh')
  async refresh(@Body() body: AuthRefreshReqDto): Promise<RefreshResDto> {
    return plainToInstance(
      RefreshResDto,
      await this.authFacade.refresh({ body }),
    );
  }
}
