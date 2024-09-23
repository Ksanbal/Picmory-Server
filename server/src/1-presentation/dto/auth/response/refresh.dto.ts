import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class RefreshResDto {
  @ApiProperty()
  @Expose()
  accessToken: string;
}
