import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class AlbumsCreateReqDto {
  @ApiProperty()
  @IsString()
  name: string;
}
