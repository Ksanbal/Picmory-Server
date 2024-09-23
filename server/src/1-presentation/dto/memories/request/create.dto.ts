import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsDate, IsInt, IsString } from 'class-validator';

export class MemoriesCreateReqDto {
  @ApiProperty({
    type: [Number],
  })
  @IsInt({ each: true })
  fileIds: number[];

  @ApiProperty()
  @IsDate()
  @Type(() => Date)
  date: Date;

  @ApiProperty()
  @IsString()
  brandName: string;
}
