import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsDate, IsString } from 'class-validator';

export class MemoriesCreateReqDto {
  @ApiProperty({
    type: [String],
  })
  @IsString({ each: true })
  fileKeys: string[];

  @ApiProperty()
  @IsDate()
  @Type(() => Date)
  date: Date;

  @ApiProperty()
  @IsString()
  brandName: string;
}
