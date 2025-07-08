import { Module } from '@nestjs/common';
import { MembersController } from 'src/1-presentation/controller/members/members.controller';
import { MembersFacade } from 'src/2-application/facade/members/members.facade';
import { MembersService } from 'src/3-domain/service/members/members.service';
import { MemberRepository } from 'src/4-infrastructure/repository/member/member.repository';
import { PrismaService } from 'src/lib/database/prisma.service';

@Module({
  controllers: [MembersController],
  providers: [PrismaService, MembersFacade, MembersService, MemberRepository],
})
export class MembersModule {}
