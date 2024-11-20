import { Injectable } from '@nestjs/common';
import * as sharp from 'sharp';
import * as fs from 'fs';
import { MemoryFileType } from '@prisma/client';
import * as ffmpeg from 'fluent-ffmpeg';

@Injectable()
export class FileService {
  /**
   * 썸네일 이미지 생성 및 저장
   */
  async createThumbnail(dto: CreateThumbnailDto): Promise<string | null> {
    const { filePath, type } = dto;

    try {
      const fileDir = filePath.slice(0, filePath.lastIndexOf('/'));
      const fileOriginalName = filePath
        .slice(filePath.lastIndexOf('/') + 1)
        .split('.')[0];

      let thumbnailPath = null;

      if (type == MemoryFileType.IMAGE) {
        thumbnailPath = `${fileDir}/thumbnail-${fileOriginalName}.avif`;

        await sharp(dto.filePath).toFormat('avif').toFile(thumbnailPath);
      } else if (type == MemoryFileType.VIDEO) {
        // 썸네일 이미지 생성
        await new Promise<void>((resolve, reject) => {
          ffmpeg(filePath)
            .on('end', () => {
              resolve();
            })
            .on('error', (err) => {
              reject(err);
            })
            .screenshots({
              timestamps: [1],
              filename: `thumbnail-${fileOriginalName}.avif`,
              folder: fileDir,
            });
        });
        thumbnailPath = `${fileDir}/thumbnail-${fileOriginalName}.avif`;
      }

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
  type: MemoryFileType;
};

type DeleteDto = {
  filePaths: string[];
};
