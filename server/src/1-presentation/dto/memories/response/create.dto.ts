import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class MemoriesCreateResDto {
  @ApiProperty()
  @Expose()
  id: number;
}
