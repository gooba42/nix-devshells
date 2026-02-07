# Nix Flake Template Standards

This document defines the standards for all language/project templates in this workspace. Follow these guidelines for every new or updated template to ensure consistency, usability, and Nixpkgs compatibility.

---

## 1. Flake Structure

Every template **must** include:

- **flake.nix**: Provides a devShell with all necessary tools for the language/project type. The devShell must print a welcome message or usage tip on entry.
- **src/**: Contains a minimal, working "hello world" program for the language.
- **README.md**: Documents usage, build/run, and packaging for Nixpkgs. Must include quickstart, devShell usage, and build/test instructions.
- **.gitignore**: Language-appropriate, excludes build artifacts, editor files, and Nix/direnv outputs.
- **.editorconfig**: Present in every template for consistent editor settings.
- **Makefile** or **justfile**: Provides common build, test, and clean tasks (use Makefile unless language strongly prefers justfile).
- **shell.nix**: Legacy support for non-flake users, with a minimal dev environment and a welcome message.
- **project.toml** (or similar): Minimal project metadata file (see [bleur.toml] or [pyproject.toml] for inspiration).

## 2. Dev Environment

- The devShell must include all compilers, interpreters, and tools needed for development and building.
- Prefer upstream Nixpkgs packages for all dependencies.
- If a language has a standard build tool (e.g., cargo, make, cmake, dotnet, pip), include it in the devShell.
- The devShell must print a clear welcome/usage message on entry, listing key tools and usage tips.

## 3. Minimal Example Project

- Place a minimal, working "hello world" program in `src/`.
- The example must build and run with the provided instructions, using only the devShell and included files.
- Use idiomatic code for the language.

## 4. README.md Requirements

Each README **must** include:

- **Project summary**: What the template is for, what tools it provides.
- **Quick start**: How to enter the dev shell and initialize a new project from the template.
- **Build and run instructions**: Step-by-step commands to build and run the example project.
- **Project layout**: Directory structure, highlighting `src/` and any build files.
- **Project metadata**: Reference to `project.toml` or equivalent.
- **Packaging for nixpkgs**: How to adapt the template for official Nixpkgs distribution, with a link to the relevant Nixpkgs manual section.
- **Customization**: How to add dependencies, change versions, or extend the template.
- **Legacy usage**: How to use the template with `nix-shell` if not using flakes.

## 5. Nixpkgs Packaging Support

- The template must be structured so it can be easily packaged for Nixpkgs:
  - All sources in `src/`
  - `flake.nix` provides a devShell and template
  - Add a `default.nix` or package expression as needed for Nixpkgs
- README must link to the official Nixpkgs manual for the language.

## 6. General Best Practices

- Keep templates minimal and focused.
- Use clear, consistent naming and formatting.
- Document any deviations from these standards in the README.
- Test that the template builds and runs as documented.
- Ensure all templates are included in the top-level flake registry and README.
- Add a minimal CI config (e.g., GitHub Actions workflow) to check that all templates build.

---

**For updates, always check this file and keep all templates in sync with these standards.**
