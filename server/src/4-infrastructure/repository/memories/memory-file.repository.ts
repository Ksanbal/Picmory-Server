import { Injectable } from '@nestjs/common';
import { MemoryFile, MemoryFileType } from '@prisma/client';
import { PrismaService } from 'src/lib/database/prisma.service';

@Injectable()
export class MemoryFileRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateDto): Promise<MemoryFile> {
    return await this.prisma.memoryFile.create({
      data: {
        memoryId: null,
        thumbnailPath: null,
        ...dto,
      },
    });
  }
}

type CreateDto = {
  memberId: number;
  type: MemoryFileType;
  originalName: string;
  size: number;
  path: string;
};
