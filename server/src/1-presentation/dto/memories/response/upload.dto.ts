import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class MemoriesUploadResDto {
  @ApiProperty()
  @Expose()
  id: number;
}
