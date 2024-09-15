import { Injectable } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { FileCreatedDto } from 'src/1-presentation/dto/memories/event/file-created.dto';
import { MemoriesFacade } from 'src/2-application/facade/memories/memories.facade';
import { EVENT_NAMES } from 'src/lib/constants/event-names';

@Injectable()
export class MemoriesEventHandler {
  constructor(private readonly memoriesFacade: MemoriesFacade) {}

  @OnEvent(EVENT_NAMES.MEMORIES_FILE_CREATED, { async: true })
  async handleFileCreated(dto: FileCreatedDto) {
    await this.memoriesFacade.createThumbnail({
      memoryFile: dto.memoryFile,
    });
  }
}
