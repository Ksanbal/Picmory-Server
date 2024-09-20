import { IsUrl } from 'class-validator';

export class QrCrawlerCrawlReqDto {
  @IsUrl()
  url: string;
}
