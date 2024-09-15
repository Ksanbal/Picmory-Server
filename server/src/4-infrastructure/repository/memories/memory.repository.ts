import { Injectable } from '@nestjs/common';
import { Memory, PrismaClient } from '@prisma/client';
import { ITXClientDenyList } from '@prisma/client/runtime/library';

@Injectable()
export class MemoryRepository {
  async create(dto: CreateDto): Promise<Memory | null> {
    return await dto.tx.memory.create({
      data: {
        memberId: dto.memberId,
        brandName: dto.brandName,
        date: dto.date,
      },
    });
  }
}

type CreateDto = {
  tx: Omit<PrismaClient, ITXClientDenyList>;
  memberId: number;
  brandName: string;
  date: Date;
};
