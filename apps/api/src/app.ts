import { cors } from '@elysiajs/cors';
import { Elysia, t } from 'elysia';

import { env } from './env';

const healthResponse = t.Object({
  service: t.Literal('api'),
  status: t.Literal('ok'),
  timestamp: t.String(),
});

export const app = new Elysia({
  name: '@gotenks-template/api',
})
  .use(
    cors({
      origin: env.corsOrigin,
      credentials: true,
    }),
  )
  .group('/api', (api) =>
    api
      .get(
        '/health',
        () => ({
          service: 'api' as const,
          status: 'ok' as const,
          timestamp: new Date().toISOString(),
        }),
        {
          response: {
            200: healthResponse,
          },
          detail: {
            summary: 'Health check',
            description: 'Useful for local orchestration and deployment probes.',
          },
        },
      ),
  );
