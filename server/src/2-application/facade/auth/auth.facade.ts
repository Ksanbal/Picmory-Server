import { Injectable } from '@nestjs/common';
import { AuthSigninReqDto } from 'src/1-presentation/dto/auth/request/signin.dto';
import { AuthService } from 'src/3-domain/service/auth/auth.service';
import { MembersService } from 'src/3-domain/service/members/members.service';

@Injectable()
export class AuthFacade {
  constructor(
    private readonly authService: AuthService,
    private readonly membersService: MembersService,
  ) {}

  // [ ] 로그인
  async signin(dto: AuthSigninReqDto) {
    const { provider, providerId, fcmToken } = dto;

    // provider로 사용자 가져오기
    const member = await this.membersService.getByProvider({
      provider,
      providerId,
    });

    // JWT 토큰 발급
    const token = await this.authService.createToken({ sub: member.id });

    // FCM Token 업데이트
    await this.membersService.updateFcmToken({ member, fcmToken });

    return token;
  }

  // [ ] 로그아웃

  // [ ] 토큰 유효성 검사

  // [ ] 토큰 갱신
}
