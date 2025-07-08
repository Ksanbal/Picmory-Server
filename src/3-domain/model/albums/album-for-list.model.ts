import { Album, MemoryFile } from '@prisma/client';

export interface AlbumForListModel extends Album {
  memoryCount: number;
  lastMemoryFile?: MemoryFile;
}
