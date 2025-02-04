import { Injectable } from '@nestjs/common';
import * as sharp from 'sharp';
import * as fs from 'fs';
import { StorageClient } from 'src/4-infrastructure/client/storage/storage.client';

@Injectable()
export class FileService {
  constructor(private readonly storageClient: StorageClient) {}

  /**
   * 썸네일 이미지 생성 및 저장
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<string | null> {
    const { filePath } = dto;

    try {
      // 스토리지에서 이미지 가져오기
      const imgStream = await this.storageClient.getObject({ key: filePath });
      const imgBuffer = await this.streamToBuffer(imgStream);

      // 썸네일 경로
      const fileDir = filePath.slice(0, filePath.lastIndexOf('/'));
      const fileOriginalName = filePath
        .slice(filePath.lastIndexOf('/') + 1)
        .split('.')[0];
      const thumbnailPath = `${fileDir}/thumbnail-${fileOriginalName}.avif`;

      // 썸네일 생성
      const thumbnailBuffer = await sharp(imgBuffer)
        .withMetadata()
        .toFormat('avif')
        .toBuffer();

      await this.storageClient.putObjectWithBuffer({
        key: thumbnailPath,
        buffer: thumbnailBuffer,
        contentType: 'image/avif',
      });

      return thumbnailPath;
    } catch (error) {
      return null;
    }
  }

  // 스트림을 버퍼로 변환
  private async streamToBuffer(stream: any): Promise<Buffer> {
    return new Promise((resolve, reject) => {
      const chunks: any[] = [];
      stream.on('data', (chunk: any) => chunks.push(chunk));
      stream.on('end', () => resolve(Buffer.concat(chunks)));
      stream.on('error', reject);
    });
  }

  /**
   * 파일 삭제
   */
  async delete(dto: DeleteDto): Promise<void> {
    const { filePaths } = dto;

    for (const filePath of filePaths) {
      try {
        fs.rmSync(filePath);
      } catch (error) {
        console.error('Error during delete files: ', error, filePath);
      }
    }
  }
}

type CreateThumbnailDto = {
  filePath: string;
};

type DeleteDto = {
  filePaths: string[];
};
