import { Expose } from 'class-transformer';

export class QrCrawlerCrawlResDto {
  @Expose()
  brand: string;

  @Expose()
  photoUrls: string[];

  @Expose()
  videoUrls: string[];
}
