import { Expose, Transform, Type } from 'class-transformer';
import { MemoriesFileRes } from './list.dto';

export class MemoriesRetrieveResDto {
  @Expose()
  id: number;

  @Expose()
  createdAt: Date;

  @Expose()
  date: Date;

  @Expose()
  brandName: string;

  @Expose()
  like: boolean;

  @Transform(({ obj }) => obj.MemoryFile)
  @Type(() => MemoriesFileRes)
  @Expose()
  files: MemoriesFileRes[];
}
