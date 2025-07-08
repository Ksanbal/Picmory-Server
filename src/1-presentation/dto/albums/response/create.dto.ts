import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class AlbumsCreateResDto {
  @ApiProperty()
  @Expose()
  id: number;
}
