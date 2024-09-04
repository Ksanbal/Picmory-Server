import { UserProvider } from '@prisma/client';
import { IsEnum, IsFirebasePushId, IsString } from 'class-validator';

export class AuthSigninReqDto {
  @IsEnum(UserProvider)
  provider: UserProvider;

  @IsString()
  providerId: string;

  @IsFirebasePushId()
  fcmToken: string;
}
