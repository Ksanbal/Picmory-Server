import { ApiProperty } from '@nestjs/swagger';
import { IsJWT } from 'class-validator';

export class AuthRefreshReqDto {
  @ApiProperty()
  @IsJWT()
  refreshToken: string;
}
