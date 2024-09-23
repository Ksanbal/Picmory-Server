import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthController } from 'src/1-presentation/controller/auth/auth.controller';
import { AuthFacade } from 'src/2-application/facade/auth/auth.facade';
import { AuthService } from 'src/3-domain/service/auth/auth.service';
import { MembersService } from 'src/3-domain/service/members/members.service';
import { RefreshTokenRepository } from 'src/4-infrastructure/repository/auth/refresh-token.repository';
import { MemberRepository } from 'src/4-infrastructure/repository/member/member.repository';
import { PrismaService } from 'src/lib/database/prisma.service';

@Module({
  imports: [
    PassportModule,
    JwtModule.registerAsync({
      global: true,
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
        signOptions: {
          expiresIn: configService.get<string>('JWT_EXPIRATION_TIME'),
        },
      }),
    }),
  ],
  controllers: [AuthController],
  providers: [
    PrismaService,
    AuthFacade,
    AuthService,
    RefreshTokenRepository,
    MembersService,
    MemberRepository,
  ],
})
export class AuthModule {}
