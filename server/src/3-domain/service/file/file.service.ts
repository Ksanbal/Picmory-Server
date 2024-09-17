import { Injectable } from '@nestjs/common';
import * as sharp from 'sharp';
import * as fs from 'fs';

@Injectable()
export class FileService {
  /**
   * 썸네일 이미지 생성 및 저장
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<string | null> {
    const { filePath } = dto;

    try {
      const fileDir = filePath.slice(0, filePath.lastIndexOf('/'));
      const fileOriginalName = filePath
        .slice(filePath.lastIndexOf('/') + 1)
        .split('.')[0];

      const thumbnailPath = `${fileDir}/thumbnail-${fileOriginalName}.avif`;

      await sharp(dto.filePath).toFormat('avif').toFile(thumbnailPath);

      return thumbnailPath;
    } catch (error) {
      return null;
    }
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
