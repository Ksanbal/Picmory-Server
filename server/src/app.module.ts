import { Module } from '@nestjs/common';
import { AuthModule } from './module/auth/auth.module';
import { ConfigModule } from '@nestjs/config';
import { MembersModule } from './module/members/members.module';
import { MemoriesModule } from './module/memories/memories.module';
import { EventEmitterModule } from '@nestjs/event-emitter';

@Module({
  imports: [
    ConfigModule.forRoot({
      cache: true,
      isGlobal: true,
    }),
    EventEmitterModule.forRoot(),
    AuthModule,
    MembersModule,
    MemoriesModule,
  ],
})
export class AppModule {}
