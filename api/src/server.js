import Fastify from 'fastify';
import ngrok from '@ngrok/ngrok';
import 'dotenv/config';

import { brands } from './brands.js';

const app = Fastify({
  logger: true,
});

// Declare a route
app.route({
  method: 'GET',
  url: '/api/qr-crawler',
  schema: {
    querystring: {
      type: 'object',
      properties: {
        url: { type: 'string' },
      },
      required: ['url'],
    },
    response: {
      200: {
        type: 'object',
        properties: {
          brand: { type: 'string' },
          photo: { type: 'array', items: { type: 'string' } },
          video: { type: 'array', items: { type: 'string' } },
        },
      },
    },
  },
  handler: async (request, reply) => {
    const { url } = request.query;

    // 호스트로 브랜드 구분 및 브랜드별 함수 호출
    const reqHost = url?.split('/')[2];
    const brand = brands[reqHost];

    if (!brand) {
      return reply.code(404).send({ message: 'Not Found' });
    }

    const result = await brand.func(url);

    return {
      brand: brand.name,
      ...result,
    };
  },
});

// Run the server!
try {
  await app.listen({ port: 3000 }, async function () {
    if (process.env.NODE_ENV == 'production') {
      const listener = await ngrok.connect({
        addr: 3000,
        authtoken: process.env.NGROK_AUTH_TOKEN,
        domain: process.env.NGROK_DOMAIN,
      });

      console.log(`Ingress established at: ${listener.url()}`);
    }

    if (process.send) {
      process.send('ready');
    }
  });

  process.on('SIGINT', async function () {
    await app.close();
    console.log('server closed');
    process.exit(0); // 정상 종료
  });
} catch (err) {
  app.log.error(err);
  process.exit(1);
}
