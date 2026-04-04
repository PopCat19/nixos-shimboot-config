# NixOS Shimboot Config Quickstart Guide

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## Prerequisites

- NixOS system with flakes enabled
- A Chromebook compatible with nixos-shimboot
- The shimboot repo (imported automatically as a flake input)

## Quick Start

### 1. Clone and Enter the Repository

```bash
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
```

### 2. Choose Your Branch

- `popcat19` — personal desktop config (Hyprland, theming, applications)
- `main` — reference template for creating your own config

```bash
git checkout popcat19
```

### 3. Build and Switch

```bash
# Full system rebuild (NixOS + Home Manager)
sudo nixos-rebuild switch --flake .#popcat19

# Home Manager only (faster iteration on dotfiles)
home-manager switch --flake .#popcat19
```

### 4. First Boot

After flashing a shimboot image and booting into NixOS:

```bash
# Clone this repo on the running system
git clone https://github.com/PopCat19/nixos-shimboot-config.git
cd nixos-shimboot-config
git checkout popcat19

# Apply your config
sudo nixos-rebuild switch --flake .#popcat19
```

## Create Your Own Config

1. Fork this repo
2. Create a branch with your name (e.g., `alice`)
3. Copy structure from `main/` as reference
4. Customize:
   - `configuration.nix` — system entry point
   - `system/` — NixOS modules (services, packages, theming)
   - `home/` — Home Manager modules (dotfiles, apps, WM config)
5. Build with `sudo nixos-rebuild switch --flake .#alice`

## How It Works

This repo imports shimboot as a hardware module:

```nix
# flake.nix
inputs.shimboot.url = "github:PopCat19/nixos-shimboot/dev";

modules = [
  shimboot.nixosModules.chromeos    # ChromeOS HAL (boot, fs, hw)
  ./popcat19/configuration.nix     # personal config (DE, packages, HM)
];
```

Shimboot handles ChromeOS-specific constraints (initScript boot, single-partition layout, patched systemd). This repo handles everything else.

## Troubleshooting

### Flake input out of date

```bash
nix flake update shimboot
```

### Home Manager switch fails

```bash
# Check for syntax errors
nix flake check

# Rebuild full system instead
sudo nixos-rebuild switch --flake .#popcat19
```

### Shimboot module not found

Ensure the shimboot input is resolving correctly:

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

For more documentation, see the [shimboot repo](https://github.com/PopCat19/nixos-shimboot).
