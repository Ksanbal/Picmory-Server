import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { MemoryFileType } from 'src/lib/enums/memory-file-type.enum';

export class MemoriesUploadReqDto {
  @ApiProperty({
    required: true,
    enum: MemoryFileType,
  })
  @IsEnum(MemoryFileType)
  type: MemoryFileType;
}
