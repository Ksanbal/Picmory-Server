import { Injectable } from '@nestjs/common';
import { Brand } from 'src/3-domain/model/qr-cralwer/brand.model';

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
    {
      // selpix
      name: 'Selpix',
      host: '14.63.225.67',
    },
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
}
