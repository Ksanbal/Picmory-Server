import { UserProvider } from '@prisma/client';
import { Expose } from 'class-transformer';

export class MembersGetMeResDto {
  @Expose()
  id: number;

  @Expose()
  createdAt: Date;

  @Expose()
  providerId: string;

  @Expose()
  provider: UserProvider;

  @Expose()
  email: string;

  @Expose()
  name: string;

  @Expose()
  isAdmin: boolean;
}
