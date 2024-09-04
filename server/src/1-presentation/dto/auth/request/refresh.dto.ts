import { IsJWT } from 'class-validator';

export class AuthRefreshReqDto {
  @IsJWT()
  refreshToken: string;
}
