# TypeScript Nix Flake Template

A reproducible TypeScript development environment using Nix flakes and Node.js with comprehensive tooling support.

## Quick Start

```sh
nix develop
# or with direnv:
direnv allow
```

### Automatic Environment Setup

When you enter the devShell (via `direnv allow` or `nix develop`), the following happens automatically:

✓ **Git Repository**: Initializes `.git` if not present
✓ **npm Cache**: Sets up a local `.npm-cache` directory for dependencies
✓ **Welcome Banner**: Displays available tools and quick commands

No manual setup needed! Just start coding.

## Quickstart

### From Template

```sh
nix flake init -t path:../flakes#typescript
nix develop
npm install
npm run dev
```

### From Existing Project

```sh
# Copy the flake files into your existing TypeScript project
cp flake.nix shell.nix .envrc .
nix develop
npm install
```

## Included Tools

| Tool | Version | Purpose |
|------|---------|---------|
| **Node.js** | 20.x | JavaScript runtime and package manager |
| **npm** | Latest | Node package manager |
| **TypeScript** | Latest | Static type checker and transpiler |
| **TypeScript LSP** | Latest | Language server for IDE integration |
| **ESLint** | Latest | JavaScript/TypeScript linter |
| **Prettier** | Latest | Code formatter |
| **esbuild** | Latest | Ultra-fast JavaScript bundler |
| **Vite** | Latest | Next-gen frontend build tool |
| **Jest** | Latest | JavaScript testing framework |
| **pnpm** | Latest | Fast, disk space efficient package manager |
| **Yarn** | Latest | Alternative package manager |

## Common Tasks

### Development

```sh
# Install dependencies
npm install

# Start development server
npm run dev

# Watch mode for automatic recompilation
npm run watch
```

### Building

```sh
# Build for production
npm run build

# Build and serve locally
npm run preview
```

### Code Quality

```sh
# Run ESLint
npm run lint

# Format code with Prettier
npm run format

# Run both lint and format
npm run check
```

### Testing

```sh
# Run Jest tests
npm test

# Watch mode
npm test -- --watch

# Coverage report
npm test -- --coverage
```

### Cleanup

```sh
# Remove dependencies and build artifacts
make clean
```

## Project Structure

```
typescript-template/
├── src/                      # Source code directory
│   └── index.ts             # Entry point
├── dist/                     # Compiled output (generated)
├── node_modules/            # Dependencies (generated)
├── package.json            # Project metadata and dependencies
├── tsconfig.json           # TypeScript configuration
├── eslint.config.js        # ESLint configuration
├── prettier.config.js      # Prettier configuration
├── flake.nix               # Nix flake configuration
├── shell.nix               # Legacy Nix shell
├── Makefile                # Common build targets
└── README.md               # This file
```

## Configuration Files

### TypeScript (tsconfig.json)

The provided `tsconfig.json` is a minimal configuration. Key options you might want to adjust:

```json
{
  "compilerOptions": {
    "target": "ES2020",           // Target JavaScript version
    "module": "ESNext",           // Module system
    "lib": ["ES2020"],            // Type definitions to include
    "outDir": "./dist",           // Output directory
    "rootDir": "./src",           // Source root
    "strict": true,               // Strict type checking
    "esModuleInterop": true,      // CommonJS compatibility
    "skipLibCheck": true,         // Skip type checking of declaration files
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### ESLint (eslint.config.js)

A minimal ESLint configuration is provided. Customize rules as needed:

```js
export default [
  {
    files: ["**/*.ts", "**/*.js"],
    ignores: ["dist/", "node_modules/"],
    rules: {
      "no-console": "warn",
      "no-unused-vars": "warn"
    }
  }
];
```

### Prettier (prettier.config.js)

Default Prettier configuration:

```js
export default {
  semi: true,
  singleQuote: false,
  trailingComma: "es5",
  printWidth: 80,
  tabWidth: 2,
  useTabs: false
};
```

## IDE Integration

### VS Code

For the best TypeScript experience in VS Code:

1. Install the [TypeScript Vue Plugin (Volar)](https://marketplace.visualstudio.com/items?itemName=Vue.vscode-typescript-vue-plugin) extension (if using Vue)
2. Install [ESLint](https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint) and [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) extensions
3. The flake provides TypeScript LSP automatically

### Vim/Neovim

Use [coc-tsserver](https://github.com/neoclide/coc-tsserver) or [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) for TypeScript support.

## Scripts in package.json

Customize these npm scripts in `package.json` based on your project needs:

```json
{
  "scripts": {
    "dev": "tsc --watch",
    "build": "tsc",
    "start": "node dist/index.js",
    "lint": "eslint src/",
    "lint:fix": "eslint src/ --fix",
    "format": "prettier --write \"src/**/*.{ts,js}\"",
    "check": "npm run lint && npm run format",
    "test": "jest",
    "prestart": "npm run build"
  }
}
```

## Environment Variables

Set environment variables in a `.env` file:

```sh
# .env
NODE_ENV=development
DEBUG=true
API_URL=http://localhost:3000
```

To use dotenv in your code:

```sh
npm install dotenv
```

## Using Alternative Package Managers

### pnpm

```sh
pnpm install
pnpm run dev
```

### Yarn

```sh
yarn install
yarn dev
```

## Debugging

### Node.js Debugger

```sh
# Run with debugger
node --inspect-brk dist/index.js

# Then open chrome://inspect in Chrome
```

### VS Code Debugging

Add to `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Launch Program",
      "preLaunchTask": "npm: build",
      "program": "${workspaceFolder}/dist/index.js",
      "restart": true,
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

## Framework Integration

### React

```sh
npm create vite@latest . -- --template react-ts
npm install
npm run dev
```

### Next.js

```sh
npm create next-app@latest . --typescript
npm install
npm run dev
```

### Astro

```sh
npm create astro@latest . -- --template minimal --no-install
npm install
npm run dev
```

### Express

```sh
npm install express
npm install --save-dev @types/express ts-node
```

## Troubleshooting

### npm Module Not Found

Ensure `node_modules` is in the Nix flake include path:

```sh
# Clean and reinstall
make clean
npm install
```

### TypeScript Compiler Errors

Verify `tsconfig.json` is correctly configured:

```sh
# Type-check without emitting
npx tsc --noEmit
```

### ESLint or Prettier Not Working

Reload the nix shell:

```sh
# Exit current shell
exit

# Re-enter with fresh environment
nix develop
```

## Advanced Usage

### Monorepo Setup

For monorepo projects, consider using [npm workspaces](https://docs.npmjs.com/cli/v7/using-npm/workspaces):

```json
{
  "workspaces": [
    "packages/*"
  ]
}
```

### Docker Deployment

Create a multi-stage build in your `Dockerfile`:

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]
```

### CI/CD Integration

GitHub Actions workflow example (`.github/workflows/ci.yml`):

```yaml
name: CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run lint
      - run: npm run build
      - run: npm test
```

## Performance Tips

1. **Use pnpm**: It's faster and uses less disk space
2. **Enable TypeScript incremental compilation**: Add `"incremental": true` to `tsconfig.json`
3. **Use esbuild for faster builds**: Much faster than `tsc` alone
4. **Parallelize tests**: Jest runs tests in parallel by default

## Resources

- [TypeScript Documentation](https://www.typescriptlang.org/docs/)
- [Node.js Documentation](https://nodejs.org/docs/)
- [npm Documentation](https://docs.npmjs.com/)
- [ESLint Rules](https://eslint.org/docs/latest/rules/)
- [Prettier Options](https://prettier.io/docs/en/options.html)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)

## License

MIT - See LICENSE file for details
