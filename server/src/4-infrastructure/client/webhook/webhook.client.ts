import { HttpService } from '@nestjs/axios';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { firstValueFrom } from 'rxjs';

@Injectable()
export class WebhookClient {
  constructor(
    private readonly configService: ConfigService,
    private readonly httpService: HttpService,
  ) {}

  async send(dto: WebhookSendDto): Promise<boolean> {
    const { title, content, color } = dto;

    const result = await firstValueFrom(
      this.httpService.post(this.configService.get('DISCORD_WEB_HOOK_URL'), {
        username: 'Picmory',
        embeds: [
          {
            title,
            content,
            description: content,
            color: color ?? WebhookColor.PRIMARY,
            timestamp: new Date().toISOString(),
          },
        ],
      }),
    );

    const isSuccess = result.status === 204;

    return isSuccess;
  }
}

type WebhookSendDto = {
  title?: string;
  content: string;
  color?: number;
};

export enum WebhookColor {
  PRIMARY = 0x295bff,
  NEGATIVE = 0xf37777,
}
