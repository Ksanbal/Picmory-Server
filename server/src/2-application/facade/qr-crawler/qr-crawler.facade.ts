import { Injectable } from '@nestjs/common';
import { Brand } from 'src/3-domain/model/qr-cralwer/brand.model';
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
}
