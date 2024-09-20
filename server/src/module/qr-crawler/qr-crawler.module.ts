import { Module } from '@nestjs/common';
import { QrCrawlerController } from 'src/1-presentation/controller/qr-crawler/qr-crawler.controller';
import { QrCrawlerFacade } from 'src/2-application/facade/qr-crawler/qr-crawler.facade';
import { QrCrawlerService } from 'src/3-domain/service/qr-crawler/qr-crawler.service';

@Module({
  controllers: [QrCrawlerController],
  providers: [QrCrawlerFacade, QrCrawlerService],
})
export class QrCrawlerModule {}
