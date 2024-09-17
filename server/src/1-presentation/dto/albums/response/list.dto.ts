import { Expose, Transform } from 'class-transformer';

export class AlbumsListResDto {
  @Expose()
  id: number;

  @Expose()
  name: string;

  @Expose()
  memoryCount: number;

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
