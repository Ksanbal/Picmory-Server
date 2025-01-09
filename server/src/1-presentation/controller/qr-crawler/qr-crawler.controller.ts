import { Body, Controller, Get, Post } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import {
  CrawlQrDocs,
  DemoDocs,
  GetBrandsDocs,
  QrCrawlerControllerDocs,
} from 'src/1-presentation/docs/qr-crawler/qr-crawler.docs';
import { QrCrawlerCrawlReqDto } from 'src/1-presentation/dto/qr-crawler/request/crawl.dto';
import { QrCrawlerCrawlResDto } from 'src/1-presentation/dto/qr-crawler/response/crawl.dto';
import { QrCrawlerGetBrandsResDto } from 'src/1-presentation/dto/qr-crawler/response/get-brands.dto';
import { QrCrawlerFacade } from 'src/2-application/facade/qr-crawler/qr-crawler.facade';

@QrCrawlerControllerDocs()
@Controller('qr-crawler')
export class QrCrawlerController {
  constructor(private readonly qrCrawlerFacade: QrCrawlerFacade) {}

  // [x] 지원하는 브랜드 리스트 조회
  @GetBrandsDocs()
  @Get('brands')
  getBrands(): QrCrawlerGetBrandsResDto[] {
    return plainToInstance(
      QrCrawlerGetBrandsResDto,
      this.qrCrawlerFacade.getBrands(),
    );
  }

  // [ ] QR 링크 크롤링 요청
  @CrawlQrDocs()
  @Post('crawl-qr')
  async crawlQr(
    @Body() body: QrCrawlerCrawlReqDto,
  ): Promise<QrCrawlerCrawlResDto> {
    return plainToInstance(
      QrCrawlerCrawlResDto,
      await this.qrCrawlerFacade.crawlQr({ body }),
    );
  }

  // [ ] 데모용 링크 크롤러
  @DemoDocs()
  @Get('demo')
  demo(): QrCrawlerCrawlResDto {
    return plainToInstance(QrCrawlerCrawlResDto, this.qrCrawlerFacade.demo());
  }
}
