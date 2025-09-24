import {
  BadRequestException,
  ConflictException,
  Injectable,
  UnprocessableEntityException,
} from '@nestjs/common';
import puppeteer from 'puppeteer';
import { Brand } from 'src/3-domain/model/qr-cralwer/brand.model';
import { BrandCrawl } from 'src/3-domain/model/qr-cralwer/crawl-result.model';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { JSDOM } from 'jsdom';
import { ConfigService } from '@nestjs/config';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';
import * as AdmZip from 'adm-zip';
import * as fs from 'fs';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { EVENT_NAMES } from 'src/lib/constants/event-names';
import {
  WebhookClient,
  WebhookColor,
} from 'src/4-infrastructure/client/webhook/webhook.client';

@Injectable()
export class QrCrawlerService {
  constructor(
    private readonly configService: ConfigService,
    private readonly httpService: HttpService,
    private readonly eventEmitter: EventEmitter2,
    private readonly webhookClient: WebhookClient,
  ) {}

  brands: Brand[] = [
    {
      // 데모용
      name: 'Picmory',
      host: 'naver.com',
    },
    {
      // 모노맨션
      name: 'Mono mansion',
      host: 'monomansion.net',
    },
    {
      // 하루필름
      name: 'HARUFILM',
      host: 'mx2.co.kr',
    },
    {
      // 포토 시그니처
      name: 'PHOTO SIGNATURE',
      host: 'photoqr', // TODO
    },
    {
      // 플랜비 스튜디오
      name: 'PLAN.B STUDIO',
      host: 'pixpixlink.com',
    },
    {
      // 비비드 뮤지엄
      name: 'VIVID MUSEUM',
      host: 'vividmuseum.co.kr',
    },
    {
      // 인생네컷
      name: '인생네컷',
      host: 'life4cut.net',
    },
    {
      // 포토그레이
      name: 'PHOTOGRAY',
      host: 'aprd.io',
    },
    {
      // 포토에이스
      name: 'PhotoAce',
      host: 'photoace.co.kr',
    },
    {
      // 포토이즘
      name: 'photoism',
      host: 'seobuk.kr',
    },
    {
      // 픽닷
      name: 'picdot',
      host: 'picdot.co.kr',
    },
    {
      // 폴라 스튜디오
      name: 'POLA STUDIO',
      host: '13.125.146.152',
    },
    {
      // 돈룩업
      name: "DON'T LXXK UP",
      host: 'dontlxxkup.kr',
    },
    {
      // 그믐달 셀프 스튜디오
      name: 'oldmoon',
      host: 'oldmoonstudio.co.kr',
    },
    {
      // 그믐달 셀프 스튜디오 2
      name: 'OLDMOON',
      host: '3.38.68.231',
    },
    {
      // 그믐달 셀프 스튜디오 2
      name: 'OLDMOON',
      host: '43.200.194.205',
    },
    {
      // 그믐달 셀프 스튜디오 3
      name: 'OLDMOON',
      host: 'pixpixlink.com',
    },
    // {
    //   // selpix
    //   name: 'Selpix',
    //   host: '14.63.225.67',
    // },
    {
      // PhotoHub
      name: 'PhotoHub',
      host: '13.124.189.94',
    },
    {
      // The Film
      name: 'The Film',
      host: 'thefilmadmin.co.kr',
    },
    {
      // Q2Center
      name: 'Q2Center',
      host: 'q2center.kr',
    },
    {
      // PhotoHani
      name: 'PhotoHani',
      host: 'cellbig.net',
    },
    {
      // Mirart Studio
      name: 'Mirart Studio',
      host: 'mirart.me',
    },
    {
      // Studio808
      name: 'Studio808',
      host: 'studio808.kr',
    },
    {
      // SNAPAI
      name: 'SNAPAI',
      host: 'snapai-vive.com',
    },
    {
      // SHOTUP
      name: 'SHOTUP',
      host: 'durishot.net',
    },
    {
      // munifilm
      name: 'munifilm',
      host: 'muinfilm.com',
    },
    {
      // GOOD PHOTO SHOP
      name: 'GOOD PHOTO SHOP',
      host: 'selfphotostudio.kr',
    },
    {
      // youngchive
      name: 'youngchive',
      host: 'youngchive.com',
    },
    {
      // 포토하임
      name: 'photo heim',
      host: 'selfphotobox.com',
    },
  ];

  /**
   * 지원하는 브랜드 리스트 조회
   */
  getBrands(): Brand[] {
    // name을 소문자로 변환하여 중복 제거
    const seen = new Set<string>();
    const deduped: Brand[] = [];
    for (const brand of this.brands) {
      const lower = brand.name.toLowerCase();
      if (!seen.has(lower)) {
        seen.add(lower);
        deduped.push(brand);
      }
    }
    return deduped;
  }

  /**
   * QR 링크 크롤링 요청
   */
  async crawlQr(dto: CrawlQrDto): Promise<BrandCrawl> {
    const { url } = dto;

    const mainDomain = this.getMainDomain(url);

    // 지원하는 브랜드인지 확인
    const brand = this.brands.find((brand) => brand.host === mainDomain);

    if (brand == undefined) {
      // 파일 생성 이벤트 발행
      this.eventEmitter.emit(EVENT_NAMES.QR_CRAWLER_BRAND_NOT_FOUND, {
        url,
      });
      throw new UnprocessableEntityException(
        ERROR_MESSAGES.QR_CRAWLER_NOT_SUPPORTED,
      );
    }

    try {
      let result: BrandCrawl;
      switch (brand.name) {
        case 'Picmory':
          result = this.demo();
          break;
        case 'Mono mansion':
          result = await this.monomansion(url);
          break;
        case 'HARUFILM':
          result = await this.haruFilm(url);
          break;
        case 'PHOTO SIGNATURE':
          result = await this.photoqr2(url);
          break;
        case 'PLAN.B STUDIO':
          result = await this.planBStudio(url);
          break;
        case 'VIVID MUSEUM':
          result = await this.vividmuseum(url);
          break;
        case '인생네컷':
          result = await this.life4cut(url);
          break;
        case 'PHOTOGRAY':
          result = await this.photogray(url);
          break;
        case 'PhotoAce':
          result = await this.photoAce(url);
          break;
        case 'photoism':
          result = await this.seobuk(url);
          break;
        case 'picdot':
          result = await this.picdot(url);
          break;
        case 'POLA STUDIO':
          result = await this.polaStudio(url);
          break;
        case "DON'T LXXK UP":
          result = await this.dontLookUp(url);
          break;
        case 'oldmoon':
          result = await this.oldmoon(url);
          break;
        case 'OLDMOON':
          result = await this.oldmoon2(url);
          break;
        // case 'Selpix':
        //   result = await this.selfix(url);
        //   break;
        case 'PhotoHub':
          result = await this.photoHub(url);
          break;
        case 'The Film':
          result = await this.thefilm(url);
          break;
        case 'Q2Center':
          result = await this.q2Center(url);
          break;
        case 'PhotoHani':
          result = await this.photoHani(url);
          break;
        case 'Mirart Studio':
          result = await this.mirartStudio(url);
          break;
        case 'Studio808':
          result = await this.studio808(url);
          break;
        case 'SNAPAI':
          result = await this.snapai(url);
          break;
        case 'SHOTUP':
          result = await this.shotup(url);
          break;
        case 'munifilm':
          result = await this.munifilm(url);
          break;
        case 'GOOD PHOTO SHOP':
          result = await this.goodPhotoShop(url);
          break;
        case 'youngchive':
          result = await this.youngchive(url);
          break;
        case 'photo heim':
          result = await this.photoHeim(url);
          break;
      }

      result.brand = brand.name;

      return result;
    } catch (error) {
      console.error(error);
      this.eventEmitter.emit(EVENT_NAMES.QR_CRAWLER_FAILED, {
        url,
      });
      throw new ConflictException(ERROR_MESSAGES.QR_CRAWLER_UNKOWN_ERROR);
    }
  }

  private getMainDomain(url: string): string {
    try {
      const urlObj = new URL(url);
      const hostname = urlObj.hostname;

      // ip인 경우 바로 반환
      const ipv4Regex =
        /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
      if (ipv4Regex.test(hostname)) {
        return hostname;
      }

      const parts = hostname.split('.');

      if (parts.length < 2) {
        return hostname;
      }

      // 한국 도메인 (.co.kr, .ac.kr 등) 처리
      if (
        parts.length >= 3 &&
        parts[parts.length - 2] === 'co' &&
        parts[parts.length - 1] === 'kr'
      ) {
        return parts.slice(-3).join('.');
      }

      // 일반적인 경우 (domain.tld)
      return parts.slice(-2).join('.');
    } catch (error) {
      console.error('Invalid URL:', error);
      return null;
    }
  }

  /**
   * QR 링크 크롤링 요청
   */
  demo(): BrandCrawl {
    return {
      brand: 'Picmory',
      photoUrls: [
        this.configService.get<string>('HOST_URL') + '/public/qr-demo.JPG',
      ],
      videoUrls: [
        this.configService.get<string>('HOST_URL') + '/public/qr-demo.MP4',
      ],
    };
  }

  async notifyCrawlFailed(dto: NotifyCrawlFailedDto): Promise<void> {
    const { url } = dto;

    const result = await this.webhookClient.send({
      title: '🔥 크롤링 실패했어요!',
      content: `실행중 오류가 있었을 수도 있어요\n${url}`,
      color: WebhookColor.NEGATIVE,
    });

    if (!result) console.error('Webhook 전송 실패');
  }

  async notifyBrandNotFound(dto: NotifyBrandNotFoundDto): Promise<void> {
    const { url } = dto;

    const result = await this.webhookClient.send({
      title: '🔍 새로운 브랜드에요!',
      content: `뉴비가 나타났다!! 새로운 브랜드에요!!\n${url}`,
      color: WebhookColor.PRIMARY,
    });

    if (!result) console.error('Webhook 전송 실패');
  }

  private async getBrowser() {
    return puppeteer.launch({
      headless: true,
      // executablePath: '/usr/bin/google-chrome',
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--disable-gpu',
        '--ignore-certificate-errors',
      ],
    });
  }

  /// 모노맨션 다운로드 링크
  private async monomansion(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    const regex = /https:\/\/\w+\.monomansion\.net/;
    const result = url.match(regex);
    if (result == null) throw new Error();

    // 사진 다운로드 링크
    const photoHref = aList[0].getAttribute('href');
    const photoUrls = [`${result[0]}/api/${photoHref.split('./')[1]}`];

    // 영상 다운로드 링크
    const videoHref = aList[1].getAttribute('href');
    const videoUrls = [`${result[0]}/api/${videoHref.split('./')[1]}`];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 하루필름
  private async haruFilm(url: string): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    const regex = /http:\/\/\w+\.mx2\.co\.kr/;
    const result = url.match(regex);
    if (result == null) throw new Error();

    // 영상 다운로드 링크
    const videoHref = result[0] + aList[0].getAttribute('href');
    const videoUrls = [videoHref];

    // 사진 다운로드 링크
    const photoHref = result[0] + aList[1].getAttribute('href');
    const photoUrls = [photoHref];

    // 보너스 이미지 다운로드
    if (2 < aList.length) {
      const bonusHref = result[0] + aList[2].getAttribute('href');
      photoUrls.push(bonusHref);
    }

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 포토 시그니처 다운로드 링크
  private async photoqr2(url): Promise<BrandCrawl> {
    const path = url.split('index.html')[0];
    // 사진 다운로드 링크
    const photoUrls = [path + 'a.jpg'];

    // 영상 다운로드 링크
    const videoUrls = [path + 'video.mp4'];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // 플랜비 스튜디오
  private async planBStudio(url): Promise<BrandCrawl> {
    const res = await fetch(url, {
      method: 'GET',
    });

    if (res.status !== 200) {
      throw new Error();
    }

    const regex = /http:\/\/\w+\.pixpixlink\.com/;
    const result = url.match(regex);
    if (result == null) throw new Error();

    const id = url.split('id=')[1];

    const photoUrls = [`${result[0]}/take/${id}.jpg`];
    const videoUrls = [`${result[0]}/take/${id}.mp4`];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 비비드 뮤지엄
  private async vividmuseum(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    // 사진 다운로드 링크
    const photoHref = aList[0].getAttribute('href');
    const photoUrls = [photoHref];

    // 영상 다운로드 링크
    const videoHref = aList[1].getAttribute('href');
    const videoUrls = [videoHref];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // 인생네컷
  private async life4cut(url): Promise<BrandCrawl> {
    const res = await fetch(url, {
      method: 'GET',
      redirect: 'manual',
    });

    if (res.status === 301) {
      const redirectedUrl = res.headers.get('Location');

      const photoUrls = [redirectedUrl.replace('index.html', 'image.jpg')];
      const videoUrls = [redirectedUrl.replace('index.html', 'video.mp4')];

      return {
        brand: '',
        photoUrls,
        videoUrls,
      };
    }

    throw new Error();
  }

  /// 포토 그레이
  private async photogray(url): Promise<BrandCrawl> {
    const res = await fetch(url, { redirect: 'manual' });

    const redirectUrl = res.headers.get('location');

    // url에서 id 추출
    const id = redirectUrl.split('id=')[1];

    // id 값을 base64로 디코딩 && sessionId 추출
    const decodedId = atob(id).split('sessionId=')[1].split('&mode')[0];

    const photoUrls = [`https://pg-qr-resource.aprd.io/${decodedId}/image.jpg`];
    const videoUrls = [
      `https://pg-qr-resource.aprd.io/${decodedId}/video.mp4`,
      `https://pg-qr-resource.aprd.io/${decodedId}/timelapse.mp4`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 포토에이스
  private async photoAce(url): Promise<BrandCrawl> {
    const browser = await this.getBrowser();
    const page = await browser.newPage();

    await page.goto(url, {
      waitUntil: 'networkidle2',
    });

    const data = await page.$('#root > div > div > div:nth-child(4) > img');

    const photoUrls = [
      await page.evaluate((element) => {
        return element.src;
      }, data),
    ];

    const videoUrls = [photoUrls[0].replace('image.jpg', 'video.mp4')];

    await page.close();
    await browser.close();

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 포토이즘
  private async seobuk(url): Promise<BrandCrawl> {
    const browser = await this.getBrowser();
    const page = await browser.newPage();

    // 네트워크 요청 감지
    let resource;
    page.on('response', async (response) => {
      const reqUrl = response.url();
      if (
        reqUrl.includes('resource') &&
        response.request().method() == 'POST'
      ) {
        resource = await response.json();
      }
    });

    await page.goto(url, {
      waitUntil: 'networkidle2',
    });

    const photoUrls = [resource.content.fileInfo.picFile.path];
    const videoUrls = [resource.content.fileInfo.vidFile.path];

    await page.close();
    await browser.close();

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 픽닷
  private async picdot(url): Promise<BrandCrawl> {
    const transactionUid = url.split('transactionUid=')[1];

    const res = await firstValueFrom(
      this.httpService.get(
        `https://api.picdot.co.kr/api/v1/transaction/qr/file/${transactionUid}`,
      ),
    );

    if (res.status !== 200) {
      throw new Error();
    }

    const data = res.data.data;

    const photoUrls = [data['pathList'][0]['path']];
    const videoUrls = [data['video']['path'], data['timeVideo']['path']];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 폴라 스튜디오
  private async polaStudio(url): Promise<BrandCrawl> {
    const [path, id] = url.split('/g2.php?id=');

    // 사진 다운로드 링크
    const photoUrls = [`${path}/take/${id}.jpg`];

    // 영상 다운로드 링크
    const videoUrls = [`${path}/take/${id}.mp4`];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 돈룩업
  private async dontLookUp(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    // 사진 다운로드 링크
    const photoHref = 'https://x.dontlxxkup.kr' + aList[0].getAttribute('href');
    const photoUrls = [photoHref];

    // 영상 다운로드 링크
    const videoHref = 'https://x.dontlxxkup.kr' + aList[1].getAttribute('href');
    const videoUrls = [videoHref];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // 그믐달 셀프 스튜디오
  private async oldmoon(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    // 사진 다운로드 링크
    const photoHref =
      'https://oldmoonstudio.co.kr/api' +
      aList[0].getAttribute('href').replace('./', '/');
    const photoUrls = [photoHref];

    // 영상 다운로드 링크
    const videoHref =
      'https://oldmoonstudio.co.kr/api' +
      aList[1].getAttribute('href').replace('./', '/');
    const videoUrls = [videoHref];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // 그믐달 셀프 스튜디오 2
  private async oldmoon2(url): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await fetch(url, {
      method: 'GET',
    });

    if (res.status !== 200) {
      throw new Error();
    }

    const parsedUrl = new URL(url);
    const host = parsedUrl.host;
    const d = parsedUrl.searchParams.get('d');
    const i = parsedUrl.searchParams.get('i');

    // 사진 다운로드 링크
    const photoUrls = [`https://${host}/t/${d}/${i}.jpg`];

    // 영상 다운로드 링크
    const videoUrls = [`https://${host}/t/${d}/${i}.mp4`];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // 셀픽스
  private async selfix(url): Promise<BrandCrawl> {
    const res = await fetch(url, {
      method: 'GET',
    });

    if (res.status !== 200) {
      throw new Error();
    }

    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const path = url.split('?qr=')[1].split('&')[0];

    const photoUrls = [``];
    const videoUrls = [``];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  // PhotoHub
  private async photoHub(url): Promise<BrandCrawl> {
    const res = await fetch(url, {
      method: 'GET',
    });

    if (res.status !== 200) {
      throw new Error();
    }

    const id = url.split('id=')[1];

    const photoUrls = [`http://13.124.189.94/image.php?id=${id}`];
    const videoUrls = [`http://13.124.189.94/video.php?id=${id}`];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// The Film
  private async thefilm(url): Promise<BrandCrawl> {
    const qrcode = url.split('qrcode=')[1];

    const photoUrls = [
      `https://thefilmadmin.co.kr/api/download.php?qrcode=${qrcode}&type=P`,
    ];
    const videoUrls = [
      `https://thefilmadmin.co.kr/api/download.php?qrcode=${qrcode}&type=V`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// Q2Center
  private async q2Center(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    const regex = /http:\/\/\w+\.q2center\.kr/;
    const result = url.match(regex);
    if (result == null) throw new Error();

    // 영상 다운로드 링크
    const videoHref = result[0] + aList[0].getAttribute('href');
    const videoUrls = [videoHref];

    // 사진 다운로드 링크
    const photoHref = result[0] + aList[1].getAttribute('href');
    const photoUrls = [photoHref];

    // 보너스 이미지 다운로드
    if (2 < aList.length) {
      const bonusHref = result[0] + aList[2].getAttribute('href');
      photoUrls.push(bonusHref);
    }

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// PhotoHani
  private async photoHani(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const blob = await res.blob();
    const arrayBuffer = await blob.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);

    // zip 파일을 풀어서 임시경로에 저장
    const zip = new AdmZip(buffer);
    const zipEntries = zip.getEntries(); // an array of ZipEntry records

    const filePath = `/uploads/temp/${new Date().getTime()}`;

    const photoUrls = [];
    const videoUrls = [];

    zipEntries.forEach((entry) => {
      zip.extractEntryTo(entry, '.' + filePath, false, true);
      if (entry.entryName.includes('.jpg')) {
        photoUrls.push(
          this.configService.get<string>('HOST_URL') +
            filePath +
            '/' +
            entry.entryName,
        );
      } else {
        videoUrls.push(
          this.configService.get<string>('HOST_URL') +
            filePath +
            '/' +
            entry.entryName,
        );
      }
    });

    // 1시간 후 임시 파일 삭제 예약
    setTimeout(
      () => {
        fs.rm('.' + filePath, { recursive: true }, (err) => {
          if (err) console.error(`임시 파일 삭제 실패: ${filePath}`, err);
        });
      },
      60 * 60 * 1000,
    );

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// Mirart Studio
  private async mirartStudio(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    // 이미지 링크 가져오기
    const img = document.querySelector('img');
    const imgSrc = img.getAttribute('src');
    const baseUrl = imgSrc.split('/').slice(0, -1).join('/');

    const photoUrls = [
      imgSrc.replace('_thumbnail', ''),
      baseUrl + '/bonus.jpg',
    ];
    const videoUrls = [baseUrl + '/video.mp4'];

    // 원본 사진 다운로드
    const aList = document.querySelectorAll('a');
    const regex = /https:\/\/.+\.jpg/;
    for (let i = 0; i < aList.length; i++) {
      if (i % 2 == 0) continue;

      const a = aList[i];
      const onclick = a.getAttribute('onclick');
      const result = onclick.match(regex);
      if (result == null) continue;

      photoUrls.push(result[0]);
    }

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// Studio808
  private async studio808(url): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(url));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const qrcode = url.split('qrcode=')[1];
    if (qrcode == undefined) {
      throw new Error('qrcode not found');
    }

    const photoUrls = [
      `https://mys.studio808.kr/api/download.php?qrcode=${qrcode}&type=P`,
    ];
    const videoUrls = [
      `https://mys.studio808.kr/api/download.php?qrcode=${qrcode}&type=V`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// SNAPAI
  private async snapai(url): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(url));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const code = url.split('/').pop();
    if (code == undefined) {
      throw new Error('code not found');
    }

    const photoUrls = [
      `http://qr.snapai-vive.com/static/temp/${code}/SNAPAI.jpg`,
    ];
    const videoUrls = [
      `http://qr.snapai-vive.com/static/temp/${code}/SNAPAI.mp4`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// SHOTUP
  private async shotup(url): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(url));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const qrcode = url.split('qrcode=')[1];
    if (qrcode == undefined) {
      throw new Error('qrcode not found');
    }

    const photoUrls = [
      `https://durishot.net/api/download.php?qrcode=${qrcode}&type=P`,
    ];
    const videoUrls = [
      `https://durishot.net/api/download.php?qrcode=${qrcode}&type=V`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// munifilm
  private async munifilm(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const dom = new JSDOM('');
    const document = new dom.window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    // 이미지 링크 가져오기
    const img = document.querySelector('#imageToSave');
    const imgSrc = img.getAttribute('src');

    const photoUrls = [imgSrc];
    const videoUrls = [];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// GOOD PHOTO SHOP
  private async goodPhotoShop(url): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(url));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const code = url.split('/').pop();
    const filePath = 'https://selfphotostudio.kr/talk/download/file/';

    const photoUrls = [
      filePath + code + '_color.png',
      filePath + code + '_greyscale.png',
    ];
    const videoUrls = [filePath + code + '_timelapse.mp4'];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// youngchive
  private async youngchive(urlStr: string): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(urlStr));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const url = new URL(urlStr);

    const qrcode = url.searchParams.get('qrcode');
    if (qrcode == null) {
      throw new Error('qrcode not found');
    }

    const imageUrl = `https://kiosk.youngchive.com/api/download.php?qrcode=${qrcode}&type=P`;
    const videoUrl = `https://kiosk.youngchive.com/api/download.php?qrcode=${qrcode}&type=V`;

    // // 유효한 url인지 확인
    // const imgRes = await firstValueFrom(this.httpService.head(imageUrl));

    // const contentLength = Number(imgRes.headers['content-length']);
    // if (imgRes.status !== 200 || !contentLength) {
    //   throw new Error('invalid url or empty file');
    // }

    return {
      brand: '',
      photoUrls: [imageUrl],
      videoUrls: [videoUrl],
    };
  }

  // 포토하임
  private async photoHeim(url: string): Promise<BrandCrawl> {
    // 유효한 url인지 확인
    const res = await firstValueFrom(this.httpService.get(url));
    if (res.status != 200) {
      throw new Error('invalid url');
    }

    const qrcode = url.split('qrcode=')[1];
    if (qrcode == undefined) {
      throw new Error('qrcode not found');
    }

    const photoUrls = [
      `https://selfphotobox.com/api/download.php?qrcode=${qrcode}&type=P`,
    ];
    const videoUrls = [
      `https://selfphotobox.com/api/download.php?qrcode=${qrcode}&type=V`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }
}

type CrawlQrDto = {
  url: string;
};

type NotifyCrawlFailedDto = {
  url: string;
};

type NotifyBrandNotFoundDto = {
  url: string;
};
