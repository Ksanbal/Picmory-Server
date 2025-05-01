import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString } from 'class-validator';
import { UserProvider } from 'src/lib/enums/user-provider.enum';

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
  @IsOptional()
  @IsString()
  fcmToken: string | null = null;
}
