import { Injectable } from '@nestjs/common';
import { QrCrawlerCrawlReqDto } from 'src/1-presentation/dto/qr-crawler/request/crawl.dto';
import { Brand } from 'src/3-domain/model/qr-cralwer/brand.model';
import { BrandCrawl } from 'src/3-domain/model/qr-cralwer/crawl-result.model';
import { QrCrawlerService } from 'src/3-domain/service/qr-crawler/qr-crawler.service';

@Injectable()
export class QrCrawlerFacade {
  constructor(private readonly qrCrawlerService: QrCrawlerService) {}

  /**
   * 지원하는 브랜드 리스트 조회
   */
  getBrands(): Brand[] {
    return this.qrCrawlerService.getBrands();
  }

  /**
   * QR 링크 크롤링 요청
   */
  crawlQr(dto: CrawlQrDto): Promise<BrandCrawl> {
    return this.qrCrawlerService.crawlQr({
      url: dto.body.url,
    });
  }

  /**
   * 데모용 QR 링크 크롤링 요청
   */
  demo(): BrandCrawl {
    return this.qrCrawlerService.demo();
  }
}

type CrawlQrDto = {
  body: QrCrawlerCrawlReqDto;
};
