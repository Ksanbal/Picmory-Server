import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsBoolean, IsDate, IsOptional, IsString } from 'class-validator';

export class MemoriesUpdateReqDto {
  @ApiProperty({
    required: false,
  })
  @IsOptional()
  @IsDate()
  @Type(() => Date)
  date: Date | null;

  @ApiProperty({
    required: false,
  })
  @IsOptional()
  @IsString()
  brandName: string | null;

  @ApiProperty({
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  like: boolean | null;
}
