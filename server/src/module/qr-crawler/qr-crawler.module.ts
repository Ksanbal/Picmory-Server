import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';
import { QrCrawlerController } from 'src/1-presentation/controller/qr-crawler/qr-crawler.controller';
import { QrCrawlerEventHandler } from 'src/1-presentation/event/qr-crawler/qr-crawler.event';
import { QrCrawlerFacade } from 'src/2-application/facade/qr-crawler/qr-crawler.facade';
import { QrCrawlerService } from 'src/3-domain/service/qr-crawler/qr-crawler.service';
import { WebhookClient } from 'src/4-infrastructure/client/webhook/webhook.client';

@Module({
  imports: [HttpModule],
  controllers: [QrCrawlerController],
  providers: [
    QrCrawlerFacade,
    QrCrawlerService,
    WebhookClient,
    QrCrawlerEventHandler,
  ],
})
export class QrCrawlerModule {}
