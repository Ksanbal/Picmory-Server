import { Expose } from 'class-transformer';

export class SigninResDto {
  @Expose()
  accessToken: string;

  @Expose()
  refreshToken: string;
}
