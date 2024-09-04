import { BadRequestException, Injectable } from '@nestjs/common';
import { Member } from '@prisma/client';
import { MembersRegisterReqDto } from 'src/1-presentation/dto/members/request/register.dto';
import { MembersService } from 'src/3-domain/service/members/members.service';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';

@Injectable()
export class MembersFacade {
  constructor(private readonly memberService: MembersService) {}

  // 회원가입
  async register(dto: RegisterDto): Promise<Member> {
    // 중복여부 확인
    const member = await this.memberService.existsByProviderId({
      providerId: dto.body.providerId,
      provider: dto.body.provider,
    });
    if (member) {
      throw new BadRequestException(ERROR_MESSAGES.MEMBER_ALREADY_EXISTS);
    }

    // 사용자 생성
    const newMember = await this.memberService.create({ ...dto.body });

    return newMember;
  }

  // 정보 조회

  // 회원탈퇴
}

type RegisterDto = {
  body: MembersRegisterReqDto;
};
