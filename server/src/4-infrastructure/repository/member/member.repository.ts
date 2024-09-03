import { Injectable } from '@nestjs/common';
import { Member, UserProvider } from '@prisma/client';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class MemberRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * provider 정보로 사용자 조회
   */
  async getByProviderId(dto: GetByProviderIdDto): Promise<Member | null> {
    const { provider, providerId } = dto;

    return await this.prisma.member.findFirst({
      where: {
        provider,
        providerId,
      },
    });
  }

  /**
   * 사용자 정보 업데이트
   */
  async update(dto: UpdateDto): Promise<Member | null> {
    const { member } = dto;

    return await this.prisma.member.update({
      where: { id: member.id },
      data: member,
    });
  }
}

type GetByProviderIdDto = {
  provider: UserProvider;
  providerId: string;
};

type UpdateDto = {
  member: Member;
};
