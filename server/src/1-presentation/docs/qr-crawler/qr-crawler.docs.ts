import { applyDecorators } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { QrCrawlerCrawlResDto } from 'src/1-presentation/dto/qr-crawler/response/crawl.dto';
import { QrCrawlerGetBrandsResDto } from 'src/1-presentation/dto/qr-crawler/response/get-brands.dto';

export function QrCrawlerControllerDocs() {
  return applyDecorators(ApiTags('QR Crawler 브랜드 크롤링'));
}

export function GetBrandsDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '지원하는 브랜드 목록 조회',
    }),
    ApiOkResponse({
      type: [QrCrawlerGetBrandsResDto],
    }),
  );
}

export function CrawlQrDocs() {
  return applyDecorators(
    ApiOperation({
      summary: '지원하는 브랜드 목록 조회',
    }),
    ApiOkResponse({
      type: QrCrawlerCrawlResDto,
    }),
    ApiBadRequestResponse(),
  );
}
