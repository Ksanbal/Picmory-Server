import { Body, Controller, Delete, Get, Post, UseGuards } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import {
  DeleteMeDocs,
  GetMeDocs,
  MembersControllerDocs,
  RegisterDocs,
} from 'src/1-presentation/docs/members/members.docs';
import { MembersRegisterReqDto } from 'src/1-presentation/dto/members/request/register.dto';
import { MembersGetMeResDto } from 'src/1-presentation/dto/members/response/get-me.dto';
import { JwtAuthGuard } from 'src/1-presentation/guard/auth/auth.guard';
import { MembersFacade } from 'src/2-application/facade/members/members.facade';
import { CurrentUser } from 'src/lib/decorator/current-user.decorator';

@MembersControllerDocs()
@Controller('members')
export class MembersController {
  constructor(private readonly membersFacade: MembersFacade) {}

  // 회원가입
  @RegisterDocs()
  @Post()
  async register(@Body() body: MembersRegisterReqDto): Promise<void> {
    return await this.membersFacade.register({ body });
  }

  // 정보 조회
  @GetMeDocs()
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getMe(@CurrentUser() sub: number): Promise<MembersGetMeResDto> {
    return plainToInstance(
      MembersGetMeResDto,
      await this.membersFacade.getMe({ sub }),
    );
  }

  // 회원탈퇴
  @DeleteMeDocs()
  @Delete('me')
  @UseGuards(JwtAuthGuard)
  async deleteMe(@CurrentUser() sub: number): Promise<void> {
    return await this.membersFacade.deleteMe({ sub });
  }
}
