import { UserProvider } from '@prisma/client';
import { IsEnum, IsString } from 'class-validator';

export class AuthSigninReqDto {
  @IsEnum(UserProvider)
  provider: UserProvider;

  @IsString()
  providerId: string;

  @IsString()
  fcmToken: string;
}
