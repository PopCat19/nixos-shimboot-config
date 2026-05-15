# Context

- `flake.nix` — Main flake entry point with binary cache configuration for Hyprland and shimboot
- `flake.lock` — Dependency lock file for reproducible builds
- `QUICKSTART.md` — Short guide for getting started with the configuration
- `README.md` — Detailed documentation of the repository purpose and structure

## Binary Caches

This flake explicitly declares the following binary caches to ensure fast builds for ChromeOS desktop environments:
- **Hyprland**: For the latest Wayland compositor binaries
- **Shimboot**: For systemd and ChromeOS-specific system components
- **Numtide**: For shared development tool binaries
