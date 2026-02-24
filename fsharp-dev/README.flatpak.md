## Flatpak Packaging

This template supports building Flatpak packages for your F# application.

### Build Flatpak Package

1. Ensure you have `flatpak-builder` installed.
2. Run:

    ```bash
    make flatpak-build
    ```

This will use the manifest at `flatpak/app.flatpak.json` to build a Flatpak bundle in the `build-flatpak/` directory.

### Customize Manifest

Edit `flatpak/app.flatpak.json` to update app ID, runtime, build commands, or sources as needed for your project.

### Install/Run Flatpak Locally

You can install and run the built Flatpak locally:

```bash
flatpak install --user build-flatpak/org.example.fsharpdevshell.flatpak
flatpak run org.example.fsharpdevshell
```
