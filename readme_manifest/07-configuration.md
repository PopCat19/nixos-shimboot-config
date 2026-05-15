### nixos-shimboot Fish Shell

nixos-shimboot includes fish functions and abbreviations by default. Opt-out options:

```nix
# Disable all nixos-shimboot fish config
shimboot.fish.enable = false;

# Keep fish enabled but skip function installation
shimboot.fish.enableFunctions = false;

# Keep functions but skip abbreviations
shimboot.fish.enableAbbreviations = false;
```

Core abbreviations `nrb` (nixos-rebuild-basic) and `cdn` (cd to config dir) are always installed. They can be remapped in your own fish config.

### Module Paths

| Path | Purpose |
|------|---------|
| `configuration.nix` | System configuration entry point |
| `system/` | NixOS system modules (services, packages, theming) |
| `home/` | Home Manager modules (dotfiles, apps, hyprland config) |
