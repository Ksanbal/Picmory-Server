import { Type } from 'class-transformer';
import { IsBoolean, IsDate, IsOptional, IsString } from 'class-validator';

export class MemoriesUpdateReqDto {
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  date: Date | null;

  @IsOptional()
  @IsString()
  brandName: string | null;

  @IsOptional()
  @IsBoolean()
  like: boolean | null;
}
