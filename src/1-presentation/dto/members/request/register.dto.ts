import { ApiProperty } from '@nestjs/swagger';

import { IsEmail, IsEnum, IsObject, IsString } from 'class-validator';
import { UserProvider } from 'src/lib/enums/user-provider.enum';

export class MembersRegisterReqDto {
  @ApiProperty()
  @IsString()
  providerId: string;

  @ApiProperty({
    enum: UserProvider,
  })
  @IsEnum(UserProvider)
  provider: UserProvider;

  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty({
    type: Object,
  })
  @IsObject()
  metadata: Record<string, any>;
}
