import { IsString } from 'class-validator';

export class AuthRefreshReqDto {
  @IsString()
  refreshToken: string;
}
