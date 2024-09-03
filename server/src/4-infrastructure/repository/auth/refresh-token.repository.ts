import { Injectable } from '@nestjs/common';
import { RefreshToken } from '@prisma/client';
import { Dayjs } from 'dayjs';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class RefreshTokenRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * 생성
   */
  async create(dto: CreateDto): Promise<RefreshToken> {
    return await this.prisma.refreshToken.create({
      data: {
        memberId: dto.memberId,
        token: dto.token,
        expiredAt: dto.expiredAt.toDate(),
      },
    });
  }
}

type CreateDto = {
  memberId: number;
  token: string;
  expiredAt: Dayjs;
};
