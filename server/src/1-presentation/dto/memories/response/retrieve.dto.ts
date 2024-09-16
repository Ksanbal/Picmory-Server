import { Expose, Type } from 'class-transformer';
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

  @Type(() => MemoriesFileRes)
  @Expose()
  MemoryFile: MemoriesFileRes[];
}
