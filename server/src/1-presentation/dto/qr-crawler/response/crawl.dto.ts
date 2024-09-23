import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class QrCrawlerCrawlResDto {
  @ApiProperty()
  @Expose()
  brand: string;

  @ApiProperty()
  @Expose()
  photoUrls: string[];

  @ApiProperty()
  @Expose()
  videoUrls: string[];
}
