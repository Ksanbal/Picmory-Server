import puppeteer from 'puppeteer';

/// 브랜드명
export const brands = {
  /// 모노맨션
  'monomansion.net': { name: 'monomansion', func: monomansion },
  /// 포토랩+
  '3.37.14.138': { name: 'photo_lab_plus', func: null },
  /// 하루필름
  'haru8.mx2.co.kr': { name: 'harufilm', func: null },
  /// 포토 시그니처
  'photoqr2.kr': { name: 'photo_signature', func: photoqr2 },
  /// 플랜비 스튜디오
  '15.165.73.8': { name: 'plan_b_studio', func: null },
  /// 플레이 인 더 박스
  'playintheboxphoto.com': { name: 'play_in_the_box', func: null },
  /// 시현하다
  'frameoffical.cafe24.com': { name: 'sihyunhada', func: null },
  /// 비비드 뮤지엄
  'vividmuseum.co.kr': { name: 'vivid_museum', func: null },
  /// 인생네컷
  'l4c01.lifejuin.biz': { name: 'life_four_cut', func: null },
  /// 포토그레이
  'pgshort.aprd.io': { name: 'photogray', func: photogray },
  /// 셀픽스
  'photoace.co.kr': { name: 'selpix', func: selpix },
  /// 포토이즘
  'qr.seobuk.kr': { name: 'photoism', func: seobuk },
  /// 픽닷
  'picdot.kr': { name: 'picdot', func: picdot },
};

/// 모노맨션 다운로드 링크
async function monomansion(url) {
  const res = await fetch(url);
  const html = await res.text();
  const document = new DOMParser().parseFromString(html, 'text/html');

  const aList = document.querySelectorAll('a');

  // https://monomansion.net/api/download.php?qrcode=Y8X3FY21ePx9NvE2fC&type=P
  // ./download.php?qrcode=Y8X3FY21ePx9NvE2fC&type=P
  // 사진 다운로드 링크
  const photoHref = aList[0].getAttribute('href');
  const photo = [`https://monomansion.net/api/${photoHref.split('./')[1]}`];

  // 영상 다운로드 링크
  const videoHref = aList[1].getAttribute('href');
  const video = [`https://monomansion.net/api/${videoHref.split('./')[1]}`];

  return { photo, video };
}

/// 포토 시그니처 다운로드 링크
async function photoqr2(url) {
  const path = url.split('index.html')[0];
  // 사진 다운로드 링크
  const photo = [path + 'a.jpg'];

  // 영상 다운로드 링크
  const video = [path + 'output.mp4'];

  return { photo, video };
}

/// 포토 그레이
async function photogray(url) {
  const res = await fetch(url, { redirect: 'manual' });

  const redirectUrl = res.headers.get('location');

  // url에서 id 추출
  const id = redirectUrl.split('id=')[1];

  // id 값을 base64로 디코딩 && sessionId 추출
  const decodedId = atob(id).split('sessionId=')[1].split('&mode')[0];

  const photo = [`https://pg-qr-resource.aprd.io/${decodedId}/image.jpg`];
  const video = [
    `https://pg-qr-resource.aprd.io/${decodedId}/video.mp4`,
    `https://pg-qr-resource.aprd.io/${decodedId}/timelapse.mp4`,
  ];

  return { photo, video };
}

/// 셀픽스
async function selpix(url) {
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();

  await page.goto(url, {
    waitUntil: 'networkidle2',
  });

  const data = await page.$('#root > div > div > div:nth-child(4) > img');

  const photo = [
    await page.evaluate((element) => {
      return element.src;
    }, data),
  ];

  const video = [photo.replace('image.jpg', 'video.mp4')];

  await page.close();
  await browser.close();

  return { photo, video };
}

/// 포토이즘
async function seobuk(url) {
  const browser = await puppeteer.launch({
    headless: true,
  });
  const page = await browser.newPage();

  // 네트워크 요청 감지
  let resource;
  page.on('response', async (response) => {
    const reqUrl = response.url();
    if (reqUrl.includes('resource') && response.request().method() == 'POST') {
      resource = await response.json();
    }
  });

  await page.goto(url, {
    waitUntil: 'networkidle2',
  });

  const photo = [resource.content.fileInfo.picFile.path];
  const video = [resource.content.fileInfo.vidFile.path];

  await page.close();
  await browser.close();

  return { photo, video };
}

/// 픽닷
async function picdot(url) {
  const qrcode = url.split('qrcode=')[1];

  const photo = [`https://picdot.kr/api/download.php?qrcode=${qrcode}&type=P`];
  const video = [`https://picdot.kr/api/download.php?qrcode=${qrcode}&type=V`];

  return { photo, video };
}
