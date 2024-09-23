import { ApiProperty } from '@nestjs/swagger';
import { UserProvider } from '@prisma/client';
import { IsEnum, IsString } from 'class-validator';

export class AuthSigninReqDto {
  @ApiProperty({
    enum: UserProvider,
    description: '로그인 제공자',
  })
  @IsEnum(UserProvider)
  provider: UserProvider;

  @ApiProperty({
    description: '로그인 제공자의 ID',
  })
  @IsString()
  providerId: string;

  @ApiProperty({
    description: 'Firebase Cloud Messaging Token',
  })
  @IsString()
  fcmToken: string;
}
