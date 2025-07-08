import { IsBoolean, IsInt, IsOptional, ValidateIf } from 'class-validator';
import { PaginationDto } from '../../common/pagination.dto';
import { Transform } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

export class MemoriesListReqDto extends PaginationDto {
  @ApiProperty({
    required: false,
  })
  // 좋아요 여부
  @IsOptional()
  @IsBoolean()
  @ValidateIf((o) => o.albumId !== undefined)
  @Transform(({ value }) => value === 'true')
  like: boolean | null = null;

  // 앨범 아이디
  @ApiProperty({
    required: false,
  })
  @IsOptional()
  @IsInt()
  @ValidateIf((o) => o.like !== undefined)
  @Transform(({ value }) => Number(value))
  albumId: number | null = null;
}
