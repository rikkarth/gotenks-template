const processes = [
  {
    name: 'api',
    child: Bun.spawn(['bun', 'run', '--cwd', 'apps/api', 'dev'], {
      stdin: 'inherit',
      stdout: 'inherit',
      stderr: 'inherit',
    }),
  },
  {
    name: 'web',
    child: Bun.spawn(['bun', 'run', '--cwd', 'apps/web', 'dev'], {
      stdin: 'inherit',
      stdout: 'inherit',
      stderr: 'inherit',
    }),
  },
];

let shuttingDown = false;

const stopAll = () => {
  if (shuttingDown) {
    return;
  }

  shuttingDown = true;

  // Kill sibling processes together so the workspace doesn't leave orphaned dev servers behind.
  for (const { child } of processes) {
    child.kill();
  }
};

process.on('SIGINT', stopAll);
process.on('SIGTERM', stopAll);

const firstExit = await Promise.race(
  processes.map(async ({ name, child }) => ({
    name,
    code: await child.exited,
  })),
);

stopAll();

if (firstExit.code !== 0) {
  console.error(`[${firstExit.name}] exited with code ${firstExit.code}`);
  process.exitCode = firstExit.code ?? 1;
}

await Promise.all(processes.map(async ({ child }) => child.exited));
