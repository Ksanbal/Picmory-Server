import { Type } from 'class-transformer';
import { IsArray, IsDate, IsString } from 'class-validator';

export class MemoriesCreateReqDto {
  @IsArray()
  fileIds: number[];

  @IsDate()
  @Type(() => Date)
  date: Date;

  @IsString()
  brandName: string;
}
