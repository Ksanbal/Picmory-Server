import { ApiProperty } from '@nestjs/swagger';
import { MemoryFileType } from '@prisma/client';
import { IsEnum } from 'class-validator';

export class MemoriesUploadReqDto {
  @ApiProperty({
    required: true,
    type: MemoryFileType,
  })
  @IsEnum(MemoryFileType)
  type: MemoryFileType;
}
