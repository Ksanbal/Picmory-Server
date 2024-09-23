import { ApiProperty } from '@nestjs/swagger';
import { IsString } from 'class-validator';

export class AlbumsUpdateReqDto {
  @ApiProperty()
  @IsString()
  name: string;
}
