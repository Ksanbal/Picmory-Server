import { ApiProperty } from '@nestjs/swagger';
import { UserProvider } from 'src/lib/enums/user-provider.enum';
import { Expose } from 'class-transformer';

export class MembersGetMeResDto {
  @ApiProperty()
  @Expose()
  id: number;

  @ApiProperty()
  @Expose()
  createdAt: Date;

  @ApiProperty()
  @Expose()
  providerId: string;

  @ApiProperty({
    enum: UserProvider,
  })
  @Expose()
  provider: UserProvider;

  @ApiProperty()
  @Expose()
  email: string;

  @ApiProperty()
  @Expose()
  name: string;

  @ApiProperty()
  @Expose()
  isAdmin: boolean;
}
