const fallbackApiUrl = 'http://localhost:3001';

const apiUrl = import.meta.env.PUBLIC_API_URL ?? fallbackApiUrl;

export type HealthResponse = {
  service: 'api';
  status: 'ok';
  timestamp: string;
};

export const getHealth = async () => {
  const response = await fetch(`${apiUrl}/api/health`);

  if (!response.ok) {
    throw new Error(`Health request failed with status ${response.status}.`);
  }

  return (await response.json()) as HealthResponse;
};
