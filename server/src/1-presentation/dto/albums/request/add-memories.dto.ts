import { IsInt } from 'class-validator';

export class AblumsAddMemoriesReqDto {
  @IsInt()
  memoryId: number;
}
