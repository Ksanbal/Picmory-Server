import { Injectable } from '@nestjs/common';
import { AuthRefreshReqDto } from 'src/1-presentation/dto/auth/request/refresh.dto';
import { AuthSigninReqDto } from 'src/1-presentation/dto/auth/request/signin.dto';
import { AuthService } from 'src/3-domain/service/auth/auth.service';
import { MembersService } from 'src/3-domain/service/members/members.service';

@Injectable()
export class AuthFacade {
  constructor(
    private readonly authService: AuthService,
    private readonly membersService: MembersService,
  ) {}

  // 로그인
  async signin(dto: SigninDto) {
    const { provider, providerId, fcmToken } = dto.body;

    // provider로 사용자 가져오기
    const member = await this.membersService.getByProvider({
      provider,
      providerId,
    });

    // JWT 토큰 발급
    const token = await this.authService.createToken({ sub: member.id });

    // FCM Token 업데이트
    if (fcmToken) {
      await this.membersService.updateFcmToken({ member, fcmToken });
    }

    return token;
  }

  // 로그아웃
  async signout(dto: SignooutDto) {
    const { sub } = dto;

    // id로 사용자 가져오기
    const member = await this.membersService.getById({ id: sub });

    // FCM Token 삭제
    await this.membersService.updateFcmToken({ member, fcmToken: null });

    // Refresh Token을 만료처리
    await this.authService.deleteRefreshToken({ sub });
  }

  // 토큰 갱신
  async refresh(dto: RefreshDto) {
    const { refreshToken } = dto.body;

    // Refresh Token 검증
    const refreshTokenEntity = await this.authService.getRefreshToken({
      token: refreshToken,
    });

    // 새로운 AccessToken 발급
    const newAccessToken = await this.authService.generateAccessToken(
      refreshTokenEntity.memberId,
    );

    return { accessToken: newAccessToken };
  }
}

type SigninDto = {
  body: AuthSigninReqDto;
};

type SignooutDto = {
  sub: number;
};

type RefreshDto = {
  body: AuthRefreshReqDto;
};
