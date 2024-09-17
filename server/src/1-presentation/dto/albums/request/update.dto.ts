import { IsString } from 'class-validator';

export class AlbumsUpdateReqDto {
  @IsString()
  name: string;
}
