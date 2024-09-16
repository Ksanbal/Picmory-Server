import { Transform } from 'class-transformer';
import { IsInt, IsOptional } from 'class-validator';

export class PaginationDto {
  // 페이지 번호
  @IsOptional()
  @IsInt()
  @Transform(({ value }) => Number(value))
  page: number = 1;

  // 페이지 당 아이템 수
  @IsOptional()
  @IsInt()
  @Transform(({ value }) => Number(value))
  limit: number = 20;
}
