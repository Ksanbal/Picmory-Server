import { Injectable } from '@nestjs/common';
import { Member } from '@prisma/client';
import { PrismaService } from 'src/lib/database/prisma.service';
import { UserProvider } from 'src/lib/enums/user-provider.enum';

@Injectable()
export class MemberRepository {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * provider 정보로 사용자 조회
   */
  async findByProviderId(dto: FindByProviderIdDto): Promise<Member | null> {
    const { provider, providerId } = dto;

    return await this.prisma.member.findFirst({
      where: {
        deletedAt: null,
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
      where: {
        id: member.id,
      },
      data: member,
    });
  }

  /**
   * 사용자 id로 사용자 조회
   */
  async findById(dto: FindByIdDto): Promise<Member | null> {
    return await this.prisma.member.findUnique({
      where: {
        id: dto.id,
        deletedAt: null,
      },
    });
  }

  /**
   * 사용자 생성
   */
  async create(dto: CreateDto): Promise<Member | null> {
    const { metadata, ...rest } = dto;
    return await this.prisma.member.create({
      data: {
        ...rest,
        metadata: JSON.stringify(metadata),
      },
    });
  }
}

type FindByProviderIdDto = {
  provider: UserProvider;
  providerId: string;
};

type FindByIdDto = {
  id: number;
};

type UpdateDto = {
  member: Member;
};

type CreateDto = {
  providerId: string;
  provider: UserProvider;
  email: string;
  name: string;
  metadata: Record<string, any>;
};
