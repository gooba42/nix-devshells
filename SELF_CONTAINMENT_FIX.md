# Self-Containment Fix for Devshell Flakes

## Issue Identified

Two devshell flakes had external path-based dependencies that broke portability:

- `arduino/flake.nix`
- `c/flake.nix`

Both referenced the `cpp-devshell` flake via:

```nix
inputs.cpp-devshell.url = "path:../cpp-devshell";
```

This meant they could only be used when cloned with the exact directory structure intact. Cloning just the `arduino` or `c` directory on another system would fail because `cpp-devshell` wouldn't exist at `../cpp-devshell`.

## Solution Applied

**Inlined the shared C++ packages directly** into both flakes, eliminating the external dependency.

### Changes Made

#### `arduino/flake.nix`

- **Removed**: `inputs.cpp-devshell.url = "path:../cpp-devshell";`
- **Inlined**: C++ packages list directly in `forEachSupportedSystem`:

  ```nix
  cppDevShellPkgs = with pkgs; [
    clang
    clang-tools
    cmake
    codespell
    conan
    cppcheck
    doxygen
    gtest
    lcov
  ] ++ (if stdenv.isDarwin then [] else [gdb]);
  ```

#### `c/flake.nix`

- **Removed**: `inputs.cpp-devshell.url = "path:../cpp-devshell";`
- **Inlined**: Same C++ packages list as arduino flake

### Benefits

✅ **Self-contained**: Both flakes now work independently without requiring `cpp-devshell`
✅ **Portable**: Can be cloned to any location on any system
✅ **Simple**: Reduced flake complexity; no indirect dependencies
✅ **Maintainable**: Single source of truth for C++ packages in each flake

### Backward Compatibility

✅ **No breaking changes**: The devShells and packages exported remain identical
✅ **Same tooling**: Users get the same C++ development tools as before

### Future Considerations

If you need to share C++ packages across many flakes in the future, consider:

1. Publishing `cpp-devshell` as a GitHub-hosted flake input (via GitHub URL, not path)
2. Creating a Nix overlay in a shared repository
3. Accepting duplication of the package list (current approach)

The current fix ensures portability while keeping things simple.
