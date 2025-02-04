import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { MemoryCreatedDto } from 'src/1-presentation/dto/memories/event/memory-created.dto';
import { MemoryDeletedDto } from 'src/1-presentation/dto/memories/event/memory-deleted.dto';
import { MemoriesFacade } from 'src/2-application/facade/memories/memories.facade';
import { EVENT_NAMES } from 'src/lib/constants/event-names';

@Injectable()
export class MemoriesEventHandler {
  constructor(private readonly memoriesFacade: MemoriesFacade) {}

  @OnEvent(EVENT_NAMES.MEMORY_CREATED, { async: true })
  async handleMemoryCreated(dto: MemoryCreatedDto) {
    await this.memoriesFacade.createThumbnail({
      memory: dto.memory,
    });
  }

  @OnEvent(EVENT_NAMES.MEMORY_DELETED, { async: true })
  async handleMemoryDeleted(dto: MemoryDeletedDto) {
    await this.memoriesFacade.deleteStorageFiles({
      memoryFiles: dto.memoryFiles,
    });
  }
}
