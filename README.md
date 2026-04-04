# NixOS Shimboot Config

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## What is this?

This repo contains desktop configurations that layer on top of the shimboot ChromeOS hardware abstraction layer. The shimboot repo provides the build system and ChromeOS-specific modules (boot, filesystem, hardware). This repo provides everything else: desktop environment, applications, theming, and Home Manager dotfiles.

## Structure

```
nixos-shimboot-config/
├── flake.nix           # imports shimboot as flake input
├── flake.lock
├── main/               # reference template (forkable)
│   ├── configuration.nix
│   ├── system/
│   └── home/
└── popcat19/           # personal desktop config
    ├── configuration.nix
    ├── system/
    └── home/
```

## Quick Start

### Prerequisites

- NixOS system with flakes enabled
- A Chromebook compatible with nixos-shimboot
- The shimboot repo (imported as a flake input)

### Build and Switch

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
git checkout popcat19  # or main for reference template

# Full system rebuild (NixOS + Home Manager)
sudo nixos-rebuild switch --flake .#popcat19

# Home Manager only (iterate on dotfiles faster)
home-manager switch --flake .#popcat19
```

### Create Your Own Config

1. Fork this repo
2. Create a branch with your name (e.g., `alice`)
3. Copy structure from `main/` as reference
4. Customize `configuration.nix`, `system/`, and `home/`
5. Build with `sudo nixos-rebuild switch --flake .#alice`

## Architecture

This repo imports shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

# In nixosConfigurations:
modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./popcat19/configuration.nix     # personal config (DE, packages, HM)
];
```

Shimboot's `mkForce` declarations handle ChromeOS-specific constraints (initScript boot, single-partition layout). Personal config handles everything else — DE, packages, theming, services.

## Configuration

| Path | Purpose |
|------|---------|
| `popcat19/configuration.nix` | System configuration entry point |
| `popcat19/system/` | NixOS system modules (services, packages, theming) |
| `popcat19/home/` | Home Manager modules (dotfiles, apps, hyprland config) |
| `main/` | Reference template for users to fork |

## Known Limitations

- Desktop config requires shimboot as a flake input
- ChromeOS kernel limitations apply (no suspend, limited audio)
- Some Home Manager modules may require specific package versions

For more documentation, see the [shimboot repo](https://github.com/PopCat19/nixos-shimboot).
