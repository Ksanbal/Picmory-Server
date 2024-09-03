import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import * as dayjs from 'dayjs';
import { RefreshTokenRepository } from 'src/4-infrastructure/repository/auth/refresh-token.repository';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';

@Injectable()
export class AuthService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly refreshTokenRepository: RefreshTokenRepository,
  ) {}

  /**
   * JWT 토큰 생성
   */
  async createToken(dto: CreateTokenDto) {
    // JWT 발급
    const accessToken = await this.generateAccessToken(dto.sub);
    const refreshToken = await this.generateRefreshToken(dto.sub);

    // RefreshToken 저장
    const expiredAt = dayjs().add(
      Number(this.configService.get<string>('JWT_REFRESH_EXPIRATION_TIME')),
      'second',
    );

    try {
      await this.refreshTokenRepository.create({
        memberId: dto.sub,
        token: refreshToken,
        expiredAt,
      });
    } catch (error) {
      throw new Error(ERROR_MESSAGES.AUTH_FAIL_INSERT_TOKEN);
    }

    return { accessToken, refreshToken };
  }

  /**
   * AccessToken 생성
   */
  private async generateAccessToken(sub: number): Promise<string> {
    const payload = { sub };

    return this.jwtService.signAsync(payload, {
      secret: this.configService.get<string>('JWT_SECRET'),
      expiresIn: this.configService.get<string>('JWT_EXPIRATION_TIME'),
    });
  }

  /**
   * RefreshToken 생성
   */
  private async generateRefreshToken(sub: number): Promise<string> {
    const payload = { sub };

    return this.jwtService.signAsync(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRATION_TIME'),
    });
  }
}

type CreateTokenDto = {
  sub: number;
};
