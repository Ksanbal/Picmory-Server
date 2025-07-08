import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class MemioresCreateUploadUrlReqDto {
  @ApiProperty()
  @IsString()
  filename: string;
}
