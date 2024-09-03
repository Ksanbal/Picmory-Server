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
        expiredAt: expiredAt.toDate(),
      });
    } catch (error) {
      throw new Error(ERROR_MESSAGES.AUTH_FAILED_INSERT_TOKEN);
    }

    return { accessToken, refreshToken };
  }

  /**
   * RefreshToken 만료처리
   */
  async deleteRefreshToken(dto: DeleteRefreshTokenDto) {
    try {
      await this.refreshTokenRepository.delete({
        memberId: dto.sub,
      });
    } catch (error) {
      throw new Error(ERROR_MESSAGES.AUTH_FAILED_EXPIRE_TOKEN);
    }
  }

  /**
   * AccessToken 생성
   */
  private async generateAccessToken(sub: number): Promise<string> {
    const payload = { sub };

    return this.jwtService.signAsync(payload, {
      secret: this.configService.get<string>('JWT_SECRET'),
      expiresIn: Number(this.configService.get<string>('JWT_EXPIRATION_TIME')),
    });
  }

  /**
   * RefreshToken 생성
   */
  private async generateRefreshToken(sub: number): Promise<string> {
    const payload = { sub };

    return this.jwtService.signAsync(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: Number(
        this.configService.get<string>('JWT_REFRESH_EXPIRATION_TIME'),
      ),
    });
  }
}

type CreateTokenDto = {
  sub: number;
};

type DeleteRefreshTokenDto = {
  sub: number;
};
