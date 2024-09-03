import { Injectable } from '@nestjs/common';
import { RefreshToken } from '@prisma/client';
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
        expiredAt: dto.expiredAt,
      },
    });
  }

  /**
   * 갱신
   */
  async delete(dto: DeleteDto): Promise<void> {
    await this.prisma.refreshToken.deleteMany({
      where: {
        memberId: dto.memberId,
      },
    });
  }
}

type CreateDto = {
  memberId: number;
  token: string;
  expiredAt: Date;
};

type DeleteDto = {
  memberId: number;
};
