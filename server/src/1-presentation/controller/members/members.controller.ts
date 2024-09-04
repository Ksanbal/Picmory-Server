import { Body, Controller, Post } from '@nestjs/common';
import { MembersRegisterReqDto } from 'src/1-presentation/dto/members/request/register.dto';
import { MembersFacade } from 'src/2-application/facade/members/members.facade';

@Controller('members')
export class MembersController {
  constructor(private readonly membersFacade: MembersFacade) {}

  // 회원가입
  @Post()
  async register(@Body() body: MembersRegisterReqDto) {
    return await this.membersFacade.register({ body });
  }

  // 정보 조회

  // 회원탈퇴
}
