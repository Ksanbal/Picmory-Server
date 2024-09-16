import { MemoryFileType } from '@prisma/client';
import { Expose, Type } from 'class-transformer';

export class MemoriesFileRes {
  @Expose()
  type: MemoryFileType;

  @Expose()
  originalName: string;

  @Expose()
  size: number;

  @Expose()
  path: string;

  @Expose()
  thumbnailPath: string;
}

export class MemoriesListResDto {
  @Expose()
  id: number;

  @Expose()
  date: Date;

  @Expose()
  brandName: string;

  @Expose()
  like: boolean;

  @Type(() => MemoriesFileRes)
  @Expose()
  MemoryFile: MemoriesFileRes[];
}
