import { PutObjectCommand, S3Client } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class StorageClient {
  constructor(private readonly configService: ConfigService) {}

  private getS3Client() {
    return new S3Client({
      region: 'auto',
      endpoint: this.configService.get('AWS_S3_ENDPOINT'),
      credentials: {
        accessKeyId: this.configService.get('AWS_ACCESS_KEY_ID'),
        secretAccessKey: this.configService.get('AWS_SECRET_ACCESS_KEY'),
      },
    });
  }

  // 업로드 URL 생성
  async generatePresignedUrl(dto: GeneratePresignedUrlDto) {
    const command = new PutObjectCommand({
      Bucket: this.configService.get('AWS_S3_BUCKET_NAME'),
      Key: dto.key,
      ContentType: dto.contentType,
    });

    const url = await getSignedUrl(this.getS3Client(), command, {
      expiresIn: dto.expiresIn,
    });
    return url;
  }
}

type GeneratePresignedUrlDto = {
  key: string;
  contentType: string;
  expiresIn: number;
};
