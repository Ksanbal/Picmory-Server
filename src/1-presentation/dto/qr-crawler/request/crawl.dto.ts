import { ApiProperty } from '@nestjs/swagger';
import { IsUrl } from 'class-validator';

export class QrCrawlerCrawlReqDto {
  @ApiProperty()
  @IsUrl()
  url: string;
}
