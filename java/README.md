# Java Development Template

Nix flake template for Java development with OpenJDK and build tools.

## Quick Start

```bash
nix develop
# or with direnv:
direnv allow
```

## Building

```bash
# With Maven:
mvn package
java -jar target/myapp.jar

# With Gradle:
gradle build
java -jar build/libs/myapp.jar
```

## Included Tools

- OpenJDK
- Maven
- Gradle

## Packaging for nixpkgs

This template is structured for easy packaging in nixpkgs:

- All sources in `src/`
- `flake.nix` provides a devShell and template
- Add a `default.nix` or package expression as needed for nixpkgs

See [nixpkgs Java packaging docs](https://nixos.org/manual/nixpkgs/stable/#java) for more details.

## Customization

Edit `flake.nix` to change Java version or add build plugins.
