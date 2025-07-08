import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class QrCrawlerGetBrandsResDto {
  @ApiProperty()
  @Expose()
  name: string;
}
