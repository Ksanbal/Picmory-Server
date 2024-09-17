import { Expose } from 'class-transformer';

export class AlbumsCreateResDto {
  @Expose()
  id: number;
}
