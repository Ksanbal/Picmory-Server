import { IsBoolean, IsInt, IsOptional, ValidateIf } from 'class-validator';
import { PaginationDto } from '../../common/pagination.dto';
import { Transform } from 'class-transformer';

export class MemoriesListReqDto extends PaginationDto {
  // 좋아요 여부
  @IsOptional()
  @IsBoolean()
  @ValidateIf((o) => o.albumId !== undefined)
  @Transform(({ value }) => value === 'true')
  like: boolean | null = null;

  // 앨범 아이디
  @IsOptional()
  @IsInt()
  @ValidateIf((o) => o.like !== undefined)
  @Transform(({ value }) => Number(value))
  albumId: number | null = null;
}
