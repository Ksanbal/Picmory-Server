import { Album, MemoryFile } from '@prisma/client';

export interface AlbumModel extends Album {
  memoryCount: number;
  lastMemoryFile?: MemoryFile;
}
