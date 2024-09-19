import { IsInt } from 'class-validator';

export class AblumsAddMemoriesReqDto {
  @IsInt({ each: true })
  ids: number[];
}
