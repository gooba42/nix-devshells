# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      templates = {
        default = {
          description = ".NET dev environment (FHS) with SDK, EF Core, and optional Rider support";
          welcomeText = ''
            .NET skeletal project created.
            - Build:   dotnet build
            - Run:     dotnet run
            - Rider:   rider . (inside nix develop)
          '';
          path = ./.;
        };
      };

      devShells =
        let
          supportedSystems = [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ];
        in
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            fhs = pkgs.buildFHSEnv {
              name = "dotnet-fhs-shell";
              targetPkgs = pkgs: [
                pkgs.dotnet-sdk
                pkgs.dotnet-ef
                pkgs.dotnet-aspnetcore
                pkgs.icu
                pkgs.openssl
                pkgs.krb5
                pkgs.zlib
                pkgs.git
              ];
              runScript = "bash";
              profile = ''
                export DOTNET_ROOT=${pkgs.dotnet-sdk}
                export DOTNET_CLI_HOME=$HOME/.dotnet
                export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
                export DOTNET_CLI_TELEMETRY_OPTOUT=1
                export PATH=${pkgs.dotnet-sdk}/bin:$PATH
              '';
            };
          in
          {
            default = fhs.env.overrideAttrs (_: {
              shellHook = ''
                # Initialize git repository if not already present
                if [ ! -d .git ]; then
                  git init
                  echo "✓ Initialized git repository"
                fi

                export DOTNET_ROOT=${pkgs.dotnet-sdk}
                export DOTNET_CLI_HOME=$HOME/.dotnet
                export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
                export DOTNET_CLI_TELEMETRY_OPTOUT=1
                export PATH=${pkgs.dotnet-sdk}/bin:$PATH
                echo "FHS shell for .NET development"
                echo "DOTNET_ROOT=$DOTNET_ROOT"
              '';
            });
          }
        );

      packages =
        let
          supportedSystems = [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ];
        in
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          in
          {
            default = pkgs.buildDotnetModule {
              pname = "sample-dotnet-app";
              version = "0.1.0";
              src = ./.;
              projectFile = "SampleApp.csproj";
              nugetDeps = ./deps.nix;
              selfContainedBuild = false;
              meta.mainProgram = "SampleApp";
            };

            devHelper = pkgs.writeShellScriptBin "dev-helper" ''
              echo ".NET dev environment"
              command -v dotnet >/dev/null 2>&1 && dotnet --version || true
              echo "This binary is built by Nix (packages.devHelper)."
            '';
          }
        );

      apps =
        let
          supportedSystems = [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ];
        in
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
          in
          {
            default = {
              type = "app";
              program = pkgs.lib.getExe self.packages.${system}.default;
            };
            dev-helper = {
              type = "app";
              program = pkgs.lib.getExe self.packages.${system}.devHelper;
            };
          }
        );
    };
}
