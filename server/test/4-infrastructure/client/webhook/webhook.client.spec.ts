import { HttpModule } from '@nestjs/axios';
import { ConfigModule } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { WebhookClient } from 'src/4-infrastructure/client/webhook/webhook.client';

describe('WebhookClient', () => {
  let webhookClient: WebhookClient;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          cache: true,
          isGlobal: true,
        }),
        HttpModule,
      ],
      providers: [WebhookClient],
    }).compile();

    webhookClient = module.get<WebhookClient>(WebhookClient);
  });

  it('should be defined', () => {
    expect(webhookClient).toBeDefined();
  });

  describe('webhook 발송', () => {
    it('일반 알림 발송', async () => {
      // given
      const title = '[테스트] 그냥 한번 보내봤어요ㅎ';
      const content =
        '일반 알림은 어떻게 가나 볼까요?\n[링크?](https://github.com/Ksanbal/Picmory)';

      // when
      const result = await webhookClient.send({ title, content });

      // then
      expect(result).toBe(true);
    });

    it('에러 메세지 발송', async () => {
      // given
      const title = '[테스트] 으아아 에러났다아';
      const content =
        '에러가 난 상황을 테스트 하고 있어요!!\n[링크?](https://github.com/Ksanbal/Picmory)';
      const color = 0xf37777;

      // when
      const result = await webhookClient.send({ title, content, color });

      // then
      expect(result).toBe(true);
    });
  });
});
