import { defineConfig } from '@wagmi/cli'
import { foundry, react } from '@wagmi/cli/plugins'

export default defineConfig({
  out: 'src/utils/generated.ts',
  contracts: [],
  plugins: [
    foundry({
      artifacts: '../contracts/out/',
    }),
    react(),
  ],
})
