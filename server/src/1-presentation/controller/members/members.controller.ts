import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import { MembersRegisterReqDto } from 'src/1-presentation/dto/members/request/register.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { MembersFacade } from 'src/2-application/facade/members/members.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@Controller('members')
export class MembersController {
  constructor(private readonly membersFacade: MembersFacade) {}

  // 회원가입
  @Post()
  async register(@Body() body: MembersRegisterReqDto) {
    return await this.membersFacade.register({ body });
  }

  // 정보 조회
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getMe(@CurrentUser() sub: number) {
    return await this.membersFacade.getMe({ sub });
  }

  // 회원탈퇴
}
