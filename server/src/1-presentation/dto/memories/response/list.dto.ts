import { ApiProperty } from '@nestjs/swagger';
import { MemoryFileType } from '@prisma/client';
import { Expose, Transform, Type } from 'class-transformer';

export class MemoriesFileRes {
  @ApiProperty()
  @Expose()
  type: MemoryFileType;

  @ApiProperty()
  @Expose()
  originalName: string;

  @ApiProperty()
  @Expose()
  size: number;

  @ApiProperty()
  @Expose()
  path: string;

  @ApiProperty()
  @Expose()
  thumbnailPath: string;
}

export class MemoriesListResDto {
  @ApiProperty()
  @Expose()
  id: number;

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
