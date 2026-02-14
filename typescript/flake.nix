{
  description = "A Nix-flake-based TypeScript development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          f { inherit pkgs; }
        );
    in
    {
      templates = {
        default = {
          path = ./.;
          description = "TypeScript dev environment with Node.js, esbuild, and TypeScript tooling; includes a skeletal npm project";
        };
      };

      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Node.js and npm
              nodejs_20
              nodePackages.npm
              nodePackages.pnpm
              nodePackages.yarn

              # TypeScript and tooling
              nodePackages.typescript
              nodePackages.typescript-language-server
              nodePackages.eslint
              nodePackages.prettier

              # Build tools
              nodePackages.esbuild
              nodePackages.vite

              # Testing
              nodePackages.jest

              # Development utilities
              git
              gnumake
              curl
              wget

              # Code editors/LSP support
              vscode-langservers-extracted
            ];

            env = {
              # Ensure npm uses the nix-managed Node.js
              NODE_PATH = "${pkgs.nodejs_20}/lib/node_modules";
            };

            shellHook = ''
              # Initialize git repository if not already present
              if [ ! -d .git ]; then
                git init
                echo "✓ Initialized git repository"
              fi

              # Set up npm cache
              if [ ! -d .npm-cache ]; then
                mkdir -p .npm-cache
              fi
              export npm_config_cache=.npm-cache

              # Display welcome message
              cat <<'EOF'
              ╔════════════════════════════════════════════╗
              ║  TypeScript Development Environment       ║
              ║  Powered by Nix Flakes                    ║
              ╚════════════════════════════════════════════╝

              📦 Quick Commands:
                npm install       - Install dependencies
                npm run dev       - Start dev server
                npm run build     - Build for production
                npm run lint      - Run ESLint
                npm run format    - Format code with Prettier
                npm test          - Run Jest tests
                make dev          - Alias for: npm run dev
                make build        - Alias for: npm run build
                make test         - Alias for: npm test
                make clean        - Remove node_modules and dist

              📚 Available Tools:
                Node.js ${pkgs.nodejs_20.version}
                npm ${pkgs.nodePackages.npm.version}
                TypeScript ${pkgs.nodePackages.typescript.version}
                ESLint ${pkgs.nodePackages.eslint.version}
                Prettier ${pkgs.nodePackages.prettier.version}

              💡 Tips:
                • Use 'direnv allow' to auto-enter this environment
                • Run 'npm init' or 'npm create' to bootstrap a new project
                • TypeScript LSP is available for VS Code integration

              EOF
            '';
          };
        }
      );
    };
}
