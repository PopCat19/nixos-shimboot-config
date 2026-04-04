# NixOS Shimboot Config Quickstart Guide

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## Prerequisites

- NixOS system with flakes enabled
- A Chromebook compatible with shimboot
- The nixos-shimboot repo (imported automatically as a flake input)

## Quick Start

### 1. Clone and Enter the Repository

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
```

### 2. Choose Your Branch

- `popcat19`. . Personal desktop config (Hyprland, theming, applications)
- `main`. . Reference template for creating your own config

```bash
git checkout popcat19
```

### 3. Build and Switch

```bash
# Navigate to config dir (using nixos-shimboot's cdn abbreviation)
cdn

# Full system rebuild (NixOS + Home Manager as a NixOS module)
nrb
```

`nrb` is shorthand for `nixos-rebuild-basic`, a fish function provided by nixos-shimboot that handles the rebuild with appropriate flags.

### 4. First Boot

After flashing a nixos-shimboot image and booting into NixOS:

```bash
# Clone this repo on the running system
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
git checkout popcat19

# Apply your config
nrb
```

## Create Your Own Config

1. Fork this repo
2. Create a branch with your name (e.g., `alice`)
3. Copy structure from `main/` as reference
4. Customize:
   - `configuration.nix`. . System entry point
   - `system/`. NixOS modules (services, packages, theming)
   - `home/`. Home Manager modules (dotfiles, apps, WM config)
5. Build with `nrb` (or `sudo nixos-rebuild switch --flake .#alice`)

## How It Works

This repo imports nixos-shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./popcat19/configuration.nix     # personal config (DE, packages, HM)
];
```

nixos-shimboot handles ChromeOS-specific constraints (initScript boot, single-partition layout, patched systemd). This repo handles everything else.

Home Manager is configured as a NixOS module. . There is no standalone `home-manager switch` command. All dotfile changes are applied via `nrb`.

## Building Shimboot Images

Building shimboot images requires Nix on Linux with sudo privileges (the assembly script uses loop mounts for partition manipulation). Docker/Podman builds are untested.

```bash
# Clone nixos-shimboot (the build system repo)
git clone https://github.com/PopCat19/nixos-shimboot.git
cd nixos-shimboot

# Build minimal image
sudo ./tools/build/assemble-final.sh --board dedede --rootfs minimal
```

## Troubleshooting

### Flake input out of date

```bash
nix flake update shimboot
```

### Build fails

```bash
# Check for syntax errors
nix flake check

# Rebuild full system
nrb
```

### nixos-shimboot module not found

Ensure the nixos-shimboot input is resolving correctly:

```bash
nix flake metadata
```

### Build takes too long

Enable the Cachix binary cache for faster builds:

```bash
nix profile install nixpkgs#cachix
cachix use shimboot-systemd-nixos
```

## Next Steps

- Explore `system/` modules for NixOS configuration
- Explore `home/` modules for Home Manager dotfiles
- Add your own modules alongside the existing ones
- Fork and customize for your own setup

For more documentation, see the [nixos-shimboot repo](https://github.com/PopCat19/nixos-shimboot).
