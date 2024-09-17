import { IsString } from 'class-validator';

export class AlbumsCreateReqDto {
  @IsString()
  name: string;
}
