import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class MemoriesCreateUploadUrlResDto {
  @ApiProperty()
  @Expose()
  url: string;

  @ApiProperty()
  @Expose()
  key: string;
}
