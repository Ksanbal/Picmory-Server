import { ConfigModule } from '@nestjs/config';
import { Test, TestingModule } from '@nestjs/testing';
import { StorageClient } from 'src/4-infrastructure/client/storage/storage.client';

describe('StorageClient', () => {
  let storageClient: StorageClient;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          cache: true,
          isGlobal: true,
        }),
      ],
      providers: [StorageClient],
    }).compile();

    storageClient = module.get<StorageClient>(StorageClient);
  });

  it('should be defined', () => {
    expect(storageClient).toBeDefined();
  });

  describe('파일 업로드 URL 생성', () => {
    it('파일 업로드 URL 생성', async () => {
      // given
      const key = 'dump.jpg';
      const contentType = 'image/jpeg';

      // when
      const result = await storageClient.generatePresignedUrl(key, contentType);

      // then
      expect(typeof result).toBe('string');
    });
  });
});
