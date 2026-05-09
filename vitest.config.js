import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    include: ['tests/**/*.test.js'],
    exclude: ['node_modules', 'tests/diag*.test.js', 'tests/debug*.test.js', 'tests/mock-test.test.js', 'tests/diagnostic.test.js'],
    environment: 'node',
    testTimeout: 10000,
    setupFiles: ['tests/setup.js'],
    server: {
      deps: {
        inline: ['@supabase/supabase-js'],
      },
    },
  },
});
