import { Expose, Transform, Type } from 'class-transformer';
import { MemoriesFileRes } from './list.dto';
import { ApiProperty } from '@nestjs/swagger';

export class MemoriesRetrieveResDto {
  @ApiProperty()
  @Expose()
  id: number;

  @ApiProperty()
  @Expose()
  createdAt: Date;

  @ApiProperty()
  @Expose()
  date: Date;

  @ApiProperty()
  @Expose()
  brandName: string;

  @ApiProperty()
  @Expose()
  like: boolean;

  @ApiProperty({
    type: [MemoriesFileRes],
  })
  @Transform(({ obj }) => obj.MemoryFile)
  @Type(() => MemoriesFileRes)
  @Expose()
  files: MemoriesFileRes[];
}
