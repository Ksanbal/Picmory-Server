import { Controller, Get } from '@nestjs/common';
import { plainToInstance } from 'class-transformer';
import { QrCrawlerGetBrandsResDto } from 'src/1-presentation/dto/qr-crawler/response/get-brands.dto';
import { QrCrawlerFacade } from 'src/2-application/facade/qr-crawler/qr-crawler.facade';

@Controller('qr-crawler')
export class QrCrawlerController {
  constructor(private readonly qrCrawlerFacade: QrCrawlerFacade) {}

  // [x] 지원하는 브랜드 리스트 조회
  @Get('brands')
  getBrands(): QrCrawlerGetBrandsResDto[] {
    return plainToInstance(
      QrCrawlerGetBrandsResDto,
      this.qrCrawlerFacade.getBrands(),
    );
  }

  // [ ] QR 링크 크롤링 요청
}
