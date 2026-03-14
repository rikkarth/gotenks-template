import { useEffect, useState } from 'react';

import { getHealth } from './api';
import './styles.css';

type HealthState =
  | { kind: 'idle' }
  | { kind: 'loading' }
  | { kind: 'ready'; timestamp: string }
  | { kind: 'error'; message: string };

export const App = () => {
  const [health, setHealth] = useState<HealthState>({ kind: 'idle' });

  useEffect(() => {
    let cancelled = false;

    const loadHealth = async () => {
      setHealth({ kind: 'loading' });

      try {
        const data = await getHealth();

        if (cancelled) {
          return;
        }

        setHealth({ kind: 'ready', timestamp: data.timestamp });
      } catch (error) {
        if (cancelled) {
          return;
        }

        setHealth({
          kind: 'error',
          message: error instanceof Error ? error.message : 'Health request failed.',
        });
      }
    };

    // Check the backend on first load so the repo shows a working full-stack path immediately.
    void loadHealth();

    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <main className="page-shell">
      <section className="hero">
        <p className="eyebrow">AI App Baseline</p>
        <h1>Clone it, rename it, and start building your app.</h1>
        <p className="lede">
          This repo is a baseline, not a builder. It gives you React + TypeScript for the UI, validated
          Elysia routes for APIs, and a Bun workspace so you can start shaping a real product immediately.
        </p>
      </section>

      <section className="grid">
        <article className="panel panel-accent">
          <h2>What is included</h2>
          <ul className="feature-list">
            <li>Rsbuild React app with public env support</li>
            <li>Elysia backend with CORS and a health route</li>
            <li>Single `make dev` command for the full workspace</li>
          </ul>
        </article>

        <article className="panel">
          <h2>Backend status</h2>
          <p className="status">
            {health.kind === 'idle' && 'Waiting for check...'}
            {health.kind === 'loading' && 'Checking API health...'}
            {health.kind === 'ready' && `Healthy at ${new Date(health.timestamp).toLocaleTimeString()}`}
            {health.kind === 'error' && health.message}
          </p>
          <p className="supporting-copy">Edit this page first, then start adding your own routes in `apps/api/src`.</p>
        </article>
      </section>

      <section className="panel">
        <p className="eyebrow">Start Here</p>
        <h2>Minimal baseline, nothing more.</h2>
        <p className="supporting-copy">
          The frontend only verifies that the backend is reachable. The backend only exposes a health route.
          Add real features from here instead of deleting a lot of demo logic.
        </p>
        <p className="supporting-copy">
          Suggested first steps: rename the app, add your domain routes, then replace this page with your real UI.
        </p>
      </section>
    </main>
  );
};
