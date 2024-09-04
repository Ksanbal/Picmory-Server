import { UserProvider } from '@prisma/client';
import { IsEmail, IsEnum, IsObject, IsString } from 'class-validator';

export class MembersRegisterReqDto {
  @IsString()
  providerId: string;

  @IsEnum(UserProvider)
  provider: UserProvider;

  @IsEmail()
  email: string;

  @IsString()
  name: string;

  @IsObject()
  metadata: Record<string, any>;
}
