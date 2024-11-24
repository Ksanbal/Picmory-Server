import { ApiProperty } from '@nestjs/swagger';
import { Expose, Transform } from 'class-transformer';

export class AlbumsRetrieveResDto {
  @ApiProperty()
  @Expose()
  id: number;

  @ApiProperty()
  @Expose()
  name: string;

  @ApiProperty()
  @Expose()
  memoryCount: number;

  @ApiProperty({
    nullable: true,
  })
  @Expose()
  @Transform(({ obj }) => {
    const { lastMemoryFile } = obj;

    if (lastMemoryFile != null) {
      return lastMemoryFile.thumbnailPath != null
        ? lastMemoryFile.thumbnailPath
        : lastMemoryFile.path;
    }

    return null;
  })
  coverImagePath: string | null;
}
