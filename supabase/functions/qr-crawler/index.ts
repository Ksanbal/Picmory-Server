import { DOMParser } from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

/// 모노맨션 다운로드 링크
async function monomansion(url: string) {
  const res = await fetch(url);
  const html = await res.text();
  const document: any = new DOMParser().parseFromString(html, "text/html");

  const aList = document.querySelectorAll("a");

  // https://monomansion.net/api/download.php?qrcode=Y8X3FY21ePx9NvE2fC&type=P
  // ./download.php?qrcode=Y8X3FY21ePx9NvE2fC&type=P
  // 사진 다운로드 링크
  const photoHref = aList[0].getAttribute("href");
  const photo = `https://monomansion.net/api/${photoHref.split("./")[1]}`;

  // 영상 다운로드 링크
  const videoHref = aList[1].getAttribute("href");
  const video = `https://monomansion.net/api/${videoHref.split("./")[1]}`;

  return [photo, video];
}

/// 포토 시그니처 다운로드 링크
function photoqr2(url: string) {
  const path = url.split("index.html")[0];
  // 사진 다운로드 링크
  const photo = path + "a.jpg";

  // 영상 다운로드 링크
  const video = path + "output.mp4";

  return [photo, video];
}

/// 포토 그레이
async function photogray(url: string) {
  const res = await fetch(url, { redirect: "manual" });

  const redirectUrl = res.headers.get("location");

  // url에서 id 추출
  const id = redirectUrl!.split("id=")[1];

  // id 값을 base64로 디코딩 && sessionId 추출
  const decodedId = atob(id).split("sessionId=")[1].split("&mode")[0];

  // const photo = [`https://pg-qr-resource.aprd.io/${decodedId}/image.jpg`];
  // const video = [
  //   `https://pg-qr-resource.aprd.io/${decodedId}/video.mp4`,
  //   `https://pg-qr-resource.aprd.io/${decodedId}/timelapse.mp4`,
  // ];
  const photo = `https://pg-qr-resource.aprd.io/${decodedId}/image.jpg`;
  const video = `https://pg-qr-resource.aprd.io/${decodedId}/video.mp4`;

  return [photo, video];
}

/// 호스트 목록
const hosts = {
  /// 모노맨션
  "monomansion.net": monomansion,
  /// 포토랩+
  "3.37.14.138": null,
  /// 하루필름
  "haru8.mx2.co.kr": null,
  /// 포토 시그니처
  "photoqr2.kr": photoqr2,
  /// 플랜비 스튜디오
  "15.165.73.8": null,
  /// 플레이 인 더 박스
  "playintheboxphoto.com": null,
  /// 시현하다
  "frameoffical.cafe24.com": null,
  /// 비비드 뮤지엄
  "vividmuseum.co.kr": null,
  /// 인생네컷
  "l4c01.lifejuin.biz": null,
  /// 포토그레이
  "pgshort.aprd.io": photogray,
};

const brands = {
  /// 모노맨션
  "monomansion.net": "monomansion",
  /// 포토랩+
  "3.37.14.138": "photo_lab_plus",
  /// 하루필름
  "haru8.mx2.co.kr": "harufilm",
  /// 포토 시그니처
  "photoqr2.kr": "photo_signature",
  /// 플랜비 스튜디오
  "15.165.73.8": "plan_b_studio",
  /// 플레이 인 더 박스
  "playintheboxphoto.com": "play_in_the_box",
  /// 시현하다
  "frameoffical.cafe24.com": "sihyunhada",
  /// 비비드 뮤지엄
  "vividmuseum.co.kr": "vivid_museum",
  /// 인생네컷
  "l4c01.lifejuin.biz": "life_four_cut",
  /// 포토그레이
  "pgshort.aprd.io": "photogray",
};

console.log("Hello from Functions!");

Deno.serve(async (req: Request) => {
  try {
    const { url } = await req.json();

    // url 파라미터가 없을 경우
    if (url === null) {
      return new Response(
        JSON.stringify({
          message: "url 파라미터가 없습니다",
        }),
        {
          status: 400,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    // request를 request_log 테이블에 저장
    if (Deno.env.get('SUPABASE_URL')) {
      const res = await fetch(url, { redirect: "manual" });
      const document = await res.text();
      const supabase = createClient(
        Deno.env.get('SUPABASE_URL'), 
        Deno.env.get('SUPABASE_ANON_KEY')
      )
      await supabase.from("request_log").insert(
        [
          {
            url,
            res: { status: res.status, headers: [...res.headers] },
            document,
          },
        ]
      );
    }

    // 호스트로 브랜드 구분 및 브랜드별 함수 호출
    const reqHost = url?.split("/")[2];
    const brand = brands[reqHost];
    const brandFunc = hosts[reqHost];

    if (brandFunc === undefined || brandFunc === null) {
      return new Response(
        JSON.stringify({
          message: "아직 지원하지 않는 브랜드입니다.",
        }),
        {
          status: 400,
          headers: { "Content-Type": "application/json" },
        }
      );
    }

    const [photo, video] = await hosts[reqHost](url);

    return new Response(
      JSON.stringify({
        brand,
        photo,
        video,
      }),
      { headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error(error);
    return new Response(
      JSON.stringify({
        message: "오류가 발생하였습니다. 다시 시도해주세요.",
      }),
      { status: 400 }
    );
  }
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/qr-crawler' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
