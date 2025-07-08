import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { QrCrawlerCrawlFailedDto } from 'src/1-presentation/dto/qr-crawler/qr-crawler-crawl-failed.dto';
import { QrCrawlerFacade } from 'src/2-application/facade/qr-crawler/qr-crawler.facade';
import { EVENT_NAMES } from 'src/lib/constants/event-names';

@Injectable()
export class QrCrawlerEventHandler {
  constructor(private readonly qrCrawlerFacade: QrCrawlerFacade) {}

  @OnEvent(EVENT_NAMES.QR_CRAWLER_FAILED, { async: true })
  async handleCrawlFailed(dto: QrCrawlerCrawlFailedDto) {
    await this.qrCrawlerFacade.notifyCrawlFailed({ url: dto.url });
  }
}
