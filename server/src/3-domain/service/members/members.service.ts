import { Injectable, NotFoundException } from '@nestjs/common';
import { Member, UserProvider } from '@prisma/client';
import { MemberRepository } from 'src/4-infrastructure/repository/member/member.repository';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';

@Injectable()
export class MembersService {
  constructor(private readonly memberRepository: MemberRepository) {}

  /**
   * provider 정보로 사용자 가져오기
   */
  async getByProvider(dto: GetByProviderDto): Promise<Member> {
    const { provider, providerId } = dto;

    const member = await this.memberRepository.findByProviderId({
      provider,
      providerId,
    });

    if (member == null) {
      throw new NotFoundException(ERROR_MESSAGES.MEMBER_NOT_FOUND);
    }

    return member;
  }

  /**
   * 사용자 id로 사용자 가져오기
   */
  async getById(dto: GetByIdDto): Promise<Member> {
    const member = await this.memberRepository.findById(dto);

    if (member == null) {
      throw new NotFoundException(ERROR_MESSAGES.MEMBER_NOT_FOUND);
    }

    return member;
  }

  /**
   * 사용자 FCM 정보 업데이트
   */
  async updateFcmToken(dto: UpdateDto): Promise<Member> {
    const { member, fcmToken } = dto;

    member.fcmToken = fcmToken;

    const updatedMember = await this.memberRepository.update({ member });

    return updatedMember;
  }
}

type GetByProviderDto = {
  provider: UserProvider;
  providerId: string;
};

type UpdateDto = {
  member: Member;
  fcmToken: string;
};

type GetByIdDto = {
  id: number;
};
