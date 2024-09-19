import { Type } from 'class-transformer';
import { IsDate, IsInt, IsString } from 'class-validator';

export class MemoriesCreateReqDto {
  @IsInt({ each: true })
  fileIds: number[];

  @IsDate()
  @Type(() => Date)
  date: Date;

  @IsString()
  brandName: string;
}
