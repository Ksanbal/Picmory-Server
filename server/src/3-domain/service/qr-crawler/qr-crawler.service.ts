import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import puppeteer from 'puppeteer';
import { Brand } from 'src/3-domain/model/qr-cralwer/brand.model';
import { BrandCrawl } from 'src/3-domain/model/qr-cralwer/crawl-result.model';
import { ERROR_MESSAGES } from 'src/lib/constants/error-messages';
import { JSDOM } from 'jsdom';

@Injectable()
export class QrCrawlerService {
  constructor() {}

  brands: Brand[] = [
    {
      // 모노맨션
      name: 'Mono mansion',
      host: 'monomansion.net',
    },
    {
      // 하루필름
      name: 'HARUFILM',
      host: 'haru2.mx2.co.kr',
    },
    {
      // 포토 시그니처
      name: 'PHOTO SIGNATURE',
      host: 'photoqr2.kr',
    },
    {
      // 플랜비 스튜디오
      name: 'PLAN.B STUDIO',
      host: '3.37.14.138',
    },
    {
      // 비비드 뮤지엄
      name: 'VIVID MUSEUM',
      host: 'vividmuseum.co.kr',
    },
    {
      // 인생네컷
      name: '인생네컷',
      host: 'api.life4cut.net',
    },
    {
      // 포토그레이
      name: 'PHOTOGRAY',
      host: 'pgshort.aprd.io',
    },
    {
      // 포토에이스
      name: 'PhotoAce',
      host: 'photoace.co.kr',
    },
    {
      // 포토이즘
      name: 'photoism',
      host: 'qr.seobuk.kr',
    },
    {
      // 픽닷
      name: 'picdot',
      host: 'picdot.kr',
    },
    {
      // 폴라 스튜디오
      name: 'POLA STUDIO',
      host: '13.125.146.152',
    },
    {
      // 돈룩업
      name: "DON'T LXXK UP",
      host: 'x.dontlxxkup.kr',
    },
    {
      // 그믐달 셀프 스튜디오
      name: 'oldmoon',
      host: 'oldmoonstudio.co.kr',
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
  ];

  /**
   * 지원하는 브랜드 리스트 조회
   */
  getBrands(): Brand[] {
    return this.brands;
  }

  /**
   * QR 링크 크롤링 요청
   */
  async crawlQr(dto: CrawlQrDto): Promise<BrandCrawl> {
    const { url } = dto;

    // 지원하는 브랜드인지 확인
    const brand = this.brands.find((brand) => url.includes(brand.host));
    if (brand == undefined) {
      throw new BadRequestException(ERROR_MESSAGES.QR_CRAWLER_NOT_SUPPORTED);
    }

    try {
      let result: BrandCrawl;
      switch (brand.name) {
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
        // case 'Selpix':
        //   result = await this.selfix(url);
        //   break;
        case 'PhotoHub':
          result = await this.photoHub(url);
          break;
      }

      result.brand = brand.name;

      return result;
    } catch (error) {
      console.error(error);
      throw new ConflictException(ERROR_MESSAGES.QR_CRAWLER_UNKOWN_ERROR);
    }
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
    const document = new new JSDOM('').window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    // 사진 다운로드 링크
    const photoHref = aList[0].getAttribute('href');
    const photoUrls = [
      `https://monomansion.net/api/${photoHref.split('./')[1]}`,
    ];

    // 영상 다운로드 링크
    const videoHref = aList[1].getAttribute('href');
    const videoUrls = [
      `https://monomansion.net/api/${videoHref.split('./')[1]}`,
    ];

    return {
      brand: '',
      photoUrls,
      videoUrls,
    };
  }

  /// 하루필름
  private async haruFilm(url): Promise<BrandCrawl> {
    const res = await fetch(url);
    const html = await res.text();
    const document = new new JSDOM('').window.DOMParser().parseFromString(
      html,
      'text/html',
    );

    const aList = document.querySelectorAll('a');

    // 영상 다운로드 링크
    const videoHref = 'http://haru2.mx2.co.kr' + aList[0].getAttribute('href');
    const videoUrls = [videoHref];

    // 사진 다운로드 링크
    const photoHref = 'http://haru2.mx2.co.kr' + aList[1].getAttribute('href');
    const photoUrls = [photoHref];

    // 보너스 이미지 다운로드
    if (2 < aList.length) {
      const bonusHref =
        'http://haru2.mx2.co.kr' + aList[2].getAttribute('href');
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
    const videoUrls = [path + 'output.mp4'];

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

    const id = url.split('id=')[1];

    const photoUrls = [`http://3.37.14.138/take/${id}.jpg`];
    const videoUrls = [`http://3.37.14.138/take/${id}.mp4`];

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
    const document = new new JSDOM('').window.DOMParser().parseFromString(
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
    const qrcode = url.split('qrcode=')[1];

    const photoUrls = [
      `https://picdot.kr/api/download.php?qrcode=${qrcode}&type=P`,
    ];
    const videoUrls = [
      `https://picdot.kr/api/download.php?qrcode=${qrcode}&type=V`,
    ];

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
    const document = new new JSDOM('').window.DOMParser().parseFromString(
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
    const document = new new JSDOM('').window.DOMParser().parseFromString(
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
}

type CrawlQrDto = {
  url: string;
};
