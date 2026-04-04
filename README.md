# NixOS Shimboot Config

Personal ChromeOS desktop configuration for [nixos-shimboot](https://github.com/PopCat19/nixos-shimboot).

## What is this?

This repo contains desktop configurations that layer on top of shimboot — a NixOS-based shimboot implementation for ChromeOS devices. Shimboot is a derivative of [ading2210/shimboot](https://github.com/ading2210/shimboot), adapted to work with NixOS's flake system. It patches the RMA shim's initramfs with a custom bootloader, applies a systemd patch to work around ChromeOS kernel mount issues, and builds bootable NixOS images.

Shimboot provides:
- ChromeOS hardware abstraction (boot, filesystem, kernel params)
- Patched systemd for ChromeOS kernel compatibility
- Helper scripts (expand-rootfs, setup-nixos, bwrap workarounds)
- Fish shell functions and abbreviations (nrb, cdn, etc.)
- Base system modules (networking, audio, hyprland, users)

This repo provides everything else: desktop environment, applications, theming, and Home Manager dotfiles.

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
- A Chromebook compatible with shimboot
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

## Shimboot-Specific Workarounds

Shimboot includes several workarounds for ChromeOS kernel limitations:

| Workaround | Purpose |
|------------|---------|
| `systemd-patch` | Patches systemd to handle ChromeOS kernel mount complaints |
| `bwrap-lsm-workaround` | Works around ChromeOS LSM restrictions on bubblewrap |
| `expand-rootfs` | Expands rootfs to full USB drive on first boot |
| `setup-nixos` | Interactive first-boot setup helper |
| `kill-frecon` | Disables ChromeOS frecon to allow graphics |

## Configuration Options

### Shimboot Fish Shell

Shimboot includes fish functions and abbreviations by default. Opt-out options:

```nix
# Disable all shimboot fish config
shimboot.fish.enable = false;

# Keep fish enabled but skip function installation
shimboot.fish.enableFunctions = false;

# Keep functions but skip abbreviations
shimboot.fish.enableAbbreviations = false;
```

Core abbreviations `nrb` (nixos-rebuild-basic) and `cdn` (cd to config dir) are always installed. They can be remapped in your own fish config.

### Shimboot Modules

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
- `nixos-rebuild` may require `--option sandbox false` on shim kernels <5.6

For more documentation, see the [shimboot repo](https://github.com/PopCat19/nixos-shimboot).
