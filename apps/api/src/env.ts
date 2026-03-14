const DEFAULT_PORT = 3001;
const DEFAULT_CORS_ORIGIN = 'http://localhost:3000';

const parsePort = (value: string | undefined) => {
  if (!value) {
    return DEFAULT_PORT;
  }

  const port = Number(value);

  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error(`API_PORT must be an integer between 1 and 65535. Received: ${value}`);
  }

  return port;
};

const parseCorsOrigin = (value: string | undefined) => {
  if (!value) {
    return DEFAULT_CORS_ORIGIN;
  }

  try {
    return new URL(value).origin;
  } catch {
    throw new Error(`API_CORS_ORIGIN must be a valid URL. Received: ${value}`);
  }
};

export const env = {
  port: parsePort(process.env.API_PORT),
  corsOrigin: parseCorsOrigin(process.env.API_CORS_ORIGIN),
} as const;
